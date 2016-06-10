---
-- Holds Objects
--

ECS = require 'ecs'
AAS = require 'aas'

class Map extends ECS
	-- game specifig map class
	-- defines its systems

	-- system definitions

	AnimationSystem = require 'ecs.systems.animation_system'

	class NavmeshSystem
		-- disabled until i figure this out lol
		filter: ECS.filters.empty!

		update: () ->
			--

	-- constructor

	new: () =>
		--
		super {
			AnimationSystem
			NavmeshSystem
		}, {
			AnimationSystem
		}

	loadData: () =>
		-- preload building data
		-- holds the building classes
		buildings = {}
		-- TODO: make recursive (for sort of mod support)
		building_resource_prefix = 'resources/assets/buildings/'
		building_prefix = 'buildings/'
		items = love.filesystem.getDirectoryItems(building_prefix)
		print 'Loading buildings from ' .. building_prefix
		for item in *items
			if (not love.filesystem.isFile(building_prefix .. item)) or not (item\sub(-4) == '.lua')
				continue 

			print ' - loading building from ' .. item

			chunk = love.filesystem.load(building_prefix .. item)
			assert(chunk, 'Failed to load building: ' .. item)
			building = chunk()
			if building.aas
				aas = AAS.fromFile(building.aas, building_resource_prefix)
				-- dirty dirty code
				building.__base.aas = aas

			print ' - loaded building "' .. building.__name .. '"'
			buildings[building.__name] = building

		@addEntity(buildings['CoalPlant'](6, 6))
		@buildings = buildings
