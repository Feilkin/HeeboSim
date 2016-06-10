---
-- Animation System

ECS = require 'ecs'

class AnimationSytem
	filter: with ECS.filters
		return .all_of animated: true, aas: true

	update: (entities, data, dt) ->
		for e in *entities
			-- update the animation here
			if e.set_animation
				e.current_animation = e.aas\getAnimation(e.set_animation)

			if not e.current_animation
				e.current_animation = e.aas\getAnimation('default')

			if not e.current_frame
				e.current_frame = e.current_animation.frames[1]

			if e.current_animation.fps
				error 'animated animations not implemented yet'

	draw: (entities, data) ->
		for e in *entities
			continue unless e.current_frame
			-- draw the animation
			for a in *e.current_frame.assets
				love.graphics.draw(a.sheet, a.quad, e.x + a.x, e.y + a.y)