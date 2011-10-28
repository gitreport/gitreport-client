module GitReport

  class BatchSender < GenericSender

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
      grlog(1, 'send_data started')
      begin
        response = Net::HTTP.Proxy(configuration.proxy_host, configuration.proxy_port).start(configuration.host, configuration.port) do |http|
          request = Net::HTTP::Post.new(request_path options)
          headers request
          request.body = body(batch)
          http.open_timeout = configuration.timeout
          http.read_timeout = configuration.timeout
          http.request request unless GitReport.global_opts[:dry_run]
        end
        grlog(1, response ? "send_data responded with #{response.code}" : "send_data had no response")
        raise GitReport::ServerError unless (response.code == "200" or response.code == "401") unless GitReport.global_opts[:dry_run]
      rescue Exception => e
        communicate e, response
        exit
      end

      true
    end

    # returns the body as an aggregate of author, project and commit data
    def self.body batch
      {
        :commits => batch.map(&:batch_data),
        :author  =>  GitReport::GitConfiguration.user_name,
        :project => GitReport.project.data
      }.to_json
    end

    # returns the request path
    def self.request_path options
      @@path ||= "/v#{configuration.api_version}/projects"
    end

  end

end
