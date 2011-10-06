# require 'spec_helper'
require 'gitreport'

describe 'GitReport::Commit' do

  before :each do
    @repo    = FakeRepository.new
    GitReport.stub!(:project).and_return(GitReport::Project.new(@repo.path))
    @project = GitReport::Project.new(@repo.path)
    @commit  = GitReport::Commit.new(@project.log.last, @project.identifier)
  end

  describe '#sha' do
    it 'should return the sha of a commit' do
      @commit.sha.should == @project.log.last.sha
    end
  end

  describe '#short_sha' do
    it 'should return the shortened sha' do
      @commit.short_sha.should == @project.log.last.sha[0..6]
    end
  end

  describe '#message' do
    it 'should return the commits message' do
      @commit.message.should == @project.log.last.message
    end
  end

  describe '#time' do
    it 'should return the commit time' do
      @commit.time.should_not be_nil
      @commit.time.is_a?(Time).should be_true
    end
  end

  describe '#author' do
    it 'should return the correct author' do
      @commit.author.name.should  == "Duffy Duck"
      @commit.author.email.should == "duffy@acme.com"
    end
  end

  describe '#stats' do
    it 'should return the commit stats' do
      stats = GitReport::Commit.new(@project.log.commits.first, @project.identifier).stats
      stats[:deletions].should  == 1
      stats[:files].should      == 1
      stats[:lines].should      == 1
      stats[:insertions].should == 0
    end
  end

  describe '#project_identifier' do
    it 'should equal the projects first commits sha' do
      @commit.project_identifier.should == @project.revlist.last
    end
  end

  describe '#data' do
    it 'should return the data to be transferred during a single commit including project data' do
      data = @commit.data
      data.size.should == 14
      [:project_path, :project_name, :current_branch, :remotes, :remote_urls, :remote_branches].each do |attr|
        data.keys.include?(attr).should be_true
      end
    end
  end

  describe '#batch_data' do
    it 'should return the data to be transferred during a batch import without project data' do
      data = @commit.batch_data
      data.size.should == 8
      [:project_path, :current_branch, :remotes, :remote_urls, :remote_branches].each do |attr|
        data.keys.include?(attr).should be_false
      end
    end
  end

  describe '#to_json' do
    it 'should return the full commit data including project data as JSON' do
      json_string = @commit.to_json
      data = JSON.parse(json_string)

      data.each_pair do |key, value|
        @commit.data[key.to_sym].should == value
      end
    end
  end

end

