# require 'spec_helper'
require 'gitreport'

describe 'GitReport::Hook' do

  before :each do
    GitReport::Hook.stub!(:puts)
    @repo    = FakeRepository.new
    GitReport.stub!(:project).and_return(GitReport::Project.new(@repo.path))
    @project = GitReport::Project.new(@repo.path)
    @commit  = GitReport::Commit.new(@project.log.first)
  end

  describe '#set!' do
    it 'should create a proper post-commit hook file if none exists' do
      GitReport::Hook.set!
      hook_file = "#{GitReport.project.path}/.git/hooks/post-commit"
      (File.exists?(hook_file)).should be_true
      content = File.open(hook_file, 'r').read

      content.match(/\nnohup\s\.git\/hooks\/gitreport-post-commit\s>\s\/dev\/null\s2>\s\/dev\/null\s<\s\/dev\/null\s&\n/).should be_true
    end

    it 'should insert the gitreport hook into an existing post-commit hook file' do
      hook_file = "#{GitReport.project.path}/.git/hooks/post-commit"

      File.open(hook_file, 'w+') do |file|
        file.write "# some preexisting hook file\n"
      end

      GitReport::Hook.set!
      content = File.open(hook_file, 'r').read
      content.match(/\nnohup\s\.git\/hooks\/gitreport-post-commit\s>\s\/dev\/null\s2>\s\/dev\/null\s<\s\/dev\/null\s&\n/).should be_true
    end

    it 'should create the custom hook file' do
      custom_hook_file = "#{GitReport.project.path}/.git/hooks/gitreport-post-commit"

      GitReport::Hook.set!

      (File.exists?(custom_hook_file)).should be_true
    end
  end

  describe '#remove!' do
    it 'should remove the post commit hook file completely in case it was not altered by someone else' do
      GitReport::Hook.set!
      hook_file = "#{GitReport.project.path}/.git/hooks/post-commit"
      (File.exists?(hook_file)).should be_true
      GitReport::Hook.remove!

      (File.exists?(hook_file)).should be_false
    end

    it 'should only remove out line from post-commit hook file in case the file was externally altered' do
      hook_file = "#{GitReport.project.path}/.git/hooks/post-commit"

      File.open(hook_file, 'w+') do |file|
        file.write "# some preexisting hook file\n\n"
        file.write "bundle exec gitreport commit &\n"
      end

      GitReport::Hook.remove!

      (File.exists?(hook_file)).should be_true
      content = File.open(hook_file, 'r').read
      content.should match(/\ssome\spreexisting\shook\sfile\n/)
      content.should_not match(/\nnohup\s\.git\/hooks\/gitreport-post-commit\s>\s\/dev\/null\s2>\s\/dev\/null\s<\s\/dev\/null\s&\n/)
    end

    it 'should remove the custom hook file' do
      custom_hook_file = "#{GitReport.project.path}/.git/hooks/post-commit"
      File.open(custom_hook_file, 'w+') do |file|
        file.write "# some existing custom hook file\n"
      end

      GitReport::Hook.remove!

      (File.exists?(custom_hook_file)).should be_true
    end
  end
end

