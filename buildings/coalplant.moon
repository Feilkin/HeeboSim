---
--
--

class CoalPlant
	aas: 'coalplant.lua'
	animated: true
	shape: {
		{
			type: 'AABB'
			x: 0
			y: 0
			width: 176
			height: 96
		}
	}

	new: () =>
		@x = 0
		@y = 0