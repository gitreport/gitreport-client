require 'ostruct'

module GitAccount

  class Project
    attr_accessor :project, :log, :branch

    def initialize path = nil
      path ||= '.'
      @project = Git.open(path)
      @log = GitAccount::Log.new(project)
      @branch = GitAccount::CurrentBranch.new(project)
    end

    # returns the local project directory
    def dir
      @project.dir.path
    end

    # returns the local name of the projected extracted from the project directory
    def name
      return "unknown" unless @project.dir.path.match(/.*\/(.*)$/)
      return $1
    end

    # returns an array of names of all remote branches
    def remotes
      @project.branches.remote.map(&:full)
    end

  end

  class CurrentBranch
    attr_accessor :project, :branch

    def initialize project = nil
      raise "No git repo found" unless project
      @project = project
      @branch = project.branch
    end

    # returns the name of the currently checked out branch
    def name
      @project.branches.select{|b| b.current}.first.full
    end

    # return the remote of this branch if it's tracking any, else nil
    def tracking
      g.config.to_a.select{|ary| ary.first.match(/^branch/)} #TODo
    end
  end

  class Log

    attr_accessor :project, :commits

    def initialize project = nil
      raise 'No git repo found!' unless project
      @project = project
    end

    # returns all the commits of that project
    def commits
      @commits ||= @project.log.entries.sort{ |a, b| a.author.date <=> b.author.date }
    end

    # returns the most recent commit
    def last
      self.commits.last
    end

    # returns the initial commit
    def first
      self.commits.first
    end
  end

  class Commit

    attr_accessor :commit

    def initialize commit = nil
      @commit = commit
    end

    # returns the commit hash of self
    def sha
      self.commit.sha
    end

    # returns the short version of the commit hash of self
    def short_sha
      self.sha[0..6]
    end

    # returns the commit message of self
    def message
      self.commit.message
    end

    # returns the time when self was committed
    def time
      Time.parse(self.commit.author.date.to_s)
    end

    # returns a struct containing author information name and email of that commit
    def author
      author = OpenStruct.new
      author.name = self.commit.author.name
      author.email = self.commit.author.email
      author
    end


    def stats

    end

  end

end
