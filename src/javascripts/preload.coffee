module.exports = ->
  @game.three = {}
  @default_text_options =
    fontSize: '12px'

  @load.json('data', '/data.json')

  @data = ->
    @cache.json.get('data')
