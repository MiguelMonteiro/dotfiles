-- color schemes
require("nvim-treesitter.configs").setup({
	ensure_installed = { "python", "json", "toml", "yaml", "lua", "markdown", "markdown_inline", "latex" },
	highlight = {
		enable = true,
	},
})

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
local keymap = vim.keymap.set
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
