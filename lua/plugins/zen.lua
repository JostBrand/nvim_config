return {
    "folke/zen-mode.nvim",
    opts = {
        window = {
            width = 90, -- adjust width as needed
            options = {
                number = false,
                relativenumber = false,
                signcolumn = "no",
                statusline = "",
                cmdheight = 1,
                laststatus = 0,
                showcmd = false,
                showmode = false,
                ruler = false,
                numberwidth = 1,
                showtabline = 0,
            },
        },
    },
    config = function()
        local zenmode = require("zen-mode")

        -- Keymap for Zen Mode toggle
        vim.keymap.set('n', '<leader>zm', "<cmd>ZenMode<cr>", { silent = true })
    end,
}
