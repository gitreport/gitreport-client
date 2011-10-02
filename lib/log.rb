module GitReport
  class Log

    attr_accessor :project, :commits

    def initialize project = nil
      raise 'No git repo found!' unless project
      @project = project
    end

    # returns all the commits of that project of the currently checked out branch
    def commits
      @commits ||= @project.log.entries.sort{ |a, b| a.author.date <=> b.author.date }
    end

    # returns the most recent commit
    def last
      @@last ||= self.commits.last
    end

    # returns the initial commit
    def first
      @@first ||= self.commits.first
    end
  end
end
