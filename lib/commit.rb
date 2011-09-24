module GitReport
  class Commit

    attr_accessor :commit

    def initialize commit = nil
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

    end

  end
end
