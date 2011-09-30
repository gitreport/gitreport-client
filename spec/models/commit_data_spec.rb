# require 'spec_helper'
require 'gitreport'

describe 'GitReport::CommitData' do

  before :each do
    @repo    = FakeRepository.new
    GitReport.stub!(:project).and_return(GitReport::Project.new(@repo.path))
    @project = GitReport.project
    @commit  = GitReport::Commit.new(@project.log.last)
  end

  describe '#initialize' do
    it 'should create a CommitData object from last commit if no commit was given' do
      cm = GitReport::CommitData.new

      cm.instance_variable_get(:@commit).message.should == @project.log.last.message
    end

    it 'should create a CommitData object from a given Git::Object::Commit' do
      cm = GitReport::CommitData.new GitReport::Commit.new(@project.log.first)

      cm.instance_variable_get(:@commit).message.should == @project.log.first.message
    end
  end

  describe '#data' do
    it 'should return the commits data in a more consise manner' do
      cm = GitReport::CommitData.new GitReport::Commit.new(@project.log.first)

      cm.data.is_a?(Hash).should be_true
      cm.data.size.should                 == 13
      cm.data[:sha].should                == @project.log.first.sha
      cm.data[:author_name].should        == @project.log.first.author.name
      cm.data[:author_email].should       == @project.log.first.author.email
      cm.data[:remote_branches].should    == @project.remote_branches
      cm.data[:project_identifier].should == @project.identifier
    end
  end

  describe '#to_json' do
    it 'should return the correct json' do
      cm = GitReport::CommitData.new GitReport::Commit.new(@project.log.first)

      json_string = cm.to_json
      json = JSON.parse(json_string)
      json_string.should be_a(String)

      json["sha"].should             == @project.log.first.sha
      json["author_name"].should     == @project.log.first.author.name
      json["author_email"].should    == @project.log.first.author.email
      json["remote_branches"].should == @project.remote_branches
    end
  end

end

