require 'commander/import'

program :name,        'Network Executive'
program :version,     NetworkExecutive::VERSION
program :description, 'An experimental application used to drive displays hung around an office.  '

command :new do |c|
  c.syntax      = 'net_exec new [path]'
  c.description = 'Create a new Network Executive installation.'
  c.action do |args, options|
    require 'network_executive/commands/application'

    NetworkExecutive::Application.new args.first
  end
end

command :server do |c|
  c.syntax      = 'net_exec server'
  c.description = 'Runs the Network Executive server.'
  c.action do |args, options|
    require 'network_executive/commands/server'
    NetworkExecutive::Server.start!
  end
end