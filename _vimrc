set nocompatible
filetype off

call plug#begin('~/.vim/plugged')
Plug 'othree/html5.vim'
Plug 'scrooloose/nerdtree'
Plug 'tomtom/tcomment_vim'
Plug 'hail2u/vim-css3-syntax'
Plug 'tpope/vim-surround'
Plug 'sheerun/vim-polyglot'
Plug 'vimwiki/vimwiki'
Plug 'alligator/accent.vim'
Plug 'junegunn/goyo.vim'
Plug 'sonph/onehalf', {'rtp': 'vim'}
call plug#end()

filetype plugin indent on

"==============================================================================
"HOW IT WORKS
"==============================================================================
set nocompatible        "Git tae, Vi compatibility
set hidden              "Allows hidden buffers with changes
set backspace=indent,eol,start "Allows backspacing over stuff
set laststatus=2        "Status line is always on
set incsearch           "Show match while entering search
set ignorecase          "Search is case insensitive unless...
set smartcase           "An uppercase letter is found
set virtualedit=all     "Cursor can move anywhere (ish)
set scrolloff=8         "Keeps the cursor centered while scrolling
set vb                  "Visual bell
set t_vb=               "shut up bell
set wildmenu            "Display options when autocompleting in cmdline mode
set shellslash          "Use / instead of \ for file paths and such
set spl=en_gb           "Language for spellchecking
" set cpoptions+=$        "Overwrite text (visually)
set viminfo+=<0         "Don't save registers
set viminfo-=<50        "Same as above, removes default stuff from viminfo
set complete+=t         "Tag completion
set shortmess+=I        "Remove the intro message
set nostartofline       "Stop jumping to the start of a line
set fillchars=          "Remove the characters in window separators
set pastetoggle=<F2>    "Use F2 to toggle paste on/off in insert mode
set showmatch           "Jump to matching paren when inserting
set mouse-=a            "Disable mouse
set foldmethod=marker   "Fold on explicit fold markers

if has("multi_byte")
  set encoding=utf-8
  setglobal fileencoding=utf-8
endif

filetype plugin indent on   "Filetype plugin
syntax on                   "Syntax highlighting

"Omni completion
set omnifunc=syntaxcomplete#Complete

"Autocmds
"--------
if has('autocmd')
  "Setting filetypes
  au BufRead,BufNewFile *.srt  set filetype=srt
  au BufRead,BufNewFile *.lr   set filetype=markdown
  au BufRead,BufNewFile *.avs  set syntax=avs

  "Folds, uses execute to supress error messages
  "au BufRead *   execute ':silent! loadview' | execute 'silent! normal gg'
  " autocmd BufWinLeave *.* silent mkview
  " autocmd BufWinEnter *.* silent loadview

  "Scheme indentation
  au BufRead,BufNewFile *.scm    setl shiftwidth=2 tabstop=2 softtabstop=2

  "HTML/CSS/PHP indentation
  " au BufRead,BufNewFile *.html   setl shiftwidth=2 tabstop=2 softtabstop=2
  " au BufRead,BufNewFile *.js     setl shiftwidth=2 tabstop=2 softtabstop=2
  " au BufRead,BufNewFile *.php    setl shiftwidth=2 tabstop=2 softtabstop=2
  " au BufRead,BufNewFile *.css    setl shiftwidth=2 tabstop=2 softtabstop=2
  " au BufRead,BufNewFile *.coffee setl shiftwidth=2 tabstop=2 softtabstop=2
  " au BufRead,BufNewFile *.tpl    setl shiftwidth=2 tabstop=2 softtabstop=2
endif

"I am bad at the shift key - Abbreviations
cabbrev Bd      bd
cabbrev Cd      cd
cabbrev W       w
cabbrev Q       q
cabbrev Colo    colo
cabbrev X       x

"==============================================================================
"MAPPINGS
"==============================================================================
let mapleader=','
map <Space> ,

"get out mousewheel
map <MiddleMouse> <Nop>
imap <MiddleMouse> <Nop>

"Default vimrc mappings
nnoremap    <Leader>ve :e $MYVIMRC<CR>
nnoremap    <Leader>vs :so $MYVIMRC<CR>

"Line movement mappings
nnoremap    <silent> <C-Down>  mz:m+<CR>==`z
nnoremap    <silent> <C-Up>    mz:m-2<CR>==`z
inoremap    <silent> <C-Down>  <Esc>:m+<CR>==gi
inoremap    <silent> <C-Up>    <Esc>:m-2<CR>==gi
vnoremap    <silent> <C-Down>  :m'>+<CR>gv=gv
vnoremap    <silent> <C-Up>    :m-2<CR>gv=gv

"Window movement
nnoremap    <C-j> <C-w>j
nnoremap    <C-k> <C-w>k
nnoremap    <C-l> <C-w>l
nnoremap    <C-h> <C-w>h

"Always use visual line movement
nnoremap    j gj
nnoremap    k gk

"Map jj to esc
inoremap    jj <Esc>
inoremap    fd <Esc>

"Cd to current file's dir
nnoremap    <Leader>cd  :cd %:h<CR>:pwd<CR>

"Insert current date
nnoremap    <Leader>d  "=strftime('%d %b %Y')<CR>P

"Moving between buffers
nnoremap    <silent> <C-n> :bn<CR>
nnoremap    <silent> <C-b> :bp<CR>

"Show the buffer list
nnoremap    <Leader>b  :ls<CR>:b 

"Toggle search highlighting
nnoremap    <Leader>hl :set invhls<CR>:set hls?<CR>

"Show hidden chars
nnoremap    <silent> <Leader>l :set invlist<CR>

"Run python script
nnoremap    <Leader>py :!python %<CR>

"Write
nnoremap    <Leader>w :w<CR>

"Spell checking
nnoremap    <Leader>s :set invspell<CR>

"Simple brace completion
inoremap    <C-]>   {<CR>}<ESC>O

"Copy and paste
nnoremap    <Leader>p "*p
vnoremap    <Leader>c "*y

"Copy all
nnoremap    <Leader>ca maG"*ygg`a

"Buffer switching
nnoremap    <Tab> 

"Show highlighting group for word under cursor (eep)
"i can't remember where i nicked this from
 nmap        <C-S-P> :echo "hi<" .
       \ synIDattr(synID(line("."),col("."),0),"name") . "> lo<" .
       \ synIDattr(synID(line("."),col("."),1),"name") . '> trans<' .
       \ synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">" . " FG:" .
       \ synIDattr(synIDtrans(synID(line("."),col("."),1)),"fg#")<CR>


"==============================================================================
"FUNCTIONS
"==============================================================================
"Underlining
command!    -nargs=1 Underline call Underline('<args>')
function! Underline(ch)
  silent t.
  silent execute 's/./' . a:ch . '/g'
endfunction

"Fix window borders
command!  Fix call Fix()
function! Fix()
  let x = getwinposx()
  let y = getwinposy()
  silent! set lines-=1|set lines+=1
  silent! execute "winpos ".x." ".y
endfunction


"==============================================================================
"HOW IT LOOKS
"==============================================================================
set tabstop=2           "Tab character width
set softtabstop=2       "Amount of whitespace to be inserted
set shiftwidth=2        "Amount of whitespace in Normal mode
set expandtab           "Spaces rather than tabs
set autoindent

set number              "Line numbering
set background=dark     "Better colours for a dark background

"Stops words being hypenated when wrapping
set wrap lbr

"Setting hidden chars
set listchars=tab:\>\ ,eol:¬,nbsp:_

"Setting the statusline
set statusline=%f\ %m%=%l/%L

"==============================================================================
"PLUGINS
"==============================================================================
"NERDTree
let NERDTreeWinPos='left'
nnoremap <silent> <Leader>nt :NERDTree.<CR>
"Open tree using file's directory
nnoremap <silent> <Leader>nf :NERDTree %:p:h<CR>

map <Space> ,

let wiki = {}
let wiki.path = '~/vimwiki/wiki'
let wiki.path_html = '~/vimwiki/docs'
let wiki.template_path = '~/vimwiki/wiki/templates'
let wiki.auto_diary_index = 1
let wiki.auto_export = 1

let g:vimwiki_list = [wiki]

set t_Co=256
let g:accent_color='cyan'
colo accent

set cinoptions=l1
