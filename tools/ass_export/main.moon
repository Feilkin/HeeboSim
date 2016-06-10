---
-- Animation aSset System (ASS) Editor/exporter
--

-- input handling

input_state = {
	buffer: ''
	state: 'idle'
	status_text: 'drop images to begin'
}

images = {}
animations = {}
local current_animation, current_frame

get_input = (pattern, callback) ->
	input_state.state = 'get_input'
	input_state.input_pattern = pattern
	input_state.callback = callback

love.textinput = (text) ->
	input_state.buffer ..= text

love.filedropped = (file) ->
	image = love.graphics.newImage(file)

	assert(image, 'failed to load image!')

	iw, ih = image\getDimensions()

	table.insert(images, {
		image: image
		name: 'img-' .. #images
		width: iw
		height: ih
	})

	input_state.status_text = 'image loaded, press [a] to create new animation'

love.keypressed = (key, code, isrepeat) ->
	switch input_state.state
		when 'idle'
			switch key
				when 'escape'
					love.event.quit()
				when 'a'
					-- create new animation
					get_input '.+', (name) ->
						new_anim = {
							name: name
							frames: {}
							flags: {}
						}

						table.insert(animations, new_anim)
						current_animation = new_anim

						input_state.status_text = 'animation created, press [f] to add frames to the animation'
						input_state.state = 'idle'

				when 's'
					-- export asset sheet and animation files
					export_all()
				when 'f'
					-- add a new frame to current animation
					if not current_animation
						input_state.status_text = 'select a animation first!'
						return

					new_frame = {
						assets: {}
						flags: {}
						lights: {}
						particles: {}
					}

					table.insert(current_animation.frames, new_frame)
					current_frame = new_frame

					input_state.status_text = 'frame added'
		when 'get_input'
			switch key
				when 'return'
					if input_state.buffer\gfind(input_state.input_pattern)
						input_state.callback(input_state.buffer)
						input_state.buffer = ''
				when 'backspace'
					input_state.buffer = input_state.buffer\sub(1, #input_state.buffer - 1)
				when 'escape'
					input_state.buffer = ''
					input_state.state = 'idle'
					input_state.status_text = 'input canceled'

love.update = (dt) ->
	switch input_state.state
		when 'get_input'
			input_state.status_text = input_state.input_pattern .. ': ' .. input_state.buffer

love.load = ->
	font = love.graphics.newFont('font.bdf', 11)
	love.graphics.setFont(font)

love.draw = ->
	cw, ch = love.graphics.getDimensions()

	love.graphics.print('[images]')
	y = 15
	for i in *images
		love.graphics.draw(i.image, 2, y)
		y += i.height + 2

	love.graphics.print('[animations]', 300)
	y = 15
	for a in *animations
		love.graphics.print(((current_animation == a and '*') or ' ') .. a.name, 300, y)
		y += 15

	love.graphics.print(input_state.status_text, 2, ch - 15)