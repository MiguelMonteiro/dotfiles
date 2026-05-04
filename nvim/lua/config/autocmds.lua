-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  pattern = "*",
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- set formatoptions for all filetypes -- default is "jcroql"
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    vim.opt_local.formatoptions = "tcqjr"
  end,
  pattern = "*",
})

-- set lisp mode for lisp languages
-- this treats hyphens as part of the word and improves indentation
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    vim.opt_local.lisp = true
  end,
  pattern = { "*.fnl", "*.lisp", "*.clj", "*.scm", "*.rkt" },
})

-- scrolloff at end of file (based on Aasim-A/scrollEOF.nvim)
local function check_eof_scrolloff()
  if vim.bo.buftype ~= "" then -- exclude all non-standard buffers
    return
  end

  local win_height = vim.api.nvim_win_get_height(0)
  local win_view = vim.fn.winsaveview()
  local scrolloff = math.min(vim.o.scrolloff, math.floor(win_height / 2))
  local scrolloff_line_count = win_height - (vim.fn.line("w$") - win_view.topline + 1)
  local distance_to_last_line = vim.fn.line("$") - win_view.lnum

  if distance_to_last_line < scrolloff and scrolloff_line_count + distance_to_last_line < scrolloff then
    win_view.topline = win_view.topline + scrolloff - (scrolloff_line_count + distance_to_last_line)
    vim.fn.winrestview(win_view)
  end
end

vim.api.nvim_create_autocmd("CursorMoved", {
  pattern = "*",
  callback = check_eof_scrolloff,
})
