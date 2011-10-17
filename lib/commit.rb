module GitReport

  class Commit

    attr_accessor :commit, :project_identifier

    def initialize commit = nil, project_identifier = nil
      @project            = GitReport.project
      @commit             = commit
      @project_identifier = project_identifier
    end

    # returns the commit hash of self
    def sha
      @commit.sha
    end

    # returns the short version of the commit hash of self
    def short_sha
      self.sha[0..6]
    end

    # returns the commit message of self
    def message
      @commit.message
    end

    # returns the time when self was committed
    def time
      Time.parse(inner_author.date.to_s)
    end

    # returns a chached struct containing author information name and email of that commit
    def author
      @author ||= get_author
    end

    # returns the author struct fr the first time
    def get_author
      author = OpenStruct.new
      author.name = inner_author.name
      author.email = inner_author.email
      author
    end

    # returns commits stats in more detail
    def stats
      @commit.diff(@commit.parent).stats[:total]
    rescue
      nil
    end

    # return the commits aggregated data in case a single commit is transferred
    def data
      @data ||= aggregate(:single)
    end

    def batch_data
      @data ||= aggregate(:batch)
    end

    # return the commits aggregated data as JSON
    def to_json
      data.to_json
    end

    private

    # aggregates all the data that needs to be transfered to the server
    def aggregate scope
      # TODO fucking slow
      data = {}
      data[:sha]                = self.sha
      data[:short_sha]          = self.short_sha
      data[:author_name]        = self.author.name
      data[:author_email]       = self.author.email
      data[:time]               = self.time.xmlschema
      data[:message]            = self.message
      data[:stats]              = self.stats
      if scope == :single
        data[:project_path]       = @project.path
        data[:project_name]       = @project.name
        data[:current_branch]     = @project.branchname
        data[:remotes]            = @project.remotes.map(&:name)
        data[:remote_urls]        = @project.remotes.map(&:url)
        data[:remote_branches]    = @project.remote_branches
        data[:project_identifier] = self.project_identifier
      end
      data
    end

    # returns the cached author object from the embedded original git object
    def inner_author
      @commit.author
    end
  end

end
