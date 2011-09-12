module GitAccount
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
end
