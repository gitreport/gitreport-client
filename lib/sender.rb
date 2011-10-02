module GitReport

  class Sender

    # sends or saves the commits
    def self.send! options = nil
      commits = GitReport::Supplier.commits(options)
      commits.each do |commit|
        send_data!(commit) ? commits = commits.inject([]){ |a,i| ( a << i unless i == commit );a } : break # weird, delete fails here
      end
      storage.save! commits

      true
    end

    private

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
        raise StandardError unless (response.code == "200" or response.code == "401")
      rescue Exception => e
        puts "Error during sending the commit: #{e}"
        return false
      end

      true
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
