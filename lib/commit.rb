module GitReport

  class Commit

    attr_accessor :commit

    def initialize commit = nil
      @project = GitReport.project
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

    # returns commits stats in more detail
    def stats
      # TODO
    end

    # return the commits aggregated data
    def data
      @data ||= aggregate
    end

    # return the commits aggregated data as JSON
    def to_json
      data.to_json
    end

    private

    def aggregate
      data = {}
      data[:sha]                = self.sha
      data[:short_sha]          = self.short_sha
      data[:author_name]        = self.author.name
      data[:author_email]       = self.author.email
      data[:time]               = self.time.xmlschema
      data[:message]            = self.message
      data[:project_path]       = @project.path
      data[:project_name]       = @project.name
      data[:current_branch]     = @project.branch.name
      data[:remotes]            = @project.remotes.map(&:name)
      data[:remote_urls]        = @project.remotes.map(&:url)
      data[:remote_branches]    = @project.remote_branches
      data[:project_identifier] = @project.identifier
      data
    end

  end

end
