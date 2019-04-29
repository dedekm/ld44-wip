Group = require './group.coffee'

MAX_LINES_COUNT = 12

class Chat extends Object
  constructor: (scene) ->
    super()

    @scene = scene
    @lines = []
    @groups = []
    for groupCategory in @scene.data.chat.viewers.groups
      @addGroup(groupCategory)
    @chatText = @scene.add.text(0, 0, '', @scene.default_text_options)
    @setViewersCounter()

    @scene.time.addEvent(
      delay: 10 * 1000
      callback: ->
        @randomGroup().react('bored=-1')
      callbackScope: @,
      loop: true
    )


  addLine: (text) ->
    @lines.shift() if @lines.length >= MAX_LINES_COUNT
    @lines.push(text)
    @chatText.text = @lines.join("\n")

  react: (reaction) ->
    for group in @groups
      group.react(reaction)

  addGroup: (category) ->
    @groups.push(new Group(@scene, category, Phaser.Math.Between(5, 7)))

  randomGroup: () ->
    Phaser.Utils.Array.GetRandom(@groups)

  setViewersCounter: () ->
    @viewersCounter ||= @scene.add.text(370, 0, '', @scene.default_text_options)
    total = 0
    for g in @groups
      total += g.count

    @viewersCounter.text = "viewers: #{total}"

module.exports = Chat
