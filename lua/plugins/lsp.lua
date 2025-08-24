return {
    -- Mason for LSP server management
    {
        'williamboman/mason.nvim',
        opts = {
            ensure_installed = {"mypy"}
        }
    },
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = {'williamboman/mason.nvim'},
        config = function()
            require('mason').setup({})
            require('mason-lspconfig').setup({
                automatic_installation = true,
                ensure_installed = {'nil_ls','lua_ls', 'pyright', "tinymist",'awk_ls', 'gopls',  'jqls', 'clangd'},
            })
        end
    },
    
    -- LSP Configuration
    {
        'neovim/nvim-lspconfig',
        dependencies = {'williamboman/mason-lspconfig.nvim'},
        config = function()
            local lspconfig = require('lspconfig')
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            
            local function get_distro_name()
                local file = io.open("/etc/os-release", "r")
                if not file then return nil end

                for line in file:lines() do
                    if line:match("^NAME=") then
                        file:close()
                        return line:gsub('NAME=', ''):gsub('"', '')
                    end
                end

                file:close()
                return nil
            end

            local function on_attach(client, bufnr)
                local opts = { noremap = true, silent = true, buffer = bufnr }
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts)
                vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
                vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
                vim.keymap.set('n', '<leader>fm', vim.lsp.buf.format, opts)
            end

            -- Default setup for most servers
            local servers = {'awk_ls', 'gopls', 'jqls', 'tinymist'}
            for _, server in ipairs(servers) do
                lspconfig[server].setup({
                    capabilities = capabilities,
                    on_attach = on_attach,
                })
            end

            -- Custom server configurations
            local distro_name = get_distro_name()
            local is_nixos = distro_name and string.find(string.lower(distro_name), string.lower("nixos"))

            -- Clangd setup
            lspconfig.clangd.setup({
                cmd = is_nixos and {"/home/jost/.nix-profile/bin/clangd"} or {"clangd"},
                capabilities = capabilities,
                on_attach = on_attach,
            })

            -- Lua LSP setup
            lspconfig.lua_ls.setup({
                cmd = is_nixos and {"/home/jost/.nix-profile/bin/lua-language-server"} or {"lua-language-server"},
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    Lua = {
                        runtime = { version = 'LuaJIT' },
                        diagnostics = { globals = {'vim'} },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                        telemetry = { enable = false },
                    },
                },
            })

            -- Nil (Nix) LSP setup
            lspconfig.nil_ls.setup({
                cmd = is_nixos and {"/home/jost/.nix-profile/bin/nil"} or {"nil"},
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    ["nil"] = {
                        formatting = {
                            command = { "nixfmt" },
                        },
                        diagnostics = {
                            command = { "nixpkgs-lint", "--stdin" },
                        },
                    },
                }
            })

            -- Pyright setup with Poetry support
            lspconfig.pyright.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                before_init = function(_, config)
                    local poetry_env = vim.fn.trim(vim.fn.system('poetry env info --path'))
                    if poetry_env ~= '' then
                        config.settings.python.pythonPath = poetry_env .. '/bin/python'
                    end
                end,
                settings = {
                    python = {
                        analysis = {
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true,
                            diagnosticMode = "workspace",
                        },
                    },
                },
            })

            -- Ruff setup
            lspconfig.ruff.setup({
                capabilities = capabilities,
                on_attach = on_attach,
            })
        end
    },

    -- Completion
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'L3MON4D3/LuaSnip',
            "Yu-Leo/cmp-go-pkgs",
            {
                "L3MON4D3/LuaSnip",
                dependencies = { "rafamadriz/friendly-snippets" },
                build = "make install_jsregexp"
            },
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp",
            "onsails/lspkind.nvim",
        },
        config = function()
            local cmp = require('cmp')
            local lspkind = require('lspkind')
            local luasnip = require("luasnip")
            
            -- LuaSnip configuration
            luasnip.config.set_config({
                history = true,
                enable_autosnippets = true,
            })
            luasnip.log.set_loglevel("info")
            require("luasnip.loaders.from_vscode").lazy_load()
            require("luasnip.loaders.from_lua").lazy_load()
            require("luasnip.loaders.from_lua").load{paths = {"~/.config/nvim/snippets/lua_snippets"}}
            require("luasnip.loaders.from_vscode").load{paths = {"~/.config/nvim/snippets/vscode_snippets"}}

            cmp.setup({
                sources = {
                    {name = 'nvim_lsp'},
                    {name = 'buffer'},
                    {name = 'path'},
                    {name = 'luasnip'},
                    {name = 'go_pkgs'},
                },
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-y>'] = cmp.mapping.confirm({select = false}),
                    ['<C-e>'] = cmp.mapping.close(),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-f>'] = cmp.mapping(function(fallback)
                        if luasnip.jumpable(1) then
                            luasnip.jump(1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<C-b>'] = cmp.mapping(function(fallback)
                        if luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                }),
                formatting = {
                    format = lspkind.cmp_format({
                        mode = 'symbol',
                        maxwidth = 50,
                        ellipsis_char = '...',
                    })
                }
            })
        end
    },

    -- Autopairs
    {
        "windwp/nvim-autopairs",
        config = function()
            local autopairs = require("nvim-autopairs")
            autopairs.setup({
                fast_wrap = {
                    map = '<M-e>',
                    chars = {'{', '[', '(', '"', "'"},
                    pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
                    offset = 0,
                    end_key = '$',
                    keys = 'qwertyuiopzxcvbnmasdfghjkl',
                    check_comma = true,
                    highlight = 'PmenuSel',
                    highlight_grey = 'LineNr',
                }
            })
            
            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            local cmp = require('cmp')
            cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
        end
    },
}