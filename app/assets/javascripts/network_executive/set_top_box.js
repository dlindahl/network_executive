;(function() {

  var channel = window.location.pathname.split('/')[2];

  if( channel ) {
    console.log( channel );

    document.getElementById('smpte_message').innerHTML = 'Establishing uplink...';

    var source = new EventSource('/tune_in/' + channel);

    source.addEventListener('open', function(e) {
      document.getElementById('smpte_message').innerHTML = 'Awaiting transmission...';
      // Connection was opened.
      console.log('[open]', e);
    }, false);

    source.addEventListener('message', function(e) {
      var payload = JSON.parse( e.data );

      console.log('[message]', payload);

      document.getElementById('smpte').style.display = 'none';
      document.getElementById('program').setAttribute('src', payload.url);
    }, false);

    source.addEventListener('error', function(e) {
      if (e.eventPhase == EventSource.CLOSED) {
        console.log('[error]', e);
        document.getElementById('smpte_message').innerHTML = 'Transmission lost...';
        document.getElementById('program').setAttribute('src', 'about:blank');
        // Move this functionality to a class for better cross-browser support
        document.getElementById('smpte').style.display = '-webkit-box';
        // Connection was closed.
      }
    }, false);
  } else {
    document.getElementById('smpte_message').innerHTML = 'No signal';
  }

})();