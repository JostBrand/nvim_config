return {
    'ravitemer/mcphub.nvim',
    cmd = 'MCPHub',
    dependencies = {
        'nvim-lua/plenary.nvim',
    },
    init = function()
        local system = require('utils.system')
        local mcphub_config = vim.fn.expand('~/.config/mcphub/servers.json')

        system.ensure_parent_dir(mcphub_config)
        if not system.file_exists(mcphub_config) then
            vim.fn.writefile({ '{', '  "mcpServers": {}', '}' }, mcphub_config)
        end
    end,
    build = 'bundled_build.lua',
    config = function()
        local mcphub_config = vim.fn.expand('~/.config/mcphub/servers.json')
        local bundled_cmd = vim.fn.stdpath('data') .. '/lazy/mcphub.nvim/bundled/mcp-hub/node_modules/.bin/mcp-hub'
        local use_bundled = vim.fn.executable(bundled_cmd) == 1
        local has_global = vim.fn.executable('mcp-hub') == 1

        if not use_bundled and not has_global then
            vim.notify('MCP Hub executable not found; skipping mcphub.nvim setup', vim.log.levels.WARN)
            return
        end

        require('mcphub').setup({
            port = 3000,
            config = mcphub_config,
            use_bundled_binary = use_bundled,
            log = {
                level = vim.log.levels.WARN,
                to_file = true,
            },
            on_ready = function()
                vim.notify('MCP Hub is online!', vim.log.levels.INFO)
            end,
        })
    end,
}
