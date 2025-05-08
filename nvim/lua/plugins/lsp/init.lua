return {
  -- lspconfig
  -- https://github.com/neovim/nvim-lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason.nvim",
      { "williamboman/mason-lspconfig.nvim", config = function() end },
    },
    opts = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = Yuki.configs.icons.diagnostics.Error,
            [vim.diagnostic.severity.WARN] = Yuki.configs.icons.diagnostics.Warn,
            [vim.diagnostic.severity.HINT] = Yuki.configs.icons.diagnostics.Hint,
            [vim.diagnostic.severity.INFO] = Yuki.configs.icons.diagnostics.Info,
          },
        },
      },
      inlay_hints = { enabled = true },
      capabilities = { workspace = { fileOperations = { didRename = true, willRename = true } } },
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      -- LSP Server Settings
      servers = {
        lua_ls = {},
      },
      setup = {},
    },
    config = function(_, opts)
      Yuki.lsp.on_attach(function(client, buffer)
        require("plugins.lsp.keymaps").on_attach(client, buffer)
      end)

      -- diagnostics signs
      if vim.fn.has("nvim-0.10.0") == 0 then
        if type(opts.diagnostics.signs) ~= "boolean" then
          for severity, icon in pairs(opts.diagnostics.signs.text) do
            local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
            name = "DiagnosticSign" .. name
            vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
          end
        end
      end

      -- inlay hints
      if opts.inlay_hints.enabled then
        Yuki.lsp.on_supports_method("textDocument/inlayHint", function(_, buffer)
          if
            vim.api.nvim_buf_is_valid(buffer)
            and vim.bo[buffer].buftype == ""
            and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
          then
            vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
          end
        end)
      end

      if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
        opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and "●"
          or function(diagnostic)
            local icons = Yuki.icons.diagnostics
            for d, icon in pairs(icons) do
              if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
                return icon
              end
            end
          end
      end

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      local servers = opts.servers
      local has_blink, blink = pcall(require, "blink.cmp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_blink and blink.get_lsp_capabilities() or {},
        opts.capabilities or {}
      )

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})
        if server_opts.enabled == false then
          return
        end

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end

        require("lspconfig")[server].setup(server_opts)
      end

      -- get all the servers that are available through mason-lspconfig
      local have_mason, mlsp = pcall(require, "mason-lspconfig")
      local all_mslp_servers = {}
      if have_mason then
        local mappings = require("mason-lspconfig.mappings").get_all()
        all_mslp_servers = vim.tbl_keys(mappings.lspconfig_to_package)
      end

      local ensure_installed = {} ---@type string[]
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          if server_opts.enabled ~= false then
            -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
            if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
              setup(server)
            else
              ensure_installed[#ensure_installed + 1] = server
            end
          end
        end
      end

      if have_mason then
        mlsp.setup({
          ensure_installed = vim.tbl_deep_extend("force", ensure_installed, {
            -- optional
          }),
          handlers = { setup },
        })
      end
    end,
  },

  -- package manager
  -- https://github.com/williamboman/mason.nvim
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {
        "shfmt",
        "stylua",
      },
      ui = {
        border = "rounded",
        icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" },
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          -- trigger FileType event to possibly load this newly installed LSP server
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)

      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },

  -- display prettier diagnostic messages
  -- https://github.com/rachartier/tiny-inline-diagnostic.nvim
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy", -- Or `LspAttach`
    priority = 1000,
    opts = function()
      vim.diagnostic.config({ virtual_text = false })

      return {}
    end,
  },
}
