require 'spec_helper'
require 'shared_contexts'

describe 'profiles::web' do
  # by default the hiera integration uses hiera data from the shared_contexts.rb file
  # but basically to mock hiera you first need to add a key/value pair
  # to the specific context in the spec/shared_contexts.rb file
  # Note: you can only use a single hiera context per describe/context block
  # rspec-puppet does not allow you to swap out hiera data on a per test block
  #include_context :hiera

  # below is the facts hash that gives you the ability to mock
  # facts on a per describe/context block.  If you use a fact in your
  # manifest you should mock the facts below.
  let(:facts) do
    { :osfamily => 'RedHat',
      :operatingsystem => 'CentOS',
      :operatingsystemmajrelease => '7',
    }

  end

  # below is a list of the resource parameters that you can override.
  # By default all non-required parameters are commented out,
  # while all required parameters will require you to add a value
  let(:params) do
    {
      #:listen_port => "8000",

    }
  end
  # add these two lines in a single test block to enable puppet and hiera debug mode
  # Puppet::Util::Log.level = :debug
  # Puppet::Util::Log.newdestination(:console)

  it do
    is_expected.to contain_file("/var/www")
        .with({
          "ensure" => "directory",
          "owner" => "root",
          "mode" => "0755",
          })
  end

  it do
    is_expected.to contain_file("/var/www/html")
        .with({
          "ensure" => "directory",
          "owner" => "root",
          "mode" => "0755",
          })
  end

  it do
    is_expected.to contain_file("/var/www/html/web1")
        .with({
          "ensure" => "directory",
          "owner" => "root",
          "mode" => "0755",
          })
  end

  it do
    is_expected.to contain_class("nginx")
        .with({
          "require" => "File[/var/www/html/web1]",
          })
  end

  describe :listen_port do
    let(:params) do
      {
        :listen_port => 7000,

      }
    end

    it do
      is_expected.to contain_nginx__resource__vhost("puppet.lab")
          .with({
            "www_root" => "/var/www/html/web1",
            "listen_port" => 7000,
            "require" => "Class[Nginx]",
            })
    end
  end

  it do
    is_expected.to contain_nginx__resource__vhost("puppet.lab")
        .with({
          "www_root" => "/var/www/html/web1",
          "listen_port" => 8000,
          "require" => "Class[Nginx]",
          })
  end

  it do
    is_expected.to contain_file("/var/www/html/web1/index.html")
        .with({
          "mode" => "0644",
          "owner" => "root",
          "group" => "root",
          "checksum" => "Content-MD5",
          "source" => "https://github.com/puppetlabs/exercise-webpage/blob/master/index.html",
          "require" => "File[/var/www/html/web1]",
          })
  end

end
