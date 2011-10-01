module GitReport

  class Supplier

    # returns the commits in relation to the given option
    def self.commits options
      raise "No option given to fetch commits" unless options
      case options
      when :last_and_stored
        last_and_stored_commits
      when :stored
        stored_commits
      when :history
        history_commits :user
        # history_commits :all
      else
        []
      end
    end

    private

    # returns stored commits plus the last commit taken
    def self.last_and_stored_commits
      @@all_commits ||= (stored_commits || []).push(recent_commit)
    end

    # returns the stored commits that could not be send before
    def self.stored_commits
      storage.load
    end

    # returns all commits of the actual user that were taken in the past
    def self.history_commits scope
      @@history_commits ||= GitReport::History.commits(scope)
    end

    # returns the commit that should be send now
    def self.recent_commit
      @@commit_data ||= GitReport::Commit.new(GitReport.project.log.last, GitReport.project.identifier)
    end

    # returns local storage
    def self.storage
      @@storage ||= GitReport::Storage.new(ENV['HOME'], '.gitreport_storage')
    end
  end

end
