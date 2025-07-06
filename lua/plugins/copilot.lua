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
            provider = "openrouter",
            providers = { 
                openrouter = {
                    __inherited_from = 'openai',
                    endpoint = 'https://openrouter.ai/api/v1',
                    api_key_name = 'OPENROUTER_API_KEY',
                    model = "anthropic/claude-sonnet-4",
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
                "HakonHarnes/img-clip.nvim",
                event = "VeryLazy",
                opts = {
                    default = {
                        embed_image_as_base64 = false,
                        prompt_for_file_name = false,
                        drag_and_drop = {
                            insert_mode = true,
                        },
                        use_absolute_path = true,
                    },
                },
            },
            {
                'MeanderingProgrammer/render-markdown.nvim',
                opts = {
                    file_types = { "markdown", "Avante" },
                },
                ft = { "markdown", "Avante" },
            },
        },
        config = function(_, opts)
            -- Load API key from rbw with proper error handling
            local function load_api_key_from_rbw(callback)
                local rbw_item_name = "openrouter"
                local env_var_name = "OPENROUTER_API_KEY"
                
                -- Check if key is already loaded
                if vim.env[env_var_name] and vim.env[env_var_name] ~= "" then
                    vim.notify(env_var_name .. " already loaded from environment", vim.log.levels.INFO)
                    if callback then callback(true) end
                    return
                end

                -- vim.notify("Loading " .. env_var_name .. " from rbw...", vim.log.levels.INFO)

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
                                -- vim.notify(env_var_name .. " loaded successfully from rbw!", vim.log.levels.INFO)
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

                -- Handle case where jobstart fails
                if job_id == 0 then
                    vim.notify("Invalid command: rbw get " .. rbw_item_name, vim.log.levels.ERROR)
                    if callback then callback(false) end
                elseif job_id == -1 then
                    vim.notify("rbw command not found. Please ensure rbw is installed and in PATH.", vim.log.levels.ERROR)
                    if callback then callback(false) end
                end
            end

            -- Function to load key and then call avante
            local function load_key_and_ask()
                load_api_key_from_rbw(function(success)
                    if success then
                        -- Small delay to ensure the environment variable is properly set
                        vim.defer_fn(function()
                            local ok, avante_api = pcall(require, "avante.api")
                            if ok and avante_api.ask then
                                avante_api.ask()
                            else
                                vim.notify("Failed to load avante.api or ask function not available", vim.log.levels.ERROR)
                            end
                        end, 100)
                    else
                        vim.notify("Cannot proceed with Avante: API key loading failed", vim.log.levels.ERROR)
                    end
                end)
            end

            require("avante_lib").load()
            require("avante").setup(opts)

            -- Create keymaps
            vim.keymap.set('n', '<leader>aa', load_key_and_ask, { 
                desc = 'Load OpenRouter API Key from rbw and ask Avante' 
            })
            
            -- Auto-load key on first use if not already loaded
            vim.api.nvim_create_autocmd("User", {
                pattern = "AvanteAskPre",
                callback = function()
                    if not vim.env.OPENROUTER_API_KEY or vim.env.OPENROUTER_API_KEY == "" then
                        vim.notify("API key not found, loading from rbw...", vim.log.levels.INFO)
                        load_api_key_from_rbw()
                    end
                end,
            })
        end,
    }
}
