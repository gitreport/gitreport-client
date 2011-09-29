# require 'spec_helper'
require 'gitreport'

describe 'GitReport' do

  before :each do
    @repo    = FakeRepository.new
    GitReport.stub!(:project).and_return(GitReport::Project.new(@repo.path))
    @project = GitReport.project
    @commit  = GitReport::Commit.new(@project.log.last)
  end

  describe '#activate' do
    
  end

  describe '#deactivate' do
    
  end

  describe '#commit' do
    
  end

  describe '#sync' do
    
  end

  describe '#history' do
    
  end

end

