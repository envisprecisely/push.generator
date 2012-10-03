# Transition Base Class
class Transition
	constructor: ( @object, @property, @target, @duration, @callback ) ->
		@begin = @object[ @property ]
		@count = 0
		
	iterate: ->
		@count += 1
		percentage = @count / @duration
		@object[ @property ] = @begin + ( @target - @begin ) * percentage
		
		this.finished() if @count == @duration
		
	finished: ->
		# remove from the group if there is one, otherwise use the TransitionManager itself
		if @group?
			@group.remove this
		else
			TransitionManager.remove this


# Group multiple transitions to trigger just one callback when all of them are finished
class TransitionGroup
	constructor: ( objects, @callback ) ->
		@objects = _.flatten objects
		_( @objects ).each ( transition ) =>
			transition.group = this
	
	iterate: ->
		_( @objects ).each ( transition ) ->
			transition.iterate()
	
	remove: ( transition ) ->
		_( @objects ).each ( item, index ) =>
			if item is transition
				@objects.splice index, 1
		
		if @objects.length is 0
			TransitionManager.remove this
			@callback()
		


# Global Transition Manager that directs all transitions in the scene
TransitionManager =
	transitions: []
	isIdle: yes
	
	update: ->
		_( TransitionManager.transitions ).each ( transition ) ->
			transition.iterate() if transition?
	
	add: ( transition ) ->
		TransitionManager.transitions.push transition
		TransitionManager.isIdle = no
	
	remove: ( transition ) ->
		_( TransitionManager.transitions ).each ( item, index ) =>
			if item is transition
				TransitionManager.transitions.splice index, 1
		TransitionManager.isIdle = yes if TransitionManager.transitions.length is 0





#mapBetween = ( input, lowIn, highIn, lowOut, highOut ) ->
#	return ( ( input-lowIn ) / ( highIn-lowIn ) * ( highOut - lowOut ) + lowOut )
