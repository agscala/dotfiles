vim.opt.backspace = "indent,eol,start"
vim.opt.hlsearch = false
vim.opt.wildignore = '*.o,*~,*.pyc,*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store,*/.node_modules'
vim.opt.tm = 500
-- vim.opt.fileformats="unix,dos,mac"

vim.opt.autowrite = true           -- Enable auto write
vim.opt.clipboard = "unnamedplus"  -- Sync with system clipboard
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.conceallevel = 3           -- Hide * markup for bold and italic
vim.opt.confirm = true             -- Confirm to save changes before exiting modified buffer
vim.opt.cursorline = true          -- Enable highlighting of the current line
vim.opt.cursorcolumn = false        -- Enable highlighting of the current line
vim.opt.expandtab = true           -- Use spaces instead of tabs
vim.opt.formatoptions = "jcroqlnt" -- tcqj
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.ignorecase = true      -- Ignore case
vim.opt.inccommand = "nosplit" -- preview incremental substitute
-- vim.opt.laststatus = 0
vim.opt.list = true            -- Show some invisible characters (tabs...
vim.opt.listchars = "tab:» ,trail:·"
vim.opt.mouse = "a"            -- Enable mouse mode
vim.opt.number = true          -- Print line number
vim.opt.numberwidth = 2        -- Number column min width
vim.opt.pumblend = 10          -- Popup blend
vim.opt.pumheight = 10         -- Maximum number of entries in a popup
vim.opt.relativenumber = false -- Relative line numbers
vim.opt.scrolloff = 4          -- Lines of context
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
vim.opt.shiftround = true      -- Round indent
vim.opt.shiftwidth = 2         -- Size of an indent
vim.opt.shortmess:append { W = true, I = true, c = true }
vim.opt.showmode = false       -- Dont show mode since we have a statusline
vim.opt.sidescrolloff = 4      -- Columns of context
vim.opt.signcolumn = "yes"     -- Always show the signcolumn, otherwise it would shift the text each time
vim.opt.smartcase = true       -- Don't ignore case with capitals
vim.opt.smartindent = true     -- Insert indents automatically
vim.opt.spelllang = { "en" }
vim.opt.splitbelow = true      -- Put new windows below current
vim.opt.splitright = true      -- Put new windows right of current
vim.opt.swapfile = false
vim.opt.tabstop = 4            -- Number of spaces tabs count for
vim.opt.termguicolors = true   -- True color support
vim.opt.timeoutlen = 300
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("~/.config/nvim/undofiles")
vim.opt.undolevels = 10000
vim.opt.updatetime = 200               -- Save swap file and trigger CursorHold
vim.opt.wildmode = "longest:full,full" -- Command-line completion mode
vim.opt.winminwidth = 5                -- Minimum window width
vim.opt.wrap = true                   -- Disable line wrap

if vim.fn.has("nvim-0.9.0") == 1 then
    vim.opt.splitkeep = "screen"
    vim.opt.shortmess:append { C = true }
end

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
