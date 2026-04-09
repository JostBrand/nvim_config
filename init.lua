local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
local config_path = vim.fn.stdpath('config')
package.path = package.path .. ';' .. config_path .. '/?.lua;' .. config_path .. '/?/init.lua'
vim.g.mapleader = " "
vim.g.suda_smart_edit = 1

require("lazy").setup({
    spec = {{ import = "plugins" }},
    lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json",
    checker = {
        enabled = true,      -- Automatically check for updates
        notify = false,      -- Don't notify on check (can be annoying)
        frequency = 3600,    -- Check every hour
    },
    change_detection = {
        enabled = true,
        notify = false,
    },
})

require('settings/remap')   -- personal keymappings
require('settings/general') -- settings
vim.cmd('colorscheme rose-pine')
