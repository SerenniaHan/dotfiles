return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- 需要图标支持
  config = function()
    require("bufferline").setup({
      options = {
        mode = "buffers", -- 🌟 确保是文件标签模式，而不是工作区模式
        separator_style = "slant", -- 标签分割线样式: "slant"(斜角) | "thin"(细线) | "round"(圆角)
        always_show_bufferline = true,
        show_buffer_close_icons = true,
        show_close_icon = false,
        -- ✨ 完美闭环：让顶栏为左侧的 nvim-tree 文件树留出空白，视觉极其解压
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            text_align = "center",
            separator = true,
          },
        },
        -- 显示 LSP 诊断状态
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level)
          local icon = level:match("error") and " " or " "
          return " " .. icon .. count
        end,
      },
    })

    -- ⚡ 配置标签页切换快捷键 (建议放进地方自治，因为重度依赖此功能)
    -- Shift + h 切换到左边的标签，Shift + l 切换到右边的标签
    vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev Buffer" })
    vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next Buffer" })
    -- 关闭当前标签页 (关闭当前 Buffer，而不退出 Neovim)
    vim.keymap.set("n", "<leader>bp", "<cmd>bdelete<CR>", { desc = "Close Current Buffer" })
  end,
}
