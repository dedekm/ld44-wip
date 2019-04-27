NAMES = ['guy', 'cutie', 'gamer']
randomName = ->
  Phaser.Utils.Array.GetRandom(NAMES) + Phaser.Math.Between(0, 99)

class Follower extends Object
  constructor: (scene) ->
    super()

    @scene = scene
    @name = randomName()

  react: (category) ->
    if Array.isArray(category)
      category = Phaser.Utils.Array.GetRandom(category)

    if @scene.data().chat.reactions[category]
      Phaser.Utils.Array.GetRandom(@scene.data().chat.reactions[category])
    else
      throw "unknown category: #{category}"

module.exports = Follower
