---
--
--

class CoalPlant
	aas: 'coalplant.lua'
	animated: true
	shape: {
		{
			type: 'AABB'
			x: 0
			y: 0
			width: 176
			height: 96
		}
	}

	width: 176
	height: 96

	sockets: {
		entrance: {
			x: 0
			y: 72
			radius: 10
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