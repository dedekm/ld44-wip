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

writeToFile = (filename, str) ->
  status = 200
  fs.appendFile filename, str, (err) ->
    if err
      throw err
      status = 500
  status

router.post '/user', (req, res, next) ->
  str = "#{req.body.user}:\n"
  str += "  started_at: #{new Date().toJSON()}\n"
  str += "  ip: #{req.ip}\n"
  str += "  actions:\n"
  status = writeToFile("data/#{req.body.user}.yml", str)
  res.sendStatus(status)

router.post '/input', (req, res, next) ->
  str = "    - #{req.body.input} [#{new Date().toJSON()}]\n"
  status = writeToFile("data/#{req.body.user}.yml", str)
  res.sendStatus(status)

module.exports = router
