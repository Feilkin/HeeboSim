---
--
--

class DirtRoad
	aas: 'road.lua'
	animated: false

	sockets: {
		road_node: {
			x: 0
			y: 0
		}
	}

	new: () =>
		@x = 0
		@y = 0
		@width = 10