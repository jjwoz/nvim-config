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
      setup = {
        gopls = function(_, opts)
          -- Workaround: gopls doesn't advertise semanticTokensProvider on attach.
          -- Guard against nil capabilities (broken in upstream LazyVim go extra).
          Snacks.util.lsp.on({ name = "gopls" }, function(_, client)
            if not client.server_capabilities.semanticTokensProvider then
              local caps = client.config and client.config.capabilities
              local semantic = caps and caps.textDocument and caps.textDocument.semanticTokens
              if not semantic then return end
              client.server_capabilities.semanticTokensProvider = {
                full = true,
                legend = {
                  tokenTypes = semantic.tokenTypes,
                  tokenModifiers = semantic.tokenModifiers,
                },
                range = true,
              }
            end
          end)
        end,
      },
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
  --
  -- Role split:
  --   pyright → type checking + inlay hints + go-to-def/hover
  --   ruff    → linting (E/F/W/I/N/UP/B/C4/SIM) + auto-fix + formatting
  --
  -- Overlap prevention:
  --   pyright's unused-import / unused-variable warnings are silenced
  --   because ruff F401/F841 handles them (avoids double-reporting).
  --   pyright's organizeImports is disabled — ruff I-rules own imports.
  -- ────────────────────────────────────────────────────────────
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}

      -- Drop basedpyright (LazyVim python extra default)
      opts.servers.basedpyright = nil

      -- ── PYRIGHT — types only ─────────────────────────────────
      opts.servers.pyright = {
        settings = {
          python = {
            analysis = {
              typeCheckingMode    = "standard",       -- off|basic|standard|strict
              autoSearchPaths     = true,
              diagnosticMode      = "openFilesOnly",  -- "workspace" for full-project scan
              useLibraryCodeForTypes = true,
              -- Suppress diagnostics ruff already covers
              diagnosticSeverityOverrides = {
                reportUnusedImport   = "none",  -- ruff F401
                reportUnusedVariable = "none",  -- ruff F841
              },
              -- Inlay hints (pyright ≥ 1.1.300)
              inlayHints = {
                variableTypes      = true,
                functionReturnTypes = true,
                callArgumentNames  = "partial",   -- only non-obvious arg names
                pytestParameters   = true,
              },
            },
            -- Look for .venv in the workspace root; override per-project
            -- via pyrightconfig.json if your venv is named differently.
            venvPath = ".",
            venv     = ".venv",
          },
          -- Let ruff's I-rules own import sorting; suppress pyright's action
          disableOrganizeImports = true,
        },
      }

      -- ── RUFF — lint + format (LSP diagnostics + code actions) ─
      opts.servers.ruff = {
        cmd_env = { RUFF_TRACE = "messages" },
        init_options = {
          settings = {
            logLevel = "error",
            lint = {
              enable = true,
              -- Rule selection. Override per-project via pyproject.toml [tool.ruff.lint]
              -- or a ruff.toml at the project root — those take precedence.
              select = {
                "E",    -- pycodestyle errors
                "W",    -- pycodestyle warnings
                "F",    -- pyflakes (undefined names, unused imports)
                "I",    -- isort  (import ordering — replaces standalone isort)
                "N",    -- pep8-naming conventions
                "UP",   -- pyupgrade (modernize to target Python version)
                "B",    -- flake8-bugbear (subtle bugs + opinionated checks)
                "C4",   -- flake8-comprehensions (simplify list/dict/set expressions)
                "SIM",  -- flake8-simplify (simplify if/return/with patterns)
              },
              ignore = {
                "E501",  -- line-too-long: ruff format handles line length
              },
            },
            format = {
              preview = false,  -- stable formatting only; no experimental rules
            },
            codeAction = {
              fixViolation       = { enable = true },   -- "fix" code action in hover
              disableRuleComment = { enable = true },   -- "# noqa: ..." code action
            },
          },
        },
      }
    end,
  },

  -- ────────────────────────────────────────────────────────────
  -- FORMATTING — prettier on save for all web file types
  -- conform.nvim is bundled by LazyVim; we extend formatters_by_ft and
  -- enable format_on_save. Prettier handles JS/TS/CSS/JSON/YAML/MDX;
  -- sql-formatter handles .sql files (Supabase migrations etc).
  -- ────────────────────────────────────────────────────────────
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        -- Web
        javascript      = { "prettier" },
        javascriptreact = { "prettier" },
        typescript      = { "prettier" },
        typescriptreact = { "prettier" },
        css             = { "prettier" },
        scss            = { "prettier" },
        html            = { "prettier" },
        json            = { "prettier" },
        jsonc           = { "prettier" },
        yaml            = { "prettier" },
        markdown        = { "prettier" },
        mdx             = { "prettier" },
        -- Python — ruff_fix runs `ruff check --fix` first (imports, UP, B, SIM),
        -- then ruff_format runs `ruff format` (spacing, line length, trailing commas).
        -- Order matters: fix violations before reformatting.
        python          = { "ruff_fix", "ruff_format" },
        -- SQL
        sql             = { "sql_formatter" },
      },
      format_on_save = {
        timeout_ms = 2000,
        lsp_fallback = true,
      },
    },
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
        -- SQL (Supabase migrations)
        "sql-formatter",
      },
    },
  },
}
