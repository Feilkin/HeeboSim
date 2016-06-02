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
		local camera
		camera = Camera()

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

	parseSettings: (raw_settings) =>
		assert(raw_settings, 'raw_settings == nil')
		return raw_settings

	update: (dt) =>
		if @has_focus
			@map\update(dt)
			@ecs\update(dt)
			@camera\update(dt)

	draw: =>
		@camera\attach()
		@map\draw()
		@ecs\draw()
		love.graphics.print('testi testi testi')
		@camera\detach()
		-- TODO: gui

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

	mousemoved: (x, y) =>
		@camera\zoom(y / 10)

	mousepressed: (x, y, button, istouch) =>
		--

	mousereleased: (x, y, button, istouch) =>
		--

	quit: =>
		return false