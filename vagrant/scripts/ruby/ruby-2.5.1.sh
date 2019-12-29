#!/usr/bin/env bash

# Run unprivileged
printf "\n========= Install a ruby ==========================\n"
ver="$(rbenv version 2>&1)"
if [[ $ver != 2.5.1* ]]; then
  rbenv install 2.5.1
  rbenv global 2.5.1
  rbenv rehash
else
  echo "Ruby 2.5.1 already installed."
fi

printf "\n=== Don't install documentation with gem install ==\n"
touch .gemrc
if ! grep -Fxq "gem: --no-document" ~/.gemrc; then
cat <<-TXT >> ~/.gemrc
gem: --no-document
TXT
fi

printf "\n========= Install bundler =========================\n"
gem install bundler

