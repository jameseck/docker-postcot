require 'serverspec'
require "docker"

describe "Dockerfile" do
  before(:all) do
    #image = Docker::Image.build_from_dir('.')
    image = Docker::Image.get(ENV['IMAGE'])

    set :backend, :docker
    set :docker_image, image.id
  end

  it "installs the right version of CentOS" do
    expect(os_version).to match(/^CentOS Linux release 7/)
  end

  describe process('supervisord') do
    it { should be_running }
  end

  describe command('sleep 2s # to let services start') do
    its(:stdout) { should match /^$/ }
  end

  describe process('postfix') do
    it { should be_running }
  end
  describe process('dovecot') do
    it { should be_running }
  end

  def os_version
    command("cat /etc/redhat-release").stdout
  end
end
