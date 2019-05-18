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
object = undefined

initialize = ->
  camera = new (THREE.PerspectiveCamera)(50, window.innerWidth / window.innerHeight, 1, 2000)
  scene = new (THREE.Scene)
  material = new (THREE.MeshBasicMaterial)
  plane = new (THREE.Mesh)(new (THREE.PlaneBufferGeometry)(300, 150), material)
  scene.add(plane)
  plane.scale.x = 0.7
  plane.scale.y = 0.8
  plane.scale.z = 0.78
  plane.rotation.x = -0.4
  plane.position.x = -1
  plane.position.y = -64
  plane.position.z = -327

  ambientLight = new (THREE.AmbientLight)(0xcccccc, 0.3)
  scene.add ambientLight
  pointLight = new (THREE.PointLight)(0xffffff, 0.7)
  scene.add pointLight

  onProgress = (xhr) ->
    if xhr.lengthComputable
      percentComplete = xhr.loaded / xhr.total * 100
      console.log Math.round(percentComplete, 2) + '% downloaded'

  onError = ->
    console.log 'import error'

  THREE.Loader.Handlers.add /\.dds$/i, new (THREE.DDSLoader)
  (new (THREE.MTLLoader)).setPath('models/').load 'table.mtl', (materials) ->
    materials.preload()
    (new (THREE.OBJLoader)).setMaterials(materials).setPath('models/').load 'table.obj', ((object) ->
      object.position.x = 20
      object.position.y = -100
      object.position.z = -350
      object.scale.x = object.scale.y = object.scale.z = 1.9
      scene.add object
    ), onProgress, onError

  geometry3 = new (THREE.SphereGeometry)(2)
  material3 = new (THREE.MeshBasicMaterial)(color: 0x00ff00)
  sphere = new (THREE.Mesh)(geometry3, material3)
  scene.add(sphere)
  sphere.position.y = 80
  sphere.position.z = -405

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
  hintMesh.position.y = 40
  hintMesh.position.z = -220

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
  inputMesh.position.y = 15
  inputMesh.position.z = -200

updateText = (opts)->
  opts.input = '...' if opts.input == ''
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

  if camera.rotation.x < -0.8
    camera.rotation.x = -0.8
  else if camera.rotation.x > 0.8
    camera.rotation.x = 0.8

  if camera.rotation.y < -0.6
    camera.rotation.y = -0.6
  else if camera.rotation.y > 0.6
    camera.rotation.y = 0.6

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
