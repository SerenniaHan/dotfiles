return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufWritePost", "InsertLeave" }, -- ⏳ 在读取文件、保存文件、退出输入模式时自动触发检查
  config = function()
    -- 把 Mason 的 bin 目录加入 PATH，让 nvim-lint 能找到 Mason 安装的工具
    vim.env.PATH = vim.env.PATH .. ":" .. vim.fn.stdpath("data") .. "/mason/bin"

    local lint = require("lint")

    -- markdownlint 默认用 --stdin 模式，此时只能从 Neovim 的 cwd 查找配置文件。
    -- 改为文件路径模式后，markdownlint 会从文件所在目录向上遍历查找 .markdownlint.yaml，
    -- 从而正确读取项目根目录中的配置。
    -- 若项目中不存在任何配置文件，则回退到 markdownlint 的内置默认规则（所有规则启用）。
    lint.linters.markdownlint.stdin = false
    lint.linters.markdownlint.args = {}

    -- yamllint 同理：默认 stdin 模式只从 nvim cwd 查找配置文件，且输出 pattern 写死了 "stdin:" 前缀。
    -- 改为文件路径模式后，yamllint 会从 nvim cwd 向上查找 .yamllint、.yamllint.yaml、.yamllint.yml。
    -- 同时覆盖 parser pattern，将 "stdin" 替换为匹配任意文件名的 [^:]+。
    lint.linters.yamllint.stdin = false
    lint.linters.yamllint.args = { "--format", "parsable" }
    lint.linters.yamllint.parser = require("lint.parser").from_pattern(
      "[^:]+:(%d+):(%d+): %[(.+)%] (.+) %((.+)%)",
      { "lnum", "col", "severity", "message", "code" },
      { ["error"] = vim.diagnostic.severity.ERROR, ["warning"] = vim.diagnostic.severity.WARN },
      { source = "yamllint" }
    )

    -- 1. 告诉插件：什么文件类型用什么 Linter
    lint.linters_by_ft = {
      markdown = { "markdownlint" }, -- ✨ 让 markdownlint 守护你的 .md 文件
      yaml = { "yamllint" },
      python = { "ruff" },
    }

    -- 2. 🎯 创建自动化流水线：只要满足上面的 event 条件，就在后台静默检查
    vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
      pattern = "*",
      callback = function()
        -- try_lint 会完全在后台异步运行，打字绝对零卡顿
        lint.try_lint()
      end,
    })
  end,
}
