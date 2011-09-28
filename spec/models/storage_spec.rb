# require 'spec_helper'
require 'gitreport'
# require 'fakefs/spec_helpers'

describe 'GitReport::Storage' do
  # include FakeFS::SpecHelpers

  before :each do
    @repo    = FakeRepository.new
    GitReport.stub!(:project).and_return(GitReport::Project.new(@repo.path))
    @project = GitReport::Project.new(@repo.path)
    @commit  = GitReport::Commit.new(@project.log.first)
    @storage = GitReport::Storage.new('path','filename')
  end

  describe '#save!' do
    it 'should save the given data to a file' do
      pending
      @storage.save!("data")
    end
  end

  describe '#load' do
    it 'should load previously stored data'
  end

end

