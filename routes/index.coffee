express = require 'express'
request = require 'request'
yaml    = require 'js-yaml'
fs      = require 'fs'

router = express.Router()

router.get '/', (req, res, next) ->
  res.render 'index', title: router.app
  return

router.get '/data.json', (req, res, next) ->
  res.setHeader('Content-Type', 'application/json')

  dataUrl = 'https://gist.github.com/dedekm/541be69e13df0c299c0288c379f034b5/raw'
  request.get(dataUrl, (error, response, body) ->
    if (!error && response.statusCode == 200)
      config = yaml.safeLoad(body)
      json = JSON.stringify(config, null, 4)
      res.end(json)
    else
      res.end('{}')
  )

module.exports = router
