return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    requires = { {"nvim-lua/plenary.nvim"} }
    ,config = function ()
        local harpoon = require('harpoon')

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

        harpoon:setup({})
        vim.keymap.set("n", "<leader>h", function() toggle_telescope(harpoon:list()) end,{ desc = "Open harpoon window" })

        vim.keymap.set("n", "<leader>ah", function() require("harpoon"):list():add() end, {desc= "Add item to harpoon"})

        vim.keymap.set("n", "<leader>n", function() require("harpoon"):list():select(1) end, {desc="Go to Harpoon 1"})
        vim.keymap.set("n", "<leader>e", function() require("harpoon"):list():select(2) end, {desc="Go to Harpoon 2"})
        vim.keymap.set("n", "<leader>i", function() require("harpoon"):list():select(3) end, {desc="Go to Harpoon 3"})

        -- Toggle previous & next buffers stored within Harpoon list
        -- vim.keymap.set("n", "<C-p>", function() harpoon:list():prev() end)
        -- vim.keymap.set("n", "<C-n>", function() harpoon:list():next() end)

    end,
}

