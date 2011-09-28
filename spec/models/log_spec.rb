# require 'spec_helper'
require 'gitreport'

describe 'GitReport::Log' do

  before :each do
    @repo    = FakeRepository.new
    GitReport.stub!(:project).and_return(GitReport::Project.new(@repo.path))
    @project = GitReport::Project.new(@repo.path)
    @commit  = GitReport::Commit.new(@project.log.first)
  end

  describe '#commits!' do
    it 'should return an array containing all commits of the currently checked out branch' do
      commits = GitReport::Log.new(GitReport.project.instance_variable_get(:@project)).commits

      commits.should be_a(Array)
      commits.size.should == 3
    end

    it 'should return the commits ordered by commit date' do
      commits = GitReport::Log.new(GitReport.project.instance_variable_get(:@project)).commits

      commits.map(&:message).should == ["commit with file3 from foreigner", "commit with file2", "initial commit with file1"]
    end
  end

  describe '#last!' do
    it 'should return the last commit of the current branch' do
      last = GitReport::Log.new(GitReport.project.instance_variable_get(:@project)).last

      last.should be_a(Git::Object::Commit)
      last.message.should == "initial commit with file1"
    end
  end

  describe '#first!' do
    it 'should return the first commit of the current branch' do
      first = GitReport::Log.new(GitReport.project.instance_variable_get(:@project)).first

      first.should be_a(Git::Object::Commit)
      first.message.should == "commit with file3 from foreigner"
    end
  end

end

