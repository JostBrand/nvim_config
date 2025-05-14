vim.api.nvim_set_hl(0, 'CmpItemAbbrDeprecated', { bg='NONE', strikethrough=true, fg='#808080' })
-- blue
vim.api.nvim_set_hl(0, 'CmpItemAbbrMatch', { bg='NONE', fg='#569CD6' })
vim.api.nvim_set_hl(0, 'CmpItemAbbrMatchFuzzy', { link='CmpIntemAbbrMatch' })
-- light blue
vim.api.nvim_set_hl(0, 'CmpItemKindVariable', { bg='NONE', fg='#9CDCFE' })
vim.api.nvim_set_hl(0, 'CmpItemKindInterface', { link='CmpItemKindVariable' })
vim.api.nvim_set_hl(0, 'CmpItemKindText', { link='CmpItemKindVariable' })
-- pink
vim.api.nvim_set_hl(0, 'CmpItemKindFunction', { bg='NONE', fg='#C586C0' })
vim.api.nvim_set_hl(0, 'CmpItemKindMethod', { link='CmpItemKindFunction' })
-- front
vim.api.nvim_set_hl(0, 'CmpItemKindKeyword', { bg='NONE', fg='#D4D4D4' })
vim.api.nvim_set_hl(0, 'CmpItemKindProperty', { link='CmpItemKindKeyword' })
vim.api.nvim_set_hl(0, 'CmpItemKindUnit', { link='CmpItemKindKeyword' })

-- General options
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
vim.opt.colorcolumn = "120"
vim.opt.smartcase = true
vim.opt.conceallevel = 2


vim.opt.clipboard = "unnamedplus"

local augroup = vim.api.nvim_create_augroup("PythonFormat", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  pattern = "*.py",
  callback = function()
    -- Use black
    vim.lsp.buf.format { async = false }
    -- If you prefer autopep8, use this instead:
    -- vim.cmd("silent !autopep8 --in-place %")
    -- If you prefer ruff, use this instead:
    -- vim.cmd("silent !ruff format %")
  end,
})

function _G.ReloadConfig()
    for name, _ in pairs(package.loaded) do
        if name:match('^user') and not name:match('nvim-tree') then
            package.loaded[name] = nil
        end
    end
    dofile(vim.env.MYVIMRC)
    vim.notify("Nvim configuration reloaded!", vim.log.levels.INFO)
end

local opts = { noremap = true, silent = false }
vim.api.nvim_set_keymap('n', '<leader>rl', '<cmd>lua ReloadConfig()<CR>', opts)
