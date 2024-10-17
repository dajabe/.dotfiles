return { -- LSP Configuration & Plugins
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for neovim
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    'mihyaeru21/nvim-lspconfig-bundler',

    -- Useful status updates for LSP.
    -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
    { 'j-hui/fidget.nvim', opts = {} },
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        map('K', vim.lsp.buf.hover, 'Hover Documentation')

        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end,
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    --  Add any additional override configuration in the following tables. Available keys are:
    --  - cmd (table): Override the default command used to start the server
    --  - filetypes (table): Override the default list of associated filetypes for the server
    --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
    --  - settings (table): Override the default settings passed when initializing the server.
    --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
    local servers = {
      solargraph = {},
      ruby_lsp = {
        vscode = true,
      },
      lua_ls = {
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            workspace = {
              checkThirdParty = false,
              library = {
                '${3rd}/luv/library',
                unpack(vim.api.nvim_get_runtime_file('', true)),
              },
            },
            completion = {
              callSnippet = 'Replace',
            },
          },
        },
      },
    }
    require('lspconfig-bundler').setup()
    require('mason').setup()

    -- local ensure_installed = vim.tbl_keys(servers or {})
    -- vim.list_extend(ensure_installed, {
    --   'stylua', -- Used to format lua code
    -- })
    -- require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    require('mason-lspconfig').setup {
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
      },
    }

    -- This is stuff I've written
    local nvim_lsp = require 'lspconfig'
    local util = require 'lspconfig/util'
    local is_prettier_installed = require('dajabe.helpers').is_prettier_installed

    local function project_file_exists(root_dir, filepath)
      return vim.fn.filereadable(root_dir .. '/' .. filepath) == 1
    end

    nvim_lsp.gopls.setup {
      capabilities = capabilities,
    }

    nvim_lsp.ruby_lsp.setup {
      capabilities = capabilities,
      vscode = true,
      settings = {
        rubocop = {
          use_bundler = true,
          auto_correct = true,
          auto_correct_all = true,
        },
      },
    }

    nvim_lsp.denols.setup {
      capabilities = capabilities,
      single_file_support = false,
      root_dir = util.root_pattern('deno.json', 'deno.jsonc'),
      init_options = {
        enable = true,
        lint = true,
        unstable = true,
        suggest = {
          imports = {
            hosts = {
              ['https://deno.land'] = true,
              ['https://cdn.nest.land'] = true,
              ['https://crux.land'] = true,
            },
          },
        },
      },
    }

    nvim_lsp.ts_ls.setup {
      capabilities = capabilities,
      root_dir = function(fname)
        return util.root_pattern 'tsconfig.json'(fname) or util.root_pattern('package.json', 'jsconfig.json')(fname)
      end,
      init_options = {
        preferences = {
          disableSuggestions = false,
        },
      },
      settings = {
        typescript = {
          format = {
            enable = false, -- Disable formatting
          },
        },
        javascript = {
          format = {
            enable = false, -- Disable formatting
          },
        },
      },
      on_attach = function(client, _)
        if is_prettier_installed() then
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end
      end,
      on_new_config = function(_, new_root_dir)
        local is_deno = project_file_exists(new_root_dir, 'deno.json') or project_file_exists(new_root_dir, 'deno.jsonc')
        if is_deno then
          return false
        end
      end,
    }

    nvim_lsp.solargraph.setup {
      capabilities = capabilities,
    }

    require('lspconfig').pylsp.setup {
      capabilities = capabilities,
      settings = {
        pylsp = {
          plugins = {
            black = { enabled = true },
            autopep8 = { enabled = false },
            yapf = { enabled = false },
            pylint = { enabled = true, executable = 'pylint' },
            pyflakes = { enabled = false },
            pycodestyle = { enabled = false },
          },
        },
      },
    }
  end,
}
