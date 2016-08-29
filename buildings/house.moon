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
			radius: 10
		}
	}

	width: 80
	height: 64

	shape: {
		{
			type: 'AABB'
			x: 0
			y: 0
			width: 80
			height: 64
		}
	}

	beds:  {
		{
			x: 40
			y: 64
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