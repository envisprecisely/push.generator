# 
#  push.coffee
#  coffee
#  
#  Created by Philipp Sackl on 2012-04-20.
# 

class window.PushGenerator
	
	constructor: ( parentNode, inputField, w, h, @autorotate=yes ) ->
		@cubes = null
		@renderer = null
		@lights = []
		@cubeContainer = null
		@cubeController = null
		@parentNode = parentNode
		@inputField = inputField
		
		this.init w, h
	
		@renderer = new THREE.CanvasRenderer
		@renderer.setSize w, h
		#@renderer.shadowMapEnabled = true
		#@renderer.shadowMapSoft = true
		
		$( @parentNode ).append @renderer.domElement
		
		this.setupListeners()
		
		this.animate()
	
	init: ( w, h ) ->
		@scene = new THREE.Scene
	
		@camera = new THREE.PerspectiveCamera 75, w / h, 1, 10000
		@camera.position.z = 1000
		@scene.add @camera
	
		@scene.add new THREE.AmbientLight( 0x999999 )
	
		this.setupLights()
	
		@cubeContainer = new THREE.Object3D
		@cubes = new CubeOfCubes( 3, 150, 0 )
		@cubes.addToScene @cubeContainer
		
		@scene.add @cubeContainer
	
		@cubeController = new CubeController( @cubes )
		@cubes.callback = @cubeController.next
		
	reset: ->
		@scene.remove @cubeContainer
		@cubeContainer = new THREE.Object3D
		@cubes = new CubeOfCubes( 3, 150, 0 )
		@cubeController = new CubeController( @cubes )
		@cubes.addToScene @cubeContainer
		@scene.add @cubeContainer
		$( @inputField ).val( '' )
		
	

	setupLights: ->
		@lights[0] = new THREE.AmbientLight 0x333333
	    
		@lights[1] = new THREE.PointLight 0xdddddd, 1, 500
		@lights[1].shadowCameraVisible = true
		@lights[1].position.z = 0
		@lights[1].position.x = -500
		@lights[1].position.y = 0
	    
		@lights[2] = new THREE.PointLight 0xdddddd, 1, 500
		@lights[2].shadowCameraVisible = true
		@lights[2].position.z = 0
		@lights[2].position.x = 0
		@lights[2].position.y = 500
	    
		@lights[3] = new THREE.PointLight 0xdddddd, 1, 500
		@lights[3].shadowCameraVisible = true
		@lights[3].position.z = 0
		@lights[3].position.x = 0
		@lights[3].position.y = -500
	    
		@lights[4] = new THREE.PointLight 0xdddddd, 1, 500
		@lights[4].shadowCameraVisible = true
		@lights[4].position.z = 500
		@lights[4].position.x = 0
		@lights[4].position.y = 0
	    
		@lights[5] = new THREE.PointLight 0xdddddd, 1, 500
		@lights[5].shadowCameraVisible = true
		@lights[5].position.z = 0
		@lights[5].position.x = 500
		@lights[5].position.y = 0
		
		@scene.add @lights[0]
		@scene.add @lights[1]
		@scene.add @lights[2]
		@scene.add @lights[3]
		@scene.add @lights[4]
		@scene.add @lights[5]
	
	
	setupListeners: =>
		#dragging
		$( @parentNode ).on 'mousemove touchmove', ( event ) =>
			if @clicked
				@cubeContainer.rotation.y += ( event.clientX - @refX ) / 200
				@cubeContainer.rotation.x += ( event.clientY - @refY ) / 200
			@refX = event.clientX
			@refY = event.clientY
		
		#clicking
		$( @parentNode ).on 'mousedown touchstart', ( event ) =>
			@clicked = true
		$( @parentNode ).on 'mouseup touchend', ( event ) =>
			@clicked = false
			$( '#gen-input' ).focus()
		
		# typing
		$( @inputField ).on 'keyup', ( event ) =>
			# should reset here if the key is backspace
			if event.keyCode is 8
				@reset()
			else
				@cubeController.setString $( event.target ).attr( 'value' )
			
			# update the URL so it can be copied and shared
			# replace spaces with _
			text = $( event.target ).attr( 'value' ).split( ' ' ).join( '_' )
			url = location.protocol + '//' + location.host + location.pathname + '?push=' + encodeURIComponent( text )
			rawUrl = location.protocol + '//' + location.host + location.pathname + '?push=' + text
			window.history.replaceState( null, "push.generator: #{text}", url )
			$( 'a.fb-share' ).attr( 'href', 'https://www.facebook.com/sharer/sharer.php?u=' + url )
			$( 'a.tw-share' ).attr( 'href', 'https://twitter.com/share?text=I created something with the push.generator!' )
			
			
		
		# sharing is caring
		# if those tags are present in the HTML, add custom sharing methods
		$( 'a.fb-share' ).on 'click', ( event ) ->
			event.preventDefault()
			window.open $(this).attr('href'), "Share on Facebook", "width=640,height=320,scrollbars=no"
		
		$( 'a.tw-share' ).on 'click', ( event ) ->
			event.preventDefault()
			window.open $(this).attr('href'), "Share on Twitter", "width=640,height=320,scrollbars=no"
		
		# image exporting
		$( 'button#gen-share' ).on 'click', ( event ) =>
			elem = $( 'canvas' )[0]
			img = Canvas2Image.saveAsPNG elem, elem.width, elem.height

	animate: =>
		unless @clicked or not @autorotate
			@cubeContainer.rotation.y += 0.001
			@cubeContainer.rotation.x += 0.0015
			
		requestAnimationFrame this.animate
		this.render()
	
	
	render: ->
		@cubes.updatePositions()
		@renderer.render @scene, @camera
	
	

window.getURLVars = ->
    vars = {}
    parts = window.location.href.replace /[?&]+([^=&]+)=([^&]*)/gi, ( m,key,value ) ->
        vars[key] = value
    return vars
	
	
	
