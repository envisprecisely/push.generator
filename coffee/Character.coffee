class Character
	
	@currentIndex = 0
	
	constructor: ( str, probability, index ) ->
		@str = str.toLowerCase()
		@probability = probability
		@index = Character.currentIndex
		Character.currentIndex += 1
