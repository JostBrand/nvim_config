-- Get hostname to conditionally load workspace
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
local workspaces = {}

-- Only load workspace if hostname is "desktopmem"
if hostname == "desktopmeme" then
  workspaces = {
    {
      name = "obsidian_notes",
      path = "/bkp/obsidian_notes/",
    },
  }
end

return {
  "epwalsh/obsidian.nvim",
  version = "*",  -- recommended, use latest release instead of latest commit
  lazy = false,
  -- ft = "markdown",
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",

    -- see below for full list of optional dependencies í ½í±‡
  },
  opts = {
    workspaces = workspaces,
    ui = {
      enable = false,  -- disable all additional syntax features
    },
    -- see below for full list of options í ½í±‡
  },
}
