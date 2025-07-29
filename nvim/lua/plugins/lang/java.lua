vim.lsp.enable("jdtls")

return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = { ensure_installed = { "java" } },
  },

  {
    "mason-org/mason.nvim",
    optional = true,
    opts = { ensure_installed = { "jdtls", "google-java-format" } },
  },

  {
    "mfussenegger/nvim-jdtls",
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        group = Yuki.utils.create_augroup("JavaLspAttach"),
        callback = function()
          local cmd = { vim.fn.expand("$MASON/bin/jdtls") }
          local lombok_jar = vim.fn.expand("$MASON/packages/jdtls/lombok.jar")
          table.insert(cmd, string.format("--jvm-arg=-javaagent:%s", lombok_jar))

          local config = {
            root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]),

            project_name = function(root_dir)
              return root_dir and vim.fs.basename(root_dir)
            end,

            jdtls_config_dir = function(project_name)
              return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/config"
            end,
            jdtls_workspace_dir = function(project_name)
              return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/workspace"
            end,

            cmd = cmd,
            full_cmd = function(opts)
              local fname = vim.api.nvim_buf_get_name(0)
              local root_dir = opts.root_dir(fname)
              local project_name = opts.project_name(root_dir)
              local cmd = vim.deepcopy(opts.cmd)
              if project_name then
                vim.list_extend(cmd, {
                  "-configuration",
                  opts.jdtls_config_dir(project_name),
                  "-data",
                  opts.jdtls_workspace_dir(project_name),
                })
              end
              return cmd
            end,

            settings = {
              java = {
                inlayHints = {
                  parameterNames = {
                    enabled = "all",
                  },
                },
              },
            },
          }

          require("jdtls").start_or_attach(config)
        end,
      })
    end,
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        java = { "google-java-format" },
      },
    },
  },
}
