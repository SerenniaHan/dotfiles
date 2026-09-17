-- github: https://github.com/nvim-tree/nvim-tree.lua/wiki/Installation

return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup({
      view = {
        width = 30,
        side = "left",
      },
      git = {
        enable = true,
        ignore = false,
        timeout = 400,
      },
      renderer = {
        group_empty = true, -- 如果为空，则自动合并文件夹
        icons = {
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
          },
        },
      },
      filters = {
        dotfiles = false,
      },
    })

    -- keymap configuration
    -- 打开/关闭文件浏览器
    vim.keymap.set("n", "<Leader>e", "<CMD>NvimTreeToggle<CR>", { desc = "Toggle File Tree" })
    -- 定位当前的文件
    vim.keymap.set("n", "<Leader>f", "<CMD>NvimTreeFindFile<CR>", { desc = "Find Current File" })
  end,
}
