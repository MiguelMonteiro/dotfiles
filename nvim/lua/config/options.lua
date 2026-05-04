-- Set <space> as the leader key (must be set before lazy.nvim installs packages)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

opt.breakindent = true
opt.clipboard = "unnamedplus"
opt.confirm = true
opt.cursorline = true
opt.expandtab = true
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true
opt.linebreak = true
opt.number = true
opt.pumheight = 10
opt.scrolloff = 2
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help" }
opt.shiftround = true
opt.tabstop = 2
opt.shiftwidth = 0 -- use tabstop value
opt.sidescrolloff = 5
opt.signcolumn = "yes"
opt.smartcase = true
opt.smartindent = true
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.timeoutlen = 100
opt.ttimeoutlen = 0
opt.undofile = true
opt.updatetime = 200
opt.wrap = false
opt.fillchars = { eob = " " }
opt.jumpoptions = "view,stack"
opt.ruler = false
opt.showcmd = false

-- show tab characters
opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

if vim.fn.has("nvim-0.9.0") == 1 then
  opt.splitkeep = "screen"
  opt.shortmess:append({ C = true })
end

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
