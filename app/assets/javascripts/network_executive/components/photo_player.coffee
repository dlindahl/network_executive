win = @

class @NE.PhotoPlayer extends @NE.CollectionPlayer
  constructor : (photoId, titleId, descId, photogId, locId ) ->
    @photo        = document.getElementById( photoId )
    @title        = document.getElementById( titleId )
    @description  = document.getElementById( descId )
    @photographer = document.getElementById( photogId )
    @location     = document.getElementById( locId )

    super()

  renderItem : (photo) =>
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

  getItems : (e) ->
    e.detail.data.items
