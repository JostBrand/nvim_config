require('nvim-treesitter.configs').setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "c", "lua","python", "vim", "vimdoc", "query" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  auto_install = true,

  ignore_install = {  },

  context_commentstring = {
    enable = true,
  },
  highlight = {
    enable = true,

    additional_vim_regex_highlighting = true,
  },
}
