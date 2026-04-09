local M = {}

function M.load_env(item_name, env_var_name, callback)
    if vim.env[env_var_name] and vim.env[env_var_name] ~= '' then
        vim.notify(env_var_name .. ' already loaded from environment', vim.log.levels.INFO)
        if callback then
            callback(true)
        end
        return
    end

    vim.notify('Loading ' .. env_var_name .. ' from rbw...', vim.log.levels.INFO)

    local stdout_data = {}
    local stderr_data = {}

    local job_id = vim.fn.jobstart({ 'rbw', 'get', item_name }, {
        on_stdout = function(_, data)
            if not data then
                return
            end

            for _, line in ipairs(data) do
                if line and line ~= '' then
                    table.insert(stdout_data, line)
                end
            end
        end,
        on_stderr = function(_, data)
            if not data then
                return
            end

            for _, line in ipairs(data) do
                if line and line ~= '' then
                    table.insert(stderr_data, line)
                end
            end
        end,
        on_exit = function(_, exit_code)
            if exit_code == 0 and #stdout_data > 0 then
                local value = vim.trim(table.concat(stdout_data, ''))
                if value ~= '' then
                    vim.env[env_var_name] = value
                    vim.notify(env_var_name .. ' loaded successfully from rbw!', vim.log.levels.INFO)
                    if callback then
                        callback(true)
                    end
                    return
                end
                vim.notify('Retrieved empty value from rbw for ' .. env_var_name, vim.log.levels.ERROR)
            else
                local error_msg = 'Failed to retrieve ' .. env_var_name .. ' from rbw'
                if #stderr_data > 0 then
                    error_msg = error_msg .. ': ' .. table.concat(stderr_data, ' ')
                elseif exit_code ~= 0 then
                    error_msg = error_msg .. ' (exit code: ' .. exit_code .. ')'
                end
                vim.notify(error_msg, vim.log.levels.ERROR)
            end

            if callback then
                callback(false)
            end
        end,
        stdout_buffered = true,
        stderr_buffered = true,
    })

    if job_id == 0 then
        vim.notify('Invalid command: rbw get ' .. item_name, vim.log.levels.ERROR)
        if callback then
            callback(false)
        end
    elseif job_id == -1 then
        vim.notify('rbw command not found. Please ensure rbw is installed and in PATH.', vim.log.levels.ERROR)
        if callback then
            callback(false)
        end
    end
end

return M
