local cmd = { vim.fn.exepath("jdtls") }

local mason_registry = require("mason-registry")
local lombok_jar = mason_registry.get_package("jdtls"):get_install_path() .. "/lombok.jar"
table.insert(cmd, string.format("--jvm-arg=-javaagent:%s", lombok_jar))

local attach_jdtls = function()
  require("jdtls").start_or_attach({
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
    root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew" }),
    project_name = function(root_dir)
      return root_dir and vim.fs.basename(root_dir)
    end,
    jdtls_config_dir = function(project_name)
      return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/config"
    end,
    jdtls_workspace_dir = function(project_name)
      return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/workspace"
    end,
    settings = {
      java = { inlayHints = { parameterNames = { enabled = "all" } } },
    },
    on_attach = function(client, bufnr)
      local map = function(key, func, desc, mode)
        mode = mode or "n"
        vim.keymap.set(mode, key, func, { buffer = bufnr, desc = desc })
      end

      local builtin = require("telescope.builtin")
      map("gd", builtin.lsp_definitions, "[G]oto [D]efinition")
      map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
      map("gr", builtin.lsp_references, "[G]oto [R]eferences")
      map("gi", builtin.lsp_implementations, "[G]oto [I]mplementation")

      map("<C-k>", vim.lsp.buf.signature_help, "Signature help", { "i", "n" })
      map("<C-j>", vim.lsp.buf.hover, "[H]over doc", { "i", "n" })

      map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
      map("<leader>cd", vim.diagnostic.open_float, "Line [D]iagnostics")
      map("<leader>cf", vim.lsp.buf.format, "[F]ormat")
      map("<leader>cr", vim.lsp.buf.rename, "[R]ename")
      map("<leader>cR", Snacks.rename.rename_file, "[R]ename file")
      map("<leader>cs", builtin.lsp_document_symbols, "Document [S]ymbols")
      map("<leader>ct", builtin.lsp_type_definitions, "[T]ype Definition")
      map("<leader>cw", builtin.lsp_dynamic_workspace_symbols, "[W]orkspace Symbols")
    end,
  })
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = attach_jdtls,
})

attach_jdtls()
