return {
  "folke/flash.nvim",
  cond = true, -- 覆盖全局默认，让此插件在 VSCode（vscode-neovim）里也加载
  event = "VeryLazy", -- 可选：推荐开启懒加载，提升启动速度
  config = function()
    require("flash").setup({
      vscode = true, -- 完美适配 VS Code
      modes = {
        char = { enable = false }, -- 保持原生的 f/F/t/T
      },
    })

    -- keymap
    vim.keymap.set("n", "s", function()
      require("flash").jump()
    end, { desc = "Flash Jump" })
  end,
}
