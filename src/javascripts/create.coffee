Utils = require './utils.coffee'
Response = require './response.coffee'
Chat = require './game_objects/chat.coffee'

WELCOME_TEXT = 'What am I going to do today?'

module.exports = ->
  @data = @cache.json.get('data')
  @itemsList = []
  for action, items of @data.actions
    for item in Object.keys(items)
      for i in item.split(',')
        unless i == 'undefined'
          @itemsList.push(i)

  @postInput = Utils.postInput
  @chat = new Chat(@)

  @inputLine = @add.text(0, 240 - 32, '', @default_text_options)
  @changeInputLine = (text) ->
    @inputLine.text = ">> #{text}"

  @responseLine = @add.text(0, 240 - 16, WELCOME_TEXT, @default_text_options)
  @changeResponseLine = (text) ->
    @responseLine.text = text

  @findNestedResponse = Response.findNestedResponse
  @findResponse = Response.findResponse

  input = (e) ->
    @scene.postInput(@value)
    @scene.changeInputLine(@value)

    response = @scene.findResponse(@value)
    if response.value
      @scene.changeResponseLine('...')
      @scene.chat.react(response.value)
    else
      @scene.changeResponseLine(response.error)

    @value = ''

  inputElement = document.getElementById('text-input')
  inputElement.scene = @
  document.getElementById('text-input').addEventListener 'change', input
