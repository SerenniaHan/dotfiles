-- github: https://github.com/folke/tokyonight.nvim
return {
  "folke/tokyonight.nvim",
  lazy = false, -- 🌟 重要：主题必须在启动时立刻加载，不能懒加载！
  priority = 1000, -- 🌟 重要：将优先级设为最高，确保它在其他插件渲染前就生效
  config = function()
    -- 在这里进行主题的细节调整
    require("tokyonight").setup({
      style = "storm", -- 可选: storm, night, moon, day
      transparent = true,
      styles = {
        comments = { italic = false }, -- 让代码注释变成优雅的斜体
        keywords = { italic = false }, -- 让 return, if 等关键字变成斜体
      },
    })
  end,
}
