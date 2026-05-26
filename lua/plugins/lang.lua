-- Language-specific overrides on top of LazyVim extras.
-- The extras (lazyvim.json) install: gopls, vtsls, basedpyright, ruff,
-- plus treesitter parsers and Mason tools. This file fine-tunes them.

return {

  -- ────────────────────────────────────────────────────────────
  -- GO
  -- Extra: lazyvim.plugins.extras.lang.go
  -- Installs: gopls, gofumpt, goimports, gomodifytags, gotests, delve
  -- ────────────────────────────────────────────────────────────
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,            -- stricter gofmt (pairs with gofumpt tool)
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                fieldalignment = true,
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { "-.git", "-.vscode", "-.idea", "-.venv", "-node_modules" },
              semanticTokens = true,
            },
          },
        },
      },
    },
  },

  -- ────────────────────────────────────────────────────────────
  -- TYPESCRIPT / JAVASCRIPT
  -- Extra: lazyvim.plugins.extras.lang.typescript
  -- Installs: vtsls (replaces tsserver), prettier, eslint
  -- ────────────────────────────────────────────────────────────
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {
          settings = {
            typescript = {
              inlayHints = {
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                variableTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                enumMemberValues = { enabled = true },
              },
              updateImportsOnFileMove = { enabled = "always" },
              suggest = {
                completeFunctionCalls = true,
              },
            },
            javascript = {
              inlayHints = {
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                variableTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                enumMemberValues = { enabled = true },
              },
              updateImportsOnFileMove = { enabled = "always" },
            },
          },
        },
      },
    },
  },

  -- ────────────────────────────────────────────────────────────
  -- PYTHON
  -- Extra: lazyvim.plugins.extras.lang.python
  -- Installs: pyright, ruff (lsp + formatter)
  -- ────────────────────────────────────────────────────────────
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- The python extra defaults to basedpyright — swap it out for official pyright
      opts.servers = opts.servers or {}
      opts.servers.basedpyright = nil

      opts.servers.pyright = {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "standard",  -- off | basic | standard | strict
              autoSearchPaths = true,
              diagnosticMode = "openFilesOnly",
              useLibraryCodeForTypes = true,
            },
          },
        },
      }

      -- ruff acts as the linter/formatter; pyright handles types only
      opts.servers.ruff = opts.servers.ruff or {}
      opts.servers.ruff.cmd_env = { RUFF_TRACE = "messages" }
      opts.servers.ruff.init_options = {
        settings = { logLevel = "error" },
      }
    end,
  },

  -- ────────────────────────────────────────────────────────────
  -- MASON — extra tools beyond what the lang extras install
  -- ────────────────────────────────────────────────────────────
  {
    "mason-org/mason.nvim",
    opts = {
      -- Explicitly set firewall to prevent a mason 2.3.0 bug on nvim 0.12-dev
      -- where vim.deepcopy strips nested subtables during settings.set(),
      -- causing "attempt to index field 'firewall' (a nil value)" in instance.lua.
      firewall = {
        enabled = false,
      },
      ensure_installed = {
        -- Go
        "goimports",
        "gofumpt",
        "gomodifytags",
        "gotests",
        "delve",
        -- TypeScript / JS
        "prettier",
        "eslint_d",
        -- Python
        "pyright",
        "ruff",
        "debugpy",
      },
    },
  },
}
