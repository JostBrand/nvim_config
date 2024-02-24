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
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua;"
vim.opt.rtp:prepend(lazypath)
config_path = vim.fn.stdpath('config')
package.path = config_path .. "/?.lua;" .. config_path .. "/?/init.lua;" .. config_path .. "/plugins/?.lua;" .. package.path

vim.g.mapleader = " "
function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

--  need to load these settings before lazy
vim.g['suda_smart_edit'] = 1
vim.g['suda#nopass'] = 1
vim.g['suda#prompt']='pw:'

require("lazy").setup({
{import = "plugins"},
	"lambdalisue/suda.vim",
	"doums/darcula",
    "windwp/nvim-autopairs",
	"tpope/vim-fugitive",
    'mhinz/vim-startify',
    "ryanoasis/vim-devicons",
    'mbbill/undotree',
    "nvim-lua/plenary.nvim",
{ 'rose-pine/neovim', name = 'rose-pine' },
    "preservim/tagbar",
{
	"Pocco81/true-zen.nvim",
	config = function()
		 require("true-zen").setup {
			-- your config goes here
		 }
	end,
},

{
 "folke/trouble.nvim",
 dependencies = { "nvim-tree/nvim-web-devicons" },
 opts = {
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
 },
},
  performance = {
    rtp = {
      paths = { "~/.config/nvim/snippets" }
    }
  }
})

require('settings/remap') -- personal keymappings
require('settings/general') -- settings

vim.cmd('colorscheme rose-pine')
