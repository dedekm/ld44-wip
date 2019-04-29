class Group extends Object
  constructor: (scene, type, count) ->
    super()

    @scene = scene
    @type = type || Phaser.Utils.Array.GetRandom(@scene.data.chat.viewers.groups)
    @names = [@generateName()] # TODO
    @count = count
    @satisfaction = 10

    @callLoop(3)

  callLoop: (delay) ->
    @scene.time.addEvent(
      delay: delay * 1000
      callback: ->
        if @count > 0
          if @satisfaction < 0
            @count -= 1
            @scene.chat.setViewersCounter()
          else if @satisfaction > 20
            @scene.money.add(1)
        @callLoop(Phaser.Math.Between(1, 5))

      callbackScope: @
    )

  react: (reaction) ->
    return if @count <= 0
    if typeof reaction == 'object'
      reaction = (reaction[@type] || reaction.default)

    [category, value] = reaction.split('=')

    if value
      @satisfaction += value * (0.9 + 0.2 * Math.random())

    if category.indexOf(',') != -1
      category = Phaser.Utils.Array.GetRandom(category.split(','))

    reactions = @scene.data.chat.reactions
    if reactions[@type] && reactions[@type][category]
      messages = reactions[@type][category]
    else if reactions.default[category]
      messages = reactions.default[category]
    else
      throw "unknown category: #{category}"

    message = Phaser.Utils.Array.GetRandom(messages)
    @scene.chat.addLine("#{@getRandomName()}: #{message}")

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
      if @scene.data.chat.viewers.names[partName][@type]
        Phaser.Utils.Array.GetRandom(@scene.data.chat.viewers.names[partName][@type])
      else
        Phaser.Utils.Array.GetRandom(@scene.data.chat.viewers.names[partName].default)

  generateNumber: (n = 0.3) ->
    if n == 1 || Math.random() < n
      Phaser.Math.Between(0, 99)

  getRandomName: ->
    Phaser.Utils.Array.GetRandom(@names)

module.exports = Group
