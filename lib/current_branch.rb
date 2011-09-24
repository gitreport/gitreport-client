module GitReport
  class CurrentBranch
    attr_accessor :project, :branch

    def initialize project = nil
      raise "No git repo found" unless project
      @project = project
      @branch = project.branch
    end

    # returns the name of the currently checked out branch
    def name
      @project.branches.select{|b| b.current}.first.full rescue alt_name
    end

    # return the remote of this branch if it's tracking any, else nil
    def tracking
      g.config.to_a.select{|ary| ary.first.match(/^branch/)} #TODo
    end

    private

    # alternative method to return the current branches name
    def alt_name
      name = `git branch`.split("\n").select{|b| b.match(/^\*/)}.first.match(/^\*(.*)$/)
      return $1.strip
    end
  end
end
