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
        "ravitemer/mcphub.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        init = function()
            local system = require("utils.system")
            local mcphub_config = vim.fn.expand("~/.config/mcphub/servers.json")

            system.ensure_parent_dir(mcphub_config)
            if not system.file_exists(mcphub_config) then
                vim.fn.writefile({ "{", '  "mcpServers": {}', "}" }, mcphub_config)
            end
        end,
        build = 'bundled_build.lua',
        config = function()
            local system = require("utils.system")
            local mcphub_config = vim.fn.expand("~/.config/mcphub/servers.json")
            local bundled_cmd = vim.fn.stdpath("data") .. "/lazy/mcphub.nvim/bundled/mcp-hub/node_modules/.bin/mcp-hub"
            local use_bundled = vim.fn.executable(bundled_cmd) == 1
            local has_global = vim.fn.executable("mcp-hub") == 1

            if not use_bundled and not has_global then
                vim.notify("MCP Hub executable not found; skipping mcphub.nvim setup", vim.log.levels.WARN)
                return
            end

            require("mcphub").setup({
                port = 3000,
                config = mcphub_config,
                use_bundled_binary = use_bundled,
                log = {
                    level = vim.log.levels.WARN,
                    to_file = true,
                },
                on_ready = function()
                    vim.notify("MCP Hub is online!", vim.log.levels.INFO)
                end
            })
        end,
    },
    {
        "yetone/avante.nvim",
        event = "VeryLazy",
        version = false,
        opts = {
            provider = "openrouter",
            providers = {
                openrouter = {
                    __inherited_from = 'openai',
                    endpoint = 'https://openrouter.ai/api/v1',
                    api_key_name = 'OPENROUTER_API_KEY',
                    model = "x-ai/grok-code-fast-1",
                },
            },
            disabled_tools = {
                "list_files", "search_files", "read_file",
                "create_file", "rename_file", "delete_file",
                "create_dir", "rename_dir", "delete_dir"
            },
            custom_tools = function()
                local ok, ext = pcall(require, "mcphub.extensions.avante")
                if ok then
                    return { ext.mcp_tool() }
                end
                return {}
            end,
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
            "ravitemer/mcphub.nvim", -- Add mcphub as dependency
            {
                'MeanderingProgrammer/render-markdown.nvim',
                opts = {
                    file_types = { "markdown", "Avante" },
                },
                ft = { "markdown", "Avante" },
            },
        },
        config = function(_, opts)
            local function load_api_key_from_rbw(rbw_item_name, env_var_name, callback)
                if vim.env[env_var_name] and vim.env[env_var_name] ~= "" then
                    vim.notify(env_var_name .. " already loaded from environment", vim.log.levels.INFO)
                    if callback then callback(true) end
                    return
                end

                vim.notify("Loading " .. env_var_name .. " from rbw...", vim.log.levels.INFO)

                local stdout_data = {}
                local stderr_data = {}

                local job_id = vim.fn.jobstart({ "rbw", "get", rbw_item_name }, {
                    on_stdout = function(_, data)
                        if data then
                            for _, line in ipairs(data) do
                                if line and line ~= "" then
                                    table.insert(stdout_data, line)
                                end
                            end
                        end
                    end,
                    on_stderr = function(_, data)
                        if data then
                            for _, line in ipairs(data) do
                                if line and line ~= "" then
                                    table.insert(stderr_data, line)
                                end
                            end
                        end
                    end,
                    on_exit = function(_, exit_code)
                        if exit_code == 0 and #stdout_data > 0 then
                            local api_key = vim.trim(table.concat(stdout_data, ""))
                            if api_key and api_key ~= "" then
                                vim.env[env_var_name] = api_key
                                vim.notify(env_var_name .. " loaded successfully from rbw!", vim.log.levels.INFO)
                                if callback then callback(true) end
                            else
                                vim.notify("Retrieved empty API key from rbw", vim.log.levels.ERROR)
                                if callback then callback(false) end
                            end
                        else
                            local error_msg = "Failed to retrieve " .. env_var_name .. " from rbw"
                            if #stderr_data > 0 then
                                error_msg = error_msg .. ": " .. table.concat(stderr_data, " ")
                            elseif exit_code ~= 0 then
                                error_msg = error_msg .. " (exit code: " .. exit_code .. ")"
                            end
                            vim.notify(error_msg, vim.log.levels.ERROR)
                            if callback then callback(false) end
                        end
                    end,
                    stdout_buffered = true,
                    stderr_buffered = true,
                })

                if job_id == 0 then
                    vim.notify("Invalid command: rbw get " .. rbw_item_name, vim.log.levels.ERROR)
                    if callback then callback(false) end
                elseif job_id == -1 then
                    vim.notify("rbw command not found. Please ensure rbw is installed and in PATH.", vim.log.levels
                        .ERROR)
                    if callback then callback(false) end
                end
            end

            local function load_all_keys(callback)
                local loaded_keys = 0
                local total_keys = 3 -- Updated to include tavily
                local success_count = 0

                local function check_done(success)
                    if success then success_count = success_count + 1 end
                    loaded_keys = loaded_keys + 1
                    if loaded_keys == total_keys then
                        callback(success_count == total_keys)
                    end
                end

                load_api_key_from_rbw("perplexity", "PERPLEXITY_API_KEY", check_done)
                load_api_key_from_rbw("openrouter", "OPENROUTER_API_KEY", check_done)
                load_api_key_from_rbw("tavily", "TAVILY_API_KEY", check_done)
            end

            local function ask_avante()
                vim.defer_fn(function()
                    local ok, avante_api = pcall(require, "avante.api")
                    if ok and avante_api.ask then
                        avante_api.ask()
                    else
                        vim.notify("Failed to load avante.api or ask function not available", vim.log.levels.ERROR)
                    end
                end, 100)
            end

            local function load_keys_and_run_avante()
                load_all_keys(function(success)
                    if success then
                        vim.notify("All API keys loaded successfully!", vim.log.levels.INFO)
                        ask_avante()
                    else
                        vim.notify("Failed to load all API keys. Avante may not function correctly.",
                            vim.log.levels.ERROR)
                    end
                end)
            end

            require("avante_lib").load()
            require("avante").setup(opts)

            vim.keymap.set('n', '<leader>aa', load_keys_and_run_avante, {
                desc = 'Load all API Keys from rbw and ask Avante'
            })
            -- Add MCPHub keymap
            vim.keymap.set('n', '<leader>mcp', ':MCPHub<CR>', {
                desc = 'Open MCP Hub marketplace'
            })
        end,
    }
}
