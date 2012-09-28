#= require ./components/namespace
#= require ./components/postman
#= require ./components/you_tube_player

@onYouTubeIframeAPIReady = =>
  # Listen for the parent's callback message
  @addEventListener 'iframeReadyCallback', (e) ->
    new NE.YTPlayer 'player', e.detail.data

  origin = @location.origin
  msg    = JSON.stringify({ event:'iframeReady' })

  # Tell the parent that we are ready
  @parent.postMessage msg, origin