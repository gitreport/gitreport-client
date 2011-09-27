module GitReport

  class Request

    # sends or saves the commits
    def self.send! options = nil
      commits = all_commits(options)
      commits.each do |commit|
        send_data!(commit) ? commits = commits.inject([]){ |a,i| ( a << i unless i == commit );a } : break # weird, delete fails here
      end
      storage.save! commits

      true
    end

    private

    # returns the commits in relation to the given option
    def self.all_commits options
      raise "No option given to fetch commits" unless options
      case options
      when :last_and_stored
        last_and_stored_commits
      when :stored
        stored_commits
      when :history
        history_commits
      else
        []
      end
    end

    # sends the commit data to the server
    def self.send_data! commit, options = nil
      begin
        response = Net::HTTP.Proxy(configuration.proxy_host, configuration.proxy_port).start(configuration.host, configuration.port) do |http|
          request = Net::HTTP::Post.new(request_path options)
          headers request
          request.body = commit.to_json
          http.open_timeout = configuration.timeout
          http.read_timeout = configuration.timeout
          http.request request
        end
        raise StandardError unless response.code == "200"
      rescue Exception => e
        return false
      end

      true
    end

    # returns stored commits plus the last commit taken
    def self.last_and_stored_commits
      @@all_commits ||= (stored_commits || []).push(recent_commit)
    end

    # returns the stored commits that could not be send before
    def self.stored_commits
      storage.load
    end

    # returns all commits of the actual user that were taken in the past
    def self.history_commits
      []
    end

    # returns the commit that should be send now
    def self.recent_commit
      @@commit_data ||= GitReport::CommitData.new project
    end

    def self.project
      @@project ||= GitReport::Project.new
    end

    # returns local storage
    def self.storage
      @@storage ||= GitReport::Storage.new(ENV['HOME'], '.gitreport_storage')
    end

    # returns configuration object
    def self.configuration
      @@configuration ||= GitReport::Configuration.new project
    end

    # returns the request path
    def self.request_path options
      "/v#{configuration.api_version}/commits"
    end

    # returns the default headers
    def self.headers request
      request['User-Agent']              = 'gitreport-client-ruby'
      request['Content-Type']            = 'application/json'
      request['Accept']                  = 'application/json'
      request['X-gitreport-Auth-Token'] = configuration.auth_token
    end

  end

end
