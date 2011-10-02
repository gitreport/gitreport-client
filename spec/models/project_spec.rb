# require 'spec_helper'
require 'gitreport'

describe 'GitReport::Project' do

  before :each do
    @repo    = FakeRepository.new
    GitReport.stub!(:project).and_return(GitReport::Project.new(@repo.path))
    @project = GitReport::Project.new(@repo.path)
    @commit  = GitReport::Commit.new(@project.log.first)
  end

  describe '#path!' do
    it 'should return the projects path' do
      GitReport.project.path.should == @repo.path
    end
  end

  describe '#name' do
    it 'should return the projects name' do
      GitReport.project.name.should == "project"
    end
  end

  describe '#remotes' do

    it 'should return the projects remotes' do
      GitReport.project.project.add_remote("remote1", "http://www.remote1.url/project.git")
      GitReport.project.project.add_remote("remote2", "http://www.remote2.url/project.git")
      remotes = GitReport.project.remotes

      remotes.should be_a(Array)
      remotes.size.should       == 2
      remotes.first.name.should == "remote1"
      remotes.last.name.should  == "remote2"
    end
  end

  describe '#remote_branches' do

  end

  describe '#revlist' do
    it 'should return the projects revlist' do
      @project.project.branch('new_branch').checkout

      File.open("#{@project.path}/file4", 'w+') do |file|
        file.write "file content 4"
      end

      @project.project.add('file4')
      @project.project.commit('commit with file4 on new_branch')

      @project.project.branch('master').checkout

      revlist = GitReport.project.revlist

      revlist.should be_a(Array)
      revlist.size.should == 4
      revlist.each do |rev|
        rev.length.should == 40
      end
    end
  end

  describe '#identifier' do
    it 'should return the projects first commits sha' do
      GitReport.project.identifier == @project.log.commits.first.sha
    end
  end

  describe '#branchname' do
    it 'should return the branch name' do
      GitReport.project.branchname.should == "master"
    end
  end

  describe '#data' do
    it 'should return the projects core data as a hash' do
      data = GitReport.project.data
      data.should be_a(Hash)
      data.size.should == 6
      data[:project_path].should    == GitReport.project.path
      data[:project_name].should    == GitReport.project.name
      data[:current_branch].should  == GitReport.project.branchname
      data[:remotes].should         == GitReport.project.remotes.map(&:name)
      data[:remote_urls].should     == GitReport.project.remotes.map(&:url)
      data[:remote_branches].should == GitReport.project.remote_branches
    end
  end

end

