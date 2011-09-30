module GitReport

  class BatchSender

    # send the given commits chunked
    def self.send! option = nil
      i = 1
      batches(option).each do |batch|
        data = batch.map(&:data).to_json
        puts "sending batch #{i}\n"
        # puts "data: --#{data}--\\n\\n\\n"
        i += 1
      end
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

      batches
    end

  end

end
