require "benchmark"
module GitReport
  class History

    # returns the histories commits depending on the scope :user or :all
    def self.commits scope = :user
      case scope
      when :user
        self.user_commits
      else
        self.all_commits
      end
    end

    private

    # returns all commits of this project wrapped into CommitData objects
    def self.all_commits
      all_commits_raw.map{ |co| GitReport::CommitData.new(GitReport::Commit.new co) }
    end

    # returns only the users commits of this project wrapped into CommitData objects
    # TODO: horrable performance
    def self.user_commits
      user_commits_raw.map{ |co| GitReport::CommitData.new(GitReport::Commit.new co) }
    end

    # returns all commits of this project
    def self.all_commits_raw
      GitReport.project.revlist.inject([]){ |commits, rev| commits.push(GitReport.project.project.gcommit(rev)); commits }
    end

    # returns only the users commits of this project
    def self.user_commits_raw
      all_commits_raw.delete_if{ |co| co.author.name != GitReport::GitConfiguration.user_name }
    end

  end
end
