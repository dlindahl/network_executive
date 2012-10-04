win = @
$   = @$

class @NE.TweetPlayer
  constructor : (id) ->
    @tweetEl      = $(id)
    @authorEl     = document.getElementById( 'author' )
    @avatarEl     = document.getElementById( 'avatar' )
    @backgroundEl = document.getElementById( 'background' )
    @tweets       = []
    @displayTime  = 10000
    @cursor       = 0

    win.addEventListener 'load:program',   @onLoad,   false
    win.addEventListener 'update:program', @onUpdate, false

  render : =>
    return unless tweet = @nextTweet()

    @renderText   tweet.text
    @renderAuthor tweet.user
    @renderAvatar tweet.user

  nextTweet : ->
    @cursor = 0 if @cursor > @tweets.length - 1

    t = @tweets[@cursor]

    @cursor++

    t

  renderText : (text) ->
    buffer  = []
    pointer = -1
    wc      = 0
    # Trailing ellipsis look awful
    text    = text.replace /(…|\.{2,})$/, ''

    # TODO: Refactor
    text.split( /\s/ ).forEach (substr, i, txt) ->
      # First word
      if buffer.length == 0
        buffer.push substr
        pointer++
        wc = 1
      # Last word was special-a
      else if buffer[pointer].match( /,|!|\?|\.|@|#|:|\// ) and !substr.match(/https?:/) and (buffer[pointer].length > 4 or wc >= 4)
        buffer.push substr
        pointer++
        wc = 1
      # Current word is special-b, the buffer has more than 4 characters or more
      # than 3 words, and the current word is NOT the last and more than 4
      # characters
      else if substr.match( /!|\?|@|#|:|;|\// ) and !buffer[pointer].match(/https?:/) and (buffer[pointer].length > 4 or wc >= 4) and (i < txt.length - 1 and substr.length > 4) and substr != '&amp;'
        buffer.push substr
        pointer++
        wc = 1
      # Current word is a URL and the buffer has more than 3 words
      else if substr.match( /^https?/ ) and wc >= 3
        buffer.push substr
        pointer++
        wc = 1
      # Buffer has 5 or more words
      else if wc >= 5 and substr != '&amp;'
        buffer.push substr
        pointer++
        wc = 1
      # Append it
      else
        buffer[pointer] += " #{substr}"
        wc++

    text = buffer.join '</div><div>'

    text = "<div>#{text}</div>"

    @tweetEl.html( text ).bigtext()

  renderAuthor : (user) ->
    @authorEl.innerHTML = user.screen_name

  # Generates the URL for the original profile image by chopping off the suffix
  renderAvatar : (user) ->
    @backgroundEl.src = user.profile_image_url.replace '_normal', ''

  onLoad : (e) =>
    @tweets = e.detail.data.tweets

    setInterval @render, @displayTime

    @render()

  onUpdate : (e) =>
    # ...
