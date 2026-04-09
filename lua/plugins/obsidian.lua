local system = require("utils.system")

local workspace_path = vim.env.OBSIDIAN_VAULT
if not workspace_path or workspace_path == "" then
  local candidates = {
    "/bkp/obsidian_notes/",
    vim.fn.expand("~/bkp/obsidian_notes"),
    vim.fn.expand("~/obsidian_notes"),
  }

  for _, candidate in ipairs(candidates) do
    if system.path_exists(candidate) then
      workspace_path = candidate
      break
    end
  end
end

return {
  "epwalsh/obsidian.nvim",
  version = "*",  -- recommended, use latest release instead of latest commit
  ft = "markdown",
  cmd = {
    "ObsidianBacklinks",
    "ObsidianFollowLink",
    "ObsidianLink",
    "ObsidianLinkNew",
    "ObsidianNew",
    "ObsidianQuickSwitch",
    "ObsidianRename",
    "ObsidianSearch",
    "ObsidianTags",
    "ObsidianTemplate",
    "ObsidianToday",
    "ObsidianToggleCheckbox",
    "ObsidianTomorrow",
    "ObsidianWorkspace",
    "ObsidianYesterday",
  },
  cond = function()
    return workspace_path and workspace_path ~= "" and system.path_exists(workspace_path)
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
        path = workspace_path,
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
      local open_cmd = system.open_command()
      if open_cmd then
        vim.fn.jobstart({ open_cmd, url })
      else
        vim.notify("No URL opener found in PATH", vim.log.levels.WARN)
      end
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
