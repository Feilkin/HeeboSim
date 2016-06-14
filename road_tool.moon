---
-- Road Tool
--  Builds road
--

class RoadTool
	new: (game) =>
		---
		@game = game
		@starting_socket = nil
	
	clearState: () =>
		--
		@game.map.data.draw_sockets = false
		@starting_socket = nil

	initState: () =>
		--
		@game.map.data.draw_sockets = true
		@starting_socket = nil

	draw: =>
		if @starting_socket
			-- draw line from @starting_socket to mouse pos
			start_x = @starting_socket.building.x + @starting_socket.socket.x
			start_y = @starting_socket.building.y + @starting_socket.socket.y

			start_x, start_y = @game.camera\worldToScreen(start_x, start_y)

			-- TODO: clean up this mess
			end_x, end_y = love.mouse.getPosition()

			wx, wy = @game.camera\screenToWorld(end_x, end_y)

			building, name, end_socket = @game.map\getSocketAt(wx, wy)

			if end_socket
				end_x = building.x + end_socket.x
				end_y = building.y + end_socket.y
			else
				end_x, end_y = @game.map\snapToGrid(wx, wy, true)

			end_x, end_y = @game.camera\worldToScreen(end_x, end_y)

			love.graphics.line(start_x, start_y, end_x, end_y)

	mousepressed: (x, y, button, istouch) =>
		wx, wy = @game.camera\screenToWorld(x, y)

		building, name, socket = @game.map\getSocketAt(wx, wy)

		return unless building and name and socket

		@starting_socket = {
			socket: socket
			name: name
			building: building
		}

	mousereleased: (x, y, button, istouch) =>
		return unless @starting_socket
		wx, wy = @game.camera\screenToWorld(x, y)
		local building, name, socket
		building, name, socket = @game.map\getSocketAt(wx, wy)

		if not socket
			-- no socket found at this point, add a road node
			-- TODO: implement multiple road types?
			-- roads snap to grid
			wx, wy = @game.map\snapToGrid(wx, wy, true)

			building_class = @game.map.buildings['DirtRoad']

			if not @game.map\canPlace(building_class, wx, wy)
				-- could not place new road node
				@starting_socket = nil
				return

			road_node = building_class(wx, wy)
			@game.map\addEntity(road_node)

			building = road_node
			-- TODO: incoming, outgoing?
			name = 'road_node'
			socket = road_node.sockets[name]

		-- add the connection
		-- TODO: one way roads?


		starting_socket = @starting_socket

		starting_socket.socket.connections or= {}
		socket.connections or= {}

		print 'connecting "' .. starting_socket.name .. '" of ' .. tostring(starting_socket.building) .. ' to "' .. name .. '" of ' .. tostring(building)

		table.insert starting_socket.socket.connections,
			{
				socket: socket
				name: name
				building: building
			}

		table.insert socket.connections, 
			{
				socket: starting_socket.socket
				name: starting_socket.name
				building: starting_socket.building
			}

		@starting_socket = nil

	keypressed: (key, code,  isrepeat) =>
		--

	__tostring: =>
		return @@__name