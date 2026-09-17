-- github: https://github.com/saghen/blink.cmp
--
-- blink.cmp 是一个高性能的自动补全引擎，核心用 Rust 编写。
-- 补全内容来自多个 source：LSP（语言服务器）、路径、代码片段、当前缓冲区。
--
-- keymap preset 选项：
--   "default"   : 用 <C-n>/<C-p> 上下选择，<C-y> 确认，Tab 和 <CR> 不参与补全导航
--   "super-tab" : 用 <Tab>/<S-Tab> 上下选择，没有补全菜单时 Tab 正常输入缩进
--   "enter"     : 用 <CR> 确认，<C-n>/<C-p> 导航，Tab 不参与
return {
  "saghen/blink.cmp",
  -- 使用预编译的 Rust 二进制，不需要本地安装 Rust 工具链
  version = "*",
  config = function()
    require("blink.cmp").setup({
      -- 1. 键位设置
      keymap = {
        preset = "default",
        -- 默认键位：
        --   <C-Space>  手动触发补全
        --   <C-y>      确认选中项
        --   <C-n>      选中下一项
        --   <C-p>      选中上一项
        --   <C-e>      关闭补全菜单
      },

      -- 2. 外观
      appearance = {
        -- 使用 nvim-cmp 风格的图标，与 Nerd Font 更搭
        nerd_font_variant = "mono",
      },

      -- 3. 补全来源
      sources = {
        default = {
          "lsp", -- LSP 补全（pyright / lua_ls / yamlls 等）
          "path", -- 文件路径补全
          "snippets", -- 代码片段补全
          "buffer", -- 当前缓冲区词语补全（兜底）
        },
      },

      -- 4. 补全菜单行为
      completion = {
        menu = {
          -- 只有一个候选时也显示菜单
          auto_show = true,
        },
        list = {
          -- preselect：菜单弹出时自动高亮第一项（不插入）
          -- auto_insert：关闭，导航时不实时写入文字，确认前不改变编辑区内容
          selection = { preselect = true, auto_insert = false },
        },
        -- 选中候选时自动弹出文档说明
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        -- 在光标后显示灰色虚影预览当前选中项（不实际插入）
        ghost_text = {
          enabled = true,
        },
      },

      -- 5. 函数签名提示（输入参数时显示参数类型）
      signature = {
        enabled = true,
      },
    })
  end,
}
