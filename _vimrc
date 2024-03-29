" vim:expandtab shiftwidth=2 tabstop=8 textwidth=72

" Wu Yongwei's _vimrc for Vim 7
" Last Change: 2011-08-24 19:42:03
" Modified by Marvin

if v:version < 700
  echoerr 'This _vimrc requires Vim 7 or later.'
  quit
endif


if has('autocmd')
  " Remove ALL autocommands for the current group
  au!
endif

if has('gui_running')
  " Always show file types in menu
  let do_syntax_sel_menu=1
endif

if has('multi_byte')
  " Legacy encoding is the system default encoding
  let legacy_encoding=&encoding
endif

if has('gui_running') && has('multi_byte')
  " Set encoding (and possibly fileencodings)
  if $LANG !~ '\.' || $LANG =~? '\.UTF-8$'
    set encoding=utf-8
  else
    let &encoding=matchstr($LANG, '\.\zs.*')
    let &fileencodings='ucs-bom,utf-8,' . &encoding
    let legacy_encoding=&encoding
  endif
endif

set nocompatible
source $VIMRUNTIME/vimrc_example.vim

set ts=4
set sw=4
set expandtab
"colo torte
"set colo to peaksee
if !has("gui_running")
  set t_Co=256
endif
set background=dark
"colors peaksea
colo Tomorrow-Night-Eighties

set shortmess+=I
set number
map <MiddleMouse> <Nop>
imap <MiddleMouse> <Nop>

set autoindent
set nobackup
set formatoptions+=mM
set ffs=unix,dos
set fileencodings=ucs-bom,utf-8,default,latin1          " default value
set grepprg=grep\ -nH
set statusline=%<%f\ [%{&ff}]\ %h%m%r%=%k[%{(&fenc==\"\")?&enc:&fenc}%{(&bomb?\",BOM\":\"\")}]\ %-14.(%l,%c%V%)\ %P
set dictionary+=d:\vim\vimfiles\words
set tags+=d:\Vim\vimfiles\systags      " help ft-c-omni
set directory^=c:\windows\temp
set path=.,
        \,

" Personal setting for working with Windows NT/2000/XP (requires tee in path)
if &shell =~? 'cmd'
  "set shellxquote=\"
  set shellpipe=2>&1\|\ tee
  set shellpipe=>
  set makeef=vim##.err
endif

" Quote shell if it contains space and is not quoted
if &shell =~? '^[^"].* .*[^"]'
   let &shell='"' . &shell . '"'
endif

" Set British spelling convention for International English
if has('syntax')
  set spelllang=en_gb
endif

if has('eval')
  " Function to find the absolute path of a runtime file
  function! FindRuntimeFile(filename, ...)
    if a:0 != 0 && a:1 =~ 'w'
      let require_writable=1
    else
      let require_writable=0
    endif
    let runtimepaths=&runtimepath . ','
    while strlen(runtimepaths) != 0
      let filepath=substitute(runtimepaths, ',.*', '', '') . '/' . a:filename
      if filereadable(filepath)
        if !require_writable || filewritable(filepath)
          return filepath
        endif
      endif
      let runtimepaths=substitute(runtimepaths, '[^,]*,', '', '')
    endwhile
    return ''
  endfunction

  " Function to display the current character code in its 'file encoding'
  function! EchoCharCode()
    let char_enc=matchstr(getline('.'), '.', col('.') - 1)
    let char_fenc=iconv(char_enc, &encoding, &fileencoding)
    let i=0
    let len=len(char_fenc)
    let hex_code=''
    while i < len
      let hex_code.=printf('%.2x',char2nr(char_fenc[i]))
      let i+=1
    endwhile
    echo '<' . char_enc . '> Hex ' . hex_code . ' (' .
          \(&fileencoding != '' ? &fileencoding : &encoding) . ')'
  endfunction

  " Key mapping to display the current character in its 'file encoding'
  nnoremap <silent> gn :call EchoCharCode()<CR>

  " Function to switch the cursor position between the first column and the
  " first non-blank column
  function! GoToFirstNonBlankOrFirstColumn()
    let cur_col=col('.')
    normal! ^
    if cur_col != 1 && cur_col == col('.')
      normal! 0
    endif
  endfunction

  " Key mappings to make Home go to first non-blank column or first column
  nnoremap <silent> <Home>      :call GoToFirstNonBlankOrFirstColumn()<CR>
  inoremap <silent> <Home> <C-O>:call GoToFirstNonBlankOrFirstColumn()<CR>

  " Function to insert the current date
  function! InsertCurrentDate()
    let curr_date=strftime('%Y-%m-%d', localtime())
    silent! exec 'normal! gi' .  curr_date . "\<ESC>l"
  endfunction

  " Key mapping to insert the current date
  inoremap <silent> <C-\><C-D> <C-O>:call InsertCurrentDate()<CR>
endif

" Key mappings to ease browsing long lines
noremap  <C-J>         gj
noremap  <C-K>         gk
inoremap <M-Home> <C-O>g0
inoremap <M-End>  <C-O>g$

" Key mappings for quick arithmetic inside Vim (requires a calcu in path)
nnoremap <silent> <Leader>ma yypV:!calcu <C-R>"<CR>k$
vnoremap <silent> <Leader>ma yo<ESC>pV:!calcu <C-R>"<CR>k$
nnoremap <silent> <Leader>mr yyV:!calcu <C-R>"<CR>$
vnoremap <silent> <Leader>mr ygvmaomb:r !calcu <C-R>"<CR>"ay$dd`bv`a"ap

" Key mapping for confirmed exiting
nnoremap ZX :confirm qa<CR>

" Key mapping for opening the clipboard (Vim script #1014) to avoid
" conflict with the NERD Commenter (Vim script #1218)
nmap <unique> <silent> <Leader>co <Plug>ClipBrdOpen

" Key mapping to stop the search highlight
nmap <silent> <F5>      :nohlsearch<CR>
imap <silent> <F5> <C-O>:nohlsearch<CR>

" Key mappings to fold line according to syntax
nmap <silent> <F3> :set fdl=1 fdm=syntax<bar>syn sync fromstart<CR>
nmap <C-F3>   zv
nmap <M-F3>   zc


" Key mapping for the VimExplorer (Vim script #1950)
nmap <silent> <F4> :VE %:p:h<CR>

" Key mapping to toggle the display of status line for the last window
nmap <silent> <F6> :if &laststatus == 1<bar>
                     \set laststatus=2<bar>
                     \echo<bar>
                   \else<bar>
                     \set laststatus=1<bar>
                   \endif<CR>

" Key mapping for the taglist.vim plug-in (Vim script #273)
nmap <F9>      :TlistToggle<CR>
imap <F9> <C-O>:TlistToggle<CR>

" Put taglist window in the right side.
let Tlist_Auto_Open=0
let Tlist_Exit_OnlyWindow=1
let Tlist_Inc_Winwidth=0
let Tlist_Process_File_Always=0

" Key mappings for quickfix commands, tags, and buffers
nmap <F11>   :cn<CR>
nmap <F12>   :cp<CR>
nmap <M-F11> :copen<CR>
nmap <M-F12> :cclose<CR>
nmap <C-F11> :tn<CR>
nmap <C-F12> :tp<CR>
nmap <S-F11> :n<CR>
nmap <S-F12> :prev<CR>

" Key mappings for tab
nmap <M-1> 1gt
nmap <M-2> 2gt
nmap <M-3> 3gt
nmap <M-4> 4gt
nmap <M-5> 5gt

" Function to turn each paragraph to a line (to work with, say, MS Word)
function! ParagraphToLine()
  normal! ma
  if &formatoptions =~ 'w'
    let reg_bak=@"
    normal! G$vy
    if @" =~ '\s'
      normal! o
    endif
    let @"=reg_bak
    silent! %s/\(\S\)$/\1\r/e
  else
    normal! Go
  endif
  silent! g/\S/,/^\s*$/j
  silent! %s/\s\+$//e
  normal! `a
endfunction

" Non-GUI setting
if !has('gui_running')
  " English messages only
  language messages en

  " Do not increase the windows width in taglist
  let Tlist_Inc_Winwidth=0

  " Set text-mode menu
  if has('wildmenu')
    set wildmenu
    set cpoptions-=<
    set wildcharm=<C-Z>
    nmap <F10>      :emenu <C-Z>
    imap <F10> <C-O>:emenu <C-Z>
  endif

  " Change encoding according to the current console code page
  if &termencoding != '' && &termencoding != &encoding
    let &encoding=&termencoding
    let &fileencodings='ucs-bom,utf-8,' . &encoding
  endif
endif

" Display window width and height in GUI
if has('gui_running') && has('statusline')
  let &statusline=substitute(
                 \&statusline, '%=', '%=%{winwidth(0)}x%{winheight(0)}  ', '')
  set laststatus=2
endif

" Set up language and font in GUI
if has('gui_running') && has('multi_byte')
  function! UTF8_East()
    exec 'language messages ' . s:lang_east . '.UTF-8'
    set ambiwidth=double
    set encoding=utf-8
    let s:utf8_east_mode=1
  endfunction

  function! UTF8_West()
    exec 'language messages ' . s:lang_west . '.UTF-8'
    set ambiwidth=single
    set encoding=utf-8
    let s:utf8_east_mode=0
  endfunction

  function! UTF8_SwitchMode()
    if exists('b:utf8_east_mode')
      unlet b:utf8_east_mode
    endif
    if s:utf8_east_mode
      call UTF8_West()
      call UTF8_SetFont()
    else
      call UTF8_East()
      call UTF8_SetFont()
    endif
  endfunction

  function! UTF8_SetFont()
    if &encoding != 'utf-8'
      return
    endif
      if &fileencoding == 'cp936' ||
            \&fileencoding == 'gbk' ||
            \&fileencoding == 'euc-cn'
        let s:font_east=s:font_schinese
      elseif &fileencoding == 'cp950' ||
            \&fileencoding == 'big5' ||
            \&fileencoding == 'euc-tw'
        let s:font_east=s:font_tchinese
    elseif &fileencoding == 'cp932' ||
          \&fileencoding == 'sjis' ||
          \&fileencoding == 'euc-jp'
      let s:font_east=s:font_japanese
    elseif &fileencoding == 'cp949' ||
          \&fileencoding == 'euc-kr'
      let s:font_east=s:font_korean
      endif
    if exists('b:utf8_east_mode') && s:utf8_east_mode != b:utf8_east_mode
      let s:utf8_east_mode=b:utf8_east_mode
      let &ambiwidth=(s:utf8_east_mode ? 'double' : 'single')
    endif
    if s:utf8_east_mode
        exec 'set guifont=' . s:font_east
      set guifontwide=
    else
        exec 'set guifont=' . s:font_west
      if exists('s:legacy_encoding_is_west')
        exec 'set guifontwide=' . s:font_east
      endif
    endif
  endfunction

  function! UTF8_CheckAndSetFont()
    if &fileencoding == 'cp936' ||
          \&fileencoding == 'gbk' ||
          \&fileencoding == 'euc-cn' ||
          \&fileencoding == 'cp950' ||
          \&fileencoding == 'big5' ||
          \&fileencoding == 'euc-tw'
      let b:utf8_east_mode=1
    elseif &fileencoding == 'latin1' ||
          \&fileencoding =~ 'iso-8859-.*' ||
          \&fileencoding =~ 'koi8-.' ||
          \&fileencoding == 'macroman' ||
          \&fileencoding == 'cp437' ||
          \&fileencoding == 'cp850' ||
          \&fileencoding =~ 'cp125.'
      let b:utf8_east_mode=0
    endif
    if exists('b:utf8_east_mode') &&
          \(b:utf8_east_mode || (!b:utf8_east_mode && s:utf8_east_mode)) &&
          \((s:utf8_east_mode && &guifont == s:font_east) ||
          \(!s:utf8_east_mode && &guifont == s:font_west))
      call UTF8_SetFont()
    endif
  endfunction

  " Rebuild the menu to make the translations display correctly
  " --------------------------------------------------------------------
  " Uncomment the following code if all of the following conditions
  " hold:
  "   1) Unicode support is wanted (enabled by default for gVim in this
  "      _vimrc);
  "   2) The libintl.dll shipped with gVim for Windows is not updated
  "      with a new one that supports encoding conversion (see also
  "      <URL:http://tinyurl.com/2hnwaq> for issues with this approach);
  "   3) The environment variable LANG is not manually set to something
  "      like "zh_CN.UTF-8", and the default language is not ASCII-based
  "      (English).
  " The reason why the code is not enabled by default is because it can
  " interfere with the localization of menus created by plug-ins.
  " --------------------------------------------------------------------
  "
  "if $LANG !~ '\.' && v:lang !~? '^\(C\|en\)\(_\|\.\|$\)'
  "  runtime! delmenu.vim
  "endif

  " Fonts
  let s:font_schinese='NSimSun:h12:cDEFAULT'
  let s:font_tchinese='MingLiU:h12:cDEFAULT'
  let s:font_japanese='MS_Gothic:h12:cDEFAULT'
  let s:font_korean='GulimChe:h12:cDEFAULT'
  if legacy_encoding == 'cp936'
    let s:font_schinese=''              " Use the system default font
  elseif legacy_encoding == 'cp950'
    let s:font_tchinese=''              " Use the system default font
  elseif legacy_encoding == 'cp932'
    let s:font_japanese=''              " Use the system default font
  elseif legacy_encoding == 'cp949'
    let s:font_korean=''                " Use the system default font
  else
    let s:legacy_encoding_is_west=1
  endif
  if legacy_encoding == 'cp936'
    let s:font_east=s:font_schinese
  elseif legacy_encoding == 'cp950'
    let s:font_east=s:font_tchinese
  elseif legacy_encoding == 'cp932'
    let s:font_east=s:font_japanese
  elseif legacy_encoding == 'cp949'
    let s:font_east=s:font_korean
  else
    let s:font_east=s:font_schinese
  endif
  let s:font_west='Courier_New:h10:cDEFAULT'

  " Extract the current Eastern/Western language settings
  if v:lang =~? '^\(zh\)\|\(ja\)\|\(ko\)'
    let s:lang_east=matchstr(v:lang, '^[a-zA-Z_]*\ze\(\.\|$\)')
    let s:lang_west='en'
    let s:utf8_east_mode=1
    if v:lang=~? '^zh_TW'
      let s:font_east=s:font_tchinese
    elseif v:lang=~? '^ja'
      let s:font_east=s:font_japanese
    elseif v:lang=~? '^ko'
      let s:font_east=s:font_korean
    endif
  else
    let s:lang_east='zh_CN'
    let s:lang_west=matchstr(v:lang, '^[a-zA-Z_]*\ze\(\.\|$\)')
    let s:utf8_east_mode=0
  endif

  " Set a suitable GUI font and the ambiwidth option
  if &encoding == 'utf-8'
    if s:utf8_east_mode
      call UTF8_East()
    else
      call UTF8_West()
    endif
  endif
  call UTF8_SetFont()

  " Key mapping to switch the Eastern/Western UTF-8 mode
  nmap <F8>      :call UTF8_SwitchMode()<CR>
  imap <F8> <C-O>:call UTF8_SwitchMode()<CR>

  if has('autocmd')
    " Set the appropriate GUI font according to the fileencoding, but
    " not if user has manually changed it
    au BufWinEnter,WinEnter * call UTF8_CheckAndSetFont()
  endif
endif

" Key mapping to toggle spelling check
if has('syntax')
  nmap <silent> <F7>      :setlocal spell!<CR>
  imap <silent> <F7> <C-O>:setlocal spell!<CR>
  let spellfile_path=FindRuntimeFile('spell/en.' . &encoding . '.add', 'w')
  if spellfile_path != ''
    exec 'nmap <M-F7> :sp ' . spellfile_path . '<CR><bar><C-W>_'
  endif
endif

if has('autocmd')
  function! SetFileEncodings(encodings)
    let b:my_fileencodings_bak=&fileencodings
    let &fileencodings=a:encodings
  endfunction

  function! RestoreFileEncodings()
    let &fileencodings=b:my_fileencodings_bak
    unlet b:my_fileencodings_bak
  endfunction

  function! GnuIndent()
    setlocal cinoptions=>4,n-2,{2,^-2,:2,=2,g0,h2,p5,t0,+2,(0,u0,w1,m1
    setlocal shiftwidth=2
    setlocal tabstop=8
  endfunction

  function! UpdateLastChangeTime()
    let last_change_anchor='\(" Last Change:\s\+\)\d\{4}-\d\{2}-\d\{2} \d\{2}:\d\{2}:\d\{2}'
    let last_change_line=search('\%^\_.\{-}\(^\zs' . last_change_anchor . '\)', 'n')
    if last_change_line != 0
      let last_change_time=strftime('%Y-%m-%d %H:%M:%S', localtime())
      let last_change_text=substitute(getline(last_change_line), '^' . last_change_anchor, '\1', '') . last_change_time
      call setline(last_change_line, last_change_text)
    endif
  endfunction

  function! RemoveTrailingSpace()
    if $VIM_HATE_SPACE_ERRORS != '0' &&
          \(&filetype == 'c' || &filetype == 'cpp' || &filetype == 'vim')
      normal! m`
      silent! :%s/\s\+$//e
      normal! ``
    endif
  endfunction

  " Set default file encodings to the legacy encoding
  "exec 'set fileencoding=' . legacy_encoding
  if legacy_encoding != 'latin1'
  let &fileencodings=substitute(
                    \&fileencodings, '\<default\>', legacy_encoding, '')
  else
    let &fileencodings=substitute(
                      \&fileencodings, ',default,', ',', '')
  endif

  " Set the directory to store _vim_mru_files (Vim script #521)
  let MRU_File=$HOME . '\_vim_mru_files'
  " And exclude the temporary files from being saved
  let MRU_Exclude_Files='\\itsalltext\\.*\|\\temp\\.*'

  " Use the legacy encoding for calling system() in VimExplorer
  let VEConf_systemEncoding=legacy_encoding

  " Use the legacy encoding for CVS in cvsmenu (Vim script #1245)
  let CVScmdencoding=legacy_encoding
  " but the encoding of files in CVS is still UTF-8
  let CVSfileencoding='utf-8'

  " Use automatic encoding detection (Vim script #1708)
  let $FENCVIEW_TELLENC='tellenc'       " See <URL:http://wyw.dcweb.cn/>
  let fencview_auto_patterns='*.txt,*.tex,*.htm{l\=},*.asp'
                           \.',README,CHANGES,INSTALL'
  let fencview_html_filetypes='html,aspvbs'

  " File types to use function echoing (Vim script #1735)
  let EchoFuncLangsUsed=['c', 'cpp']

  " Do not use menu for NERD Commenter
  let NERDMenuMode=0
  " Prevent NERD Commenter from complaining about unknown file types
  let NERDShutUp=1

  " Highlight space errors in C/C++ source files (Vim tip #935)
  if $VIM_HATE_SPACE_ERRORS != '0'
    let c_space_errors=1
  endif

  " Tune for C highlighting
  let c_gnu=1
  let c_no_curly_error=1

  " Load doxygen syntax file for c/cpp/idl files
  " let load_doxygen_syntax=1

  " Use Bitstream Vera Sans Mono as special code font in doxygen, which
  " is available at
  " <URL:http://ftp.gnome.org/pub/GNOME/sources/ttf-bitstream-vera/1.10/>
  " let doxygen_use_bitsream_vera=1

  " Let TOhtml output <PRE> and style sheet
  let html_use_css=1

  " Show syntax highlighting attributes of character under cursor (Vim
  " script #383)
  map <Leader>a :call SyntaxAttr()<CR>

  " Automatically find scripts in the autoload directory
  au FuncUndefined Syn* exec 'runtime autoload/' . expand('<afile>') . '.vim'

  " File type related autosetting
  au FileType c,cpp     setlocal cinoptions=:0,g0,(0,w1 shiftwidth=4 tabstop=4
  au FileType diff      setlocal shiftwidth=4 tabstop=4
  au FileType changelog setlocal textwidth=76
  au FileType cvs       setlocal textwidth=72
  au FileType html,xhtml setlocal indentexpr=
  au FileType mail      setlocal expandtab softtabstop=2 textwidth=70

  " Detect file encoding based on file type
  au BufReadPre  *.gb               call SetFileEncodings('cp936')
  au BufReadPre  *.big5             call SetFileEncodings('cp950')
  au BufReadPre  *.nfo              call SetFileEncodings('cp437')
  au BufReadPost *.gb,*.big5,*.nfo  call RestoreFileEncodings()

  " Quickly exiting help files
  au BufRead *.txt      if &buftype=='help'|nmap <buffer> q <C-W>c|endif

  " Setting for files following the GNU coding standard
  " au BufEnter D:/WuYongwei/cvssrc/socket++/*  call GnuIndent()
  " au BufEnter D:/mingw*             call GnuIndent()

  " Automatically update change time
  au BufWritePre *vimrc,*.vim       call UpdateLastChangeTime()

  " Remove trailing spaces for C/C++ and Vim files
  au BufWritePre *                  call RemoveTrailingSpace()
endif

if has('autocmd')
  autocmd FileType python setlocal makeprg=python\ %
endif
set guioptions=-t
"set guifont=Courier_New:h12:cANSI
set guifont=YaHei\ Consolas\ Hybrid:h14:cANSI

syntax match Tab /\t/
hi Tab gui=underline guifg=blue ctermbg=blue

imap jj <ESC>

nmap tt :TlistToggle<CR>

"Use \e instead of :e to edit file in the same directory
"with the current file
"nnoremap <Leader>e :e <C-R>=expand('%:p:h') . '/'<CR>

"Auto wrap line when editing a txt file.
"Use gq to wrap line of highlighted area.

if has('autocmd')
  au BufRead,BufNewFile *.txt set wm=2 tw=500 spell
endif

set columns=85

"au GUIEnter * simalt ~x "maximum window on startup

"This maps Alt-Space to pop down the system menu for the Vim window.  Note that
"~ is used by simalt to represent the <Space> character. >
map <M-Space> :simalt ~<CR>

" Fast loading large file
" Protect large files from sourcing and other overhead.
" Files become read only
"if !exists("my_auto_commands_loaded")
"  let my_auto_commands_loaded = 1
"  " Large files are > 10M
"  " Set options:
"  " eventignore+=FileType (no syntax highlighting etc
"  " assumes FileType always on)
"  " noswapfile (save copy of file)
"  " bufhidden=unload (save memory when other file is viewed)
"  " buftype=nowritefile (is read-only)
"  " undolevels=-1 (no undo possible)
"  let g:LargeFile = 1024 * 1024 * 10
"  augroup LargeFile
"    autocmd BufReadPre * let f=expand("<afile>") | if getfsize(f) > g:LargeFile | set eventignore+=FileType | setlocal noswapfile bufhidden=unload buftype=nowrite undolevels=-1 | else | set eventignore-=FileType | endif
"    augroup END
"endif
"
au! BufRead,BufNewFile *.json set filetype=json foldmethod=syntax
