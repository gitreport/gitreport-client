module GitReport

  class Project
    attr_accessor :project, :log, :branch

    def initialize path = nil
      path ||= '.'
      @project = Git.open(path)
      @log = GitReport::Log.new(@project)
      @branch = GitReport::CurrentBranch.new(@project)
    end

    # returns the local project directory
    def path
      @project.dir.path
    end

    # returns the local name of the projected extracted from the project directory
    def name
      return "unknown" unless @project.dir.path.match(/.*\/(.*)$/)
      return $1
    end

    # returns an array of remote objects of the project
    def remotes
      @project.remotes
    end

    # returns an array of names of all remote branches
    def remote_branches
      @project.branches.remote.map(&:full)
    end

    # returns the projects rev-list
    def revlist
      (`git rev-list --all`).split("\n")
    end

  end

end
