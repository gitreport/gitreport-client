module GitReport
  class GitConfiguration

    # returns the current users name from git config
    def self.user_name
      @@username ||= GitReport.project.project.config('user.name')
    end

    # returns the current users email from git config
    def self.user_email
      @@useremail ||= GitReport.project.project.config('user.email')
    end
  end
end
