camera = undefined
scene = undefined
renderer = undefined
plane = undefined
material = undefined
controls = undefined
font = undefined
textMaterial = undefined
hintMesh = undefined
inputMesh = undefined

initialize = ->
  camera = new (THREE.PerspectiveCamera)(50, window.innerWidth / window.innerHeight, 1, 2000)
  scene = new (THREE.Scene)
  material = new (THREE.MeshBasicMaterial)
  plane = new (THREE.Mesh)(new (THREE.PlaneBufferGeometry)(300, 150), material)
  scene.add(plane)
  plane.position.z = -400

  geometry2 = new (THREE.BoxGeometry)(320, 170, 10)
  material2 = new (THREE.MeshBasicMaterial)(color: 0x121212)
  cuboid = new (THREE.Mesh)(geometry2, material2)
  scene.add(cuboid)
  cuboid.position.z = -410

  renderer = new (THREE.WebGLRenderer)(antialias: true)
  renderer.setPixelRatio window.devicePixelRatio
  renderer.setSize window.innerWidth, window.innerHeight
  document.body.appendChild renderer.domElement
  window.addEventListener 'resize', onWindowResize, false

  createTexts()

  controls = new THREE.PointerLockControls( camera )
  renderer.domElement.addEventListener('click', (e) ->
    controls.lock()
  , false )

createTexts = ->
  loader = new (THREE.FontLoader)
  loader.load 'fonts/helvetiker_regular.typeface.json', (f) ->
    font = f
    textMaterial = new THREE.MeshBasicMaterial(color: 0xbbbbbb)

    createHintText(font, textMaterial)
    createInputText(font, textMaterial)

createHintText = (font, material, str) ->
  hintGeo = new (THREE.TextGeometry)(str || 'What am I going to do today?',
    font: font
    size: 10
    height: 4
    curveSegments: 12)
  hintMesh = new THREE.Mesh( hintGeo, textMaterial )
  scene.add(hintMesh)
  hintMesh.geometry.center()
  hintMesh.position.x = 0
  hintMesh.position.y = -25
  hintMesh.position.z = -200

createInputText = (font, material, str) ->
  inputGeo = new (THREE.TextGeometry)(str || '...',
    font: font
    size: 16
    height: 5
    curveSegments: 12)
  inputMesh = new THREE.Mesh( inputGeo, textMaterial )
  scene.add(inputMesh)
  inputMesh.geometry.center()
  inputMesh.position.x = 0
  inputMesh.position.y = -40
  inputMesh.position.z = -200

updateText = (opts)->
  if opts.hint
    scene.remove hintMesh
    createHintText(font, material, opts.hint)
  if opts.input
    scene.remove inputMesh
    createInputText(font, material, opts.input)

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
  game.three.controls = controls
  game.three.updateText = updateText
  animate()

module.exports =
  init: init
