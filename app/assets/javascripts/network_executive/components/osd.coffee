$ = document.querySelectorAll.bind(document)

MONTHS = 'January February March April May June July August September October November December'.split( ' ' )

class @NE.OSD
  constructor : ->
    @el      = document.getElementById( 'osd' )
    @guideEl = document.getElementById( 'guide' )

    @autoHideTimer = null
    @autoHideDelay = 1000

    @guideUrl = 'guide.html'

    # document.addEventListener 'mousemove', @onMouseMove

    setInterval( @updateTimestamps, 1000 )

  onMouseMove : (e) =>
    @cancelAutoHide()

    unless @el.classList.contains( 'active' )
      @el.classList.add 'active'

      @render()

    @autoHide()

  autoHide : ->
    @autoHideTimer = setTimeout( @doAutoHide, @autoHideDelay )

  doAutoHide : =>
    if @el.classList.contains( 'active' )
      @el.classList.remove 'active'

  cancelAutoHide : ->
    clearTimeout @autoHideTimer

  render : ->
    @fetchGuide (xhr) =>
      @guideEl.innerHTML = xhr.responseText

  fetchGuide : (cb) ->
    xhr = new XMLHttpRequest();

    xhr.addEventListener 'readystatechange', (e) ->
      cb( xhr ) if xhr.readyState == 4 && xhr.status == 200

    xhr.open( 'GET', @guideUrl, true )
    xhr.send()

  updateTimestamps : ->
    now  = new Date()
    mon  = now.getMonth()
    d    = now.getDate()
    y    = now.getFullYear()
    h    = now.getHours()
    min  = now.getMinutes()
    a    = if h > 12 then 'pm' else 'am'

    h    = if h > 12   then h - 12    else h
    min  = if min < 10 then "0#{min}" else min

    $('.osd-now-time')[0].innerHTML = "#{h}:#{min}#{a}"
    $('.osd-now-date')[0].innerHTML = "#{MONTHS[mon]} #{d}, #{y}"
