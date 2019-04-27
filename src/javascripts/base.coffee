preload = require './preload.coffee'
create = require './create.coffee'
update = require './update.coffee'

config =
  type: Phaser.AUTO
  parent: 'phaser-wrapper'
  width: 320
  height: 240
  zoom: 2
  pixelArt: true
  # physics:
  #   default: 'arcade'
  scene:
    preload: preload
    create: create
    update: update

game = new (Phaser.Game)(config)
