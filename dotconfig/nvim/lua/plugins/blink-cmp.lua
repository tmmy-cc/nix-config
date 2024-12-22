return {
  "saghen/blink.cmp",
  dependencies = {
    "mikavilpas/blink-ripgrep.nvim",
    "rafamadriz/friendly-snippets",
    {
      "saghen/blink.compat",
      -- make optional so it's only enabled if any extras need it
      optional = true,
      opts = {},
    },
  },
  opts = {
    sources = {
      default = { "lsp", "path", "snippets", "buffer", "ripgrep" },

      -- Disable command line completions
      cmdline = {},

      -- Additional providers
      providers = {
        ripgrep = {
          module = "blink-ripgrep",
          name = "Ripgrep",
          opts = {
            -- For many options, see `rg --help` for an exact description of
            -- the values that ripgrep expects.

            -- the minimum length of the current word to start searching
            -- (if the word is shorter than this, the search will not start)
            prefix_min_len = 3,

            -- The number of lines to show around each match in the preview
            -- (documentation) window. For example, 5 means to show 5 lines
            -- before, then the match, and another 5 lines after the match.
            context_size = 5,

            -- The maximum file size of a file that ripgrep should include in
            -- its search. Useful when your project contains large files that
            -- might cause performance issues.
            -- Examples:
            -- "1024" (bytes by default), "200K", "1M", "1G", which will
            -- exclude files larger than that size.
            max_filesize = "1M",

            -- Specifies how to find the root of the project where the ripgrep
            -- search will start from. Accepts the same options as the marker
            -- given to `:h vim.fs.root()` which offers many possibilities for
            -- configuration.
            project_root_marker = ".git",

            -- The casing to use for the search in a format that ripgrep
            -- accepts. Defaults to "--ignore-case". See `rg --help` for all the
            -- available options ripgrep supports, but you can try
            -- "--case-sensitive" or "--smart-case".
            search_casing = "--ignore-case",

            -- (advanced) Any additional options you want to give to ripgrep.
            -- See `rg -h` for a list of all available options. Might be
            -- helpful in adjusting performance in specific situations.
            -- If you have an idea for a default, please open an issue!
            --
            -- Not everything will work (obviously).
            additional_rg_options = {},

            -- When a result is found for a file whose filetype does not have a
            -- treesitter parser installed, fall back to regex based highlighting
            -- that is bundled in Neovim.
            fallback_to_regex_highlighting = true,
          },
        },
      },
    },

    appearance = {
      -- sets the fallback highlight groups to nvim-cmp's highlight groups
      -- useful for when your theme doesn't support blink.cmp
      -- will be removed in a future release, assuming themes add support
      use_nvim_cmp_as_default = false,
      -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- adjusts spacing to ensure icons are aligned
      nerd_font_variant = "mono",
    },

    completion = {
      -- 'prefix' will fuzzy match on the text before the cursor
      -- 'full' will fuzzy match on the text before *and* after the cursor
      -- example: 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
      keyword = { range = 'full' },

      -- Disable auto brackets
      -- NOTE: some LSPs may add auto brackets themselves anyway
      accept = { auto_brackets = { enabled = false } },

      -- Insert completion item on selection, don't select by default
      list = { selection = 'auto_insert' },

      menu = {
        draw = {
          --treesitter = { "lsp" },

          -- nvim-cmp style menu
          columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
        },
      },

      -- Show documentation when selecting a completion item
      documentation = { auto_show = true, auto_show_delay_ms = 200 },

      -- Display a preview of the selected item on the current line
      ghost_text = { enabled = true },
    },

    -- experimental signature help support
    -- signature = { enabled = true },

    keymap = {
      preset = "default",
    },
  },
}
