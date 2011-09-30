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
    it 'should return last and stored commits if called with :last_and_stored'
    it 'should return stored commits if called with :stored'
    it 'should return the whole history if called with history'
  end

end

