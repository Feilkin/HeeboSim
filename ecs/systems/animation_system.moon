---
-- Animation System

ECS = require 'ecs'

class AnimationSytem
	filter: with ECS.filters
		.all_of animated: true

	update: (entities, data, dt) ->
		for e in *entities
			-- update the animation here
			pass

	draw: (entities, data) ->
		for e in *entities
			-- draw the animation
			pass