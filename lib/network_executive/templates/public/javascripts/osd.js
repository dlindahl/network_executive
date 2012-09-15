;(function() {
  var autoHideTimer = null;

  var autoHide = function() {
    $('#osd.active').removeClass('active');
  };

  // detect mouse movement and scale display
  $(document).on('mousemove', function(e) {
    clearTimeout( autoHideTimer );

    $('#osd:not(.active)').addClass('active');

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

    $('.osd-now-time').html( time );
    $('.osd-now-date').html( date );
  }, 1000);

})();