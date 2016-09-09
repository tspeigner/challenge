class roles::web {
  class {'profiles::web':
    listen_port => 8000,
  }
}
