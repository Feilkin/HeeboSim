-- settings.moon (-> settings.lua)
{
	keybindings: {
		'escape': ->
			love.event.quit()
			return true

		'f1': (game) ->
			game\selectTool 'selection_tool'
			return true
		'f2': (game) ->
			game\selectTool 'building_tool'
			return true
		'f3': (game) ->
			game\selectTool 'road_tool'
			return true
	}
}