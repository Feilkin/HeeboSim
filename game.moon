---
-- Handles game logic
--

-- requires
Camera = require 'camera'
Map = require 'map'
World = require 'world'
ECS = require 'ecs'

class Game
	-- locals

	-- class variables

	-- constructor
	new: () =>
		-- camera for the game
		local camera, ww, wh
		ww, wh = love.graphics.getDimensions()
		camera = Camera(ww, wh)

		@camera = camera

		-- map for the game
		local map
		map = Map()

		@map = map

		-- ECS for the game (holds ppl, needs better name)
		local ecs
		ecs = World()

		@ecs = ecs

		-- flags
		@has_focus = true

	-- methods

	load: =>
		-- crispy pixels
		--love.graphics.setDefaultFilter('nearest', 'nearest', 1)
		-- maybe not?

		-- load settings
		local settings, raw_settings
		raw_settings = love.filesystem.load('settings.lua')

		assert(raw_settings, 'Failed to load settings.lua')

		raw_settings = raw_settings()

		settings = @parseSettings(raw_settings)
		@settings = settings

		-- load data
		@map\loadData()
		@ecs\loadData()

		-- load save
		-- TODO: implement

		-- the world shader
		world_shader_code = love.filesystem.read('world_shader.glsl')

		assert(world_shader_code, 'Failed to load world shader: no contents :(')

		world_shader = love.graphics.newShader(world_shader_code)
		day_cycle_hue = love.graphics.newImage('resources/day_cycle_hues.png')

		world_shader\send('day_cycle_hue', day_cycle_hue)
		world_shader\send('day_time', 0)

		@world_shader = world_shader
		@world_time = 700
		@world_tick_rate = 1
		@_world_time_buffer = 0

		-- load tools
		local tools
		tools = {}

		for tool_name in *{'selection_tool', 'building_tool', 'road_tool'}
			tool = require tool_name
			tools[tool_name] = tool(@)

		@tools = tools
		@current_tool = tools['building_tool']


	parseSettings: (raw_settings) =>
		assert(raw_settings, 'raw_settings == nil')
		return raw_settings

	update: (dt) =>
		if @has_focus
			-- update world time
			@_world_time_buffer += dt

			if @_world_time_buffer >= @world_tick_rate
				ticks = math.floor(@_world_time_buffer / @world_tick_rate)

				if ticks > 1
					print 'Skipping ' .. ticks - 1 .. ' ticks!'

				@world_time += ticks
				if @world_time > 24 * 60
					@world_time = @world_time - 24 * 60

				@_world_time_buffer -= ticks * @world_tick_rate

			@map\update(dt)
			@ecs\update(dt)
			@camera\update(dt)
			@world_shader\send('day_time', @world_time / (24 * 60))

	draw: =>
		@camera\clear({56, 109, 0})
		@camera\attach()
		@map\draw()
		@ecs\draw()
		@camera\detach()
		local old_shader
		old_shader = love.graphics.getShader()
		love.graphics.setShader(@world_shader)
		@camera\draw()
		love.graphics.setShader(old_shader)
		-- TODO: gui
		@current_tool\draw!
		love.graphics.print('Current tool: ' .. tostring(@current_tool), 2, 2)

	selectTool: (tool_name) =>
		old_tool = @current_tool
		tool = @tools[tool_name]
		assert(tool, 'Tool "' .. tool_name .. '" not found!')

		if old_tool
			old_tool\clearState()

		tool\initState()

		@current_tool = tool

		-- TODO: reset tool related input states

	mousefocus: (f) =>
		@had_focus = f

	keypressed: (key, code, istouch) =>
		-- TODO: handle keypresses
		-- get mod keys
		local mods, mod_keys
		mods = ''
		mod_keys = {
			'rctrl', 'lctrl'
			'ralt', 'lalt'
			'rshift', 'lshift'
		}

		for mod_key in *mod_keys
			-- return if mod
			return if mod_key == key

			mods ..= mod_key .. '+' if love.keyboard.isDown(mod_key)

		print mods .. key

		local callback
		callback = @settings.keybindings[mods .. key]

		return if callback and callback(@)

		-- a callback was not found or it returned false
		-- pass the event to current tool

		@current_tool\keypressed(key, code, istouch)

	wheelmoved: (x, y) =>
		-- zooming is disabled because it is broken
		--@camera\zoom(y / 10)

	mousepressed: (x, y, button, istouch) =>
		@current_tool\mousepressed(x, y, button, istouch)

	mousereleased: (x, y, button, istouch) =>
		@current_tool\mousereleased(x, y, button, istouch)

	quit: =>
		return false