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


	class SocketRenderer
		filter: ECS.filters.all_of {sockets: true}

		draw: (entities, data) ->
			if data.draw_sockets
				for object in *entities
					for name, socket in pairs object.sockets
						x = object.x + socket.x
						y = object.y + socket.y
						r = socket.radius or 10

						love.graphics.circle('line', x, y, r)

						-- draw connections
						if socket.connections
							for connection in *socket.connections
								ob = connection.building
								os = connection.socket
								love.graphics.line(x, y, ob.x + os.x, ob.y + os.y)

	-- constructor

	new: () =>
		--
		super {
			AnimationSystem
			NavmeshSystem
		}, {
			AnimationSystem
			SocketRenderer
		}

		@data.draw_sockets = false
		@data.highlight_object = false

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

			-- build preview image
			if building.aas
				preview_name = building.preview_animation or 'default'
				preview_animation = building.aas\getAnimation(preview_name)
				-- TODO: maybe add a way to animate? do we need that?
				preview_frame = preview_animation.frames[1]

				preview_canvas = love.graphics.newCanvas(preview_animation.width, preview_animation.height)

				-- draw the animation to the canvas
				old_canvas = love.graphics.getCanvas()
				love.graphics.setCanvas(preview_canvas)
				for a in *preview_frame.assets
					love.graphics.draw(a.sheet, a.quad, a.x, a.y)
				love.graphics.setCanvas(old_canvas)
				preview_image = love.graphics.newImage(preview_canvas\newImageData())
				building.preview_image = preview_image
			else
				error 'Failed to build preview image for "' .. building.__name .. '": no AAS'

			print ' - loaded building "' .. building.__name .. '"'
			buildings[building.__name] = building

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

	getSocketAt: (x, y) =>
		for object in *@entities
			for name, socket in pairs object.sockets
				if math.sqrt((x - (object.x + socket.x))^2 + (y - (object.y + socket.y))^2) < socket.radius
					return object, name, socket

	checkAABB: (a_min_x, a_min_y, a_max_x, a_max_y, b_min_x, b_min_y, b_max_x, b_max_y) =>
		return a_min_x < b_max_x and a_max_x > b_min_x and a_min_y < b_max_y and a_max_y > b_min_y

	overlaps: (object, other) =>
		-- test if object overlaps with other
		for collider in *object.shape
			for other_collider in *other.shape
				switch collider.type .. '-' .. other_collider.type
					when 'AABB-AABB'
						return @checkAABB object.x + collider.x,
							object.y + collider.y,
							object.x + collider.x + collider.width,
							object.y + collider.y + collider.height,
							other.x + other_collider.x,
							other.y + other_collider.y,
							other.x + other_collider.x + other_collider.width,
							other.y + other_collider.y + other_collider.height
					else
						error 'No collider for ' .. collider.type .. '-' .. other_collider.type
		return false

	canPlace: (object_class, x, y) =>
		-- check if a object can placed here
		temp_object = object_class(x, y)

		for other in *@entities
			if @overlaps(temp_object, other)
				return false

		return true

	snapToGrid: (wx, wy) =>
		return wx - (wx % 16), wy - (wy % 16)