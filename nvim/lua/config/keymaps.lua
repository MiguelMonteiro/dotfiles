local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- better up/down
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })

-- Use Q instead of q for recording macros
map("n", "Q", "q")
map("n", "q", "<Nop>")

-- Move to window using the <ctrl> hjkl keys
map({ "n", "t" }, "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
map({ "n", "t" }, "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
map({ "n", "t" }, "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
map({ "n", "t" }, "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })

-- use esc to go to normal mode in terminal
map("t", "<esc>", [[<C-\><C-n>]])

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- move cursor with alt-hjkl in insert mode
map({ "i", "c", "t" }, "<M-h>", "<Left>", { silent = false, noremap = false, desc = "Left" })
map({ "i", "c", "t" }, "<M-j>", "<Down>", { silent = false, noremap = false, desc = "Down" })
map({ "i", "c", "t" }, "<M-k>", "<Up>", { silent = false, noremap = false, desc = "Up" })
map({ "i", "c", "t" }, "<M-l>", "<Right>", { silent = false, noremap = false, desc = "Right" })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Quicker find and replace with confirmation (nb the visual mode one overrides h register)
map("v", "<leader>#", '"hy:%s/<C-r>h//gc<left><left><left>', { desc = "Find and replace selected text" })
map("n", "<leader>#", ":%s/<C-r><C-w>//gc<Left><Left><left>", { desc = "Find and replace current word" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map({ "n", "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map({ "n", "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- buffer keymaps
map("n", "<leader>bn", "<cmd>enew<cr>", { desc = "new buffer" })
map("n", "<leader>be", "<cmd>e<cr>", { desc = "reload/refresh" })
map("n", "<leader>bw", "<cmd>w<cr><esc>", { desc = "write buffer" })
map("n", "<leader>bd", "<cmd>bd<cr>", { desc = "close buffer" })

-- buffer navigation
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "clockwise" })
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "anti clockwise" })

-- quit
map("n", "<leader>q", "<cmd>qa<cr>", { desc = "[q]uit all" })

-- toggle word wrap
map("n", "<leader>vw", "<cmd>set wrap!<cr>", { desc = "toggle word wrap" })

-- terminal commands
map("n", "<leader>tg", "<cmd>:terminal lazygit<cr>", { desc = "󰊢 lazygit" })
map(
  "n",
  "<leader>tp",
  "<cmd>:terminal ipython --TerminalInteractiveShell.editing_mode=vi<cr>",
  { desc = " ipython" }
)

-- search in only the visible screen, respecting the scrolloff setting.
-- The window will never scroll when searching with this function.
local function screen_search()
  local scrolloff = vim.o.scrolloff
  local botline = vim.fn.line("w$") + 1
  local topline = vim.fn.line("w0") - 1
  local eofline = vim.fn.line("$")

  if topline > scrolloff then
    topline = topline + scrolloff
  end

  if botline < eofline - scrolloff then
    botline = botline - scrolloff
  end

  local pattern = "/\\%>" .. topline .. "l\\%<" .. botline .. "l"
  vim.fn.feedkeys(pattern, "n")
end
vim.api.nvim_create_user_command("ScreenSearch", screen_search, { desc = "" })

-- Experimental: mapping ? to my custom screen search function. I don't
-- use ? that much anyway because I use / with wrapping as bidirectional search
map({ "n", "v" }, "?", screen_search, { desc = "" })
