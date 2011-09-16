module GitAccount

  class Request

    # sends or saves the commits which are the most recent + stored ones
    def send! options = nil
      commits = all_commits
      commits.each do |commit|
        send_data!(commit) ? commits = commits.inject([]){ |a,i| ( a << i unless i == commit );a } : break # weird, delete fails here
      end
      storage.save! commits

      true
    end

    private

    # sends the data to the server
    def send_data! data, options = nil
      begin
        response = Net::HTTP.Proxy(configuration.proxy_host, configuration.proxy_port).start(configuration.host, configuration.port) do |http|
          request = Net::HTTP::Post.new(request_path options)
          headers request
          request.body = data.to_json
          http.open_timeout = configuration.timeout
          http.read_timeout = configuration.timeout
          http.request request
        end
        raise "Servererror" unless response.code == "200"
      rescue Exception => e
        puts "Servererror or Connectionerror or Servertimeout occured, saving commit data"
        return false
      end

      return true
    end

    # returns all commits that need to be sent
    def all_commits
      @all_commits ||= (stored_commits || []).push(recent_commit)
    end

    # returns the stored commits that could not be send before
    def stored_commits
      storage.load
    end

    # returns the commit that should be send now
    def recent_commit
      @commit_data ||= GitAccount::CommitData.new project
    end

    def project
      @project ||= GitAccount::Project.new
    end

    # returns local storage
    def storage
      @storage ||= GitAccount::Storage.new(ENV['HOME'], '.gitaccount_storage')
    end

    # returns configuration object
    def configuration
      @configuration ||= GitAccount::Configuration.new project
    end

    # returns the request path
    def request_path options
      "/v#{configuration.api_version}/commits"
    end

    # returns the default headers
    def headers request
      request['User-Agent']              = 'gitaccount-client-ruby'
      request['Content-Type']            = 'application/json'
      request['Accept']                  = 'application/json'
      request['X-gitaccount-Auth-Token'] = configuration.auth_token
    end

  end

end
