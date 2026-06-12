return {
  -- Ensure snacks notifier is enabled so noice's "snacks" backend
  -- is available before it falls through to the missing nvim-notify.
  -- Without this, early vim.notify calls (e.g. during LSP attach)
  -- fail both backends and produce: E492: Not an editor command: notify
  {
    "folke/snacks.nvim",
    opts = {
      notifier = {
        enabled = true,
        timeout = 3000,
        style = "fancy",
      },
      -- Show dotfiles (.env, .envrc, etc.) and gitignored files by default.
      -- hidden = true  → passes --hidden to fd/rg (dotfiles visible)
      -- ignored = true → passes --no-ignore to fd/rg (gitignored files visible)
      -- Toggle per-search with <alt-h> (hidden) and <alt-i> (ignored).
      picker = {
        sources = {
          files = {
            hidden = true,
            ignored = true,
          },
          grep = {
            hidden = true,
            ignored = true,
          },
          explorer = {
            hidden = true,
            ignored = true,
          },
        },
      },
    },
  },

  -- Tell noice to prefer the snacks backend and do not fall back to
  -- the nvim-notify backend (which is not installed).
  {
    "folke/noice.nvim",
    opts = {
      notify = {
        enabled = true,
        view = "notify",
      },
      views = {
        notify = {
          backend = "snacks",  -- drop the "notify" fallback entirely
        },
      },
    },
  },

  -- ────────────────────────────────────────────────────────────
  -- BREADCRUMBS — IntelliJ-style winbar showing file > class > method
  -- attach_navic = false: LazyVim's LSP on_attach already attaches navic,
  -- so we let it do that and just consume the context here.
  -- ────────────────────────────────────────────────────────────
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    event = "BufReadPost",
    opts = {
      attach_navic = false,
      show_dirname = false,
      show_basename = false,
      theme = "auto",
    },
  },
}
