---
--
--

class DirtRoad
	aas: 'road.lua'
	animated: false
	road: true

	sockets: {
		road_node: {
			x: 0
			y: 0
			radius: 10
		}
	}

	shape: {
		{
			type: 'AABB'
			x: -10
			y: -10
			width: 20
			height: 20
		}
	}

	new: (x, y) =>
		@x = x or 0
		@y = y or 0

		@sockets = {}
		for name, socket in pairs @@sockets
			@sockets[name] = {
				x: socket.x
				y: socket.y
				radius: socket.radius
				connections: {}
			}