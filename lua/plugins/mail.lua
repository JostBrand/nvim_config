local system = require("utils.system")
local hostname = system.hostname()

return {
"pimalaya/himalaya-vim",
  cond = function()
    return vim.env.ENABLE_HIMALAYA == "1" or hostname == "desktopmeme"
  end,
}
