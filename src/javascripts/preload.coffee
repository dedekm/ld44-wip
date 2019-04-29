Keyboard = require './keyboard.coffee'

module.exports = ->
  @game.three = {}
  @default_text_options =
    fontSize: '12px'

  Keyboard.setUpKeyboard(@)

  @load.json('data', '/data.json')
