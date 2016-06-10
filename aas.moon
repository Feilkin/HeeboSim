---
-- AAS (Asset Animation System)
-- (c) Feikki 2016
--

class AAS
	-- locals

	-- class methods
	fromFile: (filename, prefix) ->
		chunk = love.filesystem.load(prefix .. filename)
		assert(chunk, 'Failed to load file "' .. filename .. '"')
		res = chunk()
		assert(type(res) == 'table', 'Failed to load file "' .. filename .. '": did not return a table')

		res.prefix = prefix

		-- TODO: validate data
		return AAS(res)

	-- constructor
	new: (data) =>
		-- prepare assets
		assets = {}
		file_cache = {}
		animations = {}

		print 'building new animation -- '
		print ' - prepairing assets'

		for n, a in pairs data.assets
			print 'preparing asset ' .. n
			-- load the asset sheet
			assert(a.file, 'Asset has no asset sheet specified (.file)!')

			if data.prefix
				a.file = data.prefix .. a.file

			sheet = file_cache[a.file]

			if not sheet
				print '  - loading asset sheet "' .. a.file .. '"'
				sheet = love.graphics.newImage(a.file)
				file_cache[a.file] = sheet

			sw, sh = sheet\getDimensions()

			-- make a new quad
			assert a.source_x and a.source_y and a.width and a.height,
				'Asset does not define source region (source_x, source_y, width, height)!'
			print '  - making quad (' .. a.source_x .. ', ' .. a.source_y .. ', ' .. a.width .. ', ' .. a.height
			quad = love.graphics.newQuad(a.source_x, a.source_y, a.width, a.height, sw, sh)

			a.sheet = sheet
			a.quad = quad

			assets[n] = a

		print ' - prepairing animations'

		for n, a in pairs data.animations
			print '  - prepairing animation ' .. n
			local animation, frames
			animation = {}
			frames = {}

			-- handle frames in current animation
			for f in *a.frames
				-- handle assets in frame
				local frame
				frame = {
					assets: {}
				}
				for as in *f.assets
					print '   - adding asset "' .. as.asset .. '" to frame'
					asset = assets[as.asset]
					assert(asset, 'Failed to load frame: asset "' .. as.asset.. '" not found!')

					as.quad = asset.quad
					as.sheet = asset.sheet
					table.insert(frame.assets, as)

				table.insert(frames, frame)
			animation.frames = frames
			animation.name = n
			animations[n] = animation

		@assets = assets
		@animations = animations

	getAnimation: (name) =>
		animation = @animations[name]
		assert(animation, 'Animation "' .. name .. '" not found')
		return animation


