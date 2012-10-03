class CubeController
	
	constructor: ( cube ) ->
		@cube = cube
		@currentSide = 0
		@chars = new CharacterList()
		@maxProbability = @chars.maxProbability()
		@charCount = 0
		@queue = ''
		@pos = 0
	
	
	setString: ( str ) ->
	#	console.log "setting string: #{str}"
		# append new letters
		
		unless @pos < @queue.length
			@pos = 0
			unless @queue.length is 0
				while str.charAt( @pos ) is @queue.charAt( @pos )
					break if @queue.charAt( @pos ) is '' or str.charAt( @pos ) is ''
					@pos += 1
		
		@queue = str
	#	console.log "set: #{@pos}"
		
		this.next() if TransitionManager.isIdle
	
	next: =>
		if @pos < @queue.length
			this.pushCharacter @queue.charAt @pos
			@pos += 1
	#	console.log "next: #{@pos}"
		
		
	pushCharacter: ( char ) ->
		c = @chars.getCharacter( char )[ 0 ]
		
		# default to e, if the character is not mapped
		unless c?
			c = @chars.getCharacter( 'e' )[ 0 ]
		
		# calculate the number of rows that should be pushed
		frequency = @cube.numberOfRows - Math.floor( Math.sqrt( c.probability ) / Math.sqrt( @maxProbability ) * (@cube.numberOfRows-1) )
		
		direction = ( @charCount % 2 ) * 2 - 1
		before = 2
		before = @currentSide-1 unless @currentSide is 0
		after = 0
		after = @currentSide+1 unless @currentSide is 2
		
		transitions = []
		
		for i in [ 0...frequency ]
			args = [ 0, 0, 0 ]
			args[ @currentSide ] = null
			args[ before ] = i
			args[ after ] =  c.index % @cube.numberOfRows
				
			transitions.push @cube.pushRow( args[0], args[1], args[2], direction )
		
		TransitionManager.add new TransitionGroup transitions, this.next
		
		@currentSide += 1
		@currentSide = 0 if @currentSide == 3
		@charCount++
		