# require 'spec_helper'
require 'gitreport'

describe 'GitReport::Sender' do

  before :each do
    @repo    = FakeRepository.new
    GitReport.stub!(:project).and_return(GitReport::Project.new(@repo.path))
    @project = GitReport::Project.new(@repo.path)
    @commit  = GitReport::Commit.new(@project.log.first)
    # TODO: better stub please
    class DummyStorage
      def self.load
        ["stored_commit"]
      end

      def self.save! options
        true
      end
    end
  end

  describe '#send!' do
    it 'should send last and stored commits when called with :last_and_stored' do
      GitReport::Supplier.stub!(:storage).and_return DummyStorage
      GitReport::Sender.should_receive(:send_data!).twice.and_return(true)

      GitReport::Sender.send! :last_and_stored
    end

    it 'should send stored commits when called with :stored' do
      class DummyStorage
        def self.load
          ["stored_commit1", "stored_commit2", "stored_commit3"]
        end

        def self.save! options
          true
        end
      end

      GitReport::Supplier.stub!(:storage).and_return DummyStorage
      GitReport::Sender.should_receive(:send_data!).exactly(3).times.and_return(true)

      GitReport::Sender.send! :stored
    end

    it 'should send all commits (including foreign ones) from projects revlist when called with :history' do
      @project.project.branch('new_branch').checkout

      File.open("#{@project.path}/file4", 'w+') do |file|
        file.write "file content 4"
      end

      @project.project.add('file4')
      @project.project.commit('commit with file4 on new_branch')

      @project.project.branch('master').checkout
      GitReport::Sender.should_receive(:send_data!).exactly(4).times.and_return(true)

      GitReport::Sender.send! :history
    end

    it 'should send a single commit to the server if no stored ones are available' do
      GitReport::Supplier.send(:class_variable_set, :@@all_commits, nil)
      GitReport::Supplier.stub!(:stored_commits).and_return(nil)

      GitReport::Sender.should_receive(:send_data!).once.and_return(true)
      GitReport::Sender.send! :last_and_stored
    end

    it 'should send two commits to the server if two commits are in the pipe' do
      GitReport::Supplier.send(:class_variable_set, :@@all_commits, nil)
      GitReport::Supplier.stub!(:stored_commits).and_return(["stored_commit"])

      GitReport::Sender.should_receive(:send_data!).twice.and_return(true)
      GitReport::Sender.send! :last_and_stored
    end

    it 'should store the recent commit in case of a connection error' do
      stub_request(:post, "http://api.gitreport.com/v1/commits").to_raise(Errno::ECONNREFUSED.new)
      GitReport::Sender.stub!(:puts)
      GitReport::Supplier.send(:class_variable_set, :@@all_commits, nil)
      GitReport::Supplier.stub!(:recent_commit).and_return("recent_commit")
      GitReport::Sender.stub!(:storage).and_return(@storage = Class.new)

      @storage.should_receive(:save!).with(["recent_commit"]).once
      GitReport::Sender.send! :last_and_stored
    end

    it 'should store one commit in case of a server timeout' do
      stub_request(:post, "http://api.gitreport.com/v1/commits").to_timeout
      GitReport::Sender.stub!(:puts)
      GitReport::Supplier.send(:class_variable_set, :@@all_commits, nil)
      GitReport::Supplier.stub!(:recent_commit).and_return("recent_commit")
      GitReport::Sender.stub!(:storage).and_return(@storage = Class.new)

      @storage.should_receive(:save!).with(["recent_commit"]).once
      GitReport::Sender.send! :last_and_stored
    end

    it 'should store one commit in case of a response other than 200' do
      stub_request(:post, "http://api.gitreport.com/v1/commits").to_raise(StandardError.new("some error"))
      GitReport::Sender.stub!(:puts)
      GitReport::Supplier.send(:class_variable_set, :@@all_commits, nil)
      GitReport::Supplier.stub!(:recent_commit).and_return("recent_commit")
      GitReport::Sender.stub!(:storage).and_return(@storage = Class.new)

      @storage.should_receive(:save!).with(["recent_commit"]).once
      GitReport::Sender.send! :last_and_stored
    end

    it 'should store recent and stored commit in case of a connection error' do
      stub_request(:post, "http://api.gitreport.com/v1/commits").to_raise(Errno::ECONNREFUSED.new)
      GitReport::Sender.stub!(:puts)
      GitReport::Supplier.send(:class_variable_set, :@@all_commits, nil)
      GitReport::Supplier.stub!(:recent_commit).and_return("recent_commit")
      GitReport::Supplier.stub!(:stored_commits).and_return(["stored_commit"])
      GitReport::Sender.stub!(:storage).and_return(@storage = Class.new)

      @storage.should_receive(:save!).with(["stored_commit","recent_commit"]).once
      GitReport::Sender.send! :last_and_stored
    end

    it 'should store recent and stored commit in case of a server timeout' do
      stub_request(:post, "http://api.gitreport.com/v1/commits").to_timeout
      GitReport::Sender.stub!(:puts)
      GitReport::Supplier.send(:class_variable_set, :@@all_commits, nil)
      GitReport::Supplier.stub!(:recent_commit).and_return("recent_commit")
      GitReport::Supplier.stub!(:stored_commits).and_return(["stored_commit"])
      GitReport::Sender.stub!(:storage).and_return(@storage = Class.new)

      @storage.should_receive(:save!).with(["stored_commit","recent_commit"]).once
      GitReport::Sender.send! :last_and_stored
    end

    it 'should store recent and stored commit in case of a response other than 200' do
      stub_request(:post, "http://api.gitreport.com/v1/commits").to_raise(StandardError.new("some error"))
      GitReport::Sender.stub!(:puts)
      GitReport::Supplier.send(:class_variable_set, :@@all_commits, nil)
      GitReport::Supplier.stub!(:recent_commit).and_return("recent_commit")
      GitReport::Supplier.stub!(:stored_commits).and_return(["stored_commit"])
      GitReport::Sender.stub!(:storage).and_return(@storage = Class.new)

      @storage.should_receive(:save!).with(["stored_commit","recent_commit"]).once
      GitReport::Sender.send! :last_and_stored
    end

  end

end
