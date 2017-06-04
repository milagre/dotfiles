has_bin() {
    if command -v $1 >/dev/null; then
        return 0
    fi

    return 1
}

configure_deps() {
    if [ is_mac ]; then
        if ! has_bin 'brew'; then
            /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        fi

        if ! has_bin 'node'; then
            brew install node
        fi
    fi
}

configure_git() {
    if [ ! -e ~/.ssh/id_github ]; then
        echo 'Install ~/.ssh/id_github first'
        exit
    fi

    eval `ssh-agent -s`
    ssh-add ~/.ssh/id_github
}

configure_npm_packages() {
    echo 'sudo npm install -g ...'
    sudo npm install -g eslint omnivore-io/eslint-config.git gulp prettyjson
}

configure_vim() {
    mkdir -p ~/.vim/tmp
    mkdir -p ~/.vim/bundle
    mkdir -p ~/.vim/colors
    install_vim_vundle
    vim +PluginInstall +qall
    install_vim_ycm
}

install_vim_vundle() {
    [ ! -d ~/.vim/bundle/Vundle.vim ] && git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    cd ~/.vim/bundle/Vundle.vim
    git pull
    cd -
}

install_vim_ycm() {
    ## see https://github.com/Valloric/YouCompleteMe#full-installation-guide
    # Uncomment this business if you need C-family auto-completion
    #if ! command -v cmake >/dev/null; then
    #    if is_mac; then
    #        brew install cmake
    #    else
    #        sudo apt-get install cmake
    #    fi
    #fi
    #mkdir /tmp/ycm_build
    #cd /tmp/ycm_build
    #cmake -G "Unix Makefiles" . ~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp

    # JavaScript
    ~/.vim/bundle/YouCompleteMe/install.py  --tern-completer
    cd ~
}

configure_deps
configure_git
configure_npm_packages
configure_vim
