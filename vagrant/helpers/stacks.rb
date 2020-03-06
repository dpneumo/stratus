module Stack
  def stacks
    {
      'env' => {
        'build-env.sh' =>         'unpriv',
        'build-env-priv.sh' =>    'priv',
      },

      'base' => {
        'update-box.sh' =>        'priv',
        'development-tools.sh' => 'priv',
        'no-rpcbind.sh' =>        'priv',
        'iptables.sh' =>          'priv',
        'install-fail2ban.sh' =>  'priv',
        'config-postfix.sh' =>    'priv',
        'config-ssh.sh' =>        'priv',
      },

      'ruby' => {
        'git.sh' =>           'unpriv',
        'rbenv.sh' =>         'unpriv',
        'ruby-2.6.3.sh' =>    'unpriv',
        'sidekiq.sh' =>       'unpriv',
        'install-redis.sh' => 'unpriv',
        'config-redis.sh' =>  'priv',
      },

      'web' => {
        'openssl.sh' =>       'unpriv',
        'CA-setup.sh' =>      'unpriv',
        'install-nginx.sh' => 'priv',
      },

      'rails' => {
        'rails.sh' =>         'unpriv',
      },

      'demo_app' => {
        'demo_app.sh' =>      'unpriv',
      },

      'finish' => {
        'finalize-setup.sh' => 'unpriv',
        'start-services.sh' => 'priv',
        'cleanup.sh'        => 'unpriv',
      },

      'ansible' => {
        'install-ansible.sh' => 'unpriv',
      },
    }
  end
end

