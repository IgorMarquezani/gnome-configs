# Rust
# instalação do Rust
exec { 'instalar_rust':
  command => '/usr/bin/curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | /usr/bin/sh -s -- -y',
  require => Package['curl'],
}

# NodeJS
# instalação do nodejs
exec { 'instalar_node':
  command => '/usr/bin/curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | source ~/bashrc && nvm install 20',
}

exec { 'cria_bashrc':
    command => '/usr/bin/touch /home/ixm/.bashrc',
}

exec { 'limpa_.bashrc':
    command => 'echo "" > /home/ixm/.bashrc',
}

exec { 'adicionar_go_ao_PATH':
    command => '/usr/bin/echo "export PATH=/usr/local/go/bin:\$PATH" >> /home/ixm/.bashrc',
}

exec { 'adicionar_rust_ao_PATH':
    command => '/usr/bin/echo "export PATH=/home/ixm/.cargo/bin:\$PATH" >> /home/ixm/.bashrc',
    require => Exec['instalar_rust'],
}
