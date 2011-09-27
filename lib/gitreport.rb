require 'git'
require 'json'
require 'net/http'
require 'time'
require 'ostruct'
require 'project'
require 'current_branch'
require 'log'
require 'commit'
require 'history'
require 'configuration'
require 'commit_data'
require 'request'
require 'storage'
require 'hook'

module GitReport

  # mattr_reader
  def self.project
    @@project ||= GitReport::Project.new
  end

end
