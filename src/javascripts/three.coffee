camera = undefined
scene = undefined
renderer = undefined
plane = undefined
material = undefined

initialize = ->
  camera = new (THREE.PerspectiveCamera)(50, window.innerWidth / window.innerHeight, 1, 2000)
  scene = new (THREE.Scene)
  material = new (THREE.MeshBasicMaterial)
  plane = new (THREE.Mesh)(new (THREE.PlaneBufferGeometry)(300, 150), material)
  scene.add(plane)
  plane.position.z = -400
  renderer = new (THREE.WebGLRenderer)(antialias: true)
  renderer.setPixelRatio window.devicePixelRatio
  renderer.setSize window.innerWidth, window.innerHeight
  document.body.appendChild renderer.domElement
  window.addEventListener 'resize', onWindowResize, false

  controls = new THREE.PointerLockControls( camera )
  window.addEventListener( 'click', () ->
    controls.lock()
  , false )

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

animate = ->
  requestAnimationFrame animate

  if camera.rotation.x < -0.7
    camera.rotation.x = -0.7
  else if camera.rotation.x > 0.7
    camera.rotation.x = 0.7

  if camera.rotation.y < -0.5
    camera.rotation.y = -0.5
  else if camera.rotation.y > 0.5
    camera.rotation.y = 0.5

  camera.rotation.z = 0

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
