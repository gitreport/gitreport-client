module GitReport

  class BatchSender

    # send the given commits chunked
    def self.send! option = nil
      puts "Collecting your projects commit data - this can take some time, please be patient!"
      batches(option).each_with_index do |batch, index|
        data = batch.map(&:data).to_json
        print "Sending batch #{index + 1} of #{@@num_batches} - #{index*100/@@num_batches}%\r"
        STDOUT.flush
        send_data!(data)
      end
      print "Sending batch #{@@num_batches} of #{@@num_batches} - 100%\r"
      STDOUT.flush
      print "\n"
    end

    private

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

    def self.send_data! data
      return true
    end

  end

end
