# require 'spec_helper'
require 'gitreport'

describe 'GitReport::CurrentBranch' do

  before :each do
    @repo    = FakeRepository.new
    @project = GitReport::Project.new(@repo.path)
    @commit  = GitReport::Commit.new(@project.log.first)
  end

  describe '#name' do
    it 'should return the name of the currently checked out branch' do
      @project.instance_variable_get(:@branch).name.should == "master"

      @project.project.branch('new_branch').checkout
      @project.instance_variable_get(:@branch).name.should == "new_branch"
    end
  end

end

