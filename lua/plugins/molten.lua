return {
    {
        "benlubas/molten-nvim",
        version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
        build = ":UpdateRemotePlugins",
        init = function()
            -- these are examples, not defaults. Please see the readme
            -- vim.g.molten_image_provider = "image.nvim"
            -- vim.g.molten_output_win_max_height = 20
        end,
    },
    {
        -- see the image.nvim readme for more information about configuring this plugin
        "3rd/image.nvim",
        -- Only enable if running directly in kitty/ghostty (not through tmux)
        -- Note: tmux doesn't support image protocols, so this won't work inside tmux
        enabled = function()
            local term = vim.env.TERM or ""
            local term_program = vim.env.TERM_PROGRAM or ""
            local ghostty_dir = vim.env.GHOSTTY_RESOURCES_DIR or ""

            -- Don't enable if running in tmux (blocks image protocols)
            if term:match("tmux") or term_program:match("tmux") then
                return false
            end

            -- Enable for kitty or ghostty
            return term:match("kitty") ~= nil
                or term_program:match("kitty") ~= nil
                or ghostty_dir ~= ""
        end,
        opts = {
            backend = "kitty", -- kitty protocol works with both kitty and ghostty
            max_width = 100,
            max_height = 12,
            max_height_window_percentage = math.huge,
            max_width_window_percentage = math.huge,
            window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
            window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
        },
    },
    {
        "quarto-dev/quarto-nvim",
        dependencies = {
            "jmbuhr/otter.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
    }
}
