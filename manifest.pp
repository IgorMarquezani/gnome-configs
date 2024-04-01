package { ['build-essential', 'wget', 'curl', 'tar']:
  ensure => installed,
}

# instalação do ambiente de desktop GNOME
package { 'gnome':
  ensure => installed,
  require => Package['build-essential'],
}

# criação do usuário ixm com a senha 123456
user { 'ixm':
  ensure     => present,
  password   => '$6$Lt9Zkd9e$kxqPKw5Qd5zN8OHDfQGklA3I9j70d4G8B6Ev7It6AzQjmtwbBuKYnhKC1J5mFtGkb9c67w1VJbJfFWWvRNE9v0', # senha: 123456
  managehome => true,
}

# adicionando o repositório do Google Chrome
exec { 'adicionar_repo_chrome':
  command => '/usr/bin/wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list',
  require => Package['wget'],
}

# instalação do Chrome
package { 'google-chrome-stable':
  ensure => installed,
  require => Exec['adicionar_repo_chrome'],
}

# instalação do Alacritty
package { 'alacritty':
  ensure => installed,
  require => Package['build-essential'],
}

# instalação do python e pip
package { ['python3', 'pip']:
  ensure => installed,
  require => Package['build-essential'],
}

# instalação do Rust
exec { 'instalar_rust':
  command => '/usr/bin/curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | /usr/bin/sh',
  creates => '/home/ixm/.cargo', 
  require => Package['curl'],
}

# instalação do Go
exec { 'instalar_go':
  command => '/usr/bin/wget -O /tmp/go.tar.gz https://golang.org/dl/go1.22.1.linux-amd64.tar.gz && /usr/bin/tar -C /usr/local -xzf /tmp/go.tar.gz',
  creates => '/usr/local/go',
  require => Package['wget'],
}

# instalação do nodejs
exec { 'instalar_node':
  command => '/usr/bin/curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | /usr/bin/mkdir /usr/local/nvm && NVM_DIR=/usr/local/nvm bash && source ./bashrc && nvm install 20',
  require => Package['curl'],
}

# instalação do Lua
exec { 'instalar_lua':
  command => '/usr/bin/wget -O /tmp/lua.tar.gz https://www.lua.org/ftp/lua-5.4.6.tar.gz && cd /tmp && sudo /usr/bin/tar -xzf lua.tar.gz && cd lua-5.4.6 && /usr/bin/make linux test && /usr/bin/make install',
  creates => '/usr/local/bin/lua',
  require => Package['wget', 'tar'],
}
