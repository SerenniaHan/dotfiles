return {
  "echasnovski/mini.surround",
  cond = true, -- 覆盖全局默认，让此插件在 VSCode（vscode-neovim）里也加载
  -- 推荐在 VeryLazy 事件时加载，这样不会拖慢 Neovim 的启动速度
  event = "VeryLazy",
  -- 直接把你的自定义快捷键参数写进 opts 即可
  -- lazy.nvim 会自动在后台执行 require('mini.surround').setup(opts)
  config = function()
    require("mini.surround").setup({
      mappings = {
        add = "sa", -- 添加外壳 (Surround Add)
        delete = "sd", -- 删除外壳 (Surround Delete)
        replace = "sr", -- 替换外壳 (Surround Replace)
        find = "sf", -- 查找右侧外壳
        find_left = "sF", -- 查找左侧外壳
        highlight = "sh", -- 高亮外壳
        update_n_lines = "sn", -- 更新行数
      },
    })
  end,
}
