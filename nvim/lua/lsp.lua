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

-- treesitter

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
local keymap = vim.keymap.set
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
