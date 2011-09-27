module GitReport
  class CommitData

    def initialize(commit = nil)
      @data = {}
      @project = GitReport.project
      @commit = commit || GitReport::Commit.new(@project.log.last)
      set_data
    end

    def data
      @data
    end

    def to_json
      data.to_json
    end

    private

    def set_data
      @data[:sha]             = @commit.sha
      @data[:short_sha]       = @commit.short_sha
      @data[:author_name]     = @commit.author.name
      @data[:author_email]    = @commit.author.email
      @data[:time]            = @commit.time.xmlschema
      @data[:message]         = @commit.message
      @data[:project_path]    = @project.path
      @data[:project_name]    = @project.name
      @data[:current_branch]  = @project.branch.name
      @data[:remotes]         = @project.remotes.map(&:name)
      @data[:remote_urls]     = @project.remotes.map(&:url)
      @data[:remote_branches] = @project.remote_branches
    end
  end

end
