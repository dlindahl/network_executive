# Sends several generic events to the parent window that indicates the
# current state of the Iframe.

# Tell the parent that we are ready
@addEventListener 'DOMContentLoaded', (e) =>
  @parent.postMessage { event:'domloaded:iframe' }, @location.origin
, false

events = [ 'load', 'error', 'change', 'hashchange', 'resize', 'pageshow', 'pagehide', 'beforeunload' ]

events.forEach (evt) =>
  @addEventListener evt, (e) =>
    @parent.postMessage { event:"#{evt}:iframe" }, @location.origin
  , false
