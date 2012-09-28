;(function() {

  var paths   = window.location.pathname.split('/'),
      channel = paths[ paths.length - 1];

  if( channel ) {
    console.log( 'tune in to channel:', channel );

    document.getElementById('smpte_message').innerHTML = 'Establishing uplink...';

    var source = new EventSource('tune_in/' + channel);

    source.addEventListener('open', function(e) {
      document.getElementById('smpte_message').innerHTML = 'Awaiting transmission...';
      // Connection was opened.
      console.log('[open]', e);
    }, false);

    source.addEventListener('message', function(e) {
      console.log( '[message]', e.data );

      var payload = JSON.parse( e.data ),
          tube    = document.getElementById('program');

      document.getElementById('smpte').style.display = 'none';

      if( !payload.live_feed || payload.live_feed && payload.url != tube.getAttribute('src') ) {
        var onIframeReady = function(e) {
          console.log( 'iframe ready!', e );

          payload.onReady.event = 'iframeReadyCallback';

          var d = payload.onReady;

          e.detail.source.postMessage( JSON.stringify(d), window.location.origin );

          window.removeEventListener('iframeReady', onIframeReady);
        };

        window.addEventListener('iframeReady', onIframeReady, false);

        tube.setAttribute('src', payload.url);
      }
    }, false);

    source.addEventListener('error', function(e) {
      if (e.eventPhase == EventSource.CLOSED) {
        console.log('[closed]', e);
        document.getElementById('smpte_message').innerHTML = 'Transmission lost...';
        document.getElementById('program').setAttribute('src', 'about:blank');
        // Move this functionality to a class for better cross-browser support
        document.getElementById('smpte').style.display = '-webkit-box';
        // Connection was closed.
      } else {
        console.log('[closed]', e);
      }
    }, false);
  } else {
    document.getElementById('smpte_message').innerHTML = 'No signal';
  }

})();