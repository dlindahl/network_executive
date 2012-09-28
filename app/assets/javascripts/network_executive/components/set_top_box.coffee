paths   = @location.pathname.split '/'
channel = paths[ paths.length - 1]

if channel
  document.getElementById( 'smpte_message' ).innerHTML = 'Establishing uplink...'

  source = new EventSource( "tune_in/#{channel}" )

  source.addEventListener 'open', (e) ->
    document.getElementById('smpte_message').innerHTML = 'Awaiting transmission...';

    console.log('[open]', e);
  , false

  source.addEventListener 'message', (e) =>
    console.log '[message]', e.data

    payload = JSON.parse( e.data )
    tube    = document.getElementById( 'program' )

    document.getElementById( 'smpte' ).style.display = 'none'

    if !payload.live_feed || payload.live_feed && payload.url != tube.getAttribute( 'src' )
      onIframeReady = (e) =>
        payload.onReady.event = 'iframeReadyCallback'

        msg = JSON.stringify( payload.onReady )

        e.detail.source.postMessage msg, @location.origin

        @removeEventListener 'iframeReady', onIframeReady

      @addEventListener 'iframeReady', onIframeReady, false

      tube.setAttribute 'src', payload.url
  , false

  source.addEventListener 'error', (e) ->
    if e.eventPhase == EventSource.CLOSED
      console.log('[closed]', e);

      document.getElementById('smpte_message').innerHTML = 'Transmission lost...'
      document.getElementById('program').setAttribute 'src', 'about:blank'

      # Move this functionality to a class for better cross-browser support
      document.getElementById('smpte').style.display = '-webkit-box';
    else
      console.log '[closed]', e
  , false
else
  document.getElementById( 'smpte_message' ).innerHTML = 'No signal'
