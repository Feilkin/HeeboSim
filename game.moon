---
-- Handles game logic
--

-- requires
Camera = require 'camera'
Map = require 'map'
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

		-- ECS for the game
		local ecs
		ecs = ECS()

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
		@world_time = 0.5

		-- load tools
		local tools
		tools = {}

		for tool_name in *{'selection_tool', 'building_tool'}
			tool = require tool_name
			tools[tool_name] = tool()


	parseSettings: (raw_settings) =>
		assert(raw_settings, 'raw_settings == nil')
		return raw_settings

	update: (dt) =>
		if @has_focus
			@map\update(dt)
			@ecs\update(dt)
			@camera\update(dt)
			@world_time += dt / 60
			if @world_time >= 1
				@world_time = 0
			@world_shader\send('day_time', @world_time)

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

		return unless callback

		callback(@)

	wheelmoved: (x, y) =>
		@camera\zoom(y / 10)

	mousepressed: (x, y, button, istouch) =>
		--

	mousereleased: (x, y, button, istouch) =>
		--

	quit: =>
		return false