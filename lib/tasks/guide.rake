require 'terminal-table'

desc 'Generate a Channel Guide (options: start=14:00 stop="Oct 10, 2013 14:30")'
namespace :network_executive do
  task :guide => :environment do
    format = '%H:%M'

    start = Time.parse( ENV['start'] ) if ENV['start']
    stop  = Time.parse( ENV['stop'] )  if ENV['stop']

    guide = NetworkExecutive::Guide.new start, stop

    start_time = guide.start_time.strftime( '%B %-e, %Y between %H:%M' )
    stop_time = guide.stop_time.strftime( '%H:%M' )

    puts "\n\n"
    puts "Channel Guide for #{start_time} and #{stop_time}"
    puts "\n"

    guide[:channels].each do |ch|
      puts ch[:channel].to_s.titleize

      table = Terminal::Table.new do |t|
        ch[:programs].each do |prog|
          start    = prog.occurrence.start_time.strftime( format )
          end_time = prog.occurrence.end_time.strftime( format )

          t << [ "#{start} - #{end_time}", prog.display_name ]
        end
      end

      puts table
      puts "\n"
    end

  end
end