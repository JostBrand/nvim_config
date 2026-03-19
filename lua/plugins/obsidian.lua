-- Get hostname to conditionally load plugin
local function get_hostname()
  local handle = io.popen("hostname")
  if handle then
    local result = handle:read("*a")
    handle:close()
    return result:gsub("%s+", "") -- Remove whitespace
  end
  return ""
end

local hostname = get_hostname()

return {
  "epwalsh/obsidian.nvim",
  version = "*",  -- recommended, use latest release instead of latest commit
  lazy = false,
  cond = function()
    return hostname == "desktopmeme"
  end,
  -- ft = "markdown",
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",

    -- see below for full list of optional dependencies 📁
  },
  opts = {
    workspaces = {
      {
        name = "obsidian_notes",
        path = "/bkp/obsidian_notes/",
      },
    },

    -- UI disabled - using render-markdown.nvim instead for better rendering
    ui = {
      enable = false,
    },

    -- Daily notes
    daily_notes = {
      folder = "daily",
      date_format = "%Y-%m-%d",
      alias_format = "%B %-d, %Y",
      default_tags = { "daily-notes" },
      template = nil,
    },

    -- Templates
    templates = {
      folder = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
      substitutions = {},
    },

    -- Note ID generation
    note_id_func = function(title)
      local suffix = ""
      if title ~= nil then
        -- Use title as the note ID, replacing spaces with hyphens
        suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        -- If no title, generate random 4-character suffix
        suffix = tostring(os.time())
      end
      return suffix
    end,

    -- Note path function
    note_path_func = function(spec)
      local path = spec.dir / tostring(spec.id)
      return path:with_suffix(".md")
    end,

    -- Follow URL behavior
    follow_url_func = function(url)
      vim.fn.jobstart({ "xdg-open", url })  -- Linux
    end,

    -- Picker settings (use telescope)
    picker = {
      name = "telescope.nvim",
      note_mappings = {
        new = "<C-n>",
        insert_link = "<C-l>",
      },
      tag_mappings = {
        tag_note = "<C-t>",
        insert_tag = "<C-l>",
      },
    },

    -- Completion
    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },

    -- Mappings (in addition to keybindings in remap.lua)
    mappings = {
      -- Overrides the 'gf' mapping to work on markdown/wiki links
      ["gf"] = {
        action = function()
          return require("obsidian").util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      -- Toggle checkbox
      ["<leader>ch"] = {
        action = function()
          return require("obsidian").util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },
      -- Smart action (follow link or toggle checkbox)
      ["<cr>"] = {
        action = function()
          return require("obsidian").util.smart_action()
        end,
        opts = { buffer = true, expr = true },
      },
    },

    -- Preferred link style
    preferred_link_style = "wiki",

    -- Disable wiki link syntax in some files
    disable_frontmatter = false,

    -- Additional config
    note_frontmatter_func = function(note)
      local out = { id = note.id, aliases = note.aliases, tags = note.tags }
      if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end
      return out
    end,

    -- Attachments
    attachments = {
      img_folder = "assets",
    },
  },
}

