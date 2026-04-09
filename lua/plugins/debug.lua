return {
    {
        "mfussenegger/nvim-dap",
        cmd = {
            "DapContinue",
            "DapToggleBreakpoint",
            "DapStepOver",
            "DapStepInto",
            "DapStepOut",
        },
        keys = {
            { '<C-b>', function() require('dap').toggle_breakpoint() end, desc = 'DAP: toggle breakpoint' },
            { '<F5>', function() require('dap').continue() end, desc = 'DAP: continue' },
            { '<F6>', function() require('dap').step_over() end, desc = 'DAP: step over' },
            { '<F7>', function() require('dap').step_into() end, desc = 'DAP: step into' },
            { '<F8>', function() require('dap').step_out() end, desc = 'DAP: step out' },
        },
        dependencies = {
            "nvim-neotest/nvim-nio",
            "mfussenegger/nvim-dap-python",
            "rcarriga/nvim-dap-ui"
        },
        config = function()
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
    }
}
