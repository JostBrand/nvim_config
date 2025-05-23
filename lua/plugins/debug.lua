return {
    {"mfussenegger/nvim-dap",dependencies={
    "nvim-neotest/nvim-nio",
    "mfussenegger/nvim-dap-python",
	"rcarriga/nvim-dap-ui"
},
    config = function ()
        
require("dapui").setup()
require('dap-python').setup()

local dap, dapui = require("dap"), require("dapui")

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

    end
}}
