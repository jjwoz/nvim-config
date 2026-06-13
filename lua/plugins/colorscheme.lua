return {
  -- TokyoNight — the colorscheme visible in :Lazy sync
  -- Variants: "tokyonight-night" (darkest), "tokyonight-storm", "tokyonight-moon", "tokyonight-day"
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
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-night",
    },
  },
}
