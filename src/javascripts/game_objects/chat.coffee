Viewer = require './viewer.coffee'

MAX_LINES_COUNT = 12

class Chat extends Object
  constructor: (scene) ->
    super()

    @scene = scene
    @lines = []
    @viewers = []
    @lastUpdated = 0
    @lastCategory = undefined
    for [0...10]
      @viewers.push(new Viewer(@scene))

    @text = @scene.add.text(0, 0, '', @scene.default_text_options)

  addLine: (text) ->
    @lines.shift() if @lines.length >= MAX_LINES_COUNT
    @lines.push(text)
    @text.text = @lines.join("\n")

  react: (category) ->
    @lastCategory = category
    for viewer in @viewers
      viewer.react(category)

  update: (time, delta) ->
    @lastUpdated += delta

    if @lastUpdated / 5000 > 1
      @lastUpdated = 0
      @randomViewer().react('bored=-1')

  randomViewer: () ->
    Phaser.Utils.Array.GetRandom(@viewers)

module.exports = Chat
