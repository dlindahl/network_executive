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

    @uplink.addEventListener 'message', @purgeOnIframeLoad, false

    @uplink.addEventListener 'open',    @onUplinkUp,      false
    @uplink.addEventListener 'message', @onUplinkMessage, false
    @uplink.addEventListener 'error',   @onUplinkDown,    false

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

    payload

  onUplinkMessage : (e) =>
    console.log '[STB::message]', e.data

    @hideSmpte()

    payload = @parseEvent( e )

    switch payload.event
      when   'show:program' then cb = @onProgramShow
      when 'update:program' then cb = @onProgramUpdate

    cb( payload ) if cb

  onProgramShow : (payload) =>
    onIframeLoad = (e) =>
      console.log '[STB::onIframeLoad]'

      payload.onLoad.event = 'load:program'

      e.detail.source.postMessage payload.onLoad, '*'

    @onIframeLoad = onIframeLoad

    win.addEventListener 'load:iframe', onIframeLoad, false

    @goTo payload.url

  onProgramUpdate : (payload) ->
    @program.postMessage payload, '*'

  purgeOnIframeLoad : (e) =>
    win.removeEventListener 'load:iframe', @onIframeLoad, false

    @onIframeLoad = null