local function apply_highlights()
    vim.api.nvim_set_hl(0, 'CmpItemAbbrDeprecated', { bg = 'NONE', strikethrough = true, fg = '#808080' })
    vim.api.nvim_set_hl(0, 'CmpItemAbbrMatch', { bg = 'NONE', fg = '#569CD6' })
    vim.api.nvim_set_hl(0, 'CmpItemAbbrMatchFuzzy', { link = 'CmpItemAbbrMatch' })
    vim.api.nvim_set_hl(0, 'CmpItemKindVariable', { bg = 'NONE', fg = '#9CDCFE' })
    vim.api.nvim_set_hl(0, 'CmpItemKindInterface', { link = 'CmpItemKindVariable' })
    vim.api.nvim_set_hl(0, 'CmpItemKindText', { link = 'CmpItemKindVariable' })
    vim.api.nvim_set_hl(0, 'CmpItemKindFunction', { bg = 'NONE', fg = '#C586C0' })
    vim.api.nvim_set_hl(0, 'CmpItemKindMethod', { link = 'CmpItemKindFunction' })
    vim.api.nvim_set_hl(0, 'CmpItemKindKeyword', { bg = 'NONE', fg = '#D4D4D4' })
    vim.api.nvim_set_hl(0, 'CmpItemKindProperty', { link = 'CmpItemKindKeyword' })
    vim.api.nvim_set_hl(0, 'CmpItemKindUnit', { link = 'CmpItemKindKeyword' })

    vim.api.nvim_set_hl(0, '@lsp.type.boolean', { link = '@boolean' })
    vim.api.nvim_set_hl(0, '@lsp.type.comment', { link = '@comment' })
    vim.api.nvim_set_hl(0, '@lsp.type.enum', { link = '@type' })
    vim.api.nvim_set_hl(0, '@lsp.type.enumMember', { link = '@constant' })
    vim.api.nvim_set_hl(0, '@lsp.type.function', { link = '@function' })
    vim.api.nvim_set_hl(0, '@lsp.type.interface', { link = '@type' })
    vim.api.nvim_set_hl(0, '@lsp.type.keyword', { link = '@keyword' })
    vim.api.nvim_set_hl(0, '@lsp.type.macro', { link = '@function.macro' })
    vim.api.nvim_set_hl(0, '@lsp.type.method', { link = '@function.method' })
    vim.api.nvim_set_hl(0, '@lsp.type.namespace', { link = '@module' })
    vim.api.nvim_set_hl(0, '@lsp.type.number', { link = '@number' })
    vim.api.nvim_set_hl(0, '@lsp.type.operator', { link = '@operator' })
    vim.api.nvim_set_hl(0, '@lsp.type.parameter', { link = '@variable.parameter' })
    vim.api.nvim_set_hl(0, '@lsp.type.property', { link = '@property' })
    vim.api.nvim_set_hl(0, '@lsp.type.string', { link = '@string' })
    vim.api.nvim_set_hl(0, '@lsp.type.struct', { link = '@type' })
    vim.api.nvim_set_hl(0, '@lsp.type.type', { link = '@type' })
    vim.api.nvim_set_hl(0, '@lsp.type.typeParameter', { link = '@type.definition' })
    vim.api.nvim_set_hl(0, '@lsp.type.variable', { link = '@variable' })

    vim.api.nvim_set_hl(0, 'RenderMarkdownCode', { bg = '#1f1d2e' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownCodeInline', { bg = '#26233a', fg = '#e0def4' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownBullet', { fg = '#c4a7e7' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownUnchecked', { fg = '#908caa' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownChecked', { fg = '#9ccfd8' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownTodo', { fg = '#f6c177' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownInProgress', { fg = '#ebbcba' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownImportant', { fg = '#eb6f92' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownCancelled', { fg = '#6e6a86' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownQuote', { fg = '#908caa' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownLink', { fg = '#9ccfd8', underline = true })
    vim.api.nvim_set_hl(0, 'RenderMarkdownInfo', { fg = '#9ccfd8' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownSuccess', { fg = '#31748f' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownHint', { fg = '#c4a7e7' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownWarn', { fg = '#f6c177' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownError', { fg = '#eb6f92' })

    vim.api.nvim_set_hl(0, 'RainbowDelimiterRose', { fg = '#ebbcba', bold = true })
    vim.api.nvim_set_hl(0, 'RainbowDelimiterFoam', { fg = '#9ccfd8', bold = true })
    vim.api.nvim_set_hl(0, 'RainbowDelimiterGold', { fg = '#f6c177', bold = true })
    vim.api.nvim_set_hl(0, 'RainbowDelimiterPine', { fg = '#31748f', bold = true })
    vim.api.nvim_set_hl(0, 'RainbowDelimiterIris', { fg = '#c4a7e7', bold = true })
    vim.api.nvim_set_hl(0, 'RainbowDelimiterLove', { fg = '#eb6f92', bold = true })
    vim.api.nvim_set_hl(0, 'RainbowDelimiterMuted', { fg = '#908caa', bold = true })
end

local highlight_group = vim.api.nvim_create_augroup('UserHighlights', { clear = true })
vim.api.nvim_create_autocmd('ColorScheme', {
    group = highlight_group,
    callback = apply_highlights,
})

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
vim.opt.signcolumn = 'yes'
vim.opt.isfname:append('@-@')
vim.opt.updatetime = 50
vim.opt.colorcolumn = '120'
vim.opt.smartcase = true
vim.opt.conceallevel = 2

vim.opt.list = true
vim.opt.listchars = {
    tab = '▏ ',
    leadmultispace = '▏   ',
    trail = '·',
    nbsp = '⍽',
}

vim.opt.clipboard = 'unnamedplus'

apply_highlights()

local augroup = vim.api.nvim_create_augroup('PythonFormat', { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
    group = augroup,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 200 })
    end,
})

function _G.ReloadConfig()
    for name, _ in pairs(package.loaded) do
        if name:match('^plugins') or name:match('^settings') or name:match('^utils') then
            package.loaded[name] = nil
        end
    end
    dofile(vim.env.MYVIMRC)
    vim.notify('Nvim configuration reloaded!', vim.log.levels.INFO)
end

local opts = { noremap = true, silent = false }
vim.api.nvim_set_keymap('n', '<leader>rl', '<cmd>lua ReloadConfig()<CR>', opts)
