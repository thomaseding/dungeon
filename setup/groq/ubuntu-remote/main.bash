# For host: https://apple.stackexchange.com/questions/371997/suppressing-the-default-interactive-shell-is-now-zsh-message-in-macos-catalina
# For host: https://apple.stackexchange.com/questions/191780/how-do-i-configure-my-terminal-app-with-bash-and-iterm2-with-zshell-and-oh-my-zs
# download and install deja vu fonts on host
# install iterm2 and import json profile on host
# for macos host: ~/.bash_profile should source ~/.bashrc
# https://apple.stackexchange.com/questions/214348/how-to-prevent-mac-from-changing-the-order-of-desktops-spaces/214349

# fix git config: name, email, git behaviors
# add vm public rsa key to github

# On host ~/.ssh/config, add:
# SendEnv TMUX_SESSION
# To one of the sections.

# sudo vi /etc/ssh/sshd_config
# Then add anywhere in file: AcceptEnv TMUX_SESSION

cd "$HOME"

sudo apt-get install rubygems
sudo gem install lolcat

ln -s "$HOME/code/dungeon/vim" "$HOME/.vim"
ln -s "$HOME/code/dungeon/vimrc" "$HOME/.vimrc"
ln -s "$HOME/code/dungeon/bashrc" "$HOME/.bashrc"

git config pull.rebase true

build-hs () {
	REPO="$1"
	cd $HOME/code/${REPO}
	mkdir build
	cd src
	ghc --make Main.hs -odir ../build -hidir ../build -o ../build/Main
}

build-hs ansi2prompt
build-hs substr
#build-hs up

# Check /etc/sysctl.conf to see if
#     fs.inotify.max_user_watches = 524288
# is set to that max value first
sudo sysctl -p

# https://apple.stackexchange.com/a/55886/46550
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash


