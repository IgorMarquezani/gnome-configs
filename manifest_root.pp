package { ['build-essential', 'wget', 'curl', 'tar', 'gpg']:
  ensure => installed,
}

# instalação do ambiente de desktop GNOME
package { 'gnome':
  ensure => installed,
  require => Package['build-essential'],
}

# adicionando o repositório do Google Chrome
exec { 'adicionar_repo_chrome':
  command => '/usr/bin/curl -fSsL https://dl.google.com/linux/linux_signing_key.pub | /usr/bin/gpg --dearmor | /usr/bin/tee /usr/share/keyrings/google-chrome.gpg >> /dev/null && \
    /usr/bin/echo deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main | /usr/bin/tee /etc/apt/sources.list.d/google-chrome.list',
  require => Package['curl', 'gpg'],
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

# Python
# instalação do python e pip
package { ['python3', 'pip']:
  ensure => installed,
  require => Package['build-essential'],
}
# criando link símbolico para o python
exec { 'python-symbolic-link': 
    command => '/usr/bin/ln -s /usr/bin/python3.11 /usr/bin/python',
    require => Package['python3', 'pip'],
}

# Go
# instalação do Go
exec { 'instalar_go':
  command => '/usr/bin/wget -O /tmp/go.tar.gz https://golang.org/dl/go1.22.1.linux-amd64.tar.gz && /usr/bin/tar -C /usr/local -xzf /tmp/go.tar.gz',
  creates => '/usr/local/go',
  require => Package['wget'],
}

# Lua
# instalação do Lua
exec { 'instalar_lua':
  command => '/usr/bin/wget -O /tmp/lua.tar.gz https://www.lua.org/ftp/lua-5.4.6.tar.gz && cd /tmp && sudo /usr/bin/tar -xzf lua.tar.gz && cd lua-5.4.6 && /usr/bin/make linux test && /usr/bin/make install',
  creates => '/usr/local/bin/lua',
  require => Package['wget', 'tar'],
}

package { ['zsh']:
    ensure => installed,
}
