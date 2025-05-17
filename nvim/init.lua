--ui uimuiiuini and mini.deps
-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
	vim.cmd('echo "Installing `mini.nvim`" | redraw')
	local clone_cmd = {
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/echasnovski/mini.nvim",
		mini_path,
	}
	vim.fn.system(clone_cmd)
	vim.cmd("packadd mini.nvim | helptags ALL")
	vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Set up 'mini.deps' (customize to your liking)
require("mini.deps").setup({ path = { package = path_package } })
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

--nvim options
vim.g.mapleader = " "
vim.o.number = true

-- mini text editing modules
require("mini.comment").setup()
require("mini.move").setup() -- this is useful but it is not working because the meta key does not seem to work
require("mini.pairs").setup()
require("mini.snippets").setup()
require("mini.surround").setup() -- this is kind of useful but kind of wonky

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
		{ mode = "n", keys = "<Leader>f", desc = " find" },
		{ mode = "n", keys = "<Leader>g", desc = "󰊢 git" },
		{ mode = "n", keys = "<Leader>l", desc = "󰘦 lsp" },
		{ mode = "n", keys = "<Leader>t", desc = "󰔃 toggle" },
		{ mode = "n", keys = "<Leader>u", desc = "󰔃 ui" },
		{ mode = "n", keys = "<Leader>p", desc = "󰔃 obsidian" },
		miniclue.gen_clues.builtin_completion(),
		miniclue.gen_clues.g(),
		miniclue.gen_clues.marks(),
		miniclue.gen_clues.registers(),
		miniclue.gen_clues.windows(),
		miniclue.gen_clues.z(),
	},
	window = { delay = 0 },
})
require("mini.bufremove").setup()
require("mini.files").setup({
	mappings = {
		close = "<ESC>",
	},
	windows = {
		preview = false,
		border = "solid",
		width_preview = 40,
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
-- mini appearance modules
-- require("mini.animate").setup() this could be nice but needs to be configured to look good
require("mini.cursorword").setup()
require("mini.icons").setup()
require("mini.indentscope").setup({
	draw = {
		animation = function()
			return 1
		end,
	},
	symbol = "|",
})
require("mini.statusline").setup()
require("mini.tabline").setup()
require("mini.trailspace").setup()
-- require("mini.completion").setup()

--mini other modules
require("mini.doc").setup()
require("mini.fuzzy").setup()

-- completion
add({
	source = "saghen/blink.cmp",
	depends = { "rafamadriz/friendly-snippets" },
	checkout = "v1.2.0", -- check releases for latest tag
})
require("blink.cmp").setup({
	-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
	-- 'super-tab' for mappings similar to vscode (tab to accept)
	-- 'enter' for enter to accept
	-- 'none' for no mappings
	--
	-- All presets have the following mappings:
	-- C-space: Open menu or open docs if already open
	-- C-n/C-p or Up/Down: Select next/previous item
	-- C-e: Hide menu
	-- C-k: Toggle signature help (if signature.enabled = true)
	--
	-- See :h blink-cmp-config-keymap for defining your own keymap
	keymap = { preset = "default" },

	appearance = {
		-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
		-- Adjusts spacing to ensure icons are aligned
		nerd_font_variant = "mono",
	},

	-- (Default) Only show the documentation popup when manually triggered
	completion = { documentation = { auto_show = false } },

	-- Default list of enabled providers defined so that you can extend it
	-- elsewhere in your config, without redefining it, due to `opts_extend`
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},

	-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
	-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
	-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
	--
	-- See the fuzzy documentation for more information
	fuzzy = { implementation = "prefer_rust_with_warning" },
})
-- require("mini.fuzzy").setup()

-- color schemes
add({ source = "catppuccin/nvim", name = "catppuccin" })
vim.cmd.colorscheme("catppuccin-frappe")

-- treesitter
add({
	source = "neovim/nvim-lspconfig",
	depends = { "williamboman/mason.nvim" },
})

add({
	source = "nvim-treesitter/nvim-treesitter",
	checkout = "master",
	monitor = "main",
	hooks = {
		post_checkout = function()
			vim.cmd("TSUpdate")
		end,
	},
})

require("nvim-treesitter.configs").setup({
	ensure_installed = { "python", "json", "toml", "yaml", "lua", "markdown", "markdown_inline", "latex" },
	highlight = {
		enable = true,
	},
})

-- LSP pre-configuration
local lspconfig = require("lspconfig")
local on_attach_custom = function(client, buf_id)
	vim.bo[buf_id].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"
	-- client.resolved_capabilities.document_formatting = false
	-- client.resolved_capabilities.document_range_formatting = false
end

local diagnostic_opts = {
	float = { border = "double" },
	signs = {
		priority = 9999,
		severity = { min = "WARN", max = "ERROR" },
	},
	virtual_text = { severity = { min = "ERROR", max = "ERROR" } },
	update_in_insert = false,
}
vim.diagnostic.config(diagnostic_opts)

-- Python LSPs: ruff and pyright
-- lspconfig.ruff.setup({ on_attach = on_attach_custom })
lspconfig.ruff.setup({
	init_options = {
		settings = {
			args = { "--config=/Users/MiguelMonteiro/projects/qur8ml/pyproject.toml" },
		},
	},
	on_attach = on_attach_custom,
})
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client == nil then
			return s
		end
		if client.name == "ruff" then
			client.server_capabilities.hoverProvider = false
		end
	end,
	desc = "LSP: Disable hover capability from Ruff",
})
lspconfig.pyright.setup({
	on_attach = on_attach_custom,
	settings = {
		pyright = {
			-- Using Ruff's import organizer
			disableOrganizeImports = true,
		},
	},
})

-- formatting using conform
add({ source = "stevearc/conform.nvim" })
require("conform").setup({
	formatters_by_ft = {
		python = { "ruff_fix", "ruff_format" },
		json = { "prettier" },
		toml = { "prettier" },
		yaml = { "prettier" },
		lua = { "stylua" },
		html = { "prettier" },
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_fallback = true,
	},
})

--obsidian plugin
-- add({ source = "nvim-lua/plenary.nvim" })
-- add({
-- 	source = "epwalsh/obsidian.nvim",
-- 	tag = "*", -- recommended, use latest release instead of latest commit
-- 	depends = {
-- 		-- Required.
-- 		"nvim-lua/plenary.nvim",
-- 	},
-- })
-- require("obsidian").setup({
-- 	ui = { enable = false }, -- ui rendering is handled by markdown plugin
-- 	workspaces = {
-- 		{
-- 			name = "ml_and_stats",
-- 			path = "~/Documents/obsidian_vaults/ml_and_stats",
-- 		},
-- 	},
-- 	disable_frontmatter = false, -- set to true if you don't want automatic headers
-- 	mappings = {
-- 		-- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
-- 		["gf"] = {
-- 			action = function()
-- 				return require("obsidian").util.gf_passthrough()
-- 			end,
-- 			opts = { noremap = false, expr = true, buffer = true },
-- 		},
-- 		-- Toggle check-boxes.
-- 		["<leader>ph"] = {
-- 			action = function()
-- 				return require("obsidian").util.toggle_checkbox()
-- 			end,
-- 			opts = { buffer = true },
-- 		},
-- 		-- Smart action depending on context, either follow link or toggle checkbox.
-- 		["<cr>"] = {
-- 			action = function()
-- 				return require("obsidian").util.smart_action()
-- 			end,
-- 			opts = { buffer = true, expr = true },
-- 		},
-- 	},
-- 	picker = {
-- 		-- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
-- 		name = "mini.pick",
-- 		-- Optional, configure key mappings for the picker. These are the defaults.
-- 		-- Not all pickers support all mappings.
-- 		note_mappings = {
-- 			-- Create a new note from your query.
-- 			new = "<leader>px",
-- 			-- Insert a link to the selected note.
-- 			insert_link = "<leader>pl",
-- 		},
-- 		tag_mappings = {
-- 			-- Add tag(s) to current note.
-- 			tag_note = "<leader>px",
-- 			-- Insert a tag at the current location.
-- 			insert_tag = "leader>pl",
-- 		},
-- 	},
-- })
--
--markdown and latex equation renderers
add({ source = "jbyuki/nabla.nvim" })
add({
	source = "MeanderingProgrammer/render-markdown.nvim",
	depends = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
})
require("render-markdown").setup({
	completions = { lsp = { enabled = true } },
	latex = { enabled = false },
	win_options = { conceallevel = { rendered = 2 } },
	on = {
		render = function()
			require("nabla").enable_virt({ autogen = true })
		end,
		clear = function()
			require("nabla").disable_virt()
		end,
	},
})

-- keymaps
local keymap = vim.keymap.set

--render keymaps
keymap("n", "<leader>tm", function()
	require("render-markdown").toggle()
end, { desc = "toggle markdown" })
keymap("n", "<leader>te", function()
	require("nabla").popup()
end, { desc = "toggle equation" })
keymap("n", "<leader>ta", function()
	require("nabla").toggle_virt()
end, { desc = "toggle math" })
-- find keymaps
keymap("n", "<leader>ff", function()
	require("mini.pick").builtin.files()
end, { desc = "file" })
keymap("n", "<leader>fe", function()
	local buffer_name = vim.api.nvim_buf_get_name(0)
	if buffer_name == "" or string.match(buffer_name, "Starter") then
		require("mini.files").open(vim.loop.cwd())
	else
		require("mini.files").open(vim.api.nvim_buf_get_name(0))
	end
end, { desc = "explore" })
keymap("n", "<leader>fg", function()
	require("mini.pick").builtin.grep_live()
end, { desc = "grep" })
keymap("n", "<leader>fG", function()
	local wrd = vim.fn.expand("<cword>")
	require("mini.pick").builtin.grep({ pattern = wrd })
end, { desc = "grep cursor" })
keymap("n", "<leader>fh", function()
	require("mini.pick").builtin.help()
end, { desc = "help" })
keymap("n", ",", function()
	require("mini.extra").pickers.buf_lines({ scope = "current" })
end, { nowait = true, desc = "lines" })

-- buffer keymaps
keymap("n", "<leader>bd", "<cmd>bd<cr>", { desc = "close buffer" })
keymap("n", "<S-l>", "<cmd>bnext<cr>", { desc = "clockwise" })
keymap("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "anti clockwise" })

-- LSP keymaps
keymap("n", "<leader>fs", "<cmd>Pick lsp scope='document_symbol'<cr>", { desc = "symbols" })

keymap("n", "<leader>fd", function()
	require("mini.extra").pickers.diagnostic({ scope = "current" })
end, { desc = "diagnostics" })

keymap("n", "<leader>lr", function()
	vim.lsp.buf.rename()
	vim.cmd("silent! wa")
end, { desc = "rename" })
keymap("n", "<leader>lf", function()
	require("conform").format()
end, { desc = "format" })
keymap("n", "<leader>la", function()
	vim.lsp.buf.code_action()
end, { desc = "code action" })
keymap("n", "<leader>ld", function()
	vim.diagnostic.open_float()
end, { desc = "diagnostic" })
if vim.tbl_isempty(vim.lsp.buf_get_clients()) then
	keymap("n", "gd", function()
		vim.lsp.buf.definition()
	end, { desc = "definition" })
else
	keymap("n", "gd", "gd", { desc = "definition" })
end

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

-- colourscheme keymaps
keymap("n", "<leader>ud", "<cmd>set background=dark<cr>", { desc = "dark" })
keymap("n", "<leader>ul", "<cmd>set background=light<cr>", { desc = "light" })

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
