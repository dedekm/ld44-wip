

module.exports = (time, delta) ->
  game = @game
  @updateMaterial = (snapshot) ->
    drawingCanvas = document.getElementById('drawing-canvas')
    drawingContext = drawingCanvas.getContext('2d')
    drawingContext.drawImage(snapshot, 0, 0)
    game.three.material.map.needsUpdate = true if game.three.material

  @game.renderer.snapshot(@updateMaterial)
