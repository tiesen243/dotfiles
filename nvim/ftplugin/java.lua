if not Yuki.lang.java then
  return true
end

local home = os.getenv("HOME")
local workspace_path = home .. "/.local/share/nvim/jdtls-workspace/"
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = workspace_path .. project_name

local status, jdtls = pcall(require, "jdtls")
if not status then
  return
end
local extendedClientCapabilities = jdtls.extendedClientCapabilities

local config = {
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "-javaagent:" .. home .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar",
    "-jar",
    vim.fn.glob(home .. "/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
    "-configuration",
    home .. "/.local/share/nvim/mason/packages/jdtls/config_linux",
    "-data",
    workspace_dir,
  },
  root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),

  settings = {
    java = {
      signatureHelp = { enabled = true },
      extendedClientCapabilities = extendedClientCapabilities,
      maven = { downloadSources = true },
      referencesCodeLens = { enabled = true },
      references = { includeDecompiledSources = true },
      inlayHints = { parameterNames = { enabled = "all" } },
      format = { enabled = false },
    },
  },

  init_options = { bundles = {} },

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

    map("<C-k>", vim.lsp.buf.signature_help, "Signature help", "i")
    map("<C-h>", vim.lsp.buf.hover, "[H]over doc", "i")
    map("<leader>ck", vim.lsp.buf.signature_help, "Signature help")
    map("<leader>ch", vim.lsp.buf.hover, "[H]over doc")

    map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
    map("<leader>cd", vim.diagnostic.open_float, "Line [D]iagnostics")
    map("<leader>cr", vim.lsp.buf.rename, "[R]ename")
    map("<leader>cR", Snacks.rename.rename_file, "[R]ename file")
    map("<leader>cs", builtin.lsp_document_symbols, "Document [S]ymbols")
    map("<leader>ct", builtin.lsp_type_definitions, "[T]ype Definition")
    map("<leader>cw", builtin.lsp_dynamic_workspace_symbols, "[W]orkspace Symbols")

    if Snacks.words.is_enabled() then
      map("n", "]]", function()
        Snacks.words.jump(vim.v.count1, true)
      end, { desc = "Next word" })
      map("n", "[[", function()
        Snacks.words.jump(-vim.v.count1, true)
      end, { desc = "Previous word" })
    end

    if client and vim.lsp.inlay_hint then
      vim.lsp.inlay_hint.enable()
    end

    if client.server_capabilities.documentSymbolProvider then
      require("nvim-navic").attach(client, bufnr)
    end
  end,
}

require("jdtls").start_or_attach(config)
