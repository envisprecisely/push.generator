class CharacterList
	
	constructor: ->
		@chars = []
		
		@chars.push new Character( "a", 0.0651 )
		@chars.push new Character( "b", 0.0189 )
		@chars.push new Character( "c", 0.0306 )
		@chars.push new Character( "d", 0.0508 )
		@chars.push new Character( "e", 0.1740 )
		@chars.push new Character( "f", 0.0166 )
		@chars.push new Character( "g", 0.0301 )
		@chars.push new Character( "h", 0.0476 )
		@chars.push new Character( "i", 0.0755 )
		@chars.push new Character( "j", 0.0027 )
		@chars.push new Character( "k", 0.0121 )
		@chars.push new Character( "l", 0.0344 )
		@chars.push new Character( "m", 0.0253 )
		@chars.push new Character( "n", 0.0978 )
		@chars.push new Character( "o", 0.0251 )
		@chars.push new Character( "p", 0.0079 )
		@chars.push new Character( "q", 0.0002 )
		@chars.push new Character( "r", 0.0700 )
		@chars.push new Character( "s", 0.0727 )
		@chars.push new Character( "ß", 0.0031 )
		@chars.push new Character( "t", 0.0615 )
		@chars.push new Character( "u", 0.0435 )
		@chars.push new Character( "v", 0.0067 )
		@chars.push new Character( "w", 0.0189 )
		@chars.push new Character( "x", 0.0003 )
		@chars.push new Character( "y", 0.0004 )
		@chars.push new Character( "z", 0.0113 )
		
		
	getCharacter: ( inputString ) ->
		char = @chars.filter ( c ) ->
			if c.str is inputString.toLowerCase()
				return c
		return char
	
	maxProbability: ->
		max = @chars[0]
		
		_( @chars ).each ( item ) =>
			if item.probability > max.probability
				max = item
		
		return max.probability