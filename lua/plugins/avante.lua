return {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    version = false,
    keys = {
        {
            '<leader>aa',
            function()
                local rbw = require('utils.rbw')

                local loaded_keys = 0
                local success_count = 0
                local total_keys = 3

                local function ask_avante()
                    vim.defer_fn(function()
                        local ok, avante_api = pcall(require, 'avante.api')
                        if ok and avante_api.ask then
                            avante_api.ask()
                        else
                            vim.notify('Failed to load avante.api or ask function not available', vim.log.levels.ERROR)
                        end
                    end, 100)
                end

                local function check_done(success)
                    if success then
                        success_count = success_count + 1
                    end

                    loaded_keys = loaded_keys + 1
                    if loaded_keys ~= total_keys then
                        return
                    end

                    if success_count == total_keys then
                        vim.notify('All API keys loaded successfully!', vim.log.levels.INFO)
                        ask_avante()
                    else
                        vim.notify('Failed to load all API keys. Avante may not function correctly.', vim.log.levels.ERROR)
                    end
                end

                rbw.load_env('perplexity', 'PERPLEXITY_API_KEY', check_done)
                rbw.load_env('openrouter', 'OPENROUTER_API_KEY', check_done)
                rbw.load_env('tavily', 'TAVILY_API_KEY', check_done)
            end,
            desc = 'Load API keys from rbw and ask Avante',
        },
        { '<leader>mcp', '<cmd>MCPHub<cr>', desc = 'Open MCP Hub marketplace' },
    },
    opts = {
        provider = 'openrouter',
        providers = {
            openrouter = {
                __inherited_from = 'openai',
                endpoint = 'https://openrouter.ai/api/v1',
                api_key_name = 'OPENROUTER_API_KEY',
                model = 'x-ai/grok-code-fast-1',
            },
        },
        disabled_tools = {
            'list_files', 'search_files', 'read_file',
            'create_file', 'rename_file', 'delete_file',
            'create_dir', 'rename_dir', 'delete_dir',
        },
        custom_tools = function()
            local ok, ext = pcall(require, 'mcphub.extensions.avante')
            if ok then
                return { ext.mcp_tool() }
            end
            return {}
        end,
    },
    build = 'make',
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
        'stevearc/dressing.nvim',
        'nvim-lua/plenary.nvim',
        'MunifTanjim/nui.nvim',
        'echasnovski/mini.pick',
        'nvim-telescope/telescope.nvim',
        'hrsh7th/nvim-cmp',
        'ibhagwan/fzf-lua',
        'nvim-tree/nvim-web-devicons',
        'ravitemer/mcphub.nvim',
        {
            'MeanderingProgrammer/render-markdown.nvim',
            opts = {
                file_types = { 'markdown', 'Avante' },
            },
            ft = { 'markdown', 'Avante' },
        },
    },
    config = function(_, opts)
        require('avante_lib').load()
        require('avante').setup(opts)
    end,
}
