---
-- HeeboSim Demo 2016
--

-- requires

Game = require 'game'

-- local vars

local game

-- love callback bindings

love.load = ->
	game = Game()
	game\load()

love.update = (dt) ->
	game\update(dt)

love.draw = ->
	game\draw()

love.focus = (f) ->
	--

love.keypressed = (key, code, isrepeat) ->
	game\keypressed(key, code, isrepeat)

love.keyreleased = (key, code) ->
	--

love.mousefocus = (f) ->
	game\mousefocus(f)

love.mousemoved = (x, y, dx, dy) ->
	--

love.mousepressed = (x, y, button, istouch) ->
	game\mousepressed(x, y, button, istouch)

love.mousereleased = (x, y, button, istouch) ->
	game\mousereleased(x, y, button, istouch)

love.quit = ->
	game\quit()

love.resize = (w, h) ->
	game\resize(w, h)

love.textinput = (text) ->
	--

love.visible = (v) ->
	--

love.wheelmoved = (x, y) ->
	game\mousemoved(x, y)

