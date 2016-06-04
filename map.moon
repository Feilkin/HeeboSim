---
-- Holds Objects
--

ECS = require 'ecs'

class Map extends ECS
	-- game specifig map class
	-- defines its systems

	-- system definitions

	AnimationSystem = require 'ecs.systems.animation_system'

	class NavmeshSystem
		-- disabled until i figure this out lol
		filter: ECS.filters.empty!

	-- constructor

	new: () =>
		--
		super {
			AnimationSystem
			NavmeshSystem
		}, {
			AnimationSystem
		}