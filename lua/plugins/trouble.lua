return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "Trouble",
    keys = {
        { "<leader>tq", "<cmd>Trouble diagnostics toggle<cr>", desc = "Toggle diagnostics" },
    },
    opts = {
    },
}
