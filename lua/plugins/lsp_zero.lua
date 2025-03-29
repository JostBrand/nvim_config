return {
    {'hrsh7th/nvim-cmp',
    dependencies={'L3MON4D3/LuaSnip', "Yu-Leo/cmp-go-pkgs",
    dependencies = { "rafamadriz/friendly-snippets" },build = "make install_jsregexp"}
    },
    "saadparwaiz1/cmp_luasnip",
    {'williamboman/mason.nvim',opts = {
        ensure_installed = {"mypy"}
    }},
    {"windwp/nvim-autopairs",config = function ()
        local autopairs = require("nvim-autopairs")
        autopairs.setup({
            fast_wrap = {
                map = '<M-e>', -- This is the key mapping to trigger fastwrap
                chars = {'{', '[', '(', '"', "'"},
                pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
                offset = 0, -- Offset from pattern match
                end_key = '$',
                keys = 'qwertyuiopzxcvbnmasdfghjkl',
                check_comma = true,
                highlight = 'PmenuSel',
                highlight_grey = 'LineNr',
            }
        })
    end},
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-buffer",
    "williamboman/mason-lspconfig.nvim",
    "onsails/lspkind.nvim",
    {'neovim/nvim-lspconfig',dependencies={'hrsh7th/cmp-nvim-lsp'}},

    {
        'VonHeikemen/lsp-zero.nvim',
        config = function ()
            local lsp_zero = require('lsp-zero')

            lsp_zero.extend_lspconfig({
                sign_text = true,
                lsp_attach = lsp_attach,
                capabilities = require('cmp_nvim_lsp').default_capabilities(),
            })

            lsp_zero.on_attach(function(client, bufnr)
                -- see :help lsp-zero-keybindings
                -- to learn the available actions
                lsp_zero.default_keymaps({buffer = bufnr})
            end)

            require('mason').setup({})

            require('mason-lspconfig').setup({
                ensure_installed = {'lua_ls', 'pyright', "tinymist",'awk_ls', 'gopls',  'jqls', 'clangd'},
                handlers = {
                    -- this first function is the "default handler"
                    -- it applies to every language server without a "custom handler"
                    function(server_name)
                        require('lspconfig')[server_name].setup({})
                    end,

                    clangd = function()
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

                        local distro_name = get_distro_name()
                        if distro_name and string.find(string.lower(distro_name), string.lower("nixos")) then
                            require('lspconfig').clangd.setup({
                                cmd = {"/home/jost/.nix-profile/bin/clangd"}
                            })
                        else
                            require('lspconfig').clangd.setup({})
                        end
                    end,

                    pyright = function()
                        require('lspconfig').pyright.setup({
                            on_attach = function(client, bufnr)
                                -- Your custom on_attach function if needed
                            end,
                            disableOrganizeImports = true,
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
                    end,

                    lua_ls = function()
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

                        local distro_name = get_distro_name()
                        if distro_name and string.find(string.lower(distro_name), string.lower("nixos")) then
                            require('lspconfig').lua_ls.setup({
                                cmd = {"/home/jost/.nix-profile/bin/lua-language-server"}
                            })
                        else
                            require('lspconfig').lua_ls.setup({})
                        end
                    end

                }
            })

            require("lspconfig").ruff.setup({})
            lsp_zero.setup()
            -- You need to setup `cmp` after lsp-zero
            local cmp = require('cmp')
            local cmp_action = lsp_zero.cmp_action()
            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            local lspkind = require('lspkind')
            cmp.event:on(
            'confirm_done',
            cmp_autopairs.on_confirm_done()
            )

            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            local luasnip = require("luasnip")
            luasnip.config.set_config({
                history= true,
                enable_autosnippets = true,
            })
            luasnip.log.set_loglevel("info")
            require("luasnip.loaders.from_vscode").lazy_load{}
            require("luasnip.loaders.from_lua").lazy_load{}
            require("luasnip.loaders.from_lua").load{paths = "~/.config/nvim/snippets/lua_snippets"}
            require("luasnip.loaders.from_vscode").load{paths = "~/.config/nvim/snippets/vscode_snippets"}

            cmp.setup({

                sources = {
                    {name = 'nvim_lsp'},
                    {name = 'buffer'},
                    {name = 'path'},
                    {name = 'luasnip'},
                    {name = 'go_pkgs'},
                },
                snippet = {
                    -- REQUIRED - you must specify a snippet engine
                    expand = function(args)

                        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },

                mapping = cmp.mapping.preset.insert({
                    -- `Enter` key to confirm completion
                    ['<C-y>'] = cmp.mapping.confirm({select = false}),
                    ['<C-e>'] = cmp.mapping.close(),

                    -- Ctrl+Space to trigger completion menu
                    ['<C-Space>'] = cmp.mapping.complete(),

                    -- Navigate between snippet placeholder
                    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
                    ['<C-b>'] = cmp_action.luasnip_jump_backward(),

                    -- Scroll up and down in the completion documentation
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                }),
                formatting = {
                    format = lspkind.cmp_format({
                        mode = 'symbol', -- show only symbol annotations
                        maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                        -- can also be a function to dynamically calculate max width such as 
                        -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
                        ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

                        -- The function below will be called before any actual modifications from lspkind
                        -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
                    })
                }})
            end
        }
    }


