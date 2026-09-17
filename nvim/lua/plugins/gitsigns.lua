-- github: https://github.com/lewis6991/gitsigns.nvim
return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("gitsigns").setup({
      -- 1. 开启行尾 Git blame 虚拟提示（类似 GitLens）
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 500,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = "   󰊢 <author> • <author_time:%Y-%m-%d> • <summary>",

      -- 2. 快捷键
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- 跳到下一个 / 上一个修改点
        map("n", "]c", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, desc = "Next Git Change" })

        map("n", "[c", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, desc = "Prev Git Change" })

        -- 弹窗预览当前行的 Git Diff 详情
        map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview Git Hunk" })

        map("n", "<leader>gd", gs.diffthis, { desc = "Git Diff" })
      end,
    })
  end,
}
