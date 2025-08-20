
return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "Trouble",
    keys = {
        -- Toggle different trouble modes
        { "<leader>tq", "<cmd>Trouble diagnostics toggle<cr>", desc = "Toggle diagnostics" },
        { "<leader>tw", "<cmd>Trouble workspace_diagnostics toggle<cr>", desc = "Toggle workspace diagnostics" },
        { "<leader>td", "<cmd>Trouble document_diagnostics toggle<cr>", desc = "Toggle document diagnostics" },
        { "<leader>tl", "<cmd>Trouble loclist toggle<cr>", desc = "Toggle location list" },
        { "<leader>tf", "<cmd>Trouble quickfix toggle<cr>", desc = "Toggle quickfix list" },
        { "<leader>tr", "<cmd>Trouble lsp_references toggle<cr>", desc = "Toggle LSP references" },
        { "<leader>ti", "<cmd>Trouble lsp_implementations toggle<cr>", desc = "Toggle LSP implementations" },
        { "<leader>ts", "<cmd>Trouble symbols toggle<cr>", desc = "Toggle symbols" },
        
        -- Navigation between trouble items
        { "]t", function() require("trouble").next({skip_groups = true, jump = true}) end, desc = "Next trouble item" },
        { "[t", function() require("trouble").prev({skip_groups = true, jump = true}) end, desc = "Previous trouble item" },
        { "]T", function() require("trouble").next() end, desc = "Next trouble item (with groups)" },
        { "[T", function() require("trouble").prev() end, desc = "Previous trouble item (with groups)" },
        
        -- Quick access to first/last items
        { "<leader>tf", function() require("trouble").first({skip_groups = true, jump = true}) end, desc = "First trouble item" },
        { "<leader>tL", function() require("trouble").last({skip_groups = true, jump = true}) end, desc = "Last trouble item" },
    },
}

