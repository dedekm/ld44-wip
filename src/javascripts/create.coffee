Utils = require './utils.coffee'
Response = require './response.coffee'
Group = require './game_objects/group.coffee'
Chat = require './game_objects/chat.coffee'
Money = require './game_objects/money.coffee'

module.exports = ->
  name = prompt('Good day. Enter your chatrubateme username...', '')
  if name == null or name == ''
    name = 'anonymous'

  @game.user =
    id: new Date().getTime()
    name: name

  Utils.postNewUser(@game.user)

  @data = @cache.json.get('data')
  @itemsList = []
  for action, items of @data.actions
    for item in Object.keys(items)
      for i in item.split(',')
        unless i == 'undefined'
          @itemsList.push(i)

  @postInput = Utils.postInput
  @money = new Money(@)
  @chat = new Chat(@)

  @changeResponseLine = (text) ->
    @game.three.updateText(hint: text)

  @findNestedResponse = Response.findNestedResponse
  @findResponse = Response.findResponse

  @input = (value) ->
    @postInput(@game.user, value)

    response = @findResponse(value)
    if response.value
      @chat.react(response.value)
    else
      @changeResponseLine(response.error)
