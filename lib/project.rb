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
      @path ||= @project.dir.path
    end

    # returns the local name of the project extracted from the project directory
    def name
      @name ||= @project.dir.path.match(/.*\/(.*)$/).nil? ? "unknown" : $1
    end

    # returns an array of remote objects of the project
    def remotes
      @remotes ||= @project.remotes
    end

    # returns an array of names of all remote branches
    def remote_branches
      @remote_branches ||= @project.branches.remote.map(&:full)
    end

    # returns the projects first commits hash as an identifier
    def identifier
      @identifier ||= self.revlist.last
    end

    # returns the projects rev-list
    def revlist
      (`git rev-list --all`).split("\n")
    end

  end

end
