return {
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        build = ':TSUpdate',
        config = function()
            local languages = {
                'bash',
                'c',
                'diff',
                'dockerfile',
                'gitcommit',
                'gitignore',
                'go',
                'json',
                'lua',
                'markdown',
                'markdown_inline',
                'nix',
                'python',
                'query',
                'regex',
                'toml',
                'typst',
                'vim',
                'vimdoc',
                'yaml',
            }

            local treesitter = require('nvim-treesitter')
            local configs = require('nvim-treesitter.configs')

            treesitter.setup({
                install_dir = vim.fn.stdpath('data') .. '/site',
            })
            configs.setup({
                auto_install = false,
                parser_install_dir = vim.fn.stdpath('data') .. '/site',
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = {
                    enable = true,
                },
            })

            vim.api.nvim_create_user_command('TSInstallMyParsers', function()
                if vim.fn.executable('tree-sitter') ~= 1 then
                    vim.notify(
                        'tree-sitter-cli is required for parser installation. Install it first (Arch: sudo pacman -S tree-sitter-cli).',
                        vim.log.levels.ERROR
                    )
                    return
                end
                treesitter.install(languages)
            end, { desc = 'Install preferred Tree-sitter parsers' })
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        branch = 'main',
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
        },
        config = function()
            require('nvim-treesitter.configs').setup({
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ['aa'] = '@parameter.outer',
                            ['ia'] = '@parameter.inner',
                            ['af'] = '@function.outer',
                            ['if'] = '@function.inner',
                            ['ac'] = '@class.outer',
                            ['ic'] = '@class.inner',
                            ['ii'] = '@conditional.inner',
                            ['ai'] = '@conditional.outer',
                            ['il'] = '@loop.inner',
                            ['al'] = '@loop.outer',
                            ['at'] = '@comment.outer',
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = {
                            [']m'] = '@function.outer',
                            [']]'] = '@class.outer',
                        },
                        goto_next_end = {
                            [']M'] = '@function.outer',
                            [']['] = '@class.outer',
                        },
                        goto_previous_start = {
                            ['[m'] = '@function.outer',
                            ['[['] = '@class.outer',
                        },
                        goto_previous_end = {
                            ['[M'] = '@function.outer',
                            ['[]'] = '@class.outer',
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ['<leader>a'] = '@parameter.inner',
                        },
                        swap_previous = {
                            ['<leader>A'] = '@parameter.inner',
                        },
                    },
                },
            })
        end,
    },
    {
        'HiPhish/rainbow-delimiters.nvim',
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
        },
        config = function()
            require('rainbow-delimiters.setup').setup({
                strategy = {
                    [''] = 'rainbow-delimiters.strategy.global',
                    vim = 'rainbow-delimiters.strategy.local',
                },
                query = {
                    [''] = 'rainbow-delimiters',
                    lua = 'rainbow-blocks',
                },
                priority = {
                    [''] = 110,
                    lua = 210,
                },
                highlight = {
                    'RainbowDelimiterRose',
                    'RainbowDelimiterFoam',
                    'RainbowDelimiterGold',
                    'RainbowDelimiterPine',
                    'RainbowDelimiterIris',
                    'RainbowDelimiterLove',
                    'RainbowDelimiterMuted',
                },
            })
        end,
    },
}
