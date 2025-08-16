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
        "yetone/avante.nvim",
        event = "VeryLazy",
        version = false,
        opts = {
            provider = "perplexity",
            providers = {
                openrouter = {
                    __inherited_from = 'openai',
                    endpoint = 'https://openrouter.ai/api/v1',
                    api_key_name = 'OPENROUTER_API_KEY',
                    model = "qwen/qwen3-coder",
                },
                perplexity = {
                    __inherited_from = "openai",
                    api_key_name = "PERPLEXITY_API_KEY",
                    endpoint = "https://api.perplexity.ai",
                    model = "sonar-reasoning-pro",
                },
            },
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
                    vim.notify("rbw command not found. Please ensure rbw is installed and in PATH.", vim.log.levels.ERROR)
                    if callback then callback(false) end
                end
            end

            -- This function now correctly loads all keys and then runs the callback
            local function load_all_keys(callback)
                local loaded_keys = 0
                local total_keys = 2
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
                        vim.notify("Failed to load all API keys. Avante may not function correctly.", vim.log.levels.ERROR)
                    end
                end)
            end

            require("avante_lib").load()
            require("avante").setup(opts)

            vim.keymap.set('n', '<leader>aa', load_keys_and_run_avante, {
                desc = 'Load all API Keys from rbw and ask Avante'
            })
        end,
    }
}
