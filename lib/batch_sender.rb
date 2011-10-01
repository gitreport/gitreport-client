module GitReport

  class BatchSender

    # send the given commits chunked
    def self.send! option = nil
      puts "Collecting your projects commit data - this can take some time, please be patient!"
      batches(option).each_with_index do |batch, index|
        print "Sending batch #{index + 1} of #{@@num_batches} - #{index*100/@@num_batches}%\r"
        STDOUT.flush
        break unless send_data!(batch)
      end
      print "Sending batch #{@@num_batches} of #{@@num_batches} - 100%\r"
      STDOUT.flush
      print "\n"
    end

    private

    # returns batches of commits with the batchsize taken from configuration
    def self.batches option
      raise "Nothing to create batches from" unless option
      commits = GitReport::Supplier.commits(option)
      batchsize = GitReport.configuration.batchsize

      batches = []
      divider = commits.size.divmod(batchsize).first

      1.upto(divider+1) do |n|
        batches << commits[(n-1)*batchsize..n*batchsize-1]
      end

      @@num_batches = batches.size
      batches
    end

    # sends the commit batch data to the server
    def self.send_data! batch, options = nil
      begin
        response = Net::HTTP.Proxy(configuration.proxy_host, configuration.proxy_port).start(configuration.host, configuration.port) do |http|
          request = Net::HTTP::Post.new(request_path options)
          headers request
          request.body = batch.map(&:data).to_json
          http.open_timeout = configuration.timeout
          http.read_timeout = configuration.timeout
          http.request request
        end
        raise StandardError unless (response.code == "200" or response.code == "401")
      rescue Exception => e
        puts "Error during sending the commit batch: #{e}"
        return false
      end

      true
    end

    # returns configuration object
    def self.configuration
      @@configuration ||= GitReport.configuration
    end

    # returns the request path
    def self.request_path options
      @@path ||= "/v#{configuration.api_version}/commit_batches"
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
