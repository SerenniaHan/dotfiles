-- 全局通用的keymap

-- 工作区和nvim.tree之间的切换 (<C-w>h -> <A-h>)
vim.keymap.set("n", "<Leader>h", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<Leader>j", "<C-w>j", { desc = "Go to lower window" })
vim.keymap.set("n", "<Leader>k", "<C-w>k", { desc = "Go to upper window" })
vim.keymap.set("n", "<Leader>l", "<C-w>l", { desc = "Go to right window" })
