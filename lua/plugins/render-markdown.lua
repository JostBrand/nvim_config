return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  ft = { "markdown", "Avante" },
  opts = {
    -- Render modes
    render_modes = true,

    -- Headings
    heading = {
      enabled = true,
      sign = true,
      position = "overlay",
      icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      width = "full",
      backgrounds = {
        "RenderMarkdownH1Bg",
        "RenderMarkdownH2Bg",
        "RenderMarkdownH3Bg",
        "RenderMarkdownH4Bg",
        "RenderMarkdownH5Bg",
        "RenderMarkdownH6Bg",
      },
      foregrounds = {
        "RenderMarkdownH1",
        "RenderMarkdownH2",
        "RenderMarkdownH3",
        "RenderMarkdownH4",
        "RenderMarkdownH5",
        "RenderMarkdownH6",
      },
    },

    -- Code blocks
    code = {
      enabled = true,
      sign = true,
      style = "full",
      position = "left",
      width = "full",
      left_pad = 0,
      right_pad = 0,
      min_width = 0,
      border = "thin",
      above = "▄",
      below = "▀",
      highlight = "RenderMarkdownCode",
      highlight_inline = "RenderMarkdownCodeInline",
    },

    -- Bullet points
    bullet = {
      enabled = true,
      icons = { "●", "○", "◆", "◇" },
      ordered_icons = {},
      left_pad = 0,
      right_pad = 0,
      highlight = "RenderMarkdownBullet",
    },

    -- Checkboxes
    checkbox = {
      enabled = true,
      unchecked = {
        icon = "󰄱 ",
        highlight = "RenderMarkdownUnchecked",
      },
      checked = {
        icon = "󰱒 ",
        highlight = "RenderMarkdownChecked",
      },
      custom = {
        todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo" },
        in_progress = { raw = "[~]", rendered = " ", highlight = "RenderMarkdownInProgress" },
        important = { raw = "[!]", rendered = "󰀪 ", highlight = "RenderMarkdownImportant" },
        cancelled = { raw = "[/]", rendered = " ", highlight = "RenderMarkdownCancelled" },
      },
    },

    -- Quotes/callouts
    quote = {
      enabled = true,
      icon = "▋",
      repeat_linebreak = false,
      highlight = "RenderMarkdownQuote",
    },

    -- Pipe tables
    pipe_table = {
      enabled = true,
      preset = "round",
      style = "full",
      cell = "padded",
      border = {
        "┌", "┬", "┐",
        "├", "┼", "┤",
        "└", "┴", "┘",
        "│", "─",
      },
      alignment_indicator = "━",
      head = "RenderMarkdownTableHead",
      row = "RenderMarkdownTableRow",
      filler = "RenderMarkdownTableFill",
    },

    -- Callouts (Obsidian-style)
    callout = {
      note = { raw = "[!note]", rendered = "󰋽 Note", highlight = "RenderMarkdownInfo" },
      tip = { raw = "[!tip]", rendered = "󰌶 Tip", highlight = "RenderMarkdownSuccess" },
      important = { raw = "[!important]", rendered = "󰅾 Important", highlight = "RenderMarkdownHint" },
      warning = { raw = "[!warning]", rendered = "󰀪 Warning", highlight = "RenderMarkdownWarn" },
      caution = { raw = "[!caution]", rendered = "󰳦 Caution", highlight = "RenderMarkdownError" },
      -- Aliases
      abstract = { raw = "[!abstract]", rendered = "󰨸 Abstract", highlight = "RenderMarkdownInfo" },
      info = { raw = "[!info]", rendered = "󰋽 Info", highlight = "RenderMarkdownInfo" },
      todo = { raw = "[!todo]", rendered = "󰥔 Todo", highlight = "RenderMarkdownInfo" },
      hint = { raw = "[!hint]", rendered = "󰌶 Hint", highlight = "RenderMarkdownSuccess" },
      success = { raw = "[!success]", rendered = "󰄬 Success", highlight = "RenderMarkdownSuccess" },
      question = { raw = "[!question]", rendered = "󰘥 Question", highlight = "RenderMarkdownWarn" },
      failure = { raw = "[!failure]", rendered = "󰅖 Failure", highlight = "RenderMarkdownError" },
      danger = { raw = "[!danger]", rendered = "󱐌 Danger", highlight = "RenderMarkdownError" },
      bug = { raw = "[!bug]", rendered = "󰨰 Bug", highlight = "RenderMarkdownError" },
      example = { raw = "[!example]", rendered = "󰉹 Example", highlight = "RenderMarkdownHint" },
      quote = { raw = "[!quote]", rendered = "󱆨 Quote", highlight = "RenderMarkdownQuote" },
    },

    -- Links
    link = {
      enabled = true,
      image = "󰥶 ",
      email = "󰀓 ",
      hyperlink = "󰌹 ",
      highlight = "RenderMarkdownLink",
      custom = {
        web = { pattern = "^http[s]?://", icon = "󰖟 ", highlight = "RenderMarkdownLink" },
      },
    },

    -- Signs
    sign = {
      enabled = true,
      highlight = "RenderMarkdownSign",
    },

    -- Wiki links (for Obsidian)
    win_options = {
      conceallevel = {
        default = vim.api.nvim_get_option_value("conceallevel", {}),
        rendered = 3,
      },
      concealcursor = {
        default = vim.api.nvim_get_option_value("concealcursor", {}),
        rendered = "",
      },
    },
  },
  config = function(_, opts)
    require("render-markdown").setup(opts)

    -- Optional: Add a keybinding to toggle rendering
    vim.keymap.set("n", "<leader>om", ":RenderMarkdown toggle<CR>",
      { noremap = true, silent = true, desc = "Toggle markdown rendering" })
  end,
}
