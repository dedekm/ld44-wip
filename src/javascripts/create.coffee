Utils = require './utils.coffee'
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

  input = (e) ->
    @scene.postInput(@value)

    sentence = @value.split(' ').filter((v) ->
      ['a', 'the'].indexOf(v) == -1
    )

    inputValid = false
    data = @scene.data

    action = sentence[0]
    if data.actions[action]
      if sentence.length == 1
        if data.actions[action].undefined
          response = data.actions[action].undefined.default.reaction
          inputValid = true
        else
          response = "What do you want to #{action}?"
      else
        item = sentence[1]
        if data.actions[action][item]
          response = data.actions[action][item].default.reaction
          inputValid = true
        else
          response = "You can #{action} but not #{item}..."
    else if @scene.itemsList.indexOf(action) != -1
      response = "What do you want to do with #{action}?"

    response ||= "Don't know how to #{@value}..."

    @scene.changeInputLine(@value)
    if inputValid
      @scene.changeResponseLine('...')
      @scene.chat.react(response)
    else
      @scene.changeResponseLine(response)

    @value = ''

  inputElement = document.getElementById('text-input')
  inputElement.scene = @
  document.getElementById('text-input').addEventListener 'change', input
