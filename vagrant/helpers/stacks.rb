module Stack
  def stacks
    {
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
        'ruby-2.5.1.sh' =>    'unpriv',
        'sidekiq.sh' =>       'unpriv',
        'install-redis.sh' => 'unpriv',
        'config-redis.sh' =>  'priv',
      },

      'web' => {
        'openssl.sh' =>       'unpriv',
        'CA-setup.sh' =>      'unpriv',
        'install-nginx.sh' => 'priv',
      },

      'finish' => {
        #'finalize-setup.sh' => 'unpriv',
        #'start_services.sh' => 'priv',
        'cleanup.sh'        => 'unpriv',
      },

      'ansible' => {
        'install-ansible.sh' => 'unpriv',
      },
    }
  end
end
