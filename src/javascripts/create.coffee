Utils = require './utils.coffee'
Chat = require './game_objects/chat.coffee'

WELCOME_TEXT = 'What am I going to do today?'

module.exports = ->
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
    data = @scene.data()
    if sentence.length > 1
      action = sentence[0]
      item = sentence[1]
      if data.items[item]
        if data.items[item].actions[action]
          response = data.items[item].actions[action].response
          inputValid = true
        else
          response = "I have #{item}, but I can't #{action} it"
    else
      word = sentence[0]
      if data.actions[word]
        response = data.actions[word].response
        inputValid = true
      else if data.items[word]
        response = "What do you want to do with #{word}"

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
