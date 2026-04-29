return {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    keys = {
        { '<C-f>', function() require('telescope.builtin').find_files({ hidden = true }) end },
        {
            '<leader>fc',
            function()
                require('telescope.builtin').find_files({
                    hidden = true,
                    search_dirs = { '~/.config', '~/.ssh', '~/Dokumente', '~/Downloads', '~/bkp/Sources' }
                })
            end,
        },
        { '<leader>fg', function() require('telescope.builtin').live_grep() end },
        { '<leader>fb', function() require('telescope.builtin').buffers() end },
        { '<leader>fh', function() require('telescope.builtin').help_tags() end },
        { '<leader>fr', function() require('telescope.builtin').resume() end },
        { '<leader>ft', function() require('telescope.builtin').treesitter() end },
        { '<leader>fs', function() require('telescope.builtin').grep_string() end },
        { '<leader>gb', function() require('telescope.builtin').git_branches() end },
        { '<leader>gc', function() require('telescope.builtin').git_commits() end },
        { '<leader>gs', function() require('telescope.builtin').git_status() end },
    },
    dependencies = { 'nvim-lua/plenary.nvim', 'BurntSushi/ripgrep', 'nvim-telescope/telescope-ui-select.nvim', 'kkharji/sqlite.lua' },
    config = function()
        local ts = require("telescope")
        ts.setup {
            defaults = {
                file_ignore_patterns = {
                    "%.git.*", -- Matches any file or directory starting with .git
                    ".*%.pdf", -- Matches any file with .pdf extension
                    ".*%.mov", -- Matches any file with .mov extension
                    ".*%.bin", -- Matches any file with .bin extension
                    "node_modules/",
                    "%.DS_Store",
                    "vendor/",
                    "__pycache__/",
                    "*.pyc",
                    ".vscode/",
                    ".idea/",
                    "build/",
                    "dist/",
                    "*.log"
                },
                layout_strategy = "horizontal",
                prompt_prefix = "🔍 ",
                selection_caret = " ",
                path_display = { "smart" },
                color_devicons = true,
                set_env = { ["COLORTERM"] = "truecolor" },
                sorting_strategy = "ascending",
                winblend = 0,
                border = {},
                borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
                history = {
                    path = '~/.local/share/nvim/databases/telescope_history.sqlite3',
                    limit = 100,
                }
            },
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown {}
                }
            }
        }
        ts.load_extension("ui-select")
    end
}
