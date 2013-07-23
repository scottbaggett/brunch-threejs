View = require './view'
template = require './templates/home'

module.exports = class HomeView extends View
  id: 'home-view'
  template: template
  model: new Backbone.Model(muted: false)

  events:
    "click canvas": "addRandomCube"
    "click .muteButton": "toggleMute"

  bindings:
    '.muteButton':
      observe: ['muted']
      onGet: (values) ->
        muted = values[0]
        label = if muted then 'unmute' else 'mute'



  toggleMute: =>
    muted = @model.get('muted')
    @model.set 'muted', !muted

  afterRender: ->
    @initThreeJS()

  initThreeJS: ->
    setTimeout =>
      @initContainer()
      @initScene()
      @initCamera()
      @initRenderer()
      @bindResize()
      @initControls()
      @initStats()
      @addLights()
      @animate()
    , 0

  initContainer: ->
    @container  = document.getElementById( 'container' )

  initScene: ->
    @scene = new THREE.Scene()

  initCamera: ->
    @camera = new THREE.PerspectiveCamera 50, window.innerWidth / window.innerHeight, 1, 4000
    @camera.position.set -1000, -300, -1400

  initRenderer: ->
    @renderer = new THREE.WebGLRenderer antialias: true
    @renderer.setSize window.innerWidth, window.innerHeight
    @renderer.shadowMapEnabled = true
    @renderer.shadowMapSoft = true

  initControls: ->
    @controls  = new THREE.OrbitControls @camera
    @controls.addEventListener 'change', @renderScene

  initStats: () ->
    @stats = new Stats()
    @stats.domElement.style.position = "absolute"
    @stats.domElement.style.top = "0px"
    @stats.domElement.style.zIndex = 100
    @container.appendChild @stats.domElement
    document.getElementById('wrapper').appendChild @renderer.domElement


  addRandomCube: =>
    log "click"
    rndColor = _.shuffle([0xFF0000, 0x00FF00, 0x0000FF])[0]
    rnd = 20 + Math.random() * 40

    geom = new THREE.CubeGeometry rnd, rnd, rnd
    mat = new THREE.MeshPhongMaterial color: rndColor
    mesh = new THREE.Mesh geom, mat

    mesh.position.x = _.shuffle([-400..400])[0]
    mesh.position.y = _.shuffle([-400..400])[0]
    mesh.position.z = _.shuffle([-400..400])[0]
    mesh.castShadow = true
    mesh.randomPower = 1 + (100  * Math.random())
    mesh.receiveShadow = false

    sound   = _.shuffle(['one','two','three','four'])[0]
    s       = new buzz.sound("sounds/#{sound}.ogg");
    s.setVolume(8)
    s.play() if @model.get('muted') is false

    ['x', 'y', 'z'].forEach (axis) ->
      mesh.rotation[axis] = Math.random() * 360

    @addToScene mesh

    # animate the square in from a random point in space.
    tween = new TWEEN.Tween(
        x: _.shuffle([-4000..4000])[0]
        y: _.shuffle([-4000..4000])[0]
        z: _.shuffle([-4000..4000])[0]
        rotationX: mesh.rotation.x
      )
      .to({rotationX: 0, x: mesh.position.x, y: mesh.position.y, z: mesh.position.z}, _.shuffle([500,1800])[0])
      .easing(TWEEN.Easing.Exponential.Out)
      .onUpdate ->
        mesh.rotation.x = this.rotationX
        mesh.position.x = this.x
        mesh.position.y = this.y
        mesh.position.z = this.z
    tween.start()

  addLights: =>
    ambient = new THREE.AmbientLight 0x252525
    @addToScene ambient
    light1 = new THREE.DirectionalLight( 0xffffff )
    light1 = new THREE.DirectionalLight( 0xffffff )
    light1.position.set( 2, 20, 400 )

    @addToScene light1

    light2 = new THREE.DirectionalLight( 0xffffff )
    light2.position.set( -1200, -35, -1200 )

    @addToScene light2


  bindResize: ->
    window.addEventListener  'resize', @onWindowResize, false

  onWindowResize: =>
    @camera.aspect = window.innerWidth / window.innerHeight
    @camera.updateProjectionMatrix()
    @renderer.setSize window.innerWidth, window.innerHeight
    @renderScene()

  renderScene: =>
    @renderer.render @scene, @camera

  addToScene: (mesh) =>
    @scene.add mesh

  animate: =>
    requestAnimationFrame @animate
    @stats.update()
    window.TWEEN?.update()
    @controls?.update()
    @renderScene()

