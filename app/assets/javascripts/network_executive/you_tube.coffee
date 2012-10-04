#= require ./components/namespace
#= require ./components/iframe_notifier
#= require ./components/postman
#= require ./components/you_tube_player

player = new NE.YTPlayer( 'player' )

@onYouTubeIframeAPIReady = player.ready