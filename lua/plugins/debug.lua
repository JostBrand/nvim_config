return {
    {"mfussenegger/nvim-dap",dependencies={
    "folke/neodev.nvim",
    "nvim-neotest/nvim-nio",
    "mfussenegger/nvim-dap-python",
	"rcarriga/nvim-dap-ui"
},
    config = function ()
        
require("neodev").setup({library = { plugins = { "nvim-dap-ui" }, types = true }})
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

dap.configurations.python = {
  {
    -- The first three options are required by nvim-dap
    type = 'python'; -- the type here established the link to the adapter definition: `dap.adapters.python`
    request = 'launch';
    name = "Launch file";

    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

    program = "${file}"; -- This configuration will launch the current file if used.
   
    pythonPath = function()
      local cwd = vim.fn.getcwd()
      local venv_path = vim.fn.getenv("VIRTUAL_ENV")

      if venv_path then
        return venv_path .. '/bin/python'
      elseif vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
        return cwd .. '/venv/bin/python'
      elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
        return cwd .. '/.venv/bin/python'
      else
        return '/usr/bin/python'
      end
    end;
  },
}
    end
}}
