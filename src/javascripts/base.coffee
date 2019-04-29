preload = require './preload.coffee'
create = require './create.coffee'
update = require './update.coffee'
three = require './three.coffee'

config =
  type: Phaser.AUTO
  parent: 'phaser-wrapper'
  width: 512
  height: 256
  callbacks:
    postBoot: three.init
  scene:
    preload: preload
    create: create
    update: update

game = new (Phaser.Game)(config)
