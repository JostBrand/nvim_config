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
        local conf = require("telescope.config").values
        local function toggle_telescope(harpoon_files)
            local file_paths = {}
            for _, item in ipairs(harpoon_files.items) do
                table.insert(file_paths, item.value)
            end

            require("telescope.pickers").new({}, {
                prompt_title = "Harpoon",
                finder = require("telescope.finders").new_table({
                    results = file_paths,
                }),
                previewer = conf.file_previewer({}),
                sorter = conf.generic_sorter({}),
            }):find()
        end
    end
}
