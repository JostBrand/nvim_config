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

            treesitter.setup({
                install_dir = vim.fn.stdpath('data') .. '/site',
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
            local textobjects = require('nvim-treesitter-textobjects')
            local select = require('nvim-treesitter-textobjects.select')
            local move = require('nvim-treesitter-textobjects.move')
            local swap = require('nvim-treesitter-textobjects.swap')

            textobjects.setup({
                select = {
                    lookahead = true,
                },
                move = {
                    set_jumps = true,
                },
            })

            -- Select keymaps (operator-pending + visual)
            local select_keymaps = {
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
            }
            for key, query in pairs(select_keymaps) do
                vim.keymap.set({ 'x', 'o' }, key, function()
                    select.select_textobject(query)
                end, { desc = 'Select ' .. query })
            end

            -- Move keymaps
            vim.keymap.set({ 'n', 'x', 'o' }, ']m', function()
                move.goto_next_start('@function.outer')
            end, { desc = 'Next function start' })
            vim.keymap.set({ 'n', 'x', 'o' }, ']]', function()
                move.goto_next_start('@class.outer')
            end, { desc = 'Next class start' })
            vim.keymap.set({ 'n', 'x', 'o' }, ']M', function()
                move.goto_next_end('@function.outer')
            end, { desc = 'Next function end' })
            vim.keymap.set({ 'n', 'x', 'o' }, '][', function()
                move.goto_next_end('@class.outer')
            end, { desc = 'Next class end' })
            vim.keymap.set({ 'n', 'x', 'o' }, '[m', function()
                move.goto_previous_start('@function.outer')
            end, { desc = 'Prev function start' })
            vim.keymap.set({ 'n', 'x', 'o' }, '[[', function()
                move.goto_previous_start('@class.outer')
            end, { desc = 'Prev class start' })
            vim.keymap.set({ 'n', 'x', 'o' }, '[M', function()
                move.goto_previous_end('@function.outer')
            end, { desc = 'Prev function end' })
            vim.keymap.set({ 'n', 'x', 'o' }, '[]', function()
                move.goto_previous_end('@class.outer')
            end, { desc = 'Prev class end' })

            -- Swap keymaps
            vim.keymap.set('n', '<leader>a', function()
                swap.swap_next('@parameter.inner')
            end, { desc = 'Swap parameter next' })
            vim.keymap.set('n', '<leader>A', function()
                swap.swap_previous('@parameter.inner')
            end, { desc = 'Swap parameter prev' })
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
