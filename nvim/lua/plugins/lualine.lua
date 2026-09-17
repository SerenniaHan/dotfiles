-- github: https://github.com/nvim-lualine/lualine.nvim
return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- 漂亮的小图标支持
  config = function()
    require("lualine").setup({
      options = {
        -- default settings references github
        icons_enabled = true,
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        always_show_tabline = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
          refresh_time = 16, -- ~60fps
          -- CursorMoved / CursorMovedI 已移除：光标每次移动都触发重绘开销过大
          events = {
            "WinEnter",
            "BufEnter",
            "BufWritePost",
            "SessionLoadPost",
            "FileChangedShellPost",
            "VimResized",
            "Filetype",
            "ModeChanged",
          },
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = {
          "encoding",
          "fileformat",
          "filetype",
          {
            -- 只在 Python 文件时显示当前激活的虚拟环境名称（截取路径最后一段，避免显示完整路径）
            function()
              local venv = require("venv-selector").venv()
              if venv then
                return string.match(venv, "[^/]+$")
              end
              return ""
            end,
            icon = "",
            cond = function()
              return vim.bo.filetype == "python"
            end,
          },
        },
        lualine_y = { "progress" },
        lualine_z = { "location", "lsp_status" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    })
  end,
}
