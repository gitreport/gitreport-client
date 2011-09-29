class FakeRepository

  attr_reader :path
  attr_writer :project_dir

  def initialize
    @path = create_fake_repository
  end

  def create_fake_repository
    @project_dir = Dir.new(File.dirname(Tempfile.new('fake').path)).path + "/project"
    FileUtils.rm_rf Dir.glob(@project_dir)
    FileUtils.rmdir @project_dir if File.exists?(@project_dir)
    Dir.mkdir(@project_dir) unless File.exists?(@project_dir)

    # create a project
    # puts "Creating git repo at: #{@project_dir}"
    project = Git.init(@project_dir)

    # default config for user
    project.config('user.name', 'Duffy Duck')
    project.config('user.email', 'duffy@acme.com')

    # add and commit first file
    File.open("#{@project_dir}/file1", 'w+') do |file|
      file.write "file content 1"
    end

    project.add('file1')
    project.commit('initial commit with file1')

    # add and commit second file
    File.open("#{@project_dir}/file2", 'w+') do |file|
      file.write "file content 2"
    end

    project.add('file2')
    project.commit('commit with file2')

    # simulate third commit from other user
    project.config('user.name', 'Bugs Bunny')
    project.config('user.email', 'bugs@acme.com')

    File.open("#{@project_dir}/file3", 'w+') do |file|
      file.write "file content 2"
    end

    project.add('file3')
    project.commit('commit with file3 from foreigner')

    # change back to user
    project.config('user.name', 'Duffy Duck')
    project.config('user.email', 'duffy@acme.com')

    return @project_dir
  end

  def create_project_config_file
    File.open("#{@project_dir}/.gitreport", 'w+') do |file|
      file.write "---\n"
      file.write "auth_token: 12345ab\n"
      file.write "host: some.host.anywhere\n"
      file.write "port: 42\n"
      file.write "proxy_host: some.proxy.host\n"
      file.write "proxy_port: 23\n"
      file.write "api_version: 2\n"
      file.write "timeout: 66\n"
    end
  end

  def create_user_config_file
    File.open("#{@project_dir}/.gitreport_user", 'w+') do |file|
      file.write "---\n"
      file.write "auth_token: xyz987565\n"
      file.write "host: user.host.anywhere\n"
      file.write "port: 43\n"
      file.write "proxy_host: user.proxy.host\n"
      file.write "proxy_port: 24\n"
      file.write "api_version: 3\n"
      file.write "timeout: 77\n"
    end
  end
end
