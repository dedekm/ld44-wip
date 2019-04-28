camera = undefined
scene = undefined
renderer = undefined
mesh = undefined
material = undefined

initialize = ->
  camera = new (THREE.PerspectiveCamera)(50, window.innerWidth / window.innerHeight, 1, 2000)
  camera.position.z = 500
  scene = new (THREE.Scene)
  material = new (THREE.MeshBasicMaterial)
  mesh = new (THREE.Mesh)(new (THREE.PlaneBufferGeometry)(300, 150), material)
  scene.add mesh
  renderer = new (THREE.WebGLRenderer)(antialias: true)
  renderer.setPixelRatio window.devicePixelRatio
  renderer.setSize window.innerWidth, window.innerHeight
  document.body.appendChild renderer.domElement
  window.addEventListener 'resize', onWindowResize, false

setupCanvasDrawing = ->
  # get canvas and context
  drawingCanvas = document.getElementById('drawing-canvas')
  drawingContext = drawingCanvas.getContext('2d')

  # set canvas as material.map (this could be done to any map, bump, displacement etc.)
  material.map = new (THREE.CanvasTexture)(drawingCanvas)

onWindowResize = ->
  camera.aspect = window.innerWidth / window.innerHeight
  camera.updateProjectionMatrix()
  renderer.setSize window.innerWidth, window.innerHeight
  return

animate = ->
  requestAnimationFrame animate
  renderer.render scene, camera

init = (game) ->
  if WEBGL.isWebGLAvailable() == false
    document.body.appendChild WEBGL.getWebGLErrorMessage()

  initialize()
  setupCanvasDrawing()
  game.three.material = material
  animate()

module.exports =
  init: init
