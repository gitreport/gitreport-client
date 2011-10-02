# require 'spec_helper'
require 'gitreport'

describe 'GitReport::History' do

  before :each do
    @repo    = FakeRepository.new
    GitReport.stub!(:project).and_return(GitReport::Project.new(@repo.path))
    @project = GitReport::Project.new(@repo.path)
    @commit  = GitReport::Commit.new(@project.log.first)
  end

  describe '#commits' do
    it 'should return the users commits if called with scope = :user' do
      commits = GitReport::History.commits(:user)

      commits.size.should                     == 2
      commits.first.data[:author_name].should == "Duffy Duck"
      commits.last.data[:author_name].should  == "Duffy Duck"
    end

    it 'should return all commits if called with any scope but :user' do
      commits = GitReport::History.commits(:all)

      commits.size.should                  == 3
      commits[0].data[:author_name].should == "Bugs Bunny"
      commits[1].data[:author_name].should == "Duffy Duck"
      commits[2].data[:author_name].should == "Duffy Duck"
    end

    it 'should return commits that are not part of the currently checked out branch' do
      @project.project.branch('new_branch').checkout

      File.open("#{@project.path}/file4", 'w+') do |file|
        file.write "file content 4"
      end

      @project.project.add('file4')
      @project.project.commit('commit with file4 on new_branch')

      @project.project.branch('master').checkout

      commits = GitReport::History.commits(:all)
      commits.size.should == 4
    end

  end

end

