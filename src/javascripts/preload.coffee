module.exports = ->
  @load.json('data', '/data.json')

  @data = ->
    @cache.json.get('data')
