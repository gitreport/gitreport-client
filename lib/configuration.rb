require 'yaml'
module GitReport
  class Configuration

    def initialize
      @project = GitReport.project
      read_configuration or set_default_configuration
    end

    # sets the given configuration
    def set_configuration config_data
      default_configuration.merge!(config_data).each_pair do |key, value|
        self.class.send(:attr_accessor, key)
        self.send(:"#{key}=", value)
      end
    end

    private

    # reads project- or user configuration and sets it
    def read_configuration
      begin
        if project_configuration_file_exists?
          set_configuration YAML.load_file(project_configuration_file)
        else
          set_configuration YAML.load_file(user_configuration_file)
        end
      rescue
        return false
      end
    end

    # returns the default configuration
    def default_configuration
      {
        "host"        => "api.gitreport.com",
        "port"        => 80,
        "proxy_host"  => nil,
        "proxy_port"  => nil,
        "auth_token"  => "is_unset_check_your_config",
        "api_version" => 1,
        "timeout"     => 3,
        "batchsize"   => 6
      }
    end

    # sets the default configuration
    def set_default_configuration
      set_configuration default_configuration
    end

    # returns true if a config file exists for the recent project
    def project_configuration_file_exists?
      File.exists? project_configuration_file
    end

    # returns the project configuration file in case there is any
    def project_configuration_file
      File.join(@project.path, '.gitreport')
    end

    # returns the users configuration file in case there is any
    def user_configuration_file
      File.join(ENV['HOME'], '.gitreport')
    end

  end
end
