-- github: https://github.com/nvim-treesitter/nvim-treesitter
return {
  "nvim-treesitter/nvim-treesitter",
  -- 💡 注意：Treesitter 在首次下载或更新后，需要编译解析器。
  -- 推荐加上这一行，让它在后台自动执行 :TSUpdate，省去手动更新的麻烦
  build = ":TSUpdate",
  config = function()
    -- 1. 显式调用 Treesitter 的配置函数
    require("nvim-treesitter").setup({
      -- 确保安装的语言解析器列表
      ensure_installed = {
        "lua",
        "vim",
        "vimdoc",
        "query",
        "markdown",
        "markdown_inline",
        "bash",
        "python", -- Python 支持
        "javascript", -- 前端支持
        "html",
        "css",
        "sql", -- 基础的 SQL 高亮
        "jinja", -- Jinja 模版的高亮 (dbt核心)
        "yaml",
        "json",
        "jsonc",
        "toml",
      },

      -- 启用自动同步安装解析器
      auto_install = true,

      -- 启用现代的 Treesitter 语法高亮功能
      highlight = {
        enable = true,
        -- 彻底关闭 Vim 传统的老旧正则高亮，纯粹依靠 Treesitter，速度更快
        additional_vim_regex_highlighting = false,
      },

      -- 启用基于 Treesitter 语法树的智能自动缩进
      indent = {
        enable = true,
      },
    })
  end,
}
