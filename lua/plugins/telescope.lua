return {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' ,'BurntSushi/ripgrep'},
    config = function ()
        local ts = require("telescope")
        ts.setup{
            defaults = {
                file_ignore_patterns = {
                    "%.git.*", -- Matches any file or directory starting with .git
                    ".*%.pdf", -- Matches any file with .pdf extension
                    ".*%.mov", -- Matches any file with .mov extension
                    ".*%.bin", -- Matches any file with .bin extension
                }
            }
        }
    end
}
