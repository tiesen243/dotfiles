local function setup_jdtls()
  local jdtls = require 'jdtls'
  local utils = require 'core.utils'

  local cmd = { vim.fn.exepath 'jdtls' }
  local lombok_jar = require('mason-registry').get_package('jdtls'):get_install_path() .. '/lombok.jar'
  table.insert(cmd, string.format('--jvm-arg=-javaagent:%s', lombok_jar))

  local config = {
    root_dir = jdtls.setup.find_root { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' },
    project_name = function(root_dir)
      return root_dir and vim.fs.basename(root_dir)
    end,
    jdtls_config_dir = function(project_name)
      return vim.fn.stdpath 'cache' .. '/jdtls/' .. project_name .. '/config'
    end,
    jdtls_workspace_dir = function(project_name)
      return vim.fn.stdpath 'cache' .. '/jdtls/' .. project_name .. '/workspace'
    end,

    cmd = cmd,

    on_attach = function(client, bufnr)
      utils.lsp_attach(client, bufnr)

      -- jdtls keymaps
      local map = function(key, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, key, func, { buffer = bufnr, desc = desc })
      end

      map('<leader>cj', '<nop>', '[C]ode [J]ava', { 'n', 'v' })
      map('<leader>cjo', jdtls.organize_imports, '[C]ode [J]ava [O]rganize Imports')
      map('<leader>cjv', jdtls.extract_variable, '[C]ode [J]ava extract [V]ariable', { 'n', 'v' })
      map('<leader>cjc', jdtls.extract_constant, '[C]ode [J]ava extract [C]onstant', { 'n', 'v' })
      map('<leader>cjm', jdtls.extract_method, '[C]ode [J]ava extract [M]ethod', { 'n', 'v' })
    end,
  }

  jdtls.start_or_attach(config)
end

if Yuki.lang.java then
  setup_jdtls()
else
  return true
end
