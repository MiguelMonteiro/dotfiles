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
}
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
end, { desc = "toggle math" }))
