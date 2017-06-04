if [ ! -e ~/.ssh/id_github ]; then
    echo 'Install ~/.ssh/id_github first'
    exit
fi

eval `ssh-agent -s`
ssh-add ~/.ssh/id_github

# Global npm packages
echo 'sudo npm install -g ...'
sudo npm install -g eslint omnivore-io/eslint-config.git gulp prettyjson

# Vim config
mkdir -p ~/.vim/tmp
mkdir -p ~/.vim/bundle
[ ! -d ~/.vim/bundle/Vundle.vim ] && git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
cd ~/.vim/bundle/Vundle.vim
git pull
cd -
