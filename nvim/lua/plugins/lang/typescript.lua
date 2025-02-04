return {
  -- add javascript, typescript to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "javascript", "typescript", "tsx" } },
  },

  -- setup lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
          settings = {
            complete_function_calls = true,
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = {
                maxInlayHintLength = 30,
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
              },
            },
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              suggest = {
                completeFunctionCalls = true,
              },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
            },
          },
        },
        eslint = {
          settings = {
            workingDirectories = { mode = "auto" },
            format = Yuki.configs.auto_format
          }
        },
      },
      setup = {
        eslint = function()
          if not Yuki.configs.auto_format then
            return
          end

          if not pcall(require, "vim.lsp._dynamic") then
            local buf = vim.api.nvim_get_current_buf()
            local client = Yuki.lsp.get_clients({ name = "eslint", bufnr = buf })[1]
            local augroup = vim.api.nvim_create_augroup("yuki_eslint_fix_all", { clear = true })

            vim.api.nvim_clear_autocmds({ group = augroup, buffer = buf })
            if client then
              local diag = vim.diagnostic.get(buf, { namespace = vim.lsp.diagnostic.get_namespace(client.id) })
              if #diag > 0 then
                vim.cmd("EslintFixAll")
              end
            end
          end
        end
      }
    },
  },
}
