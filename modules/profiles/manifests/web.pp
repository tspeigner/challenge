class profiles::web(
  #User has to specify a port (Integer) between 4000-8000,
  #but for this challenge it needs to be 8000, so it is.
  Integer[4000,8000] $listen_port = '8000'
  )
  {

    #Create directory : /var/www/html/web1
    #See https://docs.puppetlabs.com/puppet/latest/reference/type.html#file for information
    file{['/var/www','/var/www/html','/var/www/html/web1']:
      ensure =>      'directory',
      owner  =>      'root',
      mode   =>      '0755',
  }


######################Configure Nginx by Community Module#####################

#Include Nginx and add a virtual host

   class {'nginx':
     require => File['/var/www/html/web1'],
  }



  #Install Virtual Hosts
    nginx::resource::vhost { 'puppet.lab':
    www_root    =>      '/var/www/html/web1',
    listen_port =>      $listen_port,
    #require     =>      Class['nginx'],
 }

# add a notify to the file resource
#After looking at this article I decided to use "Content-MD5" instead of "mtime"
#there is a potential issue that could lead to the file not being updated because of
#change, but instead of using "mtime" it seemed better to start basic.
#Source requires Puppet 4.4+
#http://ffrank.github.io/features/2016/02/06/using-http-files/

    file { '/var/www/html/web1/index.html':
      mode     => '0644',
      owner    => 'root',
      group    => 'root',
      checksum => 'md5',
      source   => 'https://raw.githubusercontent.com/puppetlabs/exercise-webpage/master/index.html',
      require  => File['/var/www/html/web1'],
  }
}
