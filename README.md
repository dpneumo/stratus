# stratus

After vagrant up completes:

vagrant ssh

Then:

RUBY_CONFIGURE_OPTS=--disable-install-doc rbenv install 2.5.0
rbenv global 2.5.0


echo 'gem: --no-document' >> ~/.gemrc
gem install rails
gem install bundler

cd ~/cirrus
bundle install

bundle exec rails db:migrate
bundle exec rails db:migrate RAILS_ENV=test

bundle exec rails test

bundle exec rails server


# to get host adaptor names for use in Vagrantfile:
```
# In unix-like terminal (eg MINGW64):
/c/Program Files/Oracle/VirtualBox
VBoxManage.exe list bridgedifs | grep ^Name
```

```
# In Windows PowerShell:
cd C:\Program Files\Oracle\VirtualBox
.\VBoxManage.exe list bridgedifs | Select-String -Pattern "^Name:*"
```
