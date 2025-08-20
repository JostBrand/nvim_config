
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
    opts = {
        position = "bottom", -- position of the list can be: bottom, top, left, right
        height = 10, -- height of the trouble list when position is top or bottom
        width = 50, -- width of the list when position is left or right
        icons = true, -- use devicons for filenames
        mode = "workspace_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
        severity = nil, -- nil (ALL) or vim.diagnostic.severity.ERROR | WARN | INFO | HINT
        fold_open = "", -- icon used for open folds
        fold_closed = "", -- icon used for closed folds
        group = true, -- group results by file
        padding = true, -- add an extra new line on top of the list
        cycle_results = true, -- cycle item list when reaching beginning or end of list
        action_keys = { -- key mappings for actions in the trouble list
            close = "q", -- close the list
            cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
            refresh = "r", -- manually refresh
            jump = {"<cr>", "<tab>", "<2-leftmouse>"}, -- jump to the diagnostic or open / close folds
            open_split = { "<c-x>" }, -- open buffer in new split
            open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
            open_tab = { "<c-t>" }, -- open buffer in new tab
            jump_close = {"o"}, -- jump to the diagnostic and close the list
            toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
            switch_severity = "s", -- switch "diagnostics" severity filter level
            toggle_preview = "P", -- toggle auto_preview
            hover = "K", -- opens a small popup with the full multiline message
            preview = "p", -- preview the diagnostic location
            open_code_href = "c", -- if present, open a URI with more information about the diagnostic error
            close_folds = {"zM", "zm"}, -- close all folds
            open_folds = {"zR", "zr"}, -- open all folds
            toggle_fold = {"zA", "za"}, -- toggle fold of current file
            previous = "k", -- previous item
            next = "j", -- next item
            help = "?" -- help menu
        },
        multiline = true, -- render multi-line messages
        indent_lines = true, -- add an indent guide below the fold icons
        win_config = { border = "single" }, -- window configuration for floating windows. See |nvim_open_win()|.
        auto_open = false, -- automatically open the list when you have diagnostics
        auto_close = false, -- automatically close the list when you have no diagnostics
        auto_preview = true, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
        auto_fold = false, -- automatically fold a file trouble list at creation
        auto_jump = {"lsp_definitions"}, -- for the given modes, automatically jump if there is only a single result
        include_declaration = { "lsp_references", "lsp_implementations", "lsp_definitions"  }, -- for the given modes, include the declaration of the current symbol in the results
        signs = {
            -- icons / text used for a diagnostic
            error = "",
            warning = "",
            hint = "",
            information = "",
            other = "",
        },
        use_diagnostic_signs = false -- enabling this will use the signs defined in your lsp client
    },
}

