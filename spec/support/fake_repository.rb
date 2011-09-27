class FakeRepository

  attr_reader :path

  def initialize
    @path = create_fake_repository
  end

  def create_fake_repository
    project_dir = Dir.new(File.dirname(Tempfile.new('fake').path)).path + "/project"
    FileUtils.rm_rf Dir.glob(project_dir)
    FileUtils.rmdir project_dir if File.exists?(project_dir)
    Dir.mkdir(project_dir) unless File.exists?(project_dir)

    # create a project
    # puts "Creating git repo at: #{project_dir}"
    project = Git.init(project_dir)

    # default config for user
    project.config('user.name', 'Duffy Duck')
    project.config('user.email', 'duffy@acme.com')

    # add and commit first file
    File.open("#{project_dir}/file1", 'w+') do |file|
      file.write "file content 1"
    end

    project.add('file1')
    project.commit('initial commit with file1')

    # add and commit second file
    File.open("#{project_dir}/file2", 'w+') do |file|
      file.write "file content 2"
    end

    project.add('file2')
    project.commit('commit with file2')

    # simulate third commit from other user
    project.config('user.name', 'Bugs Bunny')
    project.config('user.email', 'bugs@acme.com')

    File.open("#{project_dir}/file3", 'w+') do |file|
      file.write "file content 2"
    end

    project.add('file3')
    project.commit('commit with file3 from foreigner')

    # change back to user
    project.config('user.name', 'Duffy Duck')
    project.config('user.email', 'duffy@acme.com')

    return project_dir
  end
end
