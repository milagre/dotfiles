cd ~
mkdir -p ~/.vim/autoload ~/.vim/bundle; \
    curl -Sso ~/.vim/autoload/pathogen.vim \
    https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim
git submodule update --init
git submodule sync --recursive

if type npm > /dev/null; then
    npm install -g eslint
else
    echo "NPM is not install. Please install to enable eslint."
fi
