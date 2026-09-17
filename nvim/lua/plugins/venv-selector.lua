-- github: https://github.com/linux-cultist/venv-selector.nvim
return {
  "linux-cultist/venv-selector.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "neovim/nvim-lspconfig",
  },
  event = "VeryLazy",
  config = function()
    require("venv-selector").setup({
      settings = {
        options = {
          notify_user_on_venv_activation = true,
        },
        search = {
          -- Poetry 在 macOS 上默认把 venv 存放在这里
          poetry = {
            command = "find "
              .. vim.fn.expand("~/Library/Caches/pypoetry/virtualenvs")
              .. " -maxdepth 4 -name 'python' -not -path '*/bin/python[0-9]*' -type f",
          },
          -- 同时也搜索项目内的 .venv（适配 virtualenvs.in-project = true 的情况）
          in_project = {
            command = "find .venv -maxdepth 3 -name 'python' -not -path '*/bin/python[0-9]*' -type f 2>/dev/null",
          },
        },
      },
    })
  end,
  keys = {
    { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select Python Venv" },
  },
}
