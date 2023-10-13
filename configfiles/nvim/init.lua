local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end
local packer_bootstrap = ensure_packer()


vim.opt.number = true
vim.opt.mouse = "a"
vim.opt.ignorecase = true
vim.opt.hlsearch = true
vim.opt.wrap = true
vim.opt.signcolumn = "yes"
vim.opt.breakindent = true
vim.opt.belloff = "all"
vim.opt.tw = 80
vim.opt.cc = "80"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.compatible = false
vim.opt.encoding = "utf-8"
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.fileformat = unix
vim.opt.listchars = "tab:» ,trail:·"
vim.opt.cinoptions = vim.opt.cinoptions + ":0"
vim.opt.cursorline = true
vim.opt.list = true
vim.opt.autoread = true
vim.opt.autowrite = true
vim.opt.updatetime = 2000
vim.opt.guicursor = "n-v:block,i:ver10,r:hor10"
vim.opt.timeoutlen = 2000
vim.g.mapleader = "`"
vim.keymap.set("n", "<leader>w", "<cmd>write<cr>")
-- vim.keymap.set("n", "<leader>q", ":wq<cr>")

vim.keymap.set("n", "<leader>q", ":ToggleTerm direction=float<CR>", {buffer = true})
vim.g.nvim_tree_respect_buf_cwd = 1

---
-- Telescope
---
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})


---
-- Colorscheme
---
vim.opt.termguicolors = true
vim.cmd("colorscheme catppuccin")

---
-- lualine.nvim (statusline)
---
vim.opt.showmode = false

-- See :help lualine.txt
require("lualine").setup({
  options = {
    theme = "onedark",
    icons_enabled = true,
    component_separators = "|",
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'filesize', 'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
})

---
-- Treesitter
---
-- See :help nvim-treesitter-modules
require("nvim-treesitter.configs").setup({
  highlight = {
    enable = true,
  },
  -- :help nvim-treesitter-textobjects-modules
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["al"] = "@loop.outer",
        ["il"] = "@loop.inner",
      },
    },
  },
  ensure_installed = {
    "lua",
    "python",
    "c",
    "cpp",
    "ada",
    "rust",
  },
})

---
-- Comment.nvim
---
require("Comment").setup({})

---
-- Indent-blankline
---
-- See :help ibl.setup()
require("indent_blankline").setup({
  char = "▏",
  show_trailing_blankline_indent = false,
  show_first_indent_level = false,
  use_treesitter = true,
  show_current_context = false,
})

---
-- Gitsigns
---
-- See :help gitsigns-usage
require("gitsigns").setup({
  signs = {
    add = { text = "▎" },
    change = { text = "▎" },
    delete = { text = "➤" },
    topdelete = { text = "➤" },
    changedelete = { text = "▎" },
  },
})

---
-- nvim-tree (File explorer)
---
-- See :help nvim-tree-setup
require("nvim-tree").setup({
  hijack_cursor = false,
  on_attach = function(bufnr)
    local bufmap = function(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
    end

    -- :help nvim-tree.api
    local api = require("nvim-tree.api")

    bufmap("<cr>", api.node.open.edit, "Expand folder or go to file")
    bufmap("H", api.node.navigate.parent_close, "Close parent folder")
    bufmap("gh", api.tree.toggle_hidden_filter, "Toggle hidden files")
  end,
})

vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<cr>")

---
-- Luasnip (snippet engine)
---
-- See :help luasnip-loaders
require("luasnip.loaders.from_vscode").lazy_load()

local _ls = require("luasnip")
local snip = _ls.snippet
local text = _ls.text_node
local insert = _ls.insert_node
local func = _ls.function_node

local gards = function()
  return vim.api.nvim_buf_get_name(0):match("^.+/(.+)%..+$"):upper() .. "_H"
end

_ls.add_snippets(nil, {
  cpp = {
    snip({
      trig = "#ig",
      namr = "Include Gards",
      dscr = "Create include guards",
    }, {
      text({ "#ifndef " }),
      func(gards, {}),
      text({ "", "#define " }),
      func(gards, {}),
      text({ "", "", "" }),
      insert(0),
      text({ "", "", "#endif /* " }),
      func(gards, {}),
      text({ " */" }),
    }),
  },
})

---
-- nvim-cmp (autocomplete)
---

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local handlers = require('nvim-autopairs.completion.handlers')
local cmp = require("cmp")
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done(
  {
    filetypes = {
      -- "*" is a alias to all filetypes
      ["*"] = {
        ["("] = {
          kind = {
            cmp.lsp.CompletionItemKind.Function,
            cmp.lsp.CompletionItemKind.Method,
          },
          handler = handlers["*"]
        }
      }
    }
  })
  )

local luasnip = require("luasnip")

-- local select_opts = { behavior = cmp.SelectBehavior.Select }

-- See :help cmp-config
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  sources = {
    { name = "path" },
    { name = "nvim_lsp", keyword_length = 1 },
    { name = "buffer", keyword_length = 1 },
    { name = "luasnip", keyword_length = 1 },
  },
  window = {
    documentation = cmp.config.window.bordered(),
  },
  formatting = {
    fields = { "menu", "abbr", "kind" },
    format = function(entry, item)
      local menu_icon = {
        nvim_lsp = "λ",
        luasnip = "⋗",
        buffer = "Ω",
        path = "🖫",
      }

      item.menu = menu_icon[entry.source.name]
      return item
    end,
  },
  -- See :help cmp-mapping
  mapping = {
    ["<Up>"] = cmp.mapping.select_prev_item(select_opts),
    ["<Down>"] = cmp.mapping.select_next_item(select_opts),

    ["<C-p>"] = cmp.mapping.select_prev_item(select_opts),
    ["<C-n>"] = cmp.mapping.select_next_item(select_opts),

    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),

    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = false }),

    ["<C-d>"] = cmp.mapping(function(fallback)
      if luasnip.jumpable(1) then
        luasnip.jump(1)
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<C-b>"] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      local col = vim.fn.col(".") - 1

      if cmp.visible() then
        cmp.select_next_item(select_opts)
      elseif col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
        fallback()
      else
        cmp.complete()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item(select_opts)
      else
        fallback()
      end
    end, { "i", "s" }),
  },
})

---
-- LSP config
---
-- See :help lspconfig-global-defaults
local capa = require("cmp_nvim_lsp").default_capabilities
if capa == nil then
  capa = require("cmp_nvim_lsp").update_capabilities
end
local lsp_defaults = {
  flags = {
    debounce_text_changes = 150,
  },
  capabilities = capa(vim.lsp.protocol.make_client_capabilities()),
  on_attach = function(client, bufnr)
    vim.api.nvim_exec_autocmds("User", { pattern = "LspAttached" })

    if client.server_capabilities.documentHighlightProvider then
      vim.cmd([[hi link LspReferenceText Search
      hi link LspReferenceRead Search
      hi link LspReferenceWrite Search]])
      vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
      vim.api.nvim_clear_autocmds({ buffer = bufnr, group = "lsp_document_highlight" })
      vim.api.nvim_create_autocmd({ "CursorHold" }, {
        callback = vim.lsp.buf.document_highlight,
        buffer = bufnr,
        group = "lsp_document_highlight",
        desc = "Document Highlight",
      })
      vim.api.nvim_create_autocmd("CursorMoved", {
        callback = vim.lsp.buf.clear_references,
        buffer = bufnr,
        group = "lsp_document_highlight",
        desc = "Clear All the References",
      })
    end
  end,
}

local lspconfig = require("lspconfig")

lspconfig.util.default_config = vim.tbl_deep_extend("force", lspconfig.util.default_config, lsp_defaults)

---
-- Diagnostic customization
---
local sign = function(opts)
  -- See :help sign_define()
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = "",
  })
end

sign({ name = "DiagnosticSignError", text = "✘" })
sign({ name = "DiagnosticSignWarn", text = "▲" })
sign({ name = "DiagnosticSignHint", text = "⚑" })
sign({ name = "DiagnosticSignInfo", text = "" })

-- See :help vim.diagnostic.config()
vim.diagnostic.config({
  virtual_text = true,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

---
-- LSP Keybindings
---
vim.api.nvim_create_autocmd("User", {
  pattern = "LspAttached",
  desc = "LSP actions",
  callback = function()
    local bufmap = function(mode, lhs, rhs)
      local opts = { buffer = true }
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- You can search each function in the help page.
    -- For example :help vim.lsp.buf.hover()

    bufmap("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>")
    bufmap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>")
    bufmap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>")
    bufmap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>")
    bufmap("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>")
    bufmap("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>")
    bufmap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<cr>")
    bufmap("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>")
    bufmap("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>")
    bufmap("x", "<F4>", "<cmd>lua vim.lsp.buf.range_code_action()<cr>")
    bufmap("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>")
    bufmap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>")
    bufmap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>")
  end,
})

---
-- LSP servers
---

---
-- Mason.nvim
---
-- See :help mason-settings
require("mason").setup({
  ui = { border = "rounded" },
  log_level = vim.log.levels.DEBUG,
})

---
-- Null-Ls
---

local null_ls = require("null-ls")

local augroup_lspfmt = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup({
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup_lspfmt, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup_lspfmt,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
  end,
})

---
-- Mason-Null-Ls
---

require("mason-null-ls").setup({
  ensure_installed = {
    "beautysh",
    "buf",
    "clang_format",
    "codespell",
    "stylua",
    "trim_whitespace",
    "black",
  },
})


require("mason-null-ls").setup({
  function(src_name, methods)
    require("mason-null-ls.automatic_setup")(src_name, methods)
  end,
  stylua = function()
    null_ls.register(null_ls.builtins.formatting.stylua)
  end,
  clang_format = function()
    null_ls.register(null_ls.builtins.formatting.clang_format.with({
      filetypes = { "c", "cpp" },
      extra_args = { "-stype=/home/shebour/.clang-format" },
    }))
  end,
  codespell = function()
    null_ls.register(null_ls.builtins.formatting.codespell.with({
      disabled_filetypes = { "md" },
    }))
  end,
})

null_ls.setup()

---
-- Mason-Lspconfig
---

require("mason-lspconfig").setup({
  ensure_installed = {
    "als",
    "bashls",
    "clangd",
    "pyright",
    "cmake",
    "quick_lint_js",
    "rust_analyzer",
  },
})


local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.offsetEncoding = { "utf-16" }
-- See :help mason-lspconfig-dynamic-server-setup
require("mason-lspconfig").setup_handlers({
  function(server)
    -- See :help lspconfig-setup
    lspconfig[server].setup({})
  end,
  ["clangd"] = function()
    lspconfig.clangd.setup({
      cmd = { "clangd", "--header-insertion=never" },
      filetypes = { "c", "cpp" },
      capabilities = capabilities,
    })
  end,
})

return require("packer").startup(function(use)
  use({ "wbthomason/packer.nvim" })

  -- Theming
  use({ "joshdick/onedark.vim" })
  use({ "kyazdani42/nvim-web-devicons" })
  use({ "nvim-lualine/lualine.nvim", requires = { 'nvim-tree/nvim-web-devicons', opt = true } })
  use({ "lukas-reineke/indent-blankline.nvim", tag = 'v2.20.8'})
  use({ "pangloss/vim-javascript"})
  use { "catppuccin/nvim", as = "catppuccin" }

  -- File explorer
  use({ "kyazdani42/nvim-tree.lua" })

  -- Git
  use({ "lewis6991/gitsigns.nvim" })
  use({ "tpope/vim-fugitive" })

  -- Code manipulation
  use({ "numToStr/Comment.nvim" })
  use({ "nvim-treesitter/nvim-treesitter" })
  use({ "nvim-treesitter/nvim-treesitter-textobjects", after = "nvim-treesitter" })
  use({ "tpope/vim-repeat" }) -- api for repeat command
  use({ "tpope/vim-surround" }) -- cs"' ds" yssb ysiw]
  use({ "wellle/targets.vim" }) -- add more text objects

  -- Utilities
  use({ "editorconfig/editorconfig-vim" })
  -- use({ "tpope/vim-eunuch" })
  use({'nvim-telescope/telescope.nvim', tag = '0.1.2', requires = { {'nvim-lua/plenary.nvim'}}})
  use {"akinsho/toggleterm.nvim", tag = '*', config = function()
  require("toggleterm").setup {} end}

  -- LSP support
  use({ "neovim/nvim-lspconfig" })
  use({ "williamboman/mason.nvim" })
  use({ "jose-elias-alvarez/null-ls.nvim" })
  use({ "jayp0521/mason-null-ls.nvim" })
  use({ "williamboman/mason-lspconfig.nvim" })

  -- Autocomplete
  use({ "hrsh7th/nvim-cmp" })
  use({ "hrsh7th/cmp-buffer" })
  use({ "hrsh7th/cmp-path" })
  use({ "saadparwaiz1/cmp_luasnip" })
  use({ "hrsh7th/cmp-nvim-lsp" })

  -- Snippets
  use({ "L3MON4D3/LuaSnip" })
  use({ "rafamadriz/friendly-snippets" })
  use({ "windwp/nvim-autopairs",config = function() require("nvim-autopairs").setup {} end})

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require("packer").sync()
  end
end)
