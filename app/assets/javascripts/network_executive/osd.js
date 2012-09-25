;(function($) {
  var autoHideTimer = null;

  var osd = document.getElementById('osd');

  var autoHide = function() {
    if( osd.classList.contains('active') ) {
      osd.classList.remove('active');
    }
  };

  // detect mouse movement and scale display
  document.addEventListener('mousemove', function(e) {
    clearTimeout( autoHideTimer );

    if( !osd.contains('active') ) {
      osd.classList.add('active');
    }

    autoHideTimer = setTimeout(autoHide, 1000);
  });

  // Update the timestamp
  var months = 'January February March April May June July August September October November December'.split(' ');
  setInterval(function() {
    var time,
        date,
        now  = new Date(),
        mon  = now.getMonth(),
        d    = now.getDate(),
        y    = now.getFullYear(),
        h    = now.getHours(),
        min  = now.getMinutes(),
        a    = h > 12 ? 'pm' : 'am';

    h    = h > 12 ? h - 12 : h;
    min  = min < 10 ? '0'+min : min;
    time = h + ':' + min + a;

    date = months[mon] + ' ' + d + ', ' + y;

    $('.osd-now-time')[0].innerHTML = time;
    $('.osd-now-date')[0].innerHTML = date;
  }, 1000);

})( document.querySelectorAll.bind(document) );