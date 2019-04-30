string = ''
setUpKeyboard = (scene) ->
  document.addEventListener 'keydown', (e) ->
    if scene.game.three.controls.isLocked
      if e.code == 'Enter'
        scene.input(string)
        string = ''
        scene.game.three.updateText(input: '...')
      else
        if e.code == 'Backspace' && string != ''
          string = string.slice(0, -1)
        else if e.key.length == 1
          string += e.key
        scene.game.three.updateText(input: string)

module.exports =
  setUpKeyboard: setUpKeyboard
