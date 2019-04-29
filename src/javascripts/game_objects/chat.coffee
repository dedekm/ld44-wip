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

    @chatText = @scene.add.text(0, 0, '', @scene.default_text_options)
    @setViewersCounter()

  addLine: (text) ->
    @lines.shift() if @lines.length >= MAX_LINES_COUNT
    @lines.push(text)
    @chatText.text = @lines.join("\n")

  react: (category) ->
    @lastCategory = category
    for viewer in @viewers
      viewer.react(category)

  update: (time, delta) ->
    @lastUpdated += delta

    if @lastUpdated / 5000 > 1
      @lastUpdated = 0
      @randomViewer().react('bored=-1')

    @setViewersCounter()

  randomViewer: () ->
    Phaser.Utils.Array.GetRandom(@viewers)

  removeViewer: (viewer) ->

  setViewersCounter: () ->
    @viewersCounter ||= @scene.add.text(220, 0, '', @scene.default_text_options)
    @viewersCounter.text = "viewers: #{@viewers.length}"

module.exports = Chat
