DUNGEON=$HOME/code/dungeon
SRC=$DUNGEON/setup/groq/macbook/files

bash $DUNGEON/setup/github-repos.bash

ln -s $DUNGEON $HOME/dungeon
ln -s $SRC $HOME/dungeon-home

link () {
	ln -s "$SRC/$1" "$HOME/$1"
}

link .bashrc
link .inputrc
link .vimrc

rm $HOME/.bash_profile
ln -s $HOME/.bashrc $HOME/.bash_profile

brew install fortune
brew install lolcat

