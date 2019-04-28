class Viewer extends Object
  constructor: (scene) ->
    super()

    @scene = scene
    @name = Phaser.Utils.Array.GetRandom(@scene.data.chat.viewers.names) + Phaser.Math.Between(0, 99)

  react: (reaction) ->
    [category, value] = reaction.split('=')
    if category.indexOf(',') != -1
      category = Phaser.Utils.Array.GetRandom(category.split(','))

    if @scene.data.chat.reactions.default[category]
      message = Phaser.Utils.Array.GetRandom(@scene.data.chat.reactions.default[category])
      @scene.chat.addLine("#{@name}: #{message}")
    else
      throw "unknown category: #{category}"

module.exports = Viewer
