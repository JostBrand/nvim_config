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

    -- Helper: prefer loclist if current window has one, else quickfix
    local function jump_list(cmd_qf, cmd_loc)
      -- If current window has a location list with items, use it; else quickfix
      local loc = vim.fn.getloclist(0, { size = 0 })
      local use_loc = loc and loc.size and loc.size > 0
      if use_loc then
        vim.cmd(cmd_loc)
      else
        vim.cmd(cmd_qf)
      end
    end

    -- Next/Prev result: Trouble if open (with jump), else loclist/qf jump
    local function jump_next()
      if is_win_visible_with_ft("trouble") then
        -- Jump to next actual item in the active Trouble view
        trouble.next({ skip_groups = true, jump = true })
      else
        -- Wrap and be quiet; prefer loclist if present
        jump_list("silent! lnext!", "silent! lnext!")
        -- Fallback to quickfix if no loclist items
        if (vim.v.shell_error or 0) ~= 0 then
          vim.cmd("silent! cnext!")
        end
      end
    end

    local function jump_prev()
      if is_win_visible_with_ft("trouble") then
        trouble.prev({ skip_groups = true, jump = true })
      else
        jump_list("silent! lprevious!", "silent! lprevious!")
        if (vim.v.shell_error or 0) ~= 0 then
          vim.cmd("silent! cprevious!")
        end
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
