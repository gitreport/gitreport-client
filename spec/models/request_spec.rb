# require 'spec_helper'
require 'gitreport'

describe 'GitReport::Request' do

  before :each do
    @repo    = FakeRepository.new
    GitReport.stub!(:project).and_return(GitReport::Project.new(@repo.path))
    @project = GitReport::Project.new(@repo.path)
    @commit  = GitReport::Commit.new(@project.log.first)
  end

  describe '#send!' do
    it 'should send last and stored commits when called with :last_and_stored' do
      # TODO: better stub please
      class DummyStorage
        def self.load
          ["stored_commit"]
        end

        def self.save! options
          true
        end
      end

      GitReport::Request.stub!(:storage).and_return DummyStorage
      GitReport::Request.should_receive(:send_data!).twice.and_return(true)

      GitReport::Request.send! :last_and_stored
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

      GitReport::Request.stub!(:storage).and_return DummyStorage
      GitReport::Request.should_receive(:send_data!).exactly(3).times.and_return(true)

      GitReport::Request.send! :stored
    end

    it 'should send all commits from projects revlist when called with :history' do
      @project.project.branch('new_branch').checkout

      File.open("#{@project.path}/file4", 'w+') do |file|
        file.write "file content 4"
      end

      @project.project.add('file4')
      @project.project.commit('commit with file4 on new_branch')

      @project.project.branch('master').checkout
      GitReport::Request.should_receive(:send_data!).exactly(3).times.and_return(true)

      GitReport::Request.send! :history
    end
  end

end
