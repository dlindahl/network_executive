#= require ./network_executive/components/namespace
#= require ./network_executive/components/osd
#= require ./network_executive/components/set_top_box
#= require ./network_executive/components/postman

paths   = @location.pathname.split '/'
channel = paths[ paths.length - 1]

new NE.SetTopBox( channel )