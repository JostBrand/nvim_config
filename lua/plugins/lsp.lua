return {
    -- Mason for LSP server management
    {
        'williamboman/mason.nvim',
        opts = {
            ensure_installed = { "mypy" }
        }
    },
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = { 'williamboman/mason.nvim' },
        config = function()
            local distro_name = nil
            local file = io.open("/etc/os-release", "r")
            if file then
                for line in file:lines() do
                    if line:match("^NAME=") then
                        distro_name = line:gsub('NAME=', ''):gsub('"', '')
                        break
                    end
                end
                file:close()
            end

            local is_nixos = distro_name and string.find(string.lower(distro_name), "nixos")
            local ensure = { 'lua_ls', 'pyright', 'tinymist', 'awk_ls', 'gopls', 'jqls', 'clangd' }
            if is_nixos or vim.fn.executable('nil') == 1 or vim.fn.executable('nil_ls') == 1 then
                table.insert(ensure, 'nil_ls')
            end

            -- Mason will be auto-initialized by mason-lspconfig
            require('mason-lspconfig').setup({
                automatic_installation = true,
                ensure_installed = ensure,
            })
        end
    },
    -- LSP Configuration
    {
        'neovim/nvim-lspconfig',
        dependencies = { 'williamboman/mason-lspconfig.nvim' },
        config = function()
            local system = require("utils.system")
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
            local servers = { 'awk_ls', 'gopls', 'jqls', 'tinymist' }
            for _, server in ipairs(servers) do
                vim.lsp.config(server, {
                    capabilities = capabilities,
                    on_attach = on_attach,
                })
                vim.lsp.enable(server)
            end

            -- Custom server configurations
            local distro_name = get_distro_name()
            local is_nixos = distro_name and string.find(string.lower(distro_name), string.lower("nixos"))
            local home = vim.fn.expand("$HOME")

            -- Helper function to get nix binary path with fallback
            local function get_cmd(binary_name)
                local mason_binary = system.mason_bin(binary_name)
                if mason_binary then
                    return { mason_binary }
                end
                if is_nixos then
                    local nix_path = home .. "/.nix-profile/bin/" .. binary_name
                    if vim.fn.executable(nix_path) == 1 then
                        return { nix_path }
                    end
                end
                return { binary_name }
            end

            -- Clangd setup
            vim.lsp.config('clangd', {
                cmd = get_cmd("clangd"),
                capabilities = capabilities,
                on_attach = on_attach,
            })
            vim.lsp.enable('clangd')

            -- Lua LSP setup
            vim.lsp.config('lua_ls', {
                cmd = get_cmd("lua-language-server"),
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    Lua = {
                        runtime = { version = 'LuaJIT' },
                        diagnostics = { globals = { 'vim' } },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                        telemetry = { enable = false },
                    },
                },
            })
            vim.lsp.enable('lua_ls')

            -- Nil (Nix) LSP setup
            local nil_cmd = nil
            if vim.fn.executable("nil") == 1 or system.mason_bin("nil") then
                nil_cmd = get_cmd("nil")
            elseif vim.fn.executable("nil_ls") == 1 or system.mason_bin("nil_ls") then
                nil_cmd = get_cmd("nil_ls")
            end

            if nil_cmd then
                vim.lsp.config('nil_ls', {
                    cmd = nil_cmd,
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
                vim.lsp.enable('nil_ls')
            end

            -- Pyright setup with Poetry support
            vim.lsp.config('pyright', {
                capabilities = capabilities,
                on_attach = on_attach,
                before_init = function(_, config)
                    -- Check if poetry is available and try to get virtual env path
                    if vim.fn.executable('poetry') == 1 then
                        local poetry_env = vim.fn.trim(vim.fn.system('poetry env info --path 2>/dev/null'))
                        if vim.v.shell_error == 0 and poetry_env ~= '' and vim.fn.isdirectory(poetry_env) == 1 then
                            config.settings.python.pythonPath = poetry_env .. '/bin/python'
                        end
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
            vim.lsp.enable('pyright')

            -- Ruff setup
            vim.lsp.config('ruff', {
                capabilities = capabilities,
                on_attach = on_attach,
            })
            vim.lsp.enable('ruff')
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
            require("luasnip.loaders.from_lua").load { paths = { "~/.config/nvim/snippets/lua_snippets" } }
            require("luasnip.loaders.from_vscode").load { paths = { "~/.config/nvim/snippets/vscode_snippets" } }

            cmp.setup({
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'buffer' },
                    { name = 'path' },
                    { name = 'luasnip' },
                    { name = 'go_pkgs' },
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
                    ['<C-y>'] = cmp.mapping.confirm({ select = false }),
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
                    chars = { '{', '[', '(', '"', "'" },
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
