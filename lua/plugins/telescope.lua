return {
    'nvim-telescope/telescope.nvim',
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
