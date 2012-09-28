# Converts postMessage events to page-level events, handling all JSON
# parsing in the process.
@addEventListener 'message', (e) =>
  if e.origin == @location.origin
    try
      payload = JSON.parse( e.data )
    catch e
      payload = {}

    if type = payload.event
      delete payload.event

      ce = new CustomEvent type,
        detail :
          data          : payload,
          source        : e.source,
          originalEvent : e

      @dispatchEvent ce
  
, false