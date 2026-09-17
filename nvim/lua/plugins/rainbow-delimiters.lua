-- github: https://github.com/HiPhish/rainbow-delimiters.nvim
return {
  "HiPhish/rainbow-delimiters.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    local rainbow = require("rainbow-delimiters")

    vim.g.rainbow_delimiters = {
      -- 策略：决定如何高亮括号
      strategy = {
        -- 默认使用全局策略（整个文件扫描）
        [""] = rainbow.strategy["global"],
        -- 大文件改用局部策略（只扫描当前可见区域），节省性能
        commonlisp = rainbow.strategy["local"],
      },

      -- 查询：决定哪些语言的哪些符号参与彩虹高亮
      query = {
        [""] = "rainbow-delimiters",
        lua = "rainbow-blocks", -- Lua 用 block 级别（更自然）
      },

      -- 高亮优先级
      priority = {
        [""] = 110,
        lua = 210,
      },

      -- 高亮组：tokyonight 已内置这些颜色，直接使用即可
      highlight = {
        "RainbowDelimiterRed",
        "RainbowDelimiterYellow",
        "RainbowDelimiterBlue",
        "RainbowDelimiterOrange",
        "RainbowDelimiterGreen",
        "RainbowDelimiterViolet",
        "RainbowDelimiterCyan",
      },
    }
  end,
}
