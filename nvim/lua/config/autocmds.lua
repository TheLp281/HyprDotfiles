-- Suggested solution for https://github.com/altermo/ultimate-autopair.nvim/issues/102
local get_option = vim.filetype.get_option
rawset(vim.filetype, 'get_option', function(ft, opt)
  if ft == 'norg' then return vim.api.nvim_get_option_value(opt, {}) end
  return get_option(ft, opt)
end)

-- show cursor line only in active window
vim.api.nvim_create_autocmd({
  "InsertLeave",
  "WinEnter"
}, {
  callback = function()
    if vim.w.auto_cursorline then
      vim.wo.cursorline = true
      vim.w.auto_cursorline = nil
    end
  end
})
vim.api.nvim_create_autocmd({
  "InsertEnter",
  "WinLeave"
}, {
  callback = function()
    if vim.wo.cursorline then
      vim.w.auto_cursorline = true
      vim.wo.cursorline = false
    end
  end
})

-- backups
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("better_backup", {
    clear = true
  }),
  callback = function(event)
    local file = vim.uv.fs_realpath(event.match) or event.match
    local backup = vim.fn.fnamemodify(file, ":p:~:h")
    backup = backup:gsub("[/\\]", "%%")
    vim.go.backupext = backup
  end
})
