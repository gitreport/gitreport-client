module GitReport
  class GitConfiguration

    # returns the current users name from git config
    def self.user_name
      GitReport.project.project.config('user.name')
    end

    # returns the current users email from git config
    def self.user_email
      GitReport.project.project.config('user_email')
    end
  end
end
