vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false


if vim.fn.has('win32') == 1 then
  vim.opt.undodir = os.getenv("USERPROFILE") .. "\\.vim\\undodir"
  vim.opt.backupdir = os.getenv("USERPROFILE") .. "\\.vim\\backupdir"
  vim.opt.directory = os.getenv("USERPROFILE") .. "\\.vim\\swap"
else
  vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
  vim.opt.backupdir = os.getenv("HOME") .. "/.vim/backupdir"
  vim.opt.directory = os.getenv("HOME") .. "/.vim/swap"
end
vim.opt.undofile = true
vim.opt.swapfile = true
vim.opt.backup = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.colorcolumn = "101"
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 10
vim.opt.display:append("lastline")
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50
--vim.opt.colorcolumn = "80"

vim.g.netrw_browse_split = 0
vim.g.netrw_winsize = 25
vim.o.hidden = true
