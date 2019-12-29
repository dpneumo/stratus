#!/usr/bin/env bash
SRC='/vagrant/client_files'

# Run unprivileged
printf "\n========= Install ruby build environment ==========\n"
sudo yum install -y bzip2 openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel sqlite-devel

printf "\n========= Install rbenv ===========================\n"
# Install rbenv
if [[ ! -f ~/.rbenv/libexec/rbenv ]] ; then
  git clone https://github.com/rbenv/rbenv.git ~/.rbenv
  cd ~/.rbenv && src/configure && make -C src
  # Install ruby-build as an rbenv plugin
  mkdir -p plugins
  cd plugins
  rm -Rf ~/.rbenv/plugins/ruby-build
  git clone https://github.com/rbenv/ruby-build.git ruby-build
  cd ~/
else
  echo "rbenv is already installed."
fi

# Setup vagrant user to have access to rbenv on login
if ! grep -Fxq "# rbenv" ~/.bash_profile; then
cat <<-TXT >> ~/.bash_profile
# rbenv
export PATH="~/.rbenv/bin:\$PATH"
eval "\$(rbenv init -)"
TXT
fi
source ~/.bash_profile

