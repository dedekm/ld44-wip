Viewer = require './viewer.coffee'

MAX_LINES_COUNT = 12

class Chat extends Object
  constructor: (scene) ->
    super()

    @scene = scene
    @lines = []
    @viewers = []
    for [0...10]
      @viewers.push(new Viewer(@scene))

    @text = @scene.add.text(0, 0, '', @scene.default_text_options)

  addLine: (text) ->
    @lines.shift() if @lines.length >= MAX_LINES_COUNT

    viewer = Phaser.Utils.Array.GetRandom(@viewers)
    @lines.push "#{viewer.name}: #{viewer.react(text)}"
    @text.text = @lines.join("\n")

module.exports = Chat
