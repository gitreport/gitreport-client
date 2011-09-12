module GitAccount

  class Request

    # initializes self with the given event
    def initialize
      @project = GitAccount::Project.new
    end

    # sends the data to the server
    def send! options = nil
      response = Net::HTTP.Proxy(configuration.proxy_host, configuration.proxy_port).start(configuration.host, configuration.port) do |http|
        request = Net::HTTP::Post.new(request_path options)
        headers request
        request.body = commit_data.to_json
        http.request request
      end
      raise "Error #{response.code} occured, #{response.message}!" unless response.code == "200"

      true
    end

    private

    # returns configuration object
    def configuration
      @configuration ||= GitAccount::Configuration.new @project
    end

    # returns the data that should be committet
    def commit_data
      @commit_data ||= GitAccount::CommitData.new @project
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
