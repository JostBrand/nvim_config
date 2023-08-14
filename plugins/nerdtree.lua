local M = {}

M.nerdtree_smart_toggle = function()
    -- Check if NERDTree is visible
    local nerdtree_is_open = false
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local buf_name = vim.api.nvim_buf_get_name(buf)
        if string.find(buf_name, "NERD_tree_") then
            nerdtree_is_open = true
            break
        end
    end

    if nerdtree_is_open then
        vim.cmd('NERDTreeClose')
        return
    end

    -- If NERDTree is not visible, determine where to open it
    local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
    if vim.v.shell_error == 0 and git_root ~= "" then
        vim.cmd('NERDTree ' .. git_root)
    else
        -- If not inside a git repo, use the current file's directory
        vim.cmd('NERDTreeFind')
    end
end

return M

