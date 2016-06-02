---
-- Camera
--

class Camera
	-- locals

	-- class variables

	-- constructor
	new: () =>
		--
		@x = 0
		@y = 0
		@speed = 100
		@threshold = 64
		@zoom_factor = 1

	-- methods

	update: (dt) =>
		local mx, my, ww, wh

		mx, my = love.mouse.getPosition()
		ww, wh = love.graphics.getDimensions()

		if mx < @threshold
			@x -= ((@threshold - mx)/@threshold) * @speed * dt
		if mx > ww - @threshold
			@x += ((mx - (ww - @threshold)) / @threshold) * @speed * dt

	attach: () =>
		-- save scissor
		@old_scissor = {love.graphics.getScissor()}

		local ww, wh
		ww, wh = love.graphics.getDimensions()

		love.graphics.setScissor(math.floor(-@x), math.floor(@y), ww, wh)

		love.graphics.push()
		love.graphics.translate(math.floor(-@x), math.floor(@y))
		love.graphics.scale(@zoom_factor, @zoom_factor)

	detach: () =>
		love.graphics.pop()
		-- reset scissor
		love.graphics.setScissor(unpack @old_scissor)

	mouseToWorld: () =>
		local mx, my
		mx, my = love.mouse.getPosition()

		return @x + mx, @y + my

	worldToMouse: () =>
		--
		error 'worldToMouse not implemented'

	zoom: (d) =>
		@zoom_factor += d