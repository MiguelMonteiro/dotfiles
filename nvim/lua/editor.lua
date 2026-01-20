-- Plugins for improving the editor experience

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- which-key is an alternateive to mini.clue
-- which-key provides hints/menus to visualise keybindings
-- require("which-key").setup({ icons = { mappings = false } })

-- treesitter is for syntax highlighting and smart text objects
require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "bash",
    "json",
    "latex",
    "lua",
    "markdown",
    "markdown_inline",
    "python",
    "rust",
    "toml",
    "vim",
    "vimdoc",
    "yaml",
  },
  auto_install = true,
  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    -- keymaps = {
    -- 	init_selection = "<CR>",
    -- 	node_incremental = "<CR>",
    -- 	node_decremental = "<BS>",
    -- },
  },
})

-- mini.nvim is a set of utilities for improving the editor
require("mini.icons").setup()
require("mini.move").setup()
require("mini.surround").setup()
require("mini.extra").setup()
-- require("mini.diff").setup()
-- require("mini.jump").setup()
local gen_loader = require("mini.snippets").gen_loader
require("mini.snippets").setup({
  mappings = {
    -- Expand snippet at cursor position. Created globally in Insert mode.
    expand = "<Leader>sj",

    -- Interact with default `expand.insert` session.
    -- Created for the duration of active session(s)
    jump_next = "<Leader>sl",
    jump_prev = "<Leader>sh",
    stop = "<Leader>sc",
  },
  snippets = {
    -- Load custom file with global snippets first (adjust for Windows)
    -- gen_loader.from_file('~/.config/nvim/snippets/global.json'),

    -- Load snippets based on current language by reading files from
    -- "snippets/" subdirectories from 'runtimepath' directories.
    gen_loader.from_lang(),
  },
})
require("mini.comment").setup()
require("mini.pairs").setup()
require("mini.bufremove").setup()
require("mini.statusline").setup()
require("mini.tabline").setup()
require("mini.trailspace").setup()
require("mini.fuzzy").setup()
require("mini.cursorword").setup()
require("mini.files").setup({
  mappings = {
    close = "<ESC>",
  },
})
require("mini.pick").setup({
  mappings = {
    choose_in_vsplit = "<C-CR>",
  },
  options = {
    use_cache = true,
  },
})

require("mini.indentscope").setup({
  draw = {
    animation = function()
      return 1
    end,
  },
  symbol = "|",
})
-- mini text editing modules
-- mini general workflow modules
require("mini.basics").setup({
  options = {
    basic = true,
    extra_ui = true,
    win_borders = "bold",
  },
  mappings = {
    basic = true,
    windows = true,
  },
  autocommands = {
    basic = true,
    relnum_in_visual_mode = true,
  },
})

local miniclue = require("mini.clue")
miniclue.setup({
  triggers = {
    -- Leader triggers
    { mode = "n", keys = "<Leader>" },
    { mode = "x", keys = "<Leader>" },

    -- Built-in completion
    { mode = "i", keys = "<C-x>" },

    -- `g` key
    { mode = "n", keys = "g" },
    { mode = "x", keys = "g" },

    -- Marks
    { mode = "n", keys = "'" },
    { mode = "n", keys = "`" },
    { mode = "x", keys = "'" },
    { mode = "x", keys = "`" },

    -- Registers
    { mode = "n", keys = '"' },
    { mode = "x", keys = '"' },
    { mode = "i", keys = "<C-r>" },
    { mode = "c", keys = "<C-r>" },

    -- Window commands
    { mode = "n", keys = "<C-w>" },

    -- `z` key
    { mode = "n", keys = "z" },
    { mode = "x", keys = "z" },
  },

  clues = {
    { mode = "n", keys = "<Leader>b", desc = " buffer" },
    { mode = "n", keys = "<Leader>s", desc = " search" },
    { mode = "n", keys = "<Leader>t", desc = " terminal" },
    { mode = "n", keys = "<Leader>l", desc = "󰘦 lsp" },
    { mode = "n", keys = "<Leader>v", desc = "󰍹 view" },
    -- { mode = "n", keys = "<Leader>u", desc = "󰔃 ui" },
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
  },
  window = { delay = 0, config = { width = "auto" } },
})
-- file explorer (Mini.files)
map("n", "<leader>e", "<cmd>lua MiniFiles.open()<cr>", { desc = " explorer" })

-- commonly used search keymaps in top level namespace
map("n", "<leader><space>", "<cmd>Pick files<cr>", { desc = "Search files" })
map("n", "<leader>,", "<cmd>Pick buffers<cr>", { desc = "Search buffers" })
map("n", "<leader>;", "<cmd>Pick resume<cr>", { desc = "Resume last search" })
map("n", "<leader>.", "<cmd>Pick grep_live<cr>", { desc = "Live grep (workspace)" })
map("n", "<leader>/", '<cmd>Pick buf_lines scope="current"<cr>', { desc = "Fuzzy search (buffer)" })

-- <leader>s namespace is for searching with fuzzy finder (mini.pick)
map("n", "<leader>sh", "<cmd>Pick help<cr>", { desc = "help pages" })
map("n", "<leader>sf", "<cmd>Pick explorer<cr>", { desc = "files (tree view)" })
map("n", "<leader>s/", '<Cmd>Pick history scope="/"<CR>', { desc = "search history" })
map("n", "<leader>s:", '<Cmd>Pick history scope=":"<CR>', { desc = "command history" })
map("n", "<leader>sc", '<Cmd>Pick git_commits path="%"<CR>', { desc = "commits (file)" })
map("n", "<leader>sC", "<Cmd>Pick git_commits<CR>", { desc = "Commits (workspace)" })
map("n", "<leader>sd", '<Cmd>Pick diagnostic scope="current"<CR>', { desc = "diagnostics (file)" })
map("n", "<leader>sD", '<Cmd>Pick diagnostic scope="all"<CR>', { desc = "Diagnostics (workspace)" })
map("n", "<leader>sr", '<cmd>Pick lsp scope="references"<cr>', { desc = "references" })
map("n", "<leader>ss", '<cmd>Pick lsp scope="document_symbol"<cr>', { desc = "symbol (file)" })
map("n", "<leader>sS", '<cmd>Pick lsp scope="workspace_symbol"<cr>', { desc = "Symbol (workspace)" })
map("n", "<leader>sq", '<cmd>Pick list scope="quickfix"<cr>', { desc = "quickfix list" })
map("n", "<leader>sl", '<cmd>Pick list scope="location"<cr>', { desc = "location list" })
map("n", "<leader>sj", '<cmd>Pick list scope="jump"<cr>', { desc = "jump list" })

-- terminal keymaps
map("n", "<leader>tg", "<cmd>:terminal lazygit<cr>", { desc = "󰊢 lazygit" })
map(
  "n",
  "<leader>tp",
  "<cmd>:terminal ipython --TerminalInteractiveShell.editing_mode=vi<cr>",
  { desc = " ipython" }
)
