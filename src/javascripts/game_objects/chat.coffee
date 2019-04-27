Follower = require './follower.coffee'

MAX_LINES_COUNT = 12

class Chat extends Object
  constructor: (scene) ->
    super()

    @scene = scene
    @lines = []
    @text = @scene.add.text(0, 0, '', @scene.default_text_options)

  addLine: (text) ->
    @lines.shift() if @lines.length >= MAX_LINES_COUNT

    follower = new Follower(@scene)
    @lines.push "#{follower.name}: #{follower.react(text)}"
    @text.text = @lines.join("\n")

module.exports = Chat
