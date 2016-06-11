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
	
	clearState: () =>
		-- called each time the tool is deselected

	initState: () =>
		-- called each time the tool is selected

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

	__tostring: =>
		t = @@__name
		if @current_building
			t ..= ' ['  .. @current_building.__name .. ']'

		return t