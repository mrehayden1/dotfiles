HOME = os.getenv("HOME")

local api = vim.api
local g = vim.g
local opt = vim.opt
local cmd = vim.cmd
local fn = vim.fn

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- register all the packer dependencies
require('packer').startup(function()
  -- So packer doesn't delete itself
  use 'wbthomason/packer.nvim'
  -- Mason
  use 'williamboman/mason.nvim'
  -- Solarized colour scheme
  use 'overcache/NeoSolarized'
  -- GLSL
  use 'tikhomirov/vim-glsl'
  -- Language server support
  use "williamboman/mason-lspconfig.nvim"
  use 'neovim/nvim-lspconfig'
  -- Telescope
  use {
    'nvim-telescope/telescope.nvim',
    config = function()
      require('telescope')
        .setup({
          defaults = {
            file_ignore_patterns = { 'node_modules' }
          }
        })
    end,
    requires = { { 'nvim-lua/plenary.nvim' } },
    tag = '0.1.5'
  }
  -- Lualine
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
  -- exrc support
  use { 'MunifTanjim/exrc.nvim',
    config = function()
      require('exrc').setup({ files = { '.nvimrc.lua' } })
    end,
    requires = { 'MunifTanjim/nui.nvim' }
  }
  -- Automatically set up the configuration after installing packer.nvim
  if packer_bootstrap then
    require('packer').sync()
  end
end)

-- GUI scale hack for different screen pixel densities
-- For 100% scale displays
opt.guifont = "UbuntuMono Nerd Font:h12"
-- For 200% scale displays
--opt.guifont = "UbuntuMono Nerd Font:h14"
--vim.g.neovide_scale_factor=0.5

--syntax on
cmd("syntax on")

opt.termguicolors = true
cmd("colo NeoSolarized")
cmd("set background=dark")

-- Highlight the 80th column
--set colorcolumn=80
opt.colorcolumn = "80"

-- Highlight trailing whitespace
cmd("highlight ExtraWhitespace ctermbg=red guibg=red")
cmd("match ExtraWhitespace /\\s\\+$/")
cmd("autocmd BufWinEnter * match ExtraWhitespace /\\s\\+$/")
cmd("autocmd InsertEnter * match ExtraWhitespace /\\s\\+\\%#\\@<!$/")
cmd("autocmd InsertLeave * match ExtraWhitespace /\\s\\+$/")
cmd("autocmd BufWinLeave * call clearmatches()")

-- Mark tabs and non breaking whitespace.
--exec "set listchars=eol:$,tab:>,trail:~,extends:>,precedes:<"
--set list

--set expandtab
opt.expandtab = true
--set shiftwidth=2
opt.shiftwidth = 2
--set softtabstop=2
opt.softtabstop = 2
--set tabstop=2
opt.tabstop = 2
--set smartindent
opt.smartindent = true
--filetype indent on
cmd("filetype indent on")

--set number
opt.number = true
--set linespace=1
opt.linespace = 1

-- Map Ctrl+C and Ctrl+V to copy and paste.
--nmap <C-v> "+gP
--imap <C-v> <ESC><C-v>i
--vmap <C-c> "+y

--set nobackup
opt.backup = false
--set swapfile
opt.swapfile = true
--set dir=~/tmp
opt.dir = HOME .. "/tmp"

--set mouse=a
opt.mouse = "a"
--set nomousehide
--opt.mousehide = false -- Doesn't work for some reason.

-- Local .vimrc
--set exrc            " enable per-directory .vimrc files
--opt.exrc = false
--set secure          " disable unsafe commands in local .vimrc files
--opt.secure = false


-- Configuration for diagnostics and signs
opt.signcolumn = 'yes'

local signs = {
  { name = 'DiagnosticSignError', text = '' },
  { name = 'DiagnosticSignWarn', text = '' },
  { name = 'DiagnosticSignHint', text = '' },
  { name = 'DiagnosticSignInfo', text = '' },
}

for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = '' })
end

local config = {
  signs = {
    active = signs, -- show signs
  },
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = true,
    style = 'minimal',
    border = 'single',
    source = 'always',
    header = 'Diagnostic',
    prefix = '',
  },
}

vim.diagnostic.config(config)

vim.api.nvim_set_keymap('n', '<leader>do', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>d[', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>d]', '<cmd>lua vim.diagnostic.goto_next()<CR>', { noremap = true, silent = true })
-- The following command requires plug-ins "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim", and optionally "kyazdani42/nvim-web-devicons" for icon support
vim.api.nvim_set_keymap('n', '<leader>dd', '<cmd>Telescope diagnostics<CR>', { noremap = true, silent = true })
-- If you don't want to use the telescope plug-in but still want to see all the errors/warnings, comment out the telescope line and uncomment this:
-- vim.api.nvim_set_keymap('n', '<leader>dd', '<cmd>lua vim.diagnostic.setloclist()<CR>', { noremap = true, silent = true })

-- Neovide cursor
--let g:neovide_cursor_animation_length=0.03
vim.g.neovide_cursor_animation_length = 0.03
--let g:neovide_cursor_trail_length=0
vim.g.neovide_cursor_trail_length = 0
--"let g:neovide_cursor_vfx_mode = "railgun"
--vim.g.neovide_cursor_vfx_mode = "railgun"
-- Maximize window on startup
--let g:neovide_fullscreen=1
vim.g.neovide_fullscren = 1

-- Initialise fuzzy finder
--set rtp+=~/.fzf
--"Map :FZF
--nmap \t :FZF<CR>

--This unsets the last search pattern register by hitting return
api.nvim_set_keymap('n', '<Esc>', ':noh<CR>', { noremap = true, silent = true })

-- Global on_attach handler for all our lsp clients.
on_lsp_attach = function(_, bufnr)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap = true, silent = true }

  buf_set_keymap('n', 'gR', '<cmd>LspRestart<CR>', opts)

  opts.desc = "Go to declaration"
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)

  opts.desc = "Show definitions"
  buf_set_keymap('n', 'gd', '<cmd>Telescope lsp_definitions<CR>', opts)

  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)

  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)

  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)

  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)

  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)

  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)

  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)

  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)

  buf_set_keymap('n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)

  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)

  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)

  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)

  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
end

require("lspconfig").hls.setup({
  on_attach = on_lsp_attach,
})

-- Telescope keymaps
--nnoremap <leader>ff <cmd>Telescope find_files<cr>
api.nvim_set_keymap('n', '<Leader>f', '<Cmd>Telescope find_files<CR>', { noremap = true, silent = true })
--nnoremap <leader>fg <cmd>Telescope live_grep<cr>
--nnoremap <leader>fb <cmd>Telescope buffers<cr>
--nnoremap <leader>fh <cmd>Telescope help_tags<cr>

-- Lualine
lualine_sections = {
  lualine_a = {'mode'},
  lualine_b = {'branch', 'diff', 'diagnostics'},
  lualine_c = {
    {
      'filename',
      path = 1
    }
  },
  lualine_x = {'encoding', 'fileformat', 'filetype'},
  lualine_y = {'progress'},
  lualine_z = {'location'}
}

require('lualine').setup({
  inactive_sections = lualine_sections,
  options = {
    theme = 'solarized_dark'
  },
  sections = lualine_sections
})

-- Enable Mason
require("mason").setup()
