load 'deploy' if respond_to?(:namespace) # cap2 differentiator
Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }

$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

set :stages, %w(staging production)
set :default_stage, "staging"
set :rvm_type, :user

require 'capistrano/ext/multistage'
require "rvm/capistrano"
