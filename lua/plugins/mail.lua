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
"pimalaya/himalaya-vim",
  cond = function()
    return hostname == "desktopmeme"
  end,
}
