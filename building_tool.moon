---
-- Building Tool
--  Allows player to place buildings into the game world
--

class BuildingTool
	new: (game) =>
		---
		@game = game
		@building_binds = {
			'1': 'CoalPlant'
			'2': 'House'
		}
		@buildings = game.map.buildings
		@current_building = @buildings['House']
		@drag = false
	
	clearState: () =>
		-- called each time the tool is deselected
		@drag = false

	initState: () =>
		-- called each time the tool is selected
		@drag = false

	currentBuildingFitsInDrag: =>
		mx, my = love.mouse.getPosition()
		return (math.abs(mx - @drag.start_x) > @current_building.width) and (math.abs(my - @drag.start_y) > @current_building.height)

	draw: =>
		mx, my = love.mouse.getPosition()
		zf = @game.camera.zoom_factor

		wx, wy = @game.camera\screenToWorld(mx, my)
		-- center the object
		wx -= @current_building.width/2
		wy -= @current_building.height/2
		wx, wy = @game.map\snapToGrid(wx, wy)
		old_color = {love.graphics.getColor()}

		sx, sy = @game.camera\worldToScreen(wx, wy)

		sx, sy = math.floor(sx), math.floor(sy)


		if @game.map\canPlace(@current_building, wx, wy)
			love.graphics.setColor(0, 255, 0, 128)
		else
			love.graphics.setColor(255, 0, 0, 128)

		love.graphics.draw(@current_building.preview_image, sx, sy, 0, zf, zf)
		love.graphics.setColor(old_color)


	keypressed: (key, code, istouch) =>
		--
		building_name = @building_binds[key]
		return false unless building_name
		building_class = @buildings[building_name]
		if not building_class
			print @@__name .. ': No Building named "' .. building_name .. '"'
			return false

		@current_building = building_class
		return true

	mousepressed: (x, y, button, istouch) =>
		--

	mousereleased: (x, y, button, istouch) =>
		print 'mousepressed: ', x , y, button
		wx, wy = @game.camera\screenToWorld(x, y)
		wx -= @current_building.width/2
		wy -= @current_building.height/2
		wx, wy = @game.map\snapToGrid(wx, wy)

		building_class = @current_building

		if @game.map\canPlace(building_class, wx, wy)
			new_building = building_class(wx, wy)
			@game.map\addEntity(new_building)

		@drag = false

	__tostring: =>
		t = @@__name
		if @current_building
			t ..= ' ['  .. @current_building.__name .. ']'

		return t