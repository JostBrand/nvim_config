return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
          suggestion = {
              enabled = true,
              auto_trigger = true,
              debounce = 75,
              keymap = {
                  accept = "<Tab>",
              }
          },
      })
    end,
  },
{
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false,
  opts = {
    provider = "openrouter",
    vendors = {
      openrouter = {
        __inherited_from = 'openai',
        endpoint = 'https://openrouter.ai/api/v1',
        api_key_name = 'OPENROUTER_API_KEY',
        model="",
      },
    },
  },
  build = "make",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "echasnovski/mini.pick",
    "nvim-telescope/telescope.nvim",
    "hrsh7th/nvim-cmp",
    "ibhagwan/fzf-lua",
    "nvim-tree/nvim-web-devicons",
    {
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          use_absolute_path = true,
        },
      },
    },
    {
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
  config = function(_, opts)
    local api_key_loader = function()
      local rbw_item_name = "openrouter"
      local env_var_name = "OPENROUTER_API_KEY"

      vim.notify("Attempting to load " .. env_var_name .. " from rbw...", vim.log.levels.INFO)

      vim.fn.jobstart({ "rbw", "get", rbw_item_name }, {
        on_stdout = function(_, data)
          if data and #data > 0 and data[1] ~= "" then
            local api_key = vim.trim(data[1])
            vim.env[env_var_name] = api_key
            vim.notify(env_var_name .. " loaded successfully from rbw!", vim.log.levels.INFO)
          else
            vim.notify("Failed to retrieve " .. env_var_name .. " from rbw or key is empty.", vim.log.levels.ERROR)
          end
        end,
        on_stderr = function(_, data)
          if data and #data > 0 and data[1] ~= "" then
            local error_message = table.concat(data, "\\n")
            vim.notify("Error retrieving " .. env_var_name .. " from rbw: " .. error_message, vim.log.levels.ERROR)
          else
            vim.notify("Error retrieving " .. env_var_name .. " from rbw (no stderr output).", vim.log.levels.ERROR)
          end
        end,
        stdout_buffered = true,
      })
      require("avante.api").ask()
    end

    require("avante_lib").load()
    require("avante").setup(opts)

    vim.keymap.set('n', '<leader>aa', api_key_loader, { desc = 'Load OpenRouter API Key from rbw for Avante' })
  end,
}
  }

