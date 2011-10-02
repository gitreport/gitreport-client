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
        # history_commits :user #slow
        history_commits :all    #fast

        # we sort out the foreign commits on the server if the user has a single user account
        # this way we can realize company accounts and already have all the data we need during import
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
    # DO NOT cache here!!
    def self.history_commits scope
      GitReport::History.commits(scope)
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
