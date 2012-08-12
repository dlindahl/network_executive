require 'commander/import'

program :name,        'Network Executive'
program :version,     NetworkExecutive::VERSION
program :description, 'An experimental application used to drive displays hung around an office.  '

command :new do |c|
  c.syntax      = 'net_exec new [path]'
  c.description = 'Create a new Network Executive installation.'
  c.action do |args, options|
    path = args.first

    puts "Make new app in #{path}!"
  end
end

command :start do |c|
  c.syntax      = 'net_exec start'
  c.description = 'Runs the Network Executive server.'
  c.action do |args, options|
    puts 'Start all the things!'
  end
end