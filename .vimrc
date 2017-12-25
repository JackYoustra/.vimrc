" Vundle
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/syntastic'
Plugin 'bling/vim-bufferline'
Plugin 'tpope/vim-fugitive'
Plugin 'mv/mv-vim-nginx'
Plugin 'fatih/vim-go'
Plugin 'airblade/vim-gitgutter'
Plugin 'Raimondi/delimitMate'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'flazz/vim-colorschemes'
Plugin 'itchyny/lightline.vim'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'kien/ctrlp.vim'
Plugin 'nsf/gocode', {'rtp': 'vim/'}
Plugin 'wting/rust.vim'
Plugin 'Yggdroot/indentLine'
Plugin 'The-NERD-Commenter'
Plugin 'scrooloose/nerdtree'
Plugin 'wakatime/vim-wakatime'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'jeffkreeftmeijer/vim-numbertoggle'
Plugin 'Valloric/YouCompleteMe'
call vundle#end()

filetype plugin indent on
filetype plugin on
filetype on

"basic settings
syntax enable
set encoding=utf-8
set expandtab
set laststatus=2
set noautoindent
set number
set ruler
set scrolloff=10
set shell=/bin/bash
set shiftwidth=4
set t_Co=256
set tabstop=4
set term=screen-256color
set mouse=a

" customize
let mapleader = ";"
set cursorline
set ttimeoutlen=0
inoremap jk <Esc>
inoremap <esc> <nop>
vnoremap . :normal .<CR>
noremap <Leader>ww :w!<CR>
noremap <Leader>wq :w<CR>: q<CR>
noremap <Leader>qq :q!<CR>
noremap <Leader>qa :qa<CR>
noremap <Leader>bn :bNext<CR>
noremap <Leader>bd :bdelete<CR>
noremap <Leader>e 80\|
noremap <Leader>rf :%s/\<<C-r><C-w>\>/
noremap ef :lfirst<CR>
noremap ee :lnext<CR>
noremap e] :lnext<CR>
noremap e[ :lprev<CR>
nnoremap gf <C-^>
noremap ya "Ayy
if &term[:4] == "xterm" || &term[:5] == 'screen' || &term[:3] == 'rxvt'
          inoremap <silent> <C-[>OC <RIGHT>
      endif

" YCM autocomplete
noremap <F9> :YcmCompleter FixIt<CR>

" syntastic
let g:syntastic_always_populate_loc_list = 1

" ycm
let g:ycm_global_ycm_extra_conf = "~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py"

" golang
au FileType go nmap <Leader>dt <Plug>(go-def-tab)
au FileType go nmap <Leader>re <Plug>(go-rename)
let g:go_fmt_command = "gofmt"
let g:go_bin_path = $HOME . "/.go/bin"

" colors
colorscheme wombat256mod
"" colorscheme Tomorrow-Night-Eighties
set background=dark

" ctrlp settings
set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:ctrlp_arg_map = 1
let g:ctrlp_by_filename = 1
let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_follow_symlinks = 1
let g:ctrlp_map = '<c-p>'
let g:ctrlp_show_hidden = 1
let g:ctrlp_switch_buffer = 'Et'

" eas <Up>
imap ymotion settings
imap  <Down>
imap  <Right>
imap <Left>
map <Leader> <Plug>(easymotion-prefix)
nmap s <Plug>(easymotion-s)
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)
map <Leader>h <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>l <Plug>(easymotion-linebackward)
map <C-n> :NERDTreeToggle<CR>
let g:EasyMotion_smartcase = 1
let g:EasyMotion_use_upper = 1
let g:EasyMotion_use_smartsign_us = 1

" lightline
let g:lightline = {
            \ 'active': {
            \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], ['ctrlpmark', 'bufferline'] ],
            \   'right': [ [ 'syntastic', 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ] ]
            \ },
            \ 'component_function': {
            \   'fugitive': 'MyFugitive',
            \   'filename': 'MyFilename',
            \   'fileformat': 'MyFileformat',
            \   'bufferline'   : 'MyBufferline',
            \   'filetype': 'MyFiletype',
            \   'fileencoding': 'MyFileencoding',
            \   'mode': 'MyMode',
            \   'ctrlpmark': 'CtrlPMark',
            \ },
            \ 'component_expand': {
            \   'syntastic': 'SyntasticStatuslineFlag',
            \ },
            \ 'component_type': {
            \   'syntastic': 'error',
            \ },
            \ 'subseparator': { 'left': '|', 'right': '|' }
            \ }
function! MyModified()
    return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction
function! MyReadonly()
    return &ft !~? 'help' && &readonly ? 'RO' : ''
endfunction
function! MyFilename()
    let fname = expand('%:t')
    return fname == 'ControlP' ? g:lightline.ctrlp_item :
                \ fname == '__Tagbar__' ? g:lightline.fname :
                \ fname =~ '__Gundo\|NERD_tree' ? '' :
                \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
                \ &ft == 'unite' ? unite#get_status_string() :
                \ &ft == 'vimshell' ? vimshell#get_status_string() :
                \ ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
                \ ('' != fname ? fname : '[No Name]') .
                \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction
function! MyFugitive()
    try
        if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*fugitive#head')
            let mark = ''  " edit here for cool mark
            let _ = fugitive#head()
            return strlen(_) ? mark._ : ''
        endif
    catch
    endtry
    return ''
endfunction
function! MyFileformat()
    return winwidth(0) > 70 ? &fileformat : ''
endfunction
function! MyFiletype()
    return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction
function! MyFileencoding()
    return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction
function! MyMode()
    let fname = expand('%:t')
    return fname == '__Tagbar__' ? 'Tagbar' :
                \ fname == 'ControlP' ? 'CtrlP' :
                \ fname == '__Gundo__' ? 'Gundo' :
                \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
                \ fname =~ 'NERD_tree' ? 'NERDTree' :
                \ &ft == 'unite' ? 'Unite' :
                \ &ft == 'vimfiler' ? 'VimFiler' :
                \ &ft == 'vimshell' ? 'VimShell' :
                \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction
function! CtrlPMark()
    if expand('%:t') =~ 'ControlP'
        call lightline#link('iR'[g:lightline.ctrlp_regex])
        return lightline#concatenate([g:lightline.ctrlp_prev, g:lightline.ctrlp_item
                    \ , g:lightline.ctrlp_next], 0)
    else
        return ''
    endif
endfunction
let g:ctrlp_status_func = {
            \ 'main': 'CtrlPStatusFunc_1',
            \ 'prog': 'CtrlPStatusFunc_2',
            \ }
function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked)
    let g:lightline.ctrlp_regex = a:regex
    let g:lightline.ctrlp_prev = a:prev
    let g:lightline.ctrlp_item = a:item
    let g:lightline.ctrlp_next = a:next
    return lightline#statusline(0)
endfunction

function! CtrlPStatusFunc_2(str)
    return lightline#statusline(0)
endfunction
let g:tagbar_status_func = 'TagbarStatusFunc'
function! TagbarStatusFunc(current, sort, fname, ...) abort
    let g:lightline.fname = a:fname
    return lightline#statusline(0)
endfunction
augroup AutoSyntastic
    autocmd!
    autocmd BufWritePost *.c,*.cpp call s:syntastic()
augroup END
function! s:syntastic()
    SyntasticCheck
    call lightline#update()
endfunction
function! MyBufferline()
    call bufferline#refresh_status()
    let b = g:bufferline_status_info.before
    let c = g:bufferline_status_info.current
    let a = g:bufferline_status_info.after
    let alen = strlen(a)
    let blen = strlen(b)
    let clen = strlen(c)
    let w = winwidth(0) * 4 / 11
    if w < alen+blen+clen
        let whalf = (w - strlen(c)) / 2
        let aa = alen > whalf && blen > whalf ? a[:whalf] : alen + blen < w - clen || alen < whalf ? a : a[:(w - clen - blen)]
        let bb = alen > whalf && blen > whalf ? b[-(whalf):] : alen + blen < w - clen || blen < whalf ? b : b[-(w - clen - alen):]
        return (strlen(bb) < strlen(b) ? '...' : '') . bb . c . aa . (strlen(aa) < strlen(a) ? '...' : '')
    else
        return b . c . a
    endif
endfunction
let g:bufferline_echo = 0
let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0
" with enhanced tab completion
set wildmenu
set pastetoggle=<F2>
" remove trailing space
autocmd BufWritePre * :%s/\s\+$//e

"Fix arrow keys
set nocompatible

