win = @

YT_BASE_URL = '//gdata.youtube.com/feeds/api/users/%USER%/uploads/%TAGS%?v=2&alt=json';

# A random sort function
randomizer = -> 0.5 - Math.random()

class @NE.YTPlayer
  constructor : (id, options) ->
    @id      = id
    @videos  = []
    @options = options || {}

    win.addEventListener 'load:program', @onLoad, false

  ready : =>
    @__ready__ = true

    @loadChannel()

  url : ->
    url  = "#{YT_BASE_URL}"
    user = @options.user
    tags = @options.tags

    url = url.replace( '%USER%', user )

    if tags && tags.length > 0
      tags.unshift '-'

      url.replace '%TAGS%', tags.join('/')
    else
      url.replace '%TAGS%', ''

  loadChannel : ->
    return unless @__ready__ and @__loaded__

    xhr = new XMLHttpRequest()
    xhr.addEventListener 'readystatechange', (e) =>
      if xhr.readyState == 4 && xhr.status == 200
        data = JSON.parse( xhr.responseText )

        @onChannelLoaded data

    xhr.open 'GET', @url(), true
    xhr.send()

  onChannelLoaded : (data) ->
    if data.feed.entry
      data.feed.entry.forEach (v) =>
        @videos.push v.media$group.yt$videoid.$t

    @videos.sort randomizer

    @createPlayer()

  createPlayer : ->
    @player = new YT.Player @id,
      playerVars :
        autohide: 1
      events : 
        onReady       : @onPlayerReady,
        onStateChange : @onPlayerStateChange

  onPlayerReady : (e) =>
    @player.setLoop    true
    @player.setShuffle true

    @player.loadPlaylist playlist:@videos

    @player.playVideo()

  onPlayerStateChange : (e) =>
    if e.data == YT.PlayerState.ENDED
      @player.nextVideo()

  onLoad : (e) =>
    @__loaded__ = true

    payload = e.detail.data

    Object.keys(payload).forEach (k) =>
      @options[k] = payload[k]

    @loadChannel()