return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({})
    end,
  },
    {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("codecompanion").setup({
        adapters = {
            gemini = function ()
                return require("codecompanion.adapters").extend("gemini", {
                    env = {api_key = "cmd:rbw get gemini"},
                })
            end
        },
        strategies = {
            chat = {
                adapter = "gemini",
            },
            inline = {
                adapter = "gemini",
            }
        },
          display = {
    action_palette = {
      width = 95,
      height = 10,
      provider = "telescope",
      opts = {
        show_default_actions = true,
        show_default_prompt_library = true,
      },
    },
  },
    })
  end,
},
}
