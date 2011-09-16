require 'base64'

module GitAccount
  class Storage

    # inits storage object
    def initialize path, filename
      @path = path
      @filename = filename
    end

    # locally stores data
    def save! data
      File.open("#{@path}/#{@filename}", 'w+') do |file|
        file.write Base64.encode64(Marshal.dump(data))
      end
    end

    # loads locally stored data
    def load
      if File.exists?("#{@path}/#{@filename}")
        data = File.read "#{@path}/#{@filename}"
        Marshal.load(Base64.decode64(data)) rescue NameError
      end
    end
  end
end
