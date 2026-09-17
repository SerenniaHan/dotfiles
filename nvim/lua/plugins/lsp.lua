return {
  "neovim/nvim-lspconfig",
  -- 延迟加载：只在真正打开文件时才初始化 Mason，避免启动时产生不必要的 I/O
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "b0o/SchemaStore.nvim",
  },
  config = function()
    -- 1. LSP 连接成功时自动绑定快捷键（只在有 LSP 支持的 buffer 里生效）
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf, remap = false }

        -- 跳转到定义，多个结果时用 Telescope 列出来选
        vim.keymap.set("n", "gd", function() require("telescope.builtin").lsp_definitions() end, opts)
        -- 查找所有引用
        vim.keymap.set("n", "gr", function() require("telescope.builtin").lsp_references() end, opts)
        -- 跳转到接口的具体实现
        vim.keymap.set("n", "gI", function() require("telescope.builtin").lsp_implementations() end, opts)
        -- 弹出悬浮文档，相当于 VSCode 鼠标悬停效果
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        -- 重命名，改一处全项目同步，相当于 VSCode 的 F2
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        -- 代码修复建议，相当于 VSCode 的黄色灯泡 Ctrl+.
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
      end,
    })

    -- 2. 初始化Mason(管理后台LSP下载)
    -- 可以使用:Mason来调用Mason管理UI
    require("mason").setup()

    require("mason-tool-installer").setup({
      ensure_installed = {
        "stylua",
        "prettier",
        "markdownlint",
        "yamllint",
        "ruff", -- Python formatter + linter
      },
    })
    -- 3. 确保自动安装了需要的lsp
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls", -- lua的lsp
        "marksman",
        "yamlls", -- YAML
        "jsonls", -- JSON
        "pyright", -- Python
        "taplo",   -- TOML
        "sqlls",   -- SQL
      },
    })

    -- 4. 启动并且配置lspconfig
    -- 直接使用 Neovim 0.11+ 内置的 vim.lsp.config 引擎来启用配置
    -- local lspconfig = require("lspconfig")
    -- lspconfig.lua_ls.setup({})
    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim", "conform" },
          },
        },
      },
    })

    vim.lsp.enable("lua_ls")

    vim.lsp.config("marksman", {})
    vim.lsp.enable("marksman")

    vim.lsp.config("yamlls", {
      settings = {
        yaml = {
          -- 全自动Schema校验
          schemas = require("schemastore").yaml.schemas and {} or {
            -- 如果需要手动制定某一个特定的文件的schema在里面可以定义
          },
          validate = true, -- 开启语法格式合法性检查
        },
      },
    })
    vim.lsp.enable("yamlls")

    vim.lsp.config("jsonls", {
      settings = {
        json = {
          schemas = require("schemastore").json.schemas(),
          validate = { enable = true },
        },
      },
    })
    vim.lsp.enable("jsonls")
    vim.lsp.config("pyright", {
      settings = {
        python = {
          analysis = {
            typeCheckingMode = "basic", -- off / basic / standard / strict
            autoImportCompletions = true,
          },
        },
      },
    })
    vim.lsp.enable("pyright")

    vim.lsp.config("taplo", {})
    vim.lsp.enable("taplo")

    -- sqlls：提供 SQL 语法补全和基础校验
    vim.lsp.config("sqlls", {})
    vim.lsp.enable("sqlls")
  end,
}
