return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = "Trouble",
  opts = {},
  config = function(_, opts)
    local trouble = require("trouble")
    trouble.setup(opts)

    -- Helper: detect if a window with given filetype is visible
    local function is_win_visible_with_ft(ft)
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == ft then
          return true
        end
      end
      return false
    end

    local function jump_list(loc_cmd, qf_cmd)
      local loc = vim.fn.getloclist(0, { size = 0 })
      if loc and loc.size and loc.size > 0 then
        vim.cmd('silent! ' .. loc_cmd)
      else
        vim.cmd('silent! ' .. qf_cmd)
      end
    end

    local function jump_next()
      if is_win_visible_with_ft("trouble") then
        trouble.next({ skip_groups = true, jump = true })
      else
        jump_list('lnext', 'cnext')
      end
    end

    local function jump_prev()
      if is_win_visible_with_ft("trouble") then
        trouble.prev({ skip_groups = true, jump = true })
      else
        jump_list('lprevious', 'cprevious')
      end
    end

    -- Global keymaps: Alt+j / Alt+k jump to next/prev result
    vim.keymap.set("n", "<A-j>", jump_next, { desc = "Next result (Trouble/loclist/qf)" })
    vim.keymap.set("n", "<A-k>", jump_prev, { desc = "Prev result (Trouble/loclist/qf)" })

    -- Insert mode: execute once without fully leaving insert
    vim.keymap.set("i", "<A-j>", function()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-o>", true, false, true), "n", false)
      jump_next()
    end, { desc = "Next result (Trouble/loclist/qf)" })

    vim.keymap.set("i", "<A-k>", function()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-o>", true, false, true), "n", false)
      jump_prev()
    end, { desc = "Prev result (Trouble/loclist/qf)" })

    -- Terminal mode: briefly leave terminal-mode
    vim.keymap.set("t", "<A-j>", function()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", false)
      jump_next()
    end, { desc = "Next result (Trouble/loclist/qf)" })

    vim.keymap.set("t", "<A-k>", function()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", false)
      jump_prev()
    end, { desc = "Prev result (Trouble/loclist/qf)" })
  end,

  keys = {
    -- 1. Main toggles --------------------------------------------------------
    { "<leader>tq", function() require("trouble").toggle("diagnostics") end,
      desc = "Trouble: toggle diagnostics" },
    { "<leader>tw", function() require("trouble").toggle("workspace_diagnostics") end,
      desc = "Trouble: workspace diagnostics" },
    { "<leader>td", function() require("trouble").toggle("document_diagnostics") end,
      desc = "Trouble: document diagnostics" },
    { "<leader>tx", function() require("trouble").toggle("quickfix") end,
      desc = "Trouble: quickfix" },
    { "<leader>tl", function() require("trouble").toggle("loclist") end,
      desc = "Trouble: location-list" },
    { "gR",          function() require("trouble").toggle("lsp_references") end,
      desc = "Trouble: LSP references" },

    -- 2. Trouble-only in-list motions (keep your originals) -----------------
    { "]t", function() require("trouble").next({ skip_groups = true,  jump = true }) end,
      desc = "Trouble: next result" },
    { "[t", function() require("trouble").prev({ skip_groups = true,  jump = true }) end,
      desc = "Trouble: previous result" },
    { "]T", function() require("trouble").next({ skip_groups = false, jump = true }) end,
      desc = "Trouble: next (incl. groups)" },
    { "[T", function() require("trouble").prev({ skip_groups = false, jump = true }) end,
      desc = "Trouble: previous (incl. groups)" },
  },
}
