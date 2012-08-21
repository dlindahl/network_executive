;(function() {

  var channel = window.location.pathname.split('/')[2];

  if( channel ) {
    console.log( channel );

    var source = new EventSource('/tune_in/' + channel);

    source.addEventListener('open', function(e) {
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
        document.getElementById('program').setAttribute('src', 'about:blank');
        document.getElementById('smpte').style.display = 'block';
        // Connection was closed.
      }
    }, false);
  }



  // var source = new EventSource('/tune_in');

  // source.addEventListener('message', function(e) {
  //   console.log('[message]', e.data);
  // }, false);

  // source.addEventListener('open', function(e) {
  //   // Connection was opened.
  //   console.log('[open]', e)
  // }, false);

  // source.addEventListener('error', function(e) {
  //   if (e.eventPhase == EventSource.CLOSED) {
  //     console.log('[error]', e)
  //     // Connection was closed.
  //   }
  // }, false);

})();