require 'commander/import'

program :name,        'Network Executive'
program :version,     NetworkExecutive::VERSION
program :description, 'An experimental application used to drive displays hung around an office.  '

command :new do |c|
  c.syntax      = 'net_exec new [path]'
  c.description = 'Create a new Network Executive installation.'

  c.action do |args, options|
    require 'network_executive/commands/application'

    NetworkExecutive::Application.new( args.first ).build_app
  end
end

command :server do |c|
  c.syntax      = 'net_exec server'
  c.description = 'Runs the Network Executive server.'

  c.option '-e ENVIRONMENT', String,  'Specifies the environment to run this server under (test/development/production).'
  c.option '-p PORT',        Integer, 'Runs Network Executive on the specified port. Default: 9000'

  c.action do |args, options|
    require 'network_executive/commands/server'

    ARGV.shift

    NetworkExecutive::Server.start!
  end
end