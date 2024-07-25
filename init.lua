vim.cmd("set number")
vim.cmd("set cursorline")
vim.cmd("set tabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set expandtab")
vim.cmd("set autoindent")
vim.g.mapleader = " "

vim.opt.termguicolors = true

local plugins = {
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.5',
        dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
        config = function()
            require('telescope').setup {
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    }
                }
            }
            require('telescope').load_extension('fzf')
        end
    },
    {
        "scottmckendry/cyberdream.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            transparent = true,
        },
        style = {
            comments = {italic = true},
            keyboards = {italic = true},
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function () 
            local configs = require("nvim-treesitter.configs")
            configs.setup({
                ensure_installed = { "c", "lua", "go", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html" },
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },  
            })
        end
    },
    {
        "rcarriga/nvim-notify",
        config = function()
            require("notify").setup({
                background_colour = "#000000",
            })
            vim.notify = require("notify")
        end
    },
    {
        "kyazdani42/nvim-tree.lua",
        config = function()
            require'nvim-tree'.setup {
                view = {
                    width = 30,
                    side = 'left',
                },
                filters = {
                    dotfiles = true,
                },
            }
        end
    },
    {
        "hoob3rt/lualine.nvim",
        config = function()
            require'lualine'.setup {
                options = { theme = 'dracula' },
                sections = {
                    lualine_a = {'mode'},
                    lualine_b = {'branch', 'diff', 'diagnostics'},
                    lualine_c = {'filename'},
                    lualine_x = {'encoding', 'fileformat', 'filetype'},
                    lualine_y = {'progress'},
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
                extensions = {'fugitive'}
            }
        end
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path"
        },
        config = function()
            local cmp = require'cmp'
            cmp.setup {
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'buffer' },
                    { name = 'path' }
                }),
            }
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            require('lspconfig')['pyright'].setup{}
        end
    },
    {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.prettier,
                    null_ls.builtins.diagnostics.eslint,
                },
            })
        end
    },
    {
        "junegunn/fzf.vim"
    },
    {
        "tpope/vim-surround"
    },
    {
        "tpope/vim-commentary"
    },
    {
        "folke/noice.nvim",
        config = function()
            require("noice").setup({
                cmdline = {
                    enabled = true,      -- enables the Noice cmdline UI
                    --view = "cmdline",    -- default view
                },
            })
        end,
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        }
    },
    {
        "goolord/alpha-nvim",
        config = function()
            require'alpha'.setup(require'alpha.themes.startify'.config)
        end
    },
    {
        "yamatsum/nvim-cursorline",
        config = function()
            require('nvim-cursorline').setup {
                cursorline = {
                    enable = true,
                    timeout = 1000,
                    number = false,
                },
                cursorword = {
                    enable = true,
                    min_length = 3,
                    hl = { underline = true },
                }
            }
        end
    },
    {
        'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup {}
        end
    },
    { 
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {} 
    },
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup()
        end
    },
    {
        'folke/which-key.nvim',
        config = function()
            require('which-key').setup {}
        end
    },
    {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    },
}

require("lazy").setup(plugins)

vim.cmd[[colorscheme cyberdream]]

local builtin = require("telescope.builtin")
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', {})

-- Ouvrir le fichier sélectionné dans un split vertical (à droite)
vim.keymap.set('n', '<leader>vs', function()
  local api = require'nvim-tree.api'
  api.tree.open()
  api.node.open.vertical()
end, { noremap = true, silent = true })

-- Ouvrir le fichier sélectionné dans un split horizontal (en bas)
vim.keymap.set('n', '<leader>hs', function()
  local api = require'nvim-tree.api'
  api.tree.open()
  api.node.open.horizontal()
end, { noremap = true, silent = true })

-- Déplacer le curseur vers le split à gauche
vim.keymap.set('n', '<leader>l', '<C-w>h', { noremap = true, silent = true })

-- Déplacer le curseur vers le split en bas
vim.keymap.set('n', '<leader>j', '<C-w>j', { noremap = true, silent = true })

-- Déplacer le curseur vers le split en haut
vim.keymap.set('n', '<leader>k', '<C-w>k', { noremap = true, silent = true })

-- Déplacer le curseur vers le split à droite
vim.keymap.set('n', '<leader>r', '<C-w>l', { noremap = true, silent = true })

-- Fermer le split actuel
vim.keymap.set('n', '<leader>c', ':close<CR>', { noremap = true, silent = true })

-- Fermer tous les splits sauf celui sous le curseur
vim.keymap.set('n', '<leader>o', ':only<CR>', { noremap = true, silent = true })




vim.cmd 'autocmd BufRead,BufNewFile *gno set filetype=gno'
vim.treesitter.language.register('go', 'gno')


-- Fonction pour formater les fichiers Gno
local function gno_fmt()
  local file = vim.fn.expand('%')
  vim.fn.system('gofumpt -e -w ' .. file)
  vim.cmd('edit!')
  vim.cmd('set syntax=go')
  print("Formatted " .. file)
end

-- Commande utilisateur pour appeler la fonction gno_fmt
vim.api.nvim_create_user_command('GnoFmt', gno_fmt, {})

-- Groupe d'autocommandes pour les fichiers Gno
local gno_augroup = vim.api.nvim_create_augroup('gno_autocmd', { clear = true })

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = '*.gno',
  command = 'set syntax=go',
  group = gno_augroup,
})

vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = '*.gno',
  callback = function()
    gno_fmt()
    print("BufWritePost called for " .. vim.fn.expand('%'))
  end,
  group = gno_augroup,
})

return {
  lsp = {
    formatting = {
      format_on_save = true,
    },
    servers = {
      "gnols",
    },
    config = {
      gnols = function()
        return {
          cmd = { "/Users/kazai/Lab/Gnoland/gnols/bin/gnols" };
          filetypes = {"gno"};
          root_dir = require("lspconfig.util").root_pattern('.git', 'gno.mod');
          settings = {
            gno = "/Users/kazai/go/bin/gno",
            precompileOnSave = true,
            buildOnSave = false,
            -- the clone location of github.com/gnolang/gno
            root = "/Users/kazai/Lab/Gnoland/gno/",
          };
        }
      end,
    },
  },
}
