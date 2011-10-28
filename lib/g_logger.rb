module GitReport

  class GLogger

    # logs the given message in case the given level is less or equal the configured log level
    def self.log level, message
      File.open(
        GitReport.configuration.logfile,
        File::WRONLY|File::APPEND|File::CREAT
      ){ |f| f.write(message + "\n") } if level <= GitReport.configuration.loglevel
    end

    # provides method grlog in every class
    class << self.superclass
      def grlog level, message
        ::GitReport::GLogger.log level, Time.now.to_s + " - " + self.to_s + " #" + message
      end
    end

  end


end
