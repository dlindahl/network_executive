#= require ./components/namespace
#= require ./components/iframe_notifier
#= require ./components/postman
#= require ./components/exception

win = @

class @NE.CollectionPlayer
  constructor : ->
    @collection   = []
    @displayTime  = 10000
    @cursor       = 0

    win.addEventListener 'load:program',   @onLoad,   false
    win.addEventListener 'update:program', @onUpdate, false

  render : =>
    return unless item = @nextItem()

    @renderItem( item )

  nextItem : ->
    @cursor = 0 if @cursor > @items.length - 1

    i = @items[@cursor]

    @cursor++

    i

  renderItem : (item) ->
    throw new NE.Exception( 'NotImplementedError', 'A custom #renderItem method has not been implemented' )

  getItems : (e) ->
    throw new NE.Exception( 'NotImplementedError', 'A custom #getItems method has not been implemented' )

  onLoad : (e) =>
    @items = @getItems( e )

    setInterval @render, @displayTime

    @render()

  onUpdate : (e) =>
    # ...
