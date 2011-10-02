# require 'spec_helper'
require 'gitreport'

describe 'GitReport::GitConfiguration' do

  before :each do
    @repo    = FakeRepository.new
    GitReport.stub!(:project).and_return(GitReport::Project.new(@repo.path))
    @project = GitReport::Project.new(@repo.path)
    @commit  = GitReport::Commit.new(@project.log.first)
  end

  describe '#user_name' do
    it 'should return the users name from gitconfig' do
      GitReport::GitConfiguration.user_name.should == "Duffy Duck"
    end
  end

  describe '#user_email' do
    it 'should return the users email from gitconfig' do
      GitReport::GitConfiguration.user_email.should == "duffy@acme.com"
    end
  end

end

