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
cd '/c/Program Files/Oracle/VirtualBox'
VBoxManage.exe list bridgedifs | grep ^Name
```

```
# In Windows PowerShell:
cd "C:\Program Files\Oracle\VirtualBox"
.\VBoxManage.exe list bridgedifs | Select-String -Pattern "^Name:*"
```

redis-cli info:  redis.io/topics/rediscli
redis setup Gist: gist.github.com/dpneumo/74a184eb67922492230fcb65786f199b


# To reset the Centos 7 CA cert store see this article:
https://access.redhat.com/solutions/1549003

Run the commands as root: Use sudo su.

# To insert certs into Centos 7 trusted certs store:

copy your certificates inside

/etc/pki/ca-trust/source/anchors/

then run the following command

update-ca-trust

