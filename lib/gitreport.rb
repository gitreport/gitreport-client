require 'g_logger'
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
require 'git_configuration'
require 'generic_sender'
require 'sender'
require 'batch_sender'
require 'storage'
require 'hook'
require 'supplier'

module GitReport

  @@global_opts ||= nil

  class ServerError < StandardError;end

  # mattr_reader
  def self.project
    @@project ||= GitReport::Project.new
  end

  def self.configuration
    @@config ||= GitReport::Configuration.new
  end

  def self.global_opts= options={}
    @@global_opts = options
  end

  def self.global_opts
    @@global_opts || {}
  end

end
