require 'commander/import'

program :name,        'Network Executive'
program :version,     NetworkExecutive::VERSION
program :description, 'An experimental application used to drive displays hung around an office.'
program :help,        'Author', 'Derek Lindahl <github.com/dlindahl>'

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

  # Goliath Options
  c.option '-e', '--environment ENVIRONMENT', 'Specifies the environment to run this server under (test/development/production).'
  c.option '-p', '--port PORT', Integer,      'Runs Network Executive on the specified port. Default: 9000'
  c.option '-d', '--daemonize',               'Run daemonized in the background (default: off)'
  c.option '-P', '--pid FILE',                'PID file (default: off)'

  # Goliath SSL options
  c.option '--ssl',                           'Enables SSL (default: off)'
  c.option '--ssl-key FILE',                  'Path to private key'
  c.option '--ssl-cert FILE',                 'Path to certificate'
  c.option '--ssl-verify',                    'Enables SSL certificate verification'


  c.action do |args, options|
    require 'network_executive'
    require 'network_executive/commands/server'

    ARGV.shift

    log_file = File.join( NetworkExecutive.root, 'log', "#{NetworkExecutive.env}.log" )

    options.default \
      environment: NetworkExecutive.env,
      stdout:      true,
      log:         log_file

    # Pass on the NetworkExecutive options to the Goliath Runner
    options.__hash__.each do |k,v|
      ARGV << "--#{k}"
      ARGV << v if v
    end

    NetworkExecutive::Server.start!
  end
end