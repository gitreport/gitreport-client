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

    # returns the branch name
    def branchname
      @branchname ||= self.branch.name
    end

    # returns projects core data as a hash for transfer of a commit batch
    def data
      @data ||= aggregate
    end

    private

    # aggregates the projects core data
    def aggregate
      data = {}
      data[:project_path]       = self.path
      data[:project_name]       = self.name
      data[:current_branch]     = self.branchname
      data[:remotes]            = self.remotes.map(&:name)
      data[:remote_urls]        = self.remotes.map(&:url)
      data[:remote_branches]    = self.remote_branches
      data[:project_identifier] = self.identifier
      data
    end

  end

end
