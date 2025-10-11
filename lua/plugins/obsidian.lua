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
    ui = {
      enable = false,  -- disable all additional syntax features
    },
    -- see below for full list of options 📁
  },
}

