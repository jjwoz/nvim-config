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
  -- LUALINE — richer status bar matching IntelliJ's bottom bar
  -- Adds: git blame summary, total line count ("12 of 743")
  -- ────────────────────────────────────────────────────────────
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      -- "12 of 743" style location — matches IntelliJ's line counter
      local location = function()
        local line = vim.fn.line(".")
        local total = vim.fn.line("$")
        return string.format("%d of %d", line, total)
      end

      -- Compact git blame summary in the status bar (author + relative time)
      -- Complements the inline EOL blame from gitsigns.
      local blame_status = function()
        local blame = vim.b.gitsigns_blame_line_dict
        if not blame or blame.author == "Not Committed Yet" then
          return ""
        end
        local ago = blame.author_time and os.difftime(os.time(), blame.author_time)
        if not ago then return "" end
        local when
        if ago < 3600 then
          when = math.floor(ago / 60) .. "m ago"
        elseif ago < 86400 then
          when = math.floor(ago / 3600) .. "h ago"
        else
          when = math.floor(ago / 86400) .. "d ago"
        end
        return string.format(" %s, %s", blame.author, when)
      end

      -- Insert blame into lualine_c (center-left) and replace default location
      table.insert(opts.sections.lualine_c, { blame_status, color = { fg = "#6c7086" } })

      -- Replace lualine_z (far right) to add "N of Total" counter
      opts.sections.lualine_z = {
        { location },
        { "progress" },
      }

      return opts
    end,
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
