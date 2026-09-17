-- disable netrw at the very start of your init.lua
---- :help nvim-tree-setup
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- require("folder.filename") -- ~/.config/nvim/<folder>/<fileName>.lua
require("config.keymaps")
require("config.lazy") -- ~/.config/nvim/lua/config/lazy.lua
-- require("plugins.treesitter") -- 不需要去显示加载，在lazy.lua中自动会去扫描所有的plugins文件夹里的插件配置

-- require("options")
-- require("plugins.gitsigns")

-- 显示行号
vim.opt.number = true
-- 显示相对行号
vim.opt.relativenumber = true
-- 启用鼠标支持（在终端里也可以用鼠标滚轮或点击）
vim.opt.mouse = "a"
-- 开启剪贴板共享（让你在 Neovim 里 y 的内容能直接 Command+V 粘贴到其他地方）
-- 用 vim.schedule 延迟到 UI 渲染完毕后再执行，避免启动时同步探测剪贴板程序造成阻塞
vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)
-- 实时搜索（边输入边高亮结果）
vim.opt.incsearch = true
-- 显示当前光标所在行的背景颜色
vim.wo.cursorline = true

vim.opt.tabstop = 2 -- 1个 Tab 显示为多少个空格的宽度
vim.opt.shiftwidth = 2 -- 每一级自动缩进（如使用 > 或 cindent）的空格数
vim.opt.softtabstop = 2 -- 在编辑模式下按下 Tab 或 Backspace 时，视作多少个空格
vim.opt.expandtab = true -- 把输入的 Tab 键自动转换为空格（现代编程规范推荐）

-- 诊断行为与外观的全局配置（原生功能，放这里最合适）
vim.diagnostic.config({
  underline = true,
  -- 配置行尾的虚拟文本提示
  virtual_text = {
    prefix = "●",
    source = "if_many",
  },
  -- 告诉 Neovim 只要收到 LSP 数据就立刻刷新界面（即使在输入时也实时更新）
  update_in_insert = true,
  severity_sort = true,
})

-- 如果在vscode中则不开启拼写检查
if not vim.g.vscode then
  -- 1. 开启拼写检查开关
  vim.opt.spell = true

  -- 2. 设置拼写检查的语言为英文
  vim.opt.spelllang = { "en_us", "cjk" }

  -- 3. 规避代码假阳性报错：让拼写检查只在“注释（Comment）”和“字符串（String）”里生效
  -- 这样它就不会去检查你的函数名、变量名，只在你打字、写注释、写配置字符串时帮你看错字
  vim.opt.spelloptions = "camel" -- 兼容驼峰命名法（比如 checkThirdParty 不会被拆开报错）

  -- 激活主题（VSCode 里由 VSCode 自己接管配色，且 theme 插件不加载，故跳过以避免报错）
  vim.cmd([[colorscheme tokyonight]])
end
