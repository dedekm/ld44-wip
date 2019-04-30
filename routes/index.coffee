express = require 'express'
request = require 'request'
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
  res.setHeader('Content-Type', 'application/json')

  # local
  # config = yaml.safeLoad(fs.readFileSync('src/data/data.yml', 'utf8'))
  # processData(config)
  # json = JSON.stringify(config, null, 4)
  # res.end(json)

  # gist
  dataUrl = 'https://gist.github.com/vdedek/508b4c86751f54785d740d4af81eac0f/raw'
  request.get(dataUrl, (error, response, body) ->
    if (!error && response.statusCode == 200)
      config = yaml.safeLoad(body)
      processData(config)
      json = JSON.stringify(config, null, 4)
      res.end(json)
    else
      res.end('{}')
  )

writeToFile = (filename, str) ->
  status = 200
  fs.appendFile filename, str, (err) ->
    if err
      throw err
      status = 500
  status

router.post '/user', (req, res, next) ->
  console.log req.body
  str = "#{req.body.id}_#{req.body.name}:\n"
  str += "  started_at: #{new Date().toJSON()}\n"
  str += "  ip: #{req.ip}\n"
  str += "  actions:\n"
  status = writeToFile("data/#{req.body.id}_#{req.body.name}.yml", str)
  res.sendStatus(status)

router.post '/input', (req, res, next) ->
  str = "    - #{req.body.input} [#{new Date().toJSON()}]\n"
  status = writeToFile("data/#{req.body.id}_#{req.body.name}.yml", str)
  res.sendStatus(status)

module.exports = router
