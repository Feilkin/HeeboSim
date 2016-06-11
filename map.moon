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

	-- gets Objects at given point
	-- NOTE: world coordinates
	getObjectAt: (x, y) =>
		-- TODO: spatial hashing

		for object in *@entities
			for collider in *object.shape
				switch collider.type
					when 'AABB'
						local minx, miny, maxx, maxy
						minx, miny = collider.x, collider.y
						maxx, maxy = minx + collider.width, miny + collider.height

						if x > minx and x < maxy and y > miny and y < maxy
							-- we can return here, since the objects can't overlap
							return object
					else
						error('Unknown collider type: ' .. collider.type)

	checkAABB: (a_min_x, a_min_y, a_max_x, a_max_y, b_min_x, b_min_y, b_max_x, b_max_y) =>
		return a_min_x > b_max_x and a_max_x < b_min_x and a_min_y > b_max_y and a_max_y < b_min_y

	overlaps: (object, other) =>
		-- test if object overlaps with other
		for collider in *object.shape
			for other_collider in *other.shape
				switch collider.type .. '-' .. other_collider.type
					when 'AABB-AABB'
						return @checkAABB collider.x,
							collider.y,
							collider.x + collider.width,
							collider.y + collider.height,
							other_collider.x,
							other_collider.y,
							other_collider.x + other_collider.width,
							other_collider.y + other_collider.height
					else
						error 'No collider for ' .. collider.type .. '-' .. other_collider.type
		return false

	canPlace: (object_class, x, y) =>
		-- check if a object can placed here
		temp_object = object_class(x, y)

		for other in *@objects
			if overlaps(temp_object, other)
				return false

		return true