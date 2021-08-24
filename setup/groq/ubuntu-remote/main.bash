# download and install deja vu fonts
# install iterm2 and import json profile
# fix git config: name, email, git behaviors
# add vm public rsa key to github

cd "$HOME"

sudo apt-get install rubygems
sudo gem install lolcat

ln -s "$HOME/code/dungeon/vim" "$HOME/.vim"
ln -s "$HOME/code/dungeon/vimrc" "$HOME/.vimrc"
ln -s "$HOME/code/dungeon/bashrc" "$HOME/.bashrc"

build-hs () {
	REPO="$1"
	cd $HOME/code/${REPO}
	mkdir build
	cd src
	ghc --make Main.hs -odir ../build -hidir ../build -o ../build/Main
}

build-hs ansi2prompt
build-hs substr


