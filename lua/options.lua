-- Editor options. Ported from ~/.vim/vimrc with neovim-era cleanups.

local opt = vim.opt

-- Look & feel
opt.number = true
opt.relativenumber = false
opt.cursorline = true
opt.signcolumn = 'yes'        -- always-on gutter so diagnostics don't shift text
opt.scrolloff = 4
opt.showmatch = true
opt.matchtime = 3
opt.termguicolors = true       -- 24-bit colors (replaces t_Co=256)
opt.background = 'dark'
opt.fillchars = { diff = '⣿', vert = '│', eob = ' ' }

-- Indentation (your vim defaults)
opt.expandtab = true
opt.shiftwidth = 4
opt.softtabstop = 4
opt.tabstop = 4
opt.shiftround = true
opt.autoindent = true
opt.smartindent = true

-- Wrapping
opt.wrap = true
opt.linebreak = true
opt.textwidth = 0
opt.formatoptions = 'qrn1j'    -- j = remove comment leader when joining

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true
-- gdefault was here in vim — leaving it off; it's a known footgun and modern muscle memory expects /g

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Buffers / files
opt.hidden = true
opt.history = 1000
opt.backspace = { 'indent', 'eol', 'start' }
opt.virtualedit = 'onemore'
opt.mouse = 'a'
opt.confirm = true             -- prompt instead of erroring on unsaved buffers

-- Wildmenu (command-line completion)
opt.wildmenu = true
opt.wildmode = { 'longest', 'list', 'full' }
opt.wildignore = {
  '.hg', '.git', '.svn',
  '*.aux', '*.out', '*.toc',
  '*.jpg', '*.bmp', '*.gif', '*.png', '*.jpeg',
  '*.o', '*.obj', '*.exe', '*.dll', '*.manifest',
  '*.spl', '*.sw?', '*.DS_Store', '*.luac',
  'migrations', '*.pyc', '*.orig', '*.class',
  'node_modules', '.next', 'dist', 'build', '__pycache__',
}

-- Undo (XDG-conformant location, neovim manages this dir for us)
opt.undofile = true
opt.undolevels = 1000
opt.undoreload = 10000

-- Folding off by default — your vim style
opt.foldlevel = 999
opt.foldenable = false

-- Performance / UX
opt.updatetime = 250           -- faster CursorHold for LSP, gitsigns, etc.
opt.timeoutlen = 400           -- which-key feels snappier with lower timeout
opt.completeopt = { 'menuone', 'noselect', 'noinsert' }

-- Visual bell, no beeping
opt.visualbell = true

-- whichwrap: keep your vim behavior (h/l wrap across lines)
opt.whichwrap:append 'h,l,~,[,]'

-- Status line: lualine handles this, but until plugins load we want one
opt.laststatus = 3             -- global statusline (one bar at the bottom)
opt.showmode = false           -- lualine displays the mode

-- Spelling off by default; toggle per-buffer when needed
opt.spell = false

-- Live substitution preview
opt.inccommand = 'split'

-- Clipboard: sync to system clipboard. Comment out if you prefer the explicit "+y dance.
opt.clipboard = 'unnamedplus'

-- Filetype defaults below; per-language overrides live in autocmds.lua
