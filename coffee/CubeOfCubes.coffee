class CubeOfCubes
	constructor: ( @numberOfRows, @cubeSize=100, @spacing=30, @callback ) ->
		@obj = new THREE.Object3D
		@counter = 0
		@duration = 10
		@cubes = [1..@numberOfRows].map ( row, x ) =>
			return [1..@numberOfRows].map ( col, y ) =>
				return [1..@numberOfRows].map ( item, z ) =>
					nx = x-1
					ny = y-1
					nz = z-1
					cube = new Cube( @cubeSize, x+y+z )
					cube.id.x = x
					cube.id.y = y
					cube.id.z = z
					cube.castShadow = true
					cube.receiveShadow = true
					cube.mesh.position.x = (@cubeSize+@spacing)*-@numberOfRows/2 + (@cubeSize+@spacing) * nx
					cube.mesh.position.y = (@cubeSize+@spacing)*-@numberOfRows/2 + (@cubeSize+@spacing) * ny
					cube.mesh.position.z = (@cubeSize+@spacing)*+@numberOfRows/2 + (@cubeSize+@spacing) * nz
					@obj.add cube.mesh
					return cube
		@obj.position.x = ( (@cubeSize + @spacing) * (numberOfRows) ) / 2
		@obj.position.y = ( (@cubeSize + @spacing) * (numberOfRows) ) / 2
		@obj.position.z = ( (@cubeSize + @spacing) * (numberOfRows) ) / -2
	
	updatePositions: ->
		@counter += 1
		TransitionManager.update()
		
	###	if @counter % @duration == 0
			rand = Math.random()
			this.pushRow( 
				if rand > 0.33 then Math.round( Math.random()*@numberOfRows+1 )-1 else -1,
				if rand < 0.66 then Math.round( Math.random()*@numberOfRows+1 )-1 else -1,
				if rand < 0.33 or rand > 0.66 then Math.round( Math.random()*@numberOfRows+1 )-1 else -1
			)
	###
	
	pushRandom: ->
		rand = Math.random()
		this.pushRow( 
			if rand > 0.33 then Math.floor( Math.random()*@numberOfRows ) else null,
			if rand < 0.66 then Math.floor( Math.random()*@numberOfRows ) else null,
			if rand < 0.33 or rand > 0.66 then Math.floor( Math.random()*@numberOfRows ) else null
		)
		
	
	pushRow: ( x, y, z, factor = 0 ) ->
		flat = _.flatten @cubes
		if factor is 0
			factor = (1 - Math.round( Math.random() ) * 2)
		
		transitions = []
		
		_.each flat, ( cube, index ) =>
			if x? and y?
				if cube.id.x == x and cube.id.y == y
				#	console.log "had z id #{cube.id.z} and position #{cube.mesh.position.z}"
					cube.id.z += factor
					transitions.push new Transition( 
											cube.mesh.position, 
											'z', 
											cube.mesh.position.z + ( @cubeSize + @spacing ) * factor,
											@duration, null )
				#	console. log " => now has z #{cube.id.z} and position #{cube.mesh.position.z}"
			
			if x? and z?
				if cube.id.x == x and cube.id.z == z
				#	console.log "had y id #{cube.id.y}"
					cube.id.y += factor
				#	console. log " => now has y #{cube.id.y}"
					transitions.push new Transition( 
											cube.mesh.position, 
											'y', 
											cube.mesh.position.y + ( @cubeSize + @spacing ) * factor,
											@duration, null )
					
			
			if y? and z?
				if cube.id.y == y and cube.id.z == z
				#	console.log "had x id #{cube.id.x}"
					cube.id.x += factor
				#	console. log " => now has x #{cube.id.x}"
					transitions.push new Transition( 
											cube.mesh.position, 
											'x', 
											cube.mesh.position.x + ( @cubeSize + @spacing ) * factor,
											@duration, null )
			
		return transitions
			
				
	
	addToScene: ( scene ) ->
	#	cube.addToScene scene for cube in _.flatten @cubes
		scene.add @obj





class Cube
	constructor: ( @size, count = 0 ) ->
		@id = x: 0, y:0, z:0
		@geometry = new THREE.CubeGeometry @size, @size, @size
		if ( count % 4 == 0 )
			@material = new THREE.MeshLambertMaterial { color: 0xcc0066, opacity: 0.8, shading: THREE.FlatShading, overdraw: true }
		else
			@material = new THREE.MeshLambertMaterial { color: 0xffffff, opacity: 0.8, shading: THREE.FlatShading, overdraw: true }
			
		
		@mesh = new THREE.Mesh @geometry, @material
		@mesh.castShadow = true
		@mesh.receiveShadow = true
	
	addToScene: ( scene ) ->
		scene.add @mesh





