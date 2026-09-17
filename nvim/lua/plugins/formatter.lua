-- ~/.config/nvim/lua/plugins/formatter.lua

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" }, -- 在文件写入硬盘前（保存时）自动触发
  cmd = { "ConformInfo" }, -- 输入 :ConformInfo 可以查看当前文件的格式化状态
  config = function()
    require("conform").setup({
      -- 1. 定义什么文件用什么格式化工具
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        markdown = { "prettier" },
        yaml = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        python = { "ruff_format" },
        toml = { "taplo" },
      },

      -- 2. ⚡ 保存时自动格式化 (Format on Save)
      format_on_save = {
        lsp_format = "never", -- 如果没有专属格式化器，就尝试用 LSP 的自带格式化
        timeout_ms = nil, -- 超时时间 2 秒 (类似markdown文件，如果只有0.5秒会超时）
      },
    })

    -- 3. 手动格式化的全局快捷键 [空格 + c + f] (Code Format)
    vim.keymap.set("n", "<leader>cf", function()
      require("conform").format({ async = true, lsp_format = "fallback" })
    end, { desc = "Code Format (Manually)" })
  end,
}
