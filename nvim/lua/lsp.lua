--lsp
vim.lsp.config("luals", {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", ".git" },
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      workspace = { library = { vim.env.VIMRUNTIME } },
    },
  },
})


vim.lsp.config('ty', {
  settings = {
    ty = {
      configuration = {
        rules = {
          ["unresolved-reference"] = "warn"
        }
      }
    },
  },
})
-- vim.lsp.config("pyright", {
--   settings = {
--
--     pyright = {
--       -- Using Ruff's import organizer
--       disableOrganizeImports = true,
--     },
--     python = { analysis = { diagnosticMode = "workspace" } },
--   },
-- })
vim.lsp.config("pyright", {
  on_attach = on_attach,
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    "pyrightconfig.json",
    ".git",
  },
  settings = {
    pyright = { autoImportCompletion = true, disableOrganizeImports = true },
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly",
        useLibraryCodeForTypes = true,
        typeCheckingMode = "off",
      },
    },
  },
})

vim.lsp.enable("luals")
-- vim.lsp.enable("pyright")
vim.lsp.enable("ruff")
vim.lsp.enable("ty")
vim.lsp.enable("harper_ls") -- grammar and spellcheking

-- vim.lsp.enable("rust_analyzer")

require("conform").setup({
  formatters_by_ft = {
    python = { "ruff_fix", "ruff_format" },
    lua = { "stylua" },
    html = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier" },
    toml = { "prettier" },
    sh = { "shfmt" },
    markdown = { "prettier" },
    bib = { "bibtex-tidy" },
    -- "_" is for filetypes without any other formatters
    ["_"] = {
      "trim_whitespace",
      "trim_newlines",
    },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
})

require("conform").formatters.shfmt = {
  prepend_args = { "--indent=2", "--case-indent" },
}

require("conform").formatters.stylua = {
  prepend_args = { "--indent-type=Spaces", "--indent-width=2" },
}

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

-- auto-completion
require("blink.cmp").setup({
  keymap = { preset = "default" },
  cmdline = { completion = { menu = { auto_show = true } } },
  -- completion = { list = { selection = { preselect = false, auto_insert = true } } },
  completion = { documentation = { auto_show = false } },
  fuzzy = { implementation = "prefer_rust" },
  signature = { enabled = true },
})
vim.diagnostic.config({ virtual_text = false, severity_sort = true })

-- mappings
local function hover_or_diagnostic()
  local line_num = vim.api.nvim_win_get_cursor(0)[1]
  local diagnostics = vim.diagnostic.get(0, { lnum = line_num - 1, severity = { min = vim.diagnostic.severity.HINT } })

  -- use default hover behaviour if no diagnostics are available
  if #diagnostics == 0 then
    vim.lsp.buf.hover()
    return
  end

  if vim.g.replace_hover_with_diagnostics == true then
    vim.diagnostic.open_float({ source = true })
    vim.g.replace_hover_with_diagnostics = false
  else
    vim.lsp.buf.hover()
    vim.g.replace_hover_with_diagnostics = true
  end
end

vim.keymap.set("n", "K", hover_or_diagnostic, { desc = "Hover" })
vim.keymap.set("n", "<leader>ll", "<cmd>LspInfo<cr>", { desc = "lsp info" })
vim.keymap.set("n", "<leader>lk", vim.lsp.buf.hover, { desc = "hover" })
vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { desc = "rename" })
vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { desc = "action" })
vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, { desc = "definitions" })
vim.keymap.set("n", "<leader>lD", function()
  require("mini.extra").pickers.diagnostic({ scope = "current" })
end, { desc = "diagnostics" })
-- vim.keymap.set("n", "<leader>lR", vim.lsp.buf.references, { desc = "references" })
vim.keymap.set("n", "<leader>lR", function()
  require("mini.extra").pickers.lsp({ scope = "references" })
end, { desc = "references" })
vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation, { desc = "implementations" })
vim.keymap.set("n", "<leader>lt", vim.lsp.buf.type_definition, { desc = "type definitions" })
vim.keymap.set("n", "<leader>lh", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
end, { desc = "[h]ints (toggle inlay)" })
vim.keymap.set("n", "<leader>lc", "<cmd>ConformInfo<cr>", { desc = "conform (formatter) info" })
vim.keymap.set("n", "<leader>lf", function()
  require("conform").format()
end, { desc = "format" })
