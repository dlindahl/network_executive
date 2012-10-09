class @NE.Exception
  constructor : (name, message) ->
    @name    = name
    @message = message

  toString : ->
    "#{@name} - #{@message}"