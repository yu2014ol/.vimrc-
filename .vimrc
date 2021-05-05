set nocompatible                " don't bother with vi compatibility "
set autoread
set magic                       " For regular expressions turn magic on "
set title                       " change the terminal's title "
set nobackup                    " do not keep a backup file "                     
set encoding=utf-8              " set encoding
set termencoding=utf-8
set ruler                       " show the current row and column "
set number                      " show line numbers "
set showcmd                     " display incomplete commands " 
set showmode                    " display current modes "
set showmatch                   " jump to matches when entering parentheses "
set cursorline
set mouse=a                     " 启用鼠标
set selection=exclusive
set selectmode=mouse,key
set ignorecase                  " 搜索忽略大小写
set completeopt=preview,menu    " 代码补全 
set completeopt=longest,menu    " 打开文件类型检测, 加了这句才可以用智能补全

set shiftwidth=2
set tabstop=2
set autoindent smartindent shiftround 
" set expandtab                 " Makefile不能用空格替换tab，故注释掉该行

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""按键映射配置（会报错，但是能用...）
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
noremap <C-a> ggVG          " Ctrl-a 全选
inoremap <C-a> <Esc>ggVG    " Ctrl-a 全选
noremap <C-x> "+x           " Ctrl-x 剪贴
inoremap <C-x> <Esc>"+x     " Ctrl-x 剪贴
noremap <C-b> <C-v>         " Ctrl-b 块选择
noremap <C-z> u             " Ctrl-z 撤销
" Ctrl-z 撤销 注意i后面不能有其他内容
inoremap <C-z> <Esc>ui
noremap <C-v> "+P           " Ctrl-v 粘贴
" Ctrl-v 粘贴 注意i后面不能有其他内容
inoremap <C-v> <Esc>"+pi    
noremap <C-c> "+y           " Crtl-c 复制 
" Crtl-c 复制 注意i后面不能有其他内容
inoremap <C-c> <Esc>"+yi            

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""文件类型设置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype on                     " 侦测文件类型
filetype plugin on              " 载入文件类型插件
filetype indent on              " 为特定文件类型载入相关缩进文件

autocmd FileType python set tabstop=4 shiftwidth=4 expandtab ai
autocmd FileType ruby set tabstop=2 shiftwidth=2 softtabstop=2 expandtab ai
autocmd BufRead,BufNew *.md,*.mkd,*.markdown set filetype=markdown.mkd

autocmd BufNewFile *.sh,*.py exec \":call AutoSetFileHead()\"
function! AutoSetFileHead()
    " .sh "
    if &filetype == 'sh'
        call setline(1, "\#!/bin/bash")
    endif                                                                                                                                                  
         
    " python "     
    if &filetype == 'python'
        call setline(1, "# -*- coding: utf-8 -*-")
    endif

    normal G
    normal o
    normal o
endfunc

autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")                                                                                                                                      
    let c = col(".")
    %s/\s\+$//e     
    call cursor(l, c)
endfun


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""插件相关，需先安装vim-plug
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 没找到vim-plug就先安装，如果执行失败，在shell中直接执行curl以后的安装命令
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" 检查并安装任何缺失的插件
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

" coc-vim补全相关，触发tab自动补全
" Use tab for trigger completion with characters ahead and navigate.
" 注意：先在vim中使用该命令':verbose imap <tab>'检查映射有没有被其他插件占用
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

""""""""""""""""""""插件将下载到指定目录下
call plug#begin('~/.vim/plugged')
" 在这里声明插件
" coc.nvim是补全，需要安装nodejs，需要安装build-essential，需要较新版本vim
" 安装nodejs: 
"         1. curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash
"         2. sudo apt-get install -y nodejs
" 安装build-essential: sudo apt-get install -y build-essential
" 升级vim: 
"         1. sudo add-apt-repository ppa:jonathonf/vim 
"         2. sudo apt update 
"         2. sudo apt install vim 
" 为了最佳补全，要安装相应的插件coc-clangd（需要先安装clangd）
" 安装clang: sudo apt-get install -y clang 
" 安装coc-clangd: vim命令模式下，:CocInstall coc-clangd
" 安装coc-clangd: vim命令模式下，:CocInstall coc-pyright(python3)
" 安装coc-pairs（括号自动配对）: vim命令模式下，:CocInstall coc-pairs
" 参阅https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions
Plug 'neoclide/coc.nvim', {'branch': 'release'}

""""""""""""""""""""列表到此结束。 调用后，插件对Vim可见
call plug#end()
