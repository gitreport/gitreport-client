# require 'spec_helper'
require 'gitreport'

describe 'GitReport::Storage' do

  before :each do
    @tempfile = Tempfile.new('storage')
    @tempdir = File.dirname(@tempfile.path)
    @storage = GitReport::Storage.new(@tempdir, @tempfile)
    class Foo
      attr_accessor :foo, :bar

      def initialize foo, bar
        @foo = foo
        @bar = bar
      end
    end
  end

  describe '#save!' do
    it 'should save the given object to a file' do
      f1 = Foo.new("foo1", "bar1")
      f2 = Foo.new("foo2", "bar2")

      @storage.save! [f1,f2]

      restore = Marshal.load(Base64.decode64(File.read "#{@tempdir}/#{@tempfile}"))

      restore.first.foo.should == f1.foo
      restore.first.bar.should == f1.bar
      restore.last.foo.should  == f2.foo
      restore.last.bar.should  == f2.bar
    end
  end

  describe '#load' do
    it 'should load previously stored objects' do
      f1 = Foo.new("foo1", "bar1")
      f2 = Foo.new("foo2", "bar2")

      @storage.save! [f1,f2]

      restore = @storage.load

      restore.first.foo.should == f1.foo
      restore.first.bar.should == f1.bar
      restore.last.foo.should  == f2.foo
      restore.last.bar.should  == f2.bar
    end
  end

end

