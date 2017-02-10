#/bin/bash

echo "Making a backup of ~/.vimrc at ~/.vimrc.old"
if [ -e ~/.vimrc.old ]
then
    echo '~/.vimrc.old exists already. Exiting so as to not make changes that can'"'"'t be reversed.'
    exit 1
else
    cp ~/.vimrc ~/.vimrc.old
fi

if [ -e .vimrc ]
then
    cp .vimrc ~/.vimrc
else
    echo 'Missing the base .vimrc file to copy.'
    exit 1
fi

if [ ! -d ~/.vim ]
then
    mkdir ~/.vim
fi


echo "Do you want to install solarized? (y/n) Defaults to no."
read input
solarized=false

case $input in
    [yY] | [yY][eE][sS] )
        wget -q https://raw.github.com/seebi/dircolors-solarized/master/dircolors.256dark

        mv dircolors.256dark ~/.dircolors
        eval `dircolors ~/.dircolors`

        echo 'Cloning vim-colors-solarized'
        git clone -q git://github.com/altercation/vim-colors-solarized.git vim-colors-solarized
        if [ ! -d ~/.vim/colors ]
        then
            mkdir ~/.vim/colors
        fi
        mv vim-colors-solarized/colors/solarized.vim ~/.vim/colors
        rm -rf vim-colors-solarized

        echo 'Cloning gnome solarized terminal colors'
        git clone -q  https://github.com/sigurdga/gnome-terminal-colors-solarized.git gnome-terminal-colors-solarized
        cd gnome-terminal-colors-solarized
        ./install.sh
        cd ../
        rm -rf gnome-terminal-colors-solarized
        ;;
    *)
        echo '~/.vimrc may need to be edited to remove references to solarized.'
        ;;
esac

echo 'Cloning menlo for powerline font and adding to system in ~/.fonts directory'
git clone -q https://github.com/abertsch/Menlo-for-Powerline.git powerline
if [ ! -d ~/.fonts ]
then
    mkdir ~/.fonts
fi
cp powerline/*.ttf ~/.fonts
rm -rf powerline
fc-cache -vf ~/.fonts

if [ ! -d ~/.vim/bundle/Vundle.vim ]
then
    echo 'Cloning Vundle into ~/.vim/bundle/Vundle.vim'
    git clone -q https://github.com/gmarik/Vundle.vim ~/.vim/bundle/Vundle.vim
fi

if [ ! -d ~/.vim/bundle/Vundle.vim ]
then
    echo 'Cloning vim-fugitive into ~/.vim/bundle'
    git clone -q https://github.com/tpope/vim-fugitive.git ~/.vim/bundle
fi

sudo apt-get install exuberant-ctags

echo 'Installing vim plugins'
vim +PluginInstall +qall

source ~/.bashrc

echo ''
echo 'After setup, check to see if ~/.bashrc contains the following. If not, add.'
echo 'if [ -x /usr/bin/dircolors ]; then'
echo '  test -r ~/.dircolors && eval \"$(dircolors -b ~/.dircolors)\" || eval \"$(dircolors -b)\"'
echo 'fi'
echo 'Finally, set the font for the terminal profile to "Powerline" and uncomment "force_color_prompt" in .bashrc'
