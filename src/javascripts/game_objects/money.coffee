class Money extends Object
  constructor: (scene) ->
    super()

    @scene = scene
    @total = 0
    @counter = @scene.add.text(370, 20, '$0', @scene.default_text_options)

  add: (n) ->
    @total += n
    @updateViewersCounter()

  updateViewersCounter: ->
    @counter.text = "$#{@total}"

module.exports = Money
