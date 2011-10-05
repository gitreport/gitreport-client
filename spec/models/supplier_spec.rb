# require 'spec_helper'
require 'gitreport'

describe 'GitReport::Supplier' do

  before :each do
    @repo    = FakeRepository.new
    GitReport.stub!(:project).and_return(GitReport::Project.new(@repo.path))
    @project = GitReport::Project.new(@repo.path)
    @commit  = GitReport::Commit.new(@project.log.first)
  end

  describe '#commits!' do

    it 'should return last and stored commits if called with :last_and_stored' do
      GitReport::Supplier.send(:class_variable_set, :@@all_commits, nil)
      GitReport::Supplier.stub!(:stored_commits).and_return([GitReport::Commit.new(@project.log.commits.first)])
      commits = GitReport::Supplier.commits(:last_and_stored)

      commits.count.should == 2
      commits.map(&:sha).include?(@project.log.commits.first.sha)
      commits.map(&:sha).include?(@project.log.commits.last.sha)
    end

    it 'should return stored commits if called with :stored' do
      GitReport::Supplier.stub!(:stored_commits).and_return([GitReport::Commit.new(@project.log.commits.first)])
      commits = GitReport::Supplier.commits(:stored)

      commits.count.should == 1
      commits.map(&:sha).include?(@project.log.commits.first.sha)
    end

    it 'should return the whole history if called with history' do
      commits = GitReport::Supplier.commits(:history)

      commits.count.should == 3
      commits.each do |commit|
        @project.revlist.include?(commit.sha).should be_true
      end
    end

  end

end

