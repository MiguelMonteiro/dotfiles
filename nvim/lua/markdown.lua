--markdown and latex equation renderers
require("render-markdown").setup({
  completions = { lsp = { enabled = true } },
  latex = { enabled = false },
  win_options = { conceallevel = { rendered = 2 } },
  -- on = {
  --   render = function()
  --     require("nabla").enable_virt({ autogen = true })
  --   end,
  --   clear = function()
  --     require("nabla").disable_virt()
  --   end,
  -- }, -- best to render nabla independently of markdown plugin
})
-- keymaps
local keymap = vim.keymap.set

--render keymaps
keymap("n", "<leader>vm", function()
  require("render-markdown").toggle()
end, { desc = "toggle markdown" })

keymap("n", "<leader>ve", function()
  require("nabla").popup()
end, { desc = "toggle equation" })

keymap("n", "<leader>va", function()
  require("nabla").toggle_virt()
end, { desc = "toggle ascii math" })
