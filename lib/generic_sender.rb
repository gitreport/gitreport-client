class GenericSender

  # logs and puts the error according to its conditions and configuration
  # TODO refactor me!
  def self.communicate exception, response
    both, cmd, log = [], [], []
    if exception.is_a?(GitReport::ServerError)
      @error_type = "server error"
      message = JSON.parse(response.body)["message"] rescue response.body
      error = JSON.parse(response.body)["error"] rescue nil
      @details = message ? "#{message} - #{error}" : error
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

  # returns the default headers
  def self.headers request
    request['User-Agent']              = 'gitreport-client-ruby'
    request['Content-Type']            = 'application/json'
    request['Accept']                  = 'application/json'
    request['X-gitreport-Auth-Token']  = configuration.auth_token
  end

end
