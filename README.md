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
