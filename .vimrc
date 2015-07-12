" .vimrc

" Basic Settings {{{
"-----------------------------------------------------------------------------

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" release autogroup in MyAutoCmd
augroup MyAutoCmd
    autocmd!
augroup END
" }}}

" Automatic recognition of Charactor Code {{{
if &encoding !=# 'utf-8'
	set encoding=japan
	set fileencoding=japan
endif
if has('iconv')
	let s:enc_euc = 'euc-jp'
	let s:enc_jis = 'iso-2022-jp'
	" Check iconv are aware of eusJP-ms
	if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
		let s:enc_euc = 'eucjp-ms'
		let s:enc_jis = 'iso-2022-jp-3'
	" Check iconv are aware of JISX0213
	elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
		let s:enc_euc = 'euc-jisx0213'
		let s:enc_jis = 'iso-2022-jp-3'
	endif
	" Construct fileencodings
	if &encoding ==# 'utf-8'
		let s:fileencodings_default = &fileencodings
		let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
		let &fileencodings = &fileencodings .','. s:fileencodings_default
		unlet s:fileencodings_default
	else
		let &fileencodings = &fileencodings .','. s:enc_jis
		set fileencodings+=utf-8,ucs-2le,ucs-2
		if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
			set fileencodings+=cp932
			set fileencodings-=euc-jp
			set fileencodings-=euc-jisx0213
			set fileencodings-=eucjp-ms
			let &encoding = s:enc_euc
			let &fileencoding = s:enc_euc
		else
			let &fileencodings = &fileencodings .','. s:enc_euc
		endif
	endif
	" Dispose the constant
	unlet s:enc_euc
	unlet s:enc_jis
endif
" If don't include the Japanese, use the encoding to fileencoding
if has('autocmd')
	function! AU_ReCheck_FENC()
		if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
			let &fileencoding=&encoding
		endif
	endfunction
	autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" Automatic recognition of the line feed code
set fileformats=unix,dos,mac
" Cursor position to prevent misalignment even if charactor of □or ○
if exists('&ambiwidth')
	set ambiwidth=double
endif " }}}

"-----------------------------------------------------------------------------
" Editor
"-----------------------------------------------------------------------------

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" do not keep a backup file, use versions instead
set nobackup

" keep 50 lines of command line history
set history=50

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" オートインデントする
set autoindent

" 改行時に入力された行の末尾に合わせて行のインデントを増減する
set smartindent

" バイナリ編集(xxd)モード（vim -b での起動、もしくは *.bin で発動します）
augroup BinaryXXD
	autocmd!
	autocmd BufReadPre  *.bin let &binary =1
	autocmd BufReadPost * if &binary | silent %!xxd -g 1
	autocmd BufReadPost * set ft=xxd | endif
	autocmd BufWritePre * if &binary | %!xxd -r | endif
	autocmd BufWritePost * if &binary | silent %!xxd -g 1
	autocmd BufWritePost * set nomod | endif
augroup END

"-----------------------------------------------------------------------------
" Searching
"-----------------------------------------------------------------------------

" 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase

" 検索文字列に大文字が含まれている場合は区別して検索する
set smartcase

" 検索時に最後まで行ったら最初に戻る
set wrapscan

" do not incremental searching
set noincsearch

"-----------------------------------------------------------------------------
" Display
"-----------------------------------------------------------------------------

" 暗い背景色を想定する
set background=dark

" Switch syntax highlighting on.
if has("syntax")
	syntax on
endif

" 行番号を表示する
set number

" タブの左側にカーソル表示
set listchars=tab:\ \ 
set list

" タブ幅を設定する
set tabstop=4
set shiftwidth=4

" display incomplete command
set showcmd

" 括弧入力時の対応する括弧を表示
set showmatch

" Switch on highlighting the last used search pattern.
set hlsearch

" ステータスラインを常に表示
set laststatus=2

" ステータスラインに文字コードと改行文字を表示する
" * disabled for lightline.vim
" set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P


"-----------------------------------------------------------------------------
" Mapping
"-----------------------------------------------------------------------------

" バッファ移動用キーマップ
" F2: 前のバッファ
" F3: 次のバッファ
" F4: バッファ削除
map <F2> <ESC>:bp<CR>
map <F3> <ESC>:bn<CR>
map <F4> <ESC>:bw<CR>

" Even text wrapping movement by j or k, is modified to act naturally.
nnoremap j gj
nnoremap k gk

" フレームサイズを怠惰に変更する
map <kPlus> <C-W>+
map <kMinus> <C-W>-

" Ctrl-D で現在時刻を挿入する
inoremap <C-D> <C-R>=strftime("%H:%M")<CR>

"-----------------------------------------------------------------------------
" Misc
"-----------------------------------------------------------------------------

" For lightline.vim
if !has('gui_running')
	set t_Co=256
endif

" NeoBundle {{{
" ------------------------------------------------------------------------------
let s:noplugin = 0
let s:neobundledir = expand("~/.vim/neobundle.vim")
let s:bundledir = expand("~/.vim/bundle")

" Functions {{{
" Install Minimum Plugins
function! s:init_neobundle()
	if has("vim_starting")
		execute "set runtimepath+=" . s:neobundledir
	endif
	call neobundle#begin(s:bundledir)
	NeoBundleFetch "Shougo/neobundle.vim" " Let NeoBundle manage NeoBundle
	NeoBundleLazy "Shougo/unite.vim", { "autoload": { "commands": ["Unite"] }}
	NeoBundle "Shougo/vimproc", {
		\ "build": {
		\ 	"windows" : "make -f make_mingw32.mak",
		\ 	"cygwin" : "make -f make_cygwin.mak",
		\ 	"mac" : "make -f make_mac.mak",
		\ 	"unix" : "make -f make_unix.mak",
		\ }}
endfunction

" Finish NeoBundle setting
function! s:finish_neobundle()
	call neobundle#end()
	filetype plugin indent on " Required!
	NeoBundleCheck " Installation check.
endfunction

" bundled
function! s:bundled(bundle)
    if !isdirectory(s:bundledir)
        return 0
    endif
    if stridx(&runtimepath, s:neobundledir) == -1
        return 0
    endif
    if a:bundle ==# 'neobundle.vim'
        return 1
    else
        return neobundle#is_installed(a:bundle)
    endif
endfunction

" load_source
function! s:load_source(path)
    let path = expand(a:path)
    if filereadable(path)
        execute "source " . path
    endif
endfunction
" }}}

" Install Plugins
if !isdirectory(s:neobundledir) || v:version < 702
    let s:noplugin = 1
elseif isdirectory(s:neobundledir) && !isdirectory(s:bundledir)
    " If Neobundle is present and the plug-in is not installed,
    " I performed in preparation
    call s:init_neobundle()
    call s:finish_neobundle()
else
    " Shougo plugins {{{
    " -------------------------------------------------
    call s:init_neobundle()
    NeoBundleLazy "Shougo/vimfiler", {
        \ "depends" : ["Shougo/unite.vim"],
        \ "autoload" : {
        \     "commands" : ["VimFiler", "VimFilerTab", "VimFilerExplorer"],
        \ }}
    " }}}

    " Scala plugins {{{
    " -------------------------------------------------
    NeoBundleLazy "derekwyatt/vim-scala", {
        \ "autoload" : { "filetypes" : ["scala"]}}
    " }}}

    " Vim Status Line plugins {{{
    " -------------------------------------------------
    NeoBundle "itchyny/lightline.vim"
    NeoBundle "tpope/vim-fugitive"
    " }}}

    " Plugins Settings
    " -------------------------------------------------

    " vimfiler {{{
    if s:bundled("vimfiler")
        let g:vimfiler_as_default_explorer = 1
        let g:vimfiler_safe_mode_by_default = 0
        " close vimfiler automatically when there are only vimfiler open
        nnoremap <Leader>e :VimFilerExplorer -split -simple -winwidth=30 -no-quit<CR>
        autocmd MyAutoCmd BufEnter * if (winnr('$') == 1 && &filetype ==# 'vimfiler') |
            \ q | endif
    endif " }}}

    " lightline.vim {{{
    let g:lightline = {
        \ 'colorscheme': 'landscape',
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ],
        \             [ 'fugitive', 'readonly', 'filename', 'modified' ] ]
        \  },
        \ 'component': {
        \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}'
        \ },
        \ 'component_visible_condition': {
        \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
        \ }
        \ }

    call s:finish_neobundle()
endif " }}}
