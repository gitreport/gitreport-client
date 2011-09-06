require 'ostruct'

module GitAccount

  class Project
    attr_accessor :log

    def initialize path = nil
      path ||= '.'
      @log = GitAccount::Log.new(path)
    end

  end

  class Log

    attr_accessor :project, :commits

    def initialize path = nil
      path ||= '.'
      @project = Git.open(path)
    end

    def commits
      @commits ||= @project.log.entries.sort{ |a, b| a.author.date <=> b.author.date }
    end

    def last
      self.commits.last
    end

    def first
      self.commits.first
    end
  end

  class Commit

    attr_accessor :commit

    def initialize commit = nil
      @commit = commit
    end

    def sha
      self.commit.sha
    end

    def short_sha
      self.sha[0..6]
    end

    def message
      self.commit.message
    end

    def time
      Time.parse(self.commit.author.date.to_s)
    end

    def author
      author = OpenStruct.new
      author.name = self.commit.author.name
      author.email = self.commit.author.email
      author
    end

    def local_branch_name

    end

    def remote_branch_names

    end

    def stats

    end

    def project_dir

    end

    def project_name

    end

    def local_path

    end

  end

end
