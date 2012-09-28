win = @

class @NE.SetTopBox
  constructor : (channel) ->
    @smpte    = document.getElementById( 'smpte' )
    @smpteMsg = document.getElementById( 'smpte_message' )
    @program  = document.getElementById( 'program' )

    if @channel = channel
      @establishUplink()
    else
      @setSmpteMessage 'No signal'

  setSmpteMessage : (msg) ->
    @smpteMsg.innerHTML = msg

  showSmpte : ->
    # Move this functionality to a class for better cross-browser support
    @smpte.style.display = '-webkit-box'

  hideSmpte : ->
    @smpte.style.display = 'none'

  establishUplink : ->
    @uplink = new EventSource( "tune_in/#{@channel}" )

    @uplink.addEventListener 'open',    @onUplinkUp,    false
    @uplink.addEventListener 'message', @onUplinkMessage, false
    @uplink.addEventListener 'error',   @onUplinkDown,   false

  goTo : (url) ->
    @program.setAttribute 'src', url

  onUplinkUp : (e) =>
    @setSmpteMessage 'Awaiting transmission...'

  onUplinkDown : (e) =>
    if e.eventPhase == EventSource.CLOSED
      @setSmpteMessage 'Transmission lost...'

      @goTo 'about:blank'

      @showSmpte()

  parseEvent : (e) ->
    try
      payload = JSON.parse( e.data )
    catch e
      payload = {}

    payload.onReady   ?= {}
    payload.redraw     = not payload.live_feed
    payload.newProgram = payload.live_feed and payload.url != @program.getAttribute( 'src' )

    payload

  onUplinkMessage : (e) =>
    console.log '[message]', e.data

    payload = @parseEvent( e )

    @hideSmpte()

    if payload.redraw or payload.newProgram
      onIframeReady = (e) =>
        payload.onReady.event = 'iframeReadyCallback'

        msg = JSON.stringify( payload.onReady )

        e.detail.source.postMessage msg, win.location.origin

        win.removeEventListener 'iframeReady', onIframeReady

      win.addEventListener 'iframeReady', onIframeReady, false

      @goTo payload.url
