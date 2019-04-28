class Viewer extends Object
  constructor: (scene) ->
    super()

    @scene = scene
    @group = Phaser.Utils.Array.GetRandom(@scene.data.chat.viewers.groups)
    @name = Phaser.Utils.Array.GetRandom(@scene.data.chat.viewers.names) + Phaser.Math.Between(0, 99)

  react: (reaction) ->
    [category, value] = reaction.split('=')
    if category.indexOf(',') != -1
      category = Phaser.Utils.Array.GetRandom(category.split(','))

    reactions = @scene.data.chat.reactions
    if reactions[@group] && reactions[@group][category]
      messages = reactions[@group][category]
    else if reactions.default[category]
      messages = reactions.default[category]
    else
      throw "unknown category: #{category}"

    message = Phaser.Utils.Array.GetRandom(messages)
    @scene.chat.addLine("#{@name}: #{message}")

module.exports = Viewer
