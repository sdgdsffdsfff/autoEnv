set nocompatible
set encoding=utf-8
set termencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1

"set autoindent

set lbr
"set tw=78
"set whichwrap=b,s,<,>,[,],h,l
set whichwrap=b,s,<,>,[,] 
setlocal noswapfile
set bufhidden=hide

"set guifont=Courier_New:h14
"set guifontwide=YaHei\ Consolas\ Hybrid:h14
"set guifont=YaHei\ Consolas\ Hybrid:h14

" 设置窗口的起始位置和大小
"winpos 250 200
"set lines=30
"set columns=120

" 显示行号
set number
set ruler
" 不换行
"set wrap
"set mouse=a 
set mouse= 

" 设置缩进
set shiftwidth=4
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

" 关闭备份
set nobackup
set nowritebackup

" Tag List
"let Tlist_File_Fold_Auto_Close=1

" 移除菜单栏、工具栏和滚动条
"set guioptions-=m
set guioptions-=T
"set guioptions-=r
"set guioptions-=b

" Folding
"set foldmethod=syntax

"set backspace=indent,eol,start
set backspace=2

" jump only one 'line' when wrap set on

nnoremap j gj

nnoremap k gk

vnoremap j gj

vnoremap k gk

nnoremap <Down> gj

nnoremap <Up> gk

vnoremap <Down> gj

vnoremap <Up> gk

inoremap <Down> <C-o>gj

inoremap <Up> <C-o>gk

"blank
"inoremap , ,<SPACE>
"inoremap ; ;<SPACE>
"inoremap : <SPACE>:<SPACE>
"inoremap ( ()<LEFT>
"inoremap [ []<LEFT> 
"inoremap { {}<LEFT> 
"inoremap ' ''<LEFT> 
"inoremap " ""<LEFT> 
"inoremap ++ ++<SPACE>
"inoremap -- --<SPACE>
"inoremap *= <SPACE>*=<SPACE>
"inoremap += <SPACE>+=<SPACE>
"inoremap -= <SPACE>-=<SPACE>
"inoremap /= <SPACE>/=<SPACE>
"inoremap == <SPACE>==<SPACE>
"inoremap >= <SPACE>>=<SPACE>
"inoremap <= <SPACE><=<SPACE>
"inoremap && <SPACE>&&<SPACE>
""inoremap || <SPACE>||<SPACE>
"inoremap * <SPACE>*<SPACE>
"inoremap + <SPACE>+<SPACE>
"inoremap - <SPACE>-<SPACE>
"inoremap = <SPACE>=<SPACE>

map <S-Insert> <MiddleMouse>	
set nocompatible
set noerrorbells novisualbell
set esckeys             " allow arrow keys in insert mode
set ignorecase  " make searches case-insensitive
set hlsearch
"colorscheme evening


""""""""""""""""""""""""""""""
" BufExplorer
""""""""""""""""""""""""""""""
let g:bufExplorerDefaultHelp=0       " Do not show default help.
let g:bufExplorerShowRelativePath=1  " Show relative paths.
let g:bufExplorerSortBy='mru'        " Sort by most recently used.
let g:bufExplorerSplitRight=0        " Split left.
let g:bufExplorerSplitVertical=1     " Split vertically.
let g:bufExplorerSplitVertSize = 30  " Split width
let g:bufExplorerUseCurrentWindow=1  " Open in new window.
autocmd BufWinEnter \[Buf\ List\] setl nonumber 

""""""""""""""""""""""""""""""
" winManager setting
""""""""""""""""""""""""""""""
"let g:winManagerWindowLayout = "BufExplorer,FileExplorer|TagList"
"let g:winManagerWidth = 30
"let g:defaultExplorer = 0
nmap <C-W><C-F> :FirstExplorerWindow<cr>
nmap <C-W><C-B> :BottomExplorerWindow<cr>
nmap <silent> <leader>wm :WMToggle<cr><C-S-W><C-S-W> 
"nmap <F3> :WMToggle<cr>
nmap <F3> :NERDTreeToggle<cr>
"nmap <F4> :NERDTreeFind<cr>
"nmap <F5> :BufExplorer<cr>


"for quick save in normal mode
map <F2> :write<CR>
"map <F3> :Explore<CR>
"switch between windows
map <silent> <F12> <C-W>w

"for quick save in edit mode
imap <F2> <ESC><F2>a


autocmd FileType c,php,javascript call C()
fun! C()
set cindent
"set comments=sr:/*,mb:*,el:*/,://
"set commentstring=\ \ //\ %s\ " <SPACE>
"set foldcolumn=3
"set tags+=/usr/include/tags
"execute :set dictionary=C:\\dict\\C”
"control-c comments block
vmap <C-C> :s/^/\/\//g<enter>
"control-x uncomments block
vmap <C-X> :s/^\/\///g<enter>
"map! =for for(i = 0; i < ; i++){<LEFT><LEFT><LEFT><LEFT><LEFT><LEFT><LEFT>
endfun
"endfun C

filetype plugin indent on
syntax on
"set ofu=syntaxcomplete#Complete
"set completeopt=longest,menuone
"inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
"  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
"
"inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
"  \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

set laststatus=2
set statusline=
set statusline+=%-3.3n\
set statusline+=%f\
set statusline+=%h%m%r%w
set statusline+=\[%{strlen(&ft)?&ft:'none'}]
set statusline+=%=
set statusline+=0x%-8B
set statusline+=%-14(%l,%c%V%)
set statusline+=%<%P
set ruler
" Display incomplete commands.
set showcmd
set incsearch
"set wildmenu

au VimLeave * exe 'if exists("g:cmd") && g:cmd == "vims" | if strlen(v:this_session) | exe "wviminfo! " . v:this_session . ".viminfo" | else | exe "wviminfo! " . "~/.vim/session/" . g:myfilename . ".session.viminfo" | endif | endif '
au VimLeave * exe 'if exists("g:cmd") && g:cmd == "vims" | if strlen(v:this_session) | exe "mksession! " . v:this_session | else | exe "mksession! " . "~/.vim/session/" . g:myfilename . ".session" | endif | endif'


map <F8> :tabnext<CR>
map <F7> :tabprevious<CR>
map <C-t>   :tabnew .<CR>
imap <F8> <ESC>:tabnext<CR>i
imap <F7> <ESC>:tabprevious<CR>i
imap <C-t> <ESC>:tabnew .<CR>i
map <F6> :set pastetoggle<CR>

"nnoremap <C-v> "+p
"inoremap <C-v> <ESC>"+pi
vnoremap <C-c> "+y

function! VIMS (args)
    if strlen(v:this_session) 
        exe "wviminfo! " . v:this_session . ".viminfo" 
    else 
        exe "wviminfo! " . "~/.vim/session/" . g:myfilename . ".session.viminfo" 
    endif

    if strlen(v:this_session) 
        exe "mksession! " . v:this_session 
    else 
        exe "mksession! " . "~/.vim/session/" . a:args. ".session" 
    endif
endfunction
command! -nargs=* -complete=file VIMS call VIMS(<q-args>)
