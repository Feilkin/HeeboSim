---
--
--

class House
	aas: 'house.lua'
	animated: true
	sockets: {
		entrance: {
			x: 40
			y: 64
		}
	}

	new: () =>
		@x = 0
		@y = 0