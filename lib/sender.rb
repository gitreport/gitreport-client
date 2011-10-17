module GitReport

  class Sender

    # sends or saves the commits
    def self.send! options = nil
      begin
        commits = GitReport::Supplier.commits(options)
      rescue Exception => e
        puts "A client error occured during data transfer."
        if GitReport.global_opts[:trace]
          puts "Exception: #{e}\n"
          e.backtrace.each do |line|
            puts "#{line}\n"
          end
        else
          puts "Run with --trace to get more info."
        end
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
      begin
        response = Net::HTTP.Proxy(configuration.proxy_host, configuration.proxy_port).start(configuration.host, configuration.port) do |http|
          request = Net::HTTP::Post.new(request_path options)
          headers request
          request.body = commit.to_json
          http.open_timeout = configuration.timeout
          http.read_timeout = configuration.timeout
          http.request request unless GitReport.global_opts[:dry_run]
        end
        raise GitReport::ServerError unless (response.code == "201" or response.code == "401") unless GitReport.global_opts[:dry_run]
      rescue Exception => e
        if e.is_a?(GitReport::ServerError)
          puts "A server error occured during data transfer."
          if GitReport.global_opts[:trace]
            puts "Exception: #{e}\n"
            puts "Message: #{JSON.parse(response.body)["message"]}\n"
          else
            puts "Run with --trace to get more info."
          end
        else
          puts "A client error occured during data transfer."
          puts "Exception: #{e}\n"
        end

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
