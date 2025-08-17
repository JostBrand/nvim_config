return {
    "kevinhwang91/nvim-bqf",
    ft = "qf", -- load only for quickfix windows, instead of VeryLazy
    opts = {
        auto_enable = true, -- automatically enable nvim-bqf for quickfix
        preview = {
            win_height = 12,
            win_vheight = 12,
            delay_syntax = 80,
            border_chars = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
            should_preview_cb = function(bufnr, _)
                -- don't preview very large files for performance
                return vim.api.nvim_buf_line_count(bufnr) < 1000
            end,
        },
        func_map = {
            vsplit = "<C-v>",      -- open in vertical split
            split = "<C-x>",       -- open in horizontal split
            tab = "<C-t>",         -- open in new tab
            ptogglemode = "z,",    -- toggle preview window
        },
    },
}
