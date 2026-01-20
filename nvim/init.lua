-- nvim options (leader key must be set before lazy.nvim installs packages)
require("options")

-- Install lazy.nvim package mangager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)
-- vim.keymap.set("n", "<leader>l", "<cmd>:Lazy<cr>", { desc = "[l]azy (plugin manager)", noremap = true, silent = true })

-- Setup lazy.nvim and install packages
require("lazy").setup({
  -- misc
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 }, -- colour scheme
  { "christoomey/vim-tmux-navigator" }, --tmux navigation
  -- editor
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "nvim-treesitter/nvim-treesitter-textobjects" },
  { "echasnovski/mini.nvim" },
  -- lsp
  { "williamboman/mason.nvim", build = ":MasonUpdate" },
  { "neovim/nvim-lspconfig" },
  { "stevearc/conform.nvim" }, -- formatting
  { "saghen/blink.cmp", version = "1.*" }, --autocompletion
  { "rafamadriz/friendly-snippets" }, -- library of snippets
  -- markdown
  { "jbyuki/nabla.nvim" }, -- ascii math render
  { "MeanderingProgrammer/render-markdown.nvim" }, -- markdown render
  -- snippets
  {
    "danymat/neogen",
    config = true,
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

vim.cmd.colorscheme("catppuccin-frappe")

require("editor")
require("lsp")
require("markdown")
