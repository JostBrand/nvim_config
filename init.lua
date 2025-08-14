local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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
package.path = package.path ..
    ";" ..
    config_path ..
    "/?.lua;" ..
    config_path ..
    "/?/init.lua;" ..
    config_path ..
    "/plugins/?.lua;" ..
    vim.fn.expand("$HOME") ..
    "/.luarocks/share/lua/5.1/?/init.lua;" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua;"
vim.g.mapleader = " "
function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

vim.g.suda_smart_edit = 1

require("lazy").setup({
    spec = {{ import = "plugins" }},
    lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
})

require('settings/remap')   -- personal keymappings
require('settings/general') -- settings
vim.cmd('colorscheme rose-pine')
