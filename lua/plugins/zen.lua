return {
  "Pocco81/true-zen.nvim",
  opts = {
      		minimalist = {
			ignored_buf_types = { "nofile" }, -- save current options from any window except ones displaying these kinds of buffers
			options = { -- options to be disabled when entering Minimalist mode
				number = false,
				relativenumber = false,
				showtabline = 0,
				signcolumn = "no",
				statusline = "",
				cmdheight = 1,
				laststatus = 0,
				showcmd = false,
				showmode = false,
				ruler = false,
				numberwidth = 1
			},
  },
  },
  config = function()
      local truezen = require("true-zen")

    -- Keymap for Zen Mode toggle
    vim.keymap.set('n', '<leader>zm', ":TZMinimalist<CR>", {})
  end,
}
