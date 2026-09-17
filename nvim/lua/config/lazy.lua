-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  defaults = {
    -- 在 VSCode（vscode-neovim）里默认不加载任何插件。
    -- 需要在 VSCode 中保留的插件，在各自的插件文件里显式设置 cond = true 覆盖此默认值。
    cond = not vim.g.vscode,
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "auto" } },
  -- automatically check for plugin updates
  -- frequency: 每天最多检查一次，避免每次启动都 spawn git 进程拖慢响应
  checker = { enabled = true, frequency = 86400 },
  ui = { border = "none" }, -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
})

-- keymap
vim.keymap.set("n", "<leader>L", "<CMD>Lazy<CR>", { desc = "[Lazy] Open Lazy.nvim" })
