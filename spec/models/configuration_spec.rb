# require 'spec_helper'
require 'gitreport'

describe 'GitReport::Configuration' do

  before :each do
    @repo    = FakeRepository.new
    @repo.create_config_file
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
      pending
      # TODO: this is too late here, project is already initialized
      @repo.create_config_file

      config = GitReport::Configuration.new
      config.host.should == "some.host.anywhere"
    end

    it 'should set the config from the project file even if a user specific file exists'

    it 'should set the config from the user file in case no project config file exists'

    it 'should set the config to default in case no user- and no project config file exists'

  end

end

