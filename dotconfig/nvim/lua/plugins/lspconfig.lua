return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    opts = function()
      return {
        inlay_hints = {
          enable = true,
          exclude = { "vue" },
        },
      }
    end,
    config = function()
      require("lspconfig").lua_ls.setup {}
      require("lspconfig").clangd.setup {
        vim.keymap.set('n', 'gI', "<Cmd>ClangdSwitchSourceHeader<CR>", {silent = true})
      }
      require("lspconfig").pylsp.setup {}
      require("lspconfig").nil_ls.setup {}
      require("lspconfig").rust_analyzer.setup {
        settings = {
          ['rust-analyzer'] = {
            diagnostics = {
              enable = false;
            },
          },
        }
      }
      require("lspconfig").yamlls.setup {
        settings = {
          yaml = {
            schemas = {
              ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = "/*.k8s.yaml",
            },
          },
        }
      }
    end,
  },
}
