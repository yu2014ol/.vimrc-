set nocompatible                " 关闭兼容Vi,避免不必要的麻烦
set autoread                    " 硬盘文件变化后，自动读取 "
set encoding=utf-8              
set termencoding=utf-8
set ruler                       " 显示光标位置 "
set showcmd                     " 命令模式下，在底部显示键入指令 " 
set showmode                    " 显示当前模式 "
set number                      " 显示绝对行数 "
set mouse=a                     " 启用鼠标 "
set selection=exclusive         " 启用鼠标 "
set selectmode=mouse,key        " 启用鼠标 "
set clipboard=unnamed           " 使用p就能粘贴从外部程序复制的文本(将匿名寄存器和系统剪贴板关联起来) "
set ignorecase                  " 搜索忽略大小写 "
set completeopt=preview,menu    " 代码补全 "
set completeopt=longest,menu    " 打开文件类型检测, 加了这句才可以用智能补全 "
set incsearch                   " 激活增量查找 "

syntax on                       " 语法高亮 "
set t_Co=256                    " 支持 256 色模式 "
set langmenu=zn_CN.UTF-8        " 设置语言 "
set helplang=cn                

set foldenable                  
set foldmethod=syntax           " 启用语法折叠 "

set shiftwidth=4
set shiftround                  " 缩进列数对齐到 shiftwidth 值的整数倍
set smartindent                 " 智能缩进
set tabstop=4
" set expandtab                 " Makefile不能用空格替换tab，故注释掉该行

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
"         2. sudo apt install -y nodejs
" 安装build-essential: sudo apt-get install -y build-essential
" 升级vim: 
"         1. sudo add-apt-repository ppa:jonathonf/vim 
"         2. sudo apt update 
"         3. sudo apt upgrade 
"         4. sudo apt install vim 
" 为了最佳补全，要安装相应的插件coc-clangd（需要先安装clangd）
" 安装clang: 
"         1. sudo apt install clangd-10
"         1. sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-10 100
" 安装coc-clangd: vim命令模式下，:CocInstall coc-clangd
" 安装coc-clangd: vim命令模式下，:CocInstall coc-pyright(python3)
" 参阅https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'jiangmiao/auto-pairs'
""""""""""""""""""""列表到此结束。 调用后，插件对Vim可见
call plug#end()
