# Neovim Configuration - Codebase Improvement Report

**Generated:** 2025-11-07
**Configuration Type:** Neovim Lua Config
**Overall Quality:** Good - Well-organized, modern approach with some areas for improvement

---

## Executive Summary

This Neovim configuration is well-structured and uses modern best practices including lazy.nvim plugin management and the new Neovim 0.10+ LSP configuration API. However, there are several opportunities for improvement in areas of code duplication, error handling, performance optimization, and API deprecations.

**Priority Levels:**
- 🔴 **Critical** - Should be fixed immediately
- 🟡 **Important** - Should be addressed soon
- 🟢 **Optional** - Nice to have improvements

---

## 1. Code Quality Issues

### 🔴 1.1 Duplicate Plugin Configuration
**Location:** `lua/plugins/smart-splits.lua` and `lua/plugins/wezterm.lua`

**Issue:** The `smart-splits.nvim` plugin is configured in two separate files:
- `smart-splits.lua` (4 lines, minimal config)
- `wezterm.lua` (7 lines, includes setup call)

**Impact:** Potential conflicts, confusion, and unnecessary duplication.

**Solution:**
```lua
-- Remove lua/plugins/smart-splits.lua entirely
-- Keep only lua/plugins/wezterm.lua with the full configuration
```

---

### 🔴 1.2 Deprecated API Usage
**Location:** `init.lua:2`

**Issue:** Using deprecated `vim.loop` API:
```lua
if not vim.loop.fs_stat(lazypath) then
```

**Impact:** Will be removed in future Neovim versions. Already deprecated in Neovim 0.10+.

**Solution:**
```lua
-- Replace with:
if not vim.uv.fs_stat(lazypath) then
```

**Reference:** `vim.loop` has been deprecated in favor of `vim.uv` (libuv bindings).

---

### 🟡 1.3 Duplicate LSP Keybindings
**Location:** `settings/remap.lua` and `lua/plugins/lsp.lua:41-50`

**Issue:** LSP keybindings are defined in two places:
1. Global keybindings in `settings/remap.lua:12-22`
2. Buffer-local keybindings in `lsp.lua` on_attach function

**Impact:** Redundancy and potential conflicts. Global bindings will fail if LSP isn't attached.

**Solution:**
```lua
-- Option 1: Remove global LSP bindings from remap.lua (recommended)
-- Keep only the buffer-local bindings in lsp.lua on_attach

-- Option 2: If you want fallback behavior, add LSP checks:
vim.keymap.set('n', 'gd', function()
    if #vim.lsp.get_active_clients() > 0 then
        vim.lsp.buf.definition()
    else
        vim.notify("No LSP client attached", vim.log.levels.WARN)
    end
end, { noremap = true, silent = true })
```

---

### 🟡 1.4 Hardcoded Username in Paths
**Location:** `lua/plugins/lsp.lua:68, 76, 95`

**Issue:** Hardcoded `/home/jost/` paths for NixOS LSP server locations:
```lua
cmd = is_nixos and { "/home/jost/.nix-profile/bin/clangd" } or { "clangd" }
```

**Impact:** Configuration won't work for other users without manual editing.

**Solution:**
```lua
-- Use dynamic home directory:
local home = vim.fn.expand("$HOME")
cmd = is_nixos and { home .. "/.nix-profile/bin/clangd" } or { "clangd" }

-- Or even better, check if binary exists:
local function get_nix_binary(name)
    local nix_path = vim.fn.expand("$HOME") .. "/.nix-profile/bin/" .. name
    if vim.fn.executable(nix_path) == 1 then
        return nix_path
    end
    return name
end

cmd = { get_nix_binary("clangd") }
```

---

### 🟡 1.5 Missing Error Handling for Poetry Command
**Location:** `lua/plugins/lsp.lua:116`

**Issue:** No error handling when Poetry command fails:
```lua
local poetry_env = vim.fn.trim(vim.fn.system('poetry env info --path'))
if poetry_env ~= '' then
```

**Impact:** If Poetry is not installed or command fails, may cause issues or set incorrect Python path.

**Solution:**
```lua
before_init = function(_, config)
    local handle = io.popen('poetry env info --path 2>/dev/null')
    if handle then
        local poetry_env = vim.fn.trim(handle:read("*a"))
        handle:close()
        if poetry_env ~= '' and vim.fn.isdirectory(poetry_env) == 1 then
            config.settings.python.pythonPath = poetry_env .. '/bin/python'
        end
    end
end,
```

---

### 🟡 1.6 Telescope Required at Module Load Time
**Location:** `settings/remap.lua:23`

**Issue:** Telescope is required at the module level:
```lua
local builtin = require('telescope.builtin')
```

**Impact:** If telescope isn't loaded yet (lazy loading), this will cause an error or force early loading.

**Solution:**
```lua
-- Use lazy loading pattern:
keyset('n', '<C-f>', function()
    require('telescope.builtin').find_files({ hidden = true })
end, {})

-- Or wrap all telescope bindings:
local function get_telescope()
    return require('telescope.builtin')
end

keyset('n', '<C-f>', function() get_telescope().find_files({ hidden = true }) end, {})
```

---

### 🟢 1.7 Unused Global Function
**Location:** `init.lua:25-28`

**Issue:** `check_back_space()` function is defined but never used:
```lua
function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end
```

**Impact:** Dead code, minor performance overhead.

**Solution:**
```lua
-- Remove the function if not needed
-- OR document its purpose if it's for future use
```

---

### 🟢 1.8 Keybinding Conflict
**Location:** `settings/remap.lua:24` and `lua/plugins/lsp.lua:195-207`

**Issue:** `<C-f>` is bound to telescope find_files, but also used in LSP completion for snippet jumping:
```lua
-- In remap.lua:
keyset('n', '<C-f>', function() builtin.find_files({ hidden = true }) end, {})

-- In lsp.lua (completion):
['<C-f>'] = cmp.mapping(function(fallback)
    if luasnip.jumpable(1) then
        luasnip.jump(1)
    ...
```

**Impact:** Keybinding conflict in normal vs insert mode (actually okay since different modes, but could be confusing).

**Solution:**
```lua
-- This is actually fine since they're in different modes
-- But for clarity, consider using different keys or documenting:
-- <C-f> in normal mode: Find files
-- <C-f> in insert mode: Jump forward in snippet
```

---

## 2. Code Formatting & Style Issues

### 🟡 2.1 Inconsistent Formatting
**Location:** Multiple files

**Issue:** Inconsistent code formatting:
- `debug.lua:2-6` - Poor formatting, missing spaces
- `treesitter.lua` - Inconsistent indentation
- Mixed quote styles (single vs double)

**Examples:**
```lua
-- Bad (debug.lua):
{"mfussenegger/nvim-dap",dependencies={
    "nvim-neotest/nvim-nio",
    "mfussenegger/nvim-dap-python",
	"rcarriga/nvim-dap-ui"
},

-- Good:
{
    "mfussenegger/nvim-dap",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "mfussenegger/nvim-dap-python",
        "rcarriga/nvim-dap-ui"
    },
```

**Solution:**
```bash
# Install and use stylua formatter:
# Add to your CI or pre-commit hooks
stylua lua/ settings/ init.lua
```

---

### 🟢 2.2 Missing LuaLS Type Annotations
**Location:** Throughout codebase

**Issue:** No type annotations for better LSP support:
```lua
-- Current:
local function on_attach(client, bufnr)

-- Better:
---@param client vim.lsp.Client
---@param bufnr number
local function on_attach(client, bufnr)
```

**Solution:** Add LuaLS annotations for better type checking and autocompletion.

---

## 3. Performance Improvements

### 🟡 3.1 Eager Plugin Loading
**Location:** Several plugins lack lazy loading configuration

**Issue:** Some plugins are loaded immediately when they could be lazy-loaded:
- `rose-pine` colorscheme (loaded at startup, but only used after plugins load)
- `plenary.nvim` (dependency, should be lazy)
- `vim-fugitive` (could be loaded on Git commands)

**Solution:**
```lua
-- In misc.lua:
{
    "tpope/vim-fugitive",
    cmd = { "Git", "Gdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete" },
},

-- For colorscheme, current approach is fine for stability
```

---

### 🟡 3.2 Redundant Plugin Setup Calls
**Location:** `lua/plugins/lsp.lua:13-14`

**Issue:** Mason is set up twice:
```lua
require('mason').setup({})  -- Line 13
-- Then mason-lspconfig sets up mason again internally
```

**Solution:**
```lua
-- Remove the redundant mason setup:
require('mason-lspconfig').setup({
    automatic_installation = true,
    ensure_installed = { 'nil_ls', 'lua_ls', 'pyright', ... },
})
-- Mason will be auto-initialized by mason-lspconfig
```

---

### 🟢 3.3 Optimize Autocmd Event Triggers
**Location:** `lua/plugins/null-ls.lua:25`

**Issue:** Linting triggers on multiple events including `BufEnter`:
```lua
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
```

**Impact:** `BufEnter` fires frequently, may cause unnecessary linting runs.

**Solution:**
```lua
-- Consider removing BufEnter if linting is slow:
vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
    group = lint_augroup,
    callback = function()
        lint.try_lint()
    end,
})

-- Or add debouncing:
local lint_timer = nil
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    group = lint_augroup,
    callback = function()
        if lint_timer then
            vim.fn.timer_stop(lint_timer)
        end
        lint_timer = vim.fn.timer_start(100, function()
            lint.try_lint()
        end)
    end,
})
```

---

## 4. Architecture & Organization

### 🟢 4.1 ReloadConfig Function Limitation
**Location:** `settings/general.lua:61-69`

**Issue:** Module reload function assumes 'user' prefix:
```lua
if name:match('^user') and not name:match('nvim-tree') then
```

**Impact:** Won't reload modules that don't start with 'user'. Current config doesn't have 'user' prefix.

**Solution:**
```lua
function _G.ReloadConfig()
    -- Clear all non-plugin modules
    for name, _ in pairs(package.loaded) do
        -- Exclude plugin modules but include settings and custom modules
        if name:match('^settings') or name:match('^plugins') then
            package.loaded[name] = nil
        end
    end

    -- Reload init.lua
    dofile(vim.env.MYVIMRC)
    vim.notify("Nvim configuration reloaded!", vim.log.levels.INFO)
end
```

---

### 🟢 4.2 Plugin File Organization
**Location:** `lua/plugins/`

**Issue:** Some plugin files contain multiple unrelated plugins:
- `misc.lua` - Kitchen sink of miscellaneous plugins
- `lsp.lua` - Contains LSP, completion, and autopairs (247 lines)

**Impact:** Harder to maintain and find specific configurations.

**Solution:**
```lua
-- Consider splitting lsp.lua into:
-- - lua/plugins/lsp.lua (LSP servers only)
-- - lua/plugins/completion.lua (nvim-cmp, luasnip)
-- - lua/plugins/autopairs.lua (autopairs config)

-- Rename misc.lua to something more descriptive:
-- - lua/plugins/utilities.lua or lua/plugins/editing.lua
```

---

### 🟢 4.3 Missing Plugin Configuration Comments
**Location:** Various plugin files

**Issue:** Many plugins lack explanatory comments about why they're configured a certain way.

**Example:**
```lua
-- Current:
vim.opt.conceallevel = 2

-- Better:
-- Set conceallevel for obsidian.nvim markdown rendering
-- Allows hiding markdown syntax for cleaner appearance
vim.opt.conceallevel = 2
```

**Solution:** Add comments explaining non-obvious configuration choices.

---

## 5. Security & Best Practices

### 🟡 5.1 API Key Loading from rbw
**Location:** `lua/plugins/copilot.lua:83-148`

**Issue:** Complex async API key loading logic without timeout handling.

**Impact:** If rbw hangs, Neovim could appear frozen.

**Solution:**
```lua
-- Add timeout to jobstart:
local job_id = vim.fn.jobstart({ "rbw", "get", rbw_item_name }, {
    -- ... existing handlers ...
    on_exit = function(_, exit_code)
        -- ... existing code ...
    end,
    stdout_buffered = true,
    stderr_buffered = true,
    timeout = 5000, -- 5 second timeout
})

-- Or use plenary.nvim's async with timeout:
local Job = require('plenary.job')
Job:new({
    command = 'rbw',
    args = { 'get', rbw_item_name },
    timeout = 5000,
    -- ... handlers
}):start()
```

---

### 🟢 5.2 Error Messages Could Be More Helpful
**Location:** Multiple files

**Issue:** Some error messages lack context:
```lua
-- Current (copilot.lua:141):
vim.notify("Invalid command: rbw get " .. rbw_item_name, vim.log.levels.ERROR)

-- Better:
vim.notify(
    "Invalid command: rbw get " .. rbw_item_name ..
    "\nPlease check that the rbw item exists and you have access.",
    vim.log.levels.ERROR
)
```

---

## 6. Missing Features & Enhancements

### 🟢 6.1 No Plugin Update Automation
**Issue:** No automated way to check for plugin updates or changelog viewing.

**Solution:**
```lua
-- Add to init.lua or create lua/plugins/lazy-config.lua:
require("lazy").setup({
    spec = { { import = "plugins" } },
    lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
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

-- Add keymap to check updates:
vim.keymap.set('n', '<leader>lu', ':Lazy update<CR>', { desc = 'Update plugins' })
vim.keymap.set('n', '<leader>lc', ':Lazy check<CR>', { desc = 'Check for updates' })
```

---

### 🟢 6.2 No LSP Server Status Indicator
**Issue:** No easy way to see which LSP servers are attached to current buffer.

**Solution:**
```lua
-- Add to keybindings:
vim.keymap.set('n', '<leader>li', ':LspInfo<CR>', { desc = 'LSP Info' })

-- Or add a custom command:
vim.api.nvim_create_user_command('LspStatus', function()
    local clients = vim.lsp.get_active_clients({ bufnr = 0 })
    if #clients == 0 then
        vim.notify("No LSP clients attached", vim.log.levels.INFO)
    else
        local client_names = {}
        for _, client in ipairs(clients) do
            table.insert(client_names, client.name)
        end
        vim.notify("LSP clients: " .. table.concat(client_names, ", "), vim.log.levels.INFO)
    end
end, {})
```

---

### 🟢 6.3 No Project-Local Configuration Support
**Issue:** No support for project-specific Neovim configuration.

**Solution:**
```lua
-- Add to init.lua after main setup:
-- Load project-local config if it exists
local project_config = vim.fn.getcwd() .. '/.nvim.lua'
if vim.fn.filereadable(project_config) == 1 then
    vim.notify("Loading project config: " .. project_config, vim.log.levels.INFO)
    dofile(project_config)
end
```

---

## 7. Documentation Improvements

### 🟢 7.1 Missing README
**Issue:** No README.md explaining:
- How to install
- Dependencies required
- Keybinding reference
- Plugin list and purposes

**Solution:** Create a comprehensive README.md with setup instructions.

---

### 🟢 7.2 No Keybinding Cheatsheet
**Issue:** Keybindings scattered across multiple files make it hard to learn/remember.

**Solution:**
```lua
-- Leverage which-key or mini.clue (already installed!)
-- Add to lua/plugins/mini.lua or create separate config:
require('mini.clue').setup({
    triggers = {
        { mode = 'n', keys = '<Leader>' },
        { mode = 'x', keys = '<Leader>' },
        { mode = 'n', keys = 'g' },
        { mode = 'x', keys = 'g' },
    },
    clues = {
        require('mini.clue').gen_clues.builtin_completion(),
        require('mini.clue').gen_clues.g(),
        require('mini.clue').gen_clues.marks(),
        require('mini.clue').gen_clues.registers(),
        require('mini.clue').gen_clues.windows(),
        require('mini.clue').gen_clues.z(),
    },
})
```

---

## 8. Testing & Maintenance

### 🟢 8.1 No Automated Testing
**Issue:** No tests for custom functions or configurations.

**Solution:**
```lua
-- Consider adding plenary test for complex functions:
-- tests/reload_config_spec.lua
local eq = assert.are.same

describe("ReloadConfig", function()
    it("should reload configuration without errors", function()
        _G.ReloadConfig()
        -- Assert no errors occurred
        eq(vim.v.errmsg, "")
    end)
end)
```

---

### 🟢 8.2 No Configuration Validation
**Issue:** No checks if required external tools are installed.

**Solution:**
```lua
-- Add to init.lua or create lua/health.lua:
local function check_dependencies()
    local required = {
        { cmd = "git", name = "Git" },
        { cmd = "rg", name = "Ripgrep (for telescope)" },
        { cmd = "fd", name = "fd (for telescope)" },
        { cmd = "poetry", name = "Poetry (optional for Python)" },
        { cmd = "rbw", name = "rbw (for API keys)" },
    }

    local missing = {}
    for _, dep in ipairs(required) do
        if vim.fn.executable(dep.cmd) == 0 then
            table.insert(missing, dep.name)
        end
    end

    if #missing > 0 then
        vim.notify(
            "Missing dependencies: " .. table.concat(missing, ", ") ..
            "\nSome features may not work correctly.",
            vim.log.levels.WARN
        )
    end
end

-- Run on startup
vim.defer_fn(check_dependencies, 1000)
```

---

## Priority Action Items

### Immediate (Fix Today)
1. ✅ Fix deprecated `vim.loop` → `vim.uv` in init.lua:2
2. ✅ Remove duplicate smart-splits configuration
3. ✅ Remove duplicate LSP keybindings from remap.lua

### Short Term (This Week)
4. ✅ Replace hardcoded username with `$HOME` in lsp.lua
5. ✅ Add error handling for Poetry command
6. ✅ Fix telescope require in remap.lua
7. ✅ Format debug.lua and treesitter.lua consistently

### Medium Term (This Month)
8. ✅ Add type annotations for major functions
9. ✅ Split large plugin files (lsp.lua)
10. ✅ Add plugin update automation
11. ✅ Create README with documentation

### Long Term (Nice to Have)
12. ✅ Add project-local configuration support
13. ✅ Implement dependency checking
14. ✅ Add automated tests for custom functions
15. ✅ Create comprehensive keybinding documentation

---

## Conclusion

This Neovim configuration is well-structured and uses modern best practices. The main improvements needed are:

1. **Code Quality**: Fix duplications and deprecated APIs
2. **Error Handling**: Add robust error handling for external commands
3. **Performance**: Optimize lazy loading and event triggers
4. **Documentation**: Add README and keybinding documentation
5. **Maintainability**: Split large files and add comments

Overall Assessment: **7.5/10**
- Modern architecture ✅
- Good plugin choices ✅
- Needs better error handling ⚠️
- Could improve performance ⚠️
- Needs documentation ⚠️

The configuration shows solid understanding of Neovim and Lua, with room for polish and optimization.
