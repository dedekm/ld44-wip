class Viewer extends Object
  constructor: (scene) ->
    super()

    @scene = scene
    @name = Phaser.Utils.Array.GetRandom(@scene.data().chat.viewers.names) + Phaser.Math.Between(0, 99)

  react: (category) ->
    if Array.isArray(category)
      category = Phaser.Utils.Array.GetRandom(category)

    if @scene.data().chat.reactions[category]
      Phaser.Utils.Array.GetRandom(@scene.data().chat.reactions[category])
    else
      throw "unknown category: #{category}"

module.exports = Viewer
