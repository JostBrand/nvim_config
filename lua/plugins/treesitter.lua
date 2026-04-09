return {
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        build = ':TSUpdate',
        config = function()
            local languages = {
                'bash',
                'c',
                'go',
                'json',
                'lua',
                'markdown',
                'markdown_inline',
                'python',
                'query',
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

            local group = vim.api.nvim_create_augroup('TreesitterHighlighting', { clear = true })
            vim.api.nvim_create_autocmd('FileType', {
                group = group,
                pattern = languages,
                callback = function(args)
                    pcall(vim.treesitter.start, args.buf)
                end,
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
            require('nvim-treesitter-textobjects').setup({
                select = {
                    lookahead = true,
                },
                move = {
                    set_jumps = true,
                },
            })

            local select = require('nvim-treesitter-textobjects.select')
            vim.keymap.set({ 'o', 'x' }, 'aa', function() select.select_textobject('@parameter.outer', 'textobjects') end)
            vim.keymap.set({ 'o', 'x' }, 'ia', function() select.select_textobject('@parameter.inner', 'textobjects') end)
            vim.keymap.set({ 'o', 'x' }, 'af', function() select.select_textobject('@function.outer', 'textobjects') end)
            vim.keymap.set({ 'o', 'x' }, 'if', function() select.select_textobject('@function.inner', 'textobjects') end)
            vim.keymap.set({ 'o', 'x' }, 'ac', function() select.select_textobject('@class.outer', 'textobjects') end)
            vim.keymap.set({ 'o', 'x' }, 'ic', function() select.select_textobject('@class.inner', 'textobjects') end)
            vim.keymap.set({ 'o', 'x' }, 'ii', function() select.select_textobject('@conditional.inner', 'textobjects') end)
            vim.keymap.set({ 'o', 'x' }, 'ai', function() select.select_textobject('@conditional.outer', 'textobjects') end)
            vim.keymap.set({ 'o', 'x' }, 'il', function() select.select_textobject('@loop.inner', 'textobjects') end)
            vim.keymap.set({ 'o', 'x' }, 'al', function() select.select_textobject('@loop.outer', 'textobjects') end)
            vim.keymap.set({ 'o', 'x' }, 'at', function() select.select_textobject('@comment.outer', 'textobjects') end)

            local move = require('nvim-treesitter-textobjects.move')
            vim.keymap.set({ 'n', 'o', 'x' }, ']m', function() move.goto_next_start('@function.outer', 'textobjects') end)
            vim.keymap.set({ 'n', 'o', 'x' }, ']]', function() move.goto_next_start('@class.outer', 'textobjects') end)
            vim.keymap.set({ 'n', 'o', 'x' }, ']M', function() move.goto_next_end('@function.outer', 'textobjects') end)
            vim.keymap.set({ 'n', 'o', 'x' }, '][', function() move.goto_next_end('@class.outer', 'textobjects') end)
            vim.keymap.set({ 'n', 'o', 'x' }, '[m', function() move.goto_previous_start('@function.outer', 'textobjects') end)
            vim.keymap.set({ 'n', 'o', 'x' }, '[[', function() move.goto_previous_start('@class.outer', 'textobjects') end)
            vim.keymap.set({ 'n', 'o', 'x' }, '[M', function() move.goto_previous_end('@function.outer', 'textobjects') end)
            vim.keymap.set({ 'n', 'o', 'x' }, '[]', function() move.goto_previous_end('@class.outer', 'textobjects') end)

            local swap = require('nvim-treesitter-textobjects.swap')
            vim.keymap.set('n', '<leader>a', function() swap.swap_next('@parameter.inner') end)
            vim.keymap.set('n', '<leader>A', function() swap.swap_previous('@parameter.inner') end)
        end,
    },
}
