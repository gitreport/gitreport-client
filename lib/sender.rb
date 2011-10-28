module GitReport

  class Sender < GenericSender

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

    # returns the request path
    def self.request_path options
      @@path ||= "/v#{configuration.api_version}/commits"
    end

  end

end
