require 'gitreport'

describe 'GitReport::Commit' do

  before :each do
    @repo    = FakeRepository.new
    @project = GitReport::Project.new(@repo.path)
    @commit  = GitReport::Commit.new(@project.log.first)
  end

  describe '#sha' do
    it 'should return the sha of a commit' do
      @commit.sha.should == @project.log.first.sha
    end
  end

  describe '#short_sha' do
    it 'should return the shortened sha' do
      @commit.short_sha.should == @project.log.first.sha[0..6]
    end
  end

  describe '#message' do
    it 'should return the commits message' do
      @commit.message.should == @project.log.first.message
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
      @commit.author.name.should  == "Bugs Bunny"
      @commit.author.email.should == "bugs@acme.com"
    end
  end

  describe '#stats' do
    it 'should return the commit stats'
  end

end

