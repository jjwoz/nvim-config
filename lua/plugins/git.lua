return {

  -- ────────────────────────────────────────────────────────────
  -- INLINE GIT BLAME
  -- The "You, date • Uncommitted changes" overlay IntelliJ shows
  -- on the current line. gitsigns is already installed by LazyVim;
  -- we just need to turn current_line_blame on and style it.
  -- ────────────────────────────────────────────────────────────
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",   -- end of line, same as IntelliJ
        delay = 400,
        ignore_whitespace = true,
      },
      current_line_blame_formatter = " %an, %ar • %s",
      -- ^ format: "  You, 2 hours ago • fix: nil guard on gopls attach"
    },
  },

  -- ────────────────────────────────────────────────────────────
  -- GIT COMMIT PANEL — Neogit
  -- IntelliJ's "Commit" tool window equivalent. Shows staged/unstaged
  -- files, diff preview, commit message, amend toggle.
  -- <leader>gg  → open Neogit status (full panel)
  -- <leader>gc  → open directly to commit interface
  -- <leader>gd  → open Diffview for the current file or repo
  -- ────────────────────────────────────────────────────────────
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",   -- side-by-side diffs like IntelliJ's diff viewer
    },
    cmd = "Neogit",
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>",            desc = "Neogit (git panel)" },
      { "<leader>gc", "<cmd>Neogit commit<cr>",     desc = "Git commit" },
      { "<leader>gP", "<cmd>Neogit push<cr>",       desc = "Git push" },
      { "<leader>gp", "<cmd>Neogit pull<cr>",       desc = "Git pull" },
    },
    opts = {
      -- Open like IntelliJ's panel: full-width at the top
      kind = "split",
      commit_editor = {
        kind = "split",
        show_staged_diff = true,
      },
      integrations = {
        diffview = true,
      },
      -- Match IntelliJ's section layout
      sections = {
        untracked = { folded = false },
        unstaged  = { folded = false },
        staged    = { folded = false },
        stashes   = { folded = true },
        recent    = { folded = true },
      },
    },
  },

  -- ────────────────────────────────────────────────────────────
  -- DIFFVIEW — IntelliJ-style side-by-side diff viewer
  -- <leader>gD  → open diff for current file
  -- <leader>gh  → open file history (like IntelliJ's "Git Log" for a file)
  -- ────────────────────────────────────────────────────────────
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      { "<leader>gD", "<cmd>DiffviewOpen<cr>",            desc = "Diffview (repo)" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>",   desc = "File history" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        default = {
          layout = "diff2_horizontal",   -- side-by-side like IntelliJ
        },
        file_history = {
          layout = "diff2_horizontal",
        },
      },
    },
  },

}
