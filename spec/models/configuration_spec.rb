# require 'spec_helper'
require 'gitreport'

describe 'GitReport::Configuration' do

  before :each do
    @repo    = FakeRepository.new
    GitReport.stub!(:project).and_return(GitReport::Project.new(@repo.path))
    @project = GitReport.project
    @commit  = GitReport::Commit.new(@project.log.last)
  end

  describe '#initialize' do
    it 'should set the correct project' do
      config = GitReport::Configuration.new

      config.instance_variable_get(:@project).should == GitReport.project
    end

    it 'should set the config from a project config file in case one exists' do
      @repo.create_project_config_file

      GitReport.configuration.host.should       == "some.host.anywhere"
      GitReport.configuration.port.should       == 42
      GitReport.configuration.auth_token.should == "12345ab"
      GitReport.configuration.proxy_host.should == "some.proxy.host"
      GitReport.configuration.proxy_port.should == 23
    end

    it 'should set the config from the user file in case no project config file exists' do
      @repo.create_user_config_file

      class TestConfiguration < GitReport::Configuration
        def user_configuration_file
          File.join(@project.path, '.gitreport_user')
        end
      end

      config = TestConfiguration.new

      config.host.should       == "user.host.anywhere"
      config.port.should       == 43
      config.auth_token.should == "xyz987565"
      config.proxy_host.should == "user.proxy.host"
      config.proxy_port.should == 24
    end

    it 'should set the config to default in case no user- and no project config file exists' do

      class TestConfiguration < GitReport::Configuration
        def user_configuration_file
          nil
        end
      end

      config = TestConfiguration.new

      config.host.should       == "api.gitreport.com"
      config.port.should       == 80
      config.auth_token.should == "is_unset_check_your_config"
      config.proxy_host.should be_nil
      config.proxy_port.should be_nil
    end

  end

end

