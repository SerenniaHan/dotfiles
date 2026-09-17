return {
  "nvim-telescope/telescope.nvim",
  -- tag = "0.1.8", -- 推荐锁定一个稳定的社区版本
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- 让搜索结果里也带上漂亮的主题图标
  },
  config = function()
    require("telescope").setup({
      defaults = {
        -- 这里的配置可以让弹窗的外观更符合 tokyonight 的精致感
        style_preset = "default",
        layout_config = {
          horizontal = { preview_width = 0.55 }, -- 预览窗口占 55% 宽度
        },
      },
      vim.keymap.set("n", "<leader>ff", "<CMD>Telescope find_files<CR>", { desc = "Telescope find files" }),
      vim.keymap.set("n", "<leader>fg", "<CMD>Telescope live_grep<CR>", { desc = "Telescope live grep" }),
      vim.keymap.set("n", "<leader>fb", "<CMD>Telescope buffers<CR>", { desc = "Telescope buffers" }),
      vim.keymap.set("n", "<leader>fh", "<CMD>Telescope help_tags<CR>", { desc = "Telescope help tags" }),
    })
  end,
}
