# Vim config
mkdir -p ~/.vim/tmp
mkdir -p ~/.vim/bundle
[ ! -d ~/.vim/bundle/Vundle.vim ] && git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
cd ~/.vim/bundle/Vundle.vim
git pull
cd -
