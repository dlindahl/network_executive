win = @

class @NE.PhotoPlayer
  constructor : (photoId, titleId, descId, photogId, locId ) ->
    @photo        = document.getElementById( photoId )
    @title        = document.getElementById( titleId )
    @description  = document.getElementById( descId )
    @photographer = document.getElementById( photogId )
    @location     = document.getElementById( locId )

    @photos      = []
    @displayTime = 10000
    @cursor      = 0

    win.addEventListener 'load:program', @onLoad, false

  render : =>
    return unless photo = @nextPhoto()

    @renderPhoto       photo.image_url
    @renderTitle       photo.title
    @renderDescription photo.description
    @renderPhotog      photo.photographer
    @renderLocation    photo.location

  renderPhoto : (url) ->
    @photo.setAttribute 'src', url

  renderTitle : (title) ->
    @title.innerHTML = title

  renderDescription : (desc) ->
    @description.innerHTML = desc

  renderPhotog : (photog) ->
    @photographer.innerHTML = photog

  renderLocation : (location) ->
    @location.innerHTML = location

  nextPhoto : ->
    @cursor = 0 if @cursor > @photos.length - 1

    p = @photos[@cursor]

    @cursor++

    p

  onLoad : (e) =>
    @photos = e.detail.data.photos

    setInterval @render, @displayTime

    @render()
