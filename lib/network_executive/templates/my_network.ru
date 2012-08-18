# This file is used by Rack-based servers to start the application.
require ::File.expand_path('../config/<%= name %>',  __FILE__)

run <%= name.to_s.camelize %>