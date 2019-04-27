express = require('express')
yaml    = require 'js-yaml'
fs      = require 'fs'

router = express.Router()

router.get '/', (req, res, next) ->
  res.render 'index', title: router.app
  return

router.get '/data.json', (req, res, next) ->
  config = yaml.safeLoad(fs.readFileSync('src/data/data.yml', 'utf8'))
  indentedJson = JSON.stringify(config, null, 4)

  res.setHeader('Content-Type', 'application/json')
  res.end(indentedJson)

module.exports = router
