require 'json'
require 'hashie'
require 'fileutils'

module Scaler
  def self.relative_path(path)
    File.join(File.dirname(File.expand_path(__FILE__)), path)
  end

  config_path =  File.expand_path("config.rb")
  load config_path if File.exists?(config_path)
  load Scaler.relative_path("default_config.rb")
  Settings ||= Hashie::Mash.new(DefaultConfig).merge!(OverwriteConfig || {})
end

require "scaler/version"
require 'scaler/ec2'
require 'scaler/launcher'
require 'thor'
require 'scaler/cli'
