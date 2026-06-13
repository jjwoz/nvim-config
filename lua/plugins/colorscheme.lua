return {
  -- Keep tokyonight installed so it's available in <leader>uC picker
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "night",
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
      },
      on_colors = function(colors)
        colors.bg       = "#0f0f0f"
        colors.bg_dark  = "#0a0a0a"
        colors.bg_float = "#0a0a0a"
      end,
    },
  },

  -- ────────────────────────────────────────────────────────────
  -- MATERIAL — active colorscheme
  -- Variants: darker | lighter | oceanic | palenight | deep ocean
  -- Switch live with <leader>uC, or change material_style below.
  -- ────────────────────────────────────────────────────────────
  {
    "marko-cerovac/material.nvim",
    lazy = false,
    priority = 1000,   -- load before everything else
    opts = {
      contrast = {
        terminal         = true,   -- darker background in terminal splits
        sidebars         = true,   -- neogit, explorer, aerial
        floating_windows = true,   -- hover docs, completion menu
        non_current_windows = true,
      },
      styles = {
        comments    = { italic = true },
        strings     = {},
        keywords    = { italic = true },
        functions   = { bold = true },
        variables   = {},
        operators   = {},
        types       = {},
      },
      plugins = {
        "gitsigns",
        "indent_blankline",
        "neogit",
        "nvim-cmp",
        "nvim-tree",
        "telescope",
        "trouble",
        "which-key",
      },
      disable = {
        colored_cursor = false,
        borders        = false,
        background     = false,
        term_colors    = false,
        eob_lines      = true,   -- hide end-of-buffer ~ lines
      },
      lualine_style = "default",
    },
    config = function(_, opts)
      vim.g.material_style = "darker"   -- ← change this to switch variant
      require("material").setup(opts)
    end,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "material",
    },
  },
}
