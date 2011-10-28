module GitReport

  class Sender

    # sends or saves the commits
    def self.send! options = nil
      begin
        commits = GitReport::Supplier.commits(options)
      rescue Exception => e
        communicate e, nil
        exit
      end

      commits.each do |commit|
        send_data!(commit) ? commits = commits.inject([]){ |a,i| ( a << i unless i == commit );a } : break
      end
      storage.save! commits

      true
    end

    private

    # sends the commit data to the server
    def self.send_data! commit, options = nil
      grlog(1, 'send_data started')
      begin
        response = Net::HTTP.Proxy(configuration.proxy_host, configuration.proxy_port).start(configuration.host, configuration.port) do |http|
          request = Net::HTTP::Post.new(request_path options)
          headers request
          request.body = commit.to_json
          http.open_timeout = configuration.timeout
          http.read_timeout = configuration.timeout
          http.request request unless GitReport.global_opts[:dry_run]
        end
        grlog(1, response ? "send_data responded with #{response.code}" : "send_data had no response")
        raise GitReport::ServerError unless (response.code == "201" or response.code == "401") unless GitReport.global_opts[:dry_run]
      rescue Exception => e
        communicate e, response
        return false
      end

      true
    end

    # logs and puts the error according to its conditions and configuration
    # TODO refactor me!
    def self.communicate exception, response
      both, cmd, log = [], [], []
      if exception.is_a?(GitReport::ServerError)
        @error_type = "server error"
        @details = JSON.parse(response.body)["message"] rescue response.body
      else
        @error_type = "client error"
        @details = exception.backtrace
      end
      both << "A #{@error_type} occured during data transfer."
      both << "Exception: #{exception}"
      if GitReport.global_opts[:trace]
        cmd << @details
      else
        cmd << "Run with --trace to get more info."
      end
      log << @details
      puts (both + cmd).join("\n")
      (both + log).each{ |line| grlog(0, "send_data! #{line}")}
    end

    # returns local storage
    def self.storage
      @@storage ||= GitReport::Storage.new(ENV['HOME'], '.gitreport_storage')
    end

    # returns configuration object
    def self.configuration
      @@configuration ||= GitReport.configuration
    end

    # returns the request path
    def self.request_path options
      @@path ||= "/v#{configuration.api_version}/commits"
    end

    # returns the default headers
    def self.headers request
      request['User-Agent']              = 'gitreport-client-ruby'
      request['Content-Type']            = 'application/json'
      request['Accept']                  = 'application/json'
      request['X-gitreport-Auth-Token']  = configuration.auth_token
    end

  end

end
