express = require('express')
yaml    = require 'js-yaml'
fs      = require 'fs'

router = express.Router()

processData = (data) ->
  for key, value of data
    if key.indexOf(',') != -1
      obj = data[key]
      delete data[key]
      for k in key.split(',')
        data[k] = obj

    if typeof(value) == "object"
      processData(value)

router.get '/', (req, res, next) ->
  res.render 'index', title: router.app
  return

router.get '/data.json', (req, res, next) ->
  config = yaml.safeLoad(fs.readFileSync('src/data/data.yml', 'utf8'))

  processData(config)
  indentedJson = JSON.stringify(config, null, 4)

  res.setHeader('Content-Type', 'application/json')
  res.end(indentedJson)

router.post '/input', (req, res, next) ->
  console.log ">> #{req.body.input}"
  res.sendStatus(200)

module.exports = router
