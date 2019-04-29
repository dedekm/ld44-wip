class Viewer extends Object
  constructor: (scene) ->
    super()

    @scene = scene
    @group = Phaser.Utils.Array.GetRandom(@scene.data.chat.viewers.groups)
    @name = @generateName()
    @satisfaction = 10

  react: (reaction) ->
    [category, value] = reaction.split('=')

    if value
      @satisfaction += value * (0.9 + 0.2 * Math.random())

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

  generateName: ->
    prefix = @generateNamePart('prefix')
    suffix = @generateNamePart('suffix', 0.15) || @generateNumber(0.6)
    wrap = @generateNamePart('wrap')
    base = @generateNamePart('base', 1)
    name = [prefix, base, suffix].join('')
    name = wrap.replace('{name}', name) if wrap
    name

  generateNamePart: (partName, n = 0.3) ->
    if n == 1 || Math.random() < n
      if @scene.data.chat.viewers.names[partName][@group]
        Phaser.Utils.Array.GetRandom(@scene.data.chat.viewers.names[partName][@group])
      else
        Phaser.Utils.Array.GetRandom(@scene.data.chat.viewers.names[partName].default)

  generateNumber: (n = 0.3) ->
    if n == 1 || Math.random() < n
      Phaser.Math.Between(0, 99)

module.exports = Viewer
