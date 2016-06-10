---
-- Camera
--

class Camera
	-- locals

	-- class variables

	-- constructor
	new: (width, height) =>
		--
		@x = 0
		@y = 0
		@speed = 200
		@threshold = 128
		@zoom_factor = 1
		@canvas = love.graphics.newCanvas(width, height)
		@width = width
		@height = height

	-- methods

	update: (dt) =>
		local mx, my, ww, wh

		mx, my = love.mouse.getPosition()

		if mx < @threshold
			@x -= ((@threshold - mx)/@threshold) * @speed * dt
		if mx > @width - @threshold
			@x += ((mx - (@width - @threshold)) / @threshold) * @speed * dt

		if my < @threshold
			@y += ((@threshold - my)/@threshold) * @speed * dt
		if my > @height - @threshold
			@y -= ((my - (@height - @threshold)) / @threshold) * @speed * dt
 
	clear: (color) =>
		old_canvas = love.graphics.getCanvas()
		love.graphics.setCanvas(@canvas)
		love.graphics.clear(color)
		love.graphics.setCanvas(old_canvas)

	attach: () =>
		-- save scissor
		@old_scissor = {love.graphics.getScissor()}

		-- save old canvas
		@old_canvas = love.graphics.getCanvas()
		love.graphics.setCanvas(@canvas)

		--love.graphics.setScissor(math.floor(-@x), math.floor(@y), ww, wh)
		love.graphics.setScissor(0, 0, @width, @height)

		love.graphics.push()
		love.graphics.translate(math.floor(-@x), math.floor(@y))
		love.graphics.scale(@zoom_factor, @zoom_factor)

	detach: () =>
		love.graphics.pop()
		-- reset scissor
		love.graphics.setScissor(unpack @old_scissor)
		-- reset canvas
		love.graphics.setCanvas(@old_canvas)

	draw: () =>
		love.graphics.draw(@canvas)

	mouseToWorld: () =>
		local mx, my
		mx, my = love.mouse.getPosition()

		return @x + mx, @y + my

	worldToMouse: () =>
		--
		error 'worldToMouse not implemented'

	zoom: (d) =>
		@zoom_factor += d
		if @zoom_factor < 0
			@zoom_factor = 0