# require 'spec_helper'
require 'gitreport'

describe 'GitReport::BatchSender' do

  before :each do
    @repo    = FakeRepository.new
    GitReport.stub!(:project).and_return(GitReport::Project.new(@repo.path))
    @project = GitReport::Project.new(@repo.path)
    @commit  = GitReport::Commit.new(@project.log.first)
  end

  describe '#body!' do
    it 'should return a Hash containing author, project and commit data separated' do
      json_string = GitReport::BatchSender.body(GitReport::BatchSender.batches(:history).first)
      json_string.should be_a(String)

      data = JSON.parse(json_string)
      data.size.should == 3
      [:author, :project, :commits].each do |key|
        data.keys.include?(key.to_s).should be_true
      end
      data["author"].should == GitReport::GitConfiguration.user_name
      data["commits"].size.should == 3
      data["commits"].collect{ |c| c["sha"] }.each do |sha|
        GitReport.project.revlist.include?(sha).should be_true
      end
      data["project"].size.should == 7
      data["project"]["project_name"].should == GitReport.project.name
    end

    it 'should not raise an error in case of the word commit at the start of a commit message' do
      @repo.create_error_commit1

      lambda{ body = GitReport::BatchSender.body(GitReport::BatchSender.batches(:history).first) }.should_not raise_error
    end

  end

  describe '#batches' do
    it 'should create batches in relation to batchsize from configuration' do
      GitReport.configuration.stub!(:batchsize).and_return(2)
      batches = GitReport::BatchSender.batches(:history)
      batches.size.should       == 2
      batches.first.size.should == 2
      batches.last.size.should  == 1
    end
  end

end
