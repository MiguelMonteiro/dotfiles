-- Bootstrap lazy.nvim
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
vim.keymap.set("n", "<leader>l", "<cmd>:Lazy<cr>", { desc = "[l]azy (plugin manager)", noremap = true, silent = true })

-- nvim options (before lazy setup)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.o.number = true

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- import your plugins
		{ import = "plugins" },
		-- misc
		{ "catppuccin/nvim", name = "catppuccin", priority = 1000 }, -- colour scheme
		{ "christoomey/vim-tmux-navigator" }, --tmux navigation
		-- editor
		-- { "folke/which-key.nvim" },
		{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
		{ "nvim-treesitter/nvim-treesitter-textobjects" },
		{ "echasnovski/mini.nvim" },
		-- { "gpanders/nvim-parinfer" },
		-- lsp
		{ "williamboman/mason.nvim", build = ":MasonUpdate" },
		{ "neovim/nvim-lspconfig" },
		{ "stevearc/conform.nvim" }, -- formatting
		{ "saghen/blink.cmp", version = "1.*" }, --autocompletion
		-- { "rafamadriz/friendly-snippets" },
		-- markdown
		{ "jbyuki/nabla.nvim" }, -- ascii math render
		{ "MeanderingProgrammer/render-markdown.nvim" }, -- markdown render
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})
vim.cmd.colorscheme("catppuccin-frappe")

require("lua/editor")
require("lua/lsp")

-- window navigation
keymap("n", "<C-l>", "<cmd>wincmd l<cr>", { desc = "left" })
keymap("n", "<C-k>", "<cmd>wincmd k<cr>", { desc = "up" })
keymap("n", "<C-j>", "<cmd>wincmd j<cr>", { desc = "down" })
keymap("n", "<C-h>", "<cmd>wincmd h<cr>", { desc = "right" })

-- git keymaps
keymap("n", "<leader>gc", function()
	require("mini.extra").pickers.git_commits({ path = vim.fn.expand("%:p") })
end, { desc = "log current file" })
keymap("", "<leader>gh", function()
	require("mini.git").show_range_history()
end, { desc = "range history" })
keymap("n", "<leader>gb", function()
	require("mini.git").show_at_cursor()
end, { desc = "git blame at cursor" })
keymap("n", "<leader>gl", "<cmd>:terminal lazygit<cr>", { desc = "lazy" })

-- -- colourscheme keymaps
-- keymap("n", "<leader>ud", "<cmd>set background=dark<cr>", { desc = "dark" })
-- keymap("n", "<leader>ul", "<cmd>set background=light<cr>", { desc = "light" })

-- tmux navigator
add({
	source = "christoomey/vim-tmux-navigator",
	depends = {},
	cmd = {
		"TmuxNavigateLeft",
		"TmuxNavigateDown",
		"TmuxNavigateUp",
		"TmuxNavigateRight",
		"TmuxNavigatePrevious",
	},
	keys = {
		{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
		{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
		{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
		{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
		{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
	},
})
--
vim.diagnostic.config({ virtual_text = false })
