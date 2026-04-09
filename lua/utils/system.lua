local M = {}

local uv = vim.uv or vim.loop

function M.hostname()
    if uv and uv.os_gethostname then
        local ok, name = pcall(uv.os_gethostname)
        if ok and name and name ~= "" then
            return name
        end
    end

    if vim.fn.executable("hostname") == 1 then
        local name = vim.fn.trim(vim.fn.system({ "hostname" }))
        if vim.v.shell_error == 0 and name ~= "" then
            return name
        end
    end

    return ""
end

function M.executable(cmd)
    return vim.fn.executable(cmd) == 1
end

function M.path_exists(path)
    return path and vim.fn.isdirectory(vim.fn.expand(path)) == 1
end

function M.file_exists(path)
    return path and vim.fn.filereadable(vim.fn.expand(path)) == 1
end

function M.ensure_parent_dir(path)
    local dir = vim.fn.fnamemodify(vim.fn.expand(path), ":h")
    if dir ~= "" and vim.fn.isdirectory(dir) == 0 then
        vim.fn.mkdir(dir, "p")
    end
end

function M.has_clipboard_provider()
    return M.executable("win32yank")
        or M.executable("xclip")
        or M.executable("xsel")
        or M.executable("wl-copy")
end

function M.open_command()
    if M.executable("xdg-open") then
        return "xdg-open"
    end
    if M.executable("wslview") then
        return "wslview"
    end
    return nil
end

function M.mason_bin(binary)
    local path = vim.fn.stdpath("data") .. "/mason/bin/" .. binary
    if vim.fn.executable(path) == 1 then
        return path
    end
    return nil
end

function M.distro_name()
    local file = io.open("/etc/os-release", "r")
    if not file then
        return nil
    end

    for line in file:lines() do
        if line:match("^NAME=") then
            file:close()
            return line:gsub('NAME=', ''):gsub('"', '')
        end
    end

    file:close()
    return nil
end

function M.is_nixos()
    local distro_name = M.distro_name()
    return distro_name and string.find(string.lower(distro_name), "nixos") ~= nil
end

return M
