vim.lsp.enable("jdtls")

vim.api.nvim_create_autocmd("FileType", {
  group = Yuki.utils.create_augroup("jdtls"),
  pattern = "java",
  callback = function()
    local cmd = { vim.fn.expand("$MASON/bin/jdtls") }
    local lombok_jar = vim.fn.expand("$MASON/packages/jdtls/lombok.jar")
    table.insert(cmd, "--jvm-arg=-javaagent:" .. lombok_jar)

    local config = {
      name = "jdtls",

      -- `cmd` defines the executable to launch eclipse.jdt.ls.
      -- `jdtls` must be available in $PATH and you must have Python3.9 for this to work.
      --
      -- As alternative you could also avoid the `jdtls` wrapper and launch
      -- eclipse.jdt.ls via the `java` executable
      -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
      cmd = cmd,

      -- `root_dir` must point to the root of your project.
      -- See `:help vim.fs.root`
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

      -- Here you can configure eclipse.jdt.ls specific settings
      -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
      -- for a list of options
      settings = {
        java = {
          format = {
            enabled = true,
            settings = {
              url = "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml",
              profile = "GoogleStyle",
            },
          },
          inlayHints = {
            parameterNames = {
              enabled = "all",
            },
          },
        },
      },

      -- This sets the `initializationOptions` sent to the language server
      -- If you plan on using additional eclipse.jdt.ls plugins like java-debug
      -- you'll need to set the `bundles`
      --
      -- See https://codeberg.org/mfussenegger/nvim-jdtls#java-debug-installation
      --
      -- If you don't plan on any eclipse.jdt.ls plugins you can remove this
      init_options = {
        bundles = {},
      },
    }

    require("jdtls").start_or_attach(config)
  end,
})

return {
  {
    { name = "nvim-treesitter", override = true },
    opts = {
      ensure_installed = { "java" },
    },
  },

  {
    { name = "mason", override = true },
    opts = {
      ensure_installed = { "jdtls" },
    },
  },

  {
    { src = "https://github.com/mfussenegger/nvim-jdtls" },
    opts = {
      postinstall = function() end,
    },
  },

  {
    { name = "conform", override = true },
    opts = {
      formatters_by_ft = {
        java = { "clang-format" },
      },
    },
  },
}
