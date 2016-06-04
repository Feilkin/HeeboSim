---
-- Entity Component System (container + systems + entities)
--

class ECS
	-- locals

	-- handles a option passed to a filter
	handle_opt = (opt, entity) ->
		switch type(opt)
			when 'function'
				return opt(entity)
			when 'table'
				for k, v in pairs opt
					return false unless entity[k] == v
				return true
			when 'string'
				return entity[opt] == true
			else
				error('type of ' .. type(opt) .. ' as a filter option not yet implemented!')

	-- class variables

	-- filter functions
	-- filter functions are ran for each entity:
	--   if filter function returns true, the element is added to the system
	-- filter functions are chainable
	filters:
		empty: ->
			() ->
				false
		not: (...) ->
			local opts
			opts = {...}
			(e) ->
				local s
				s = true
				for o in *opts
					s and= handle_opt(o, e)
				return not s

		all_of: (...) ->
			local opts
			opts = {...}
			(e) ->
				local s
				s = true
				for o in *opts
					s and= handle_opt(o, e)
				return s
		one_of: (...) ->
			local opts
			opts = {...}
			(e) ->
				for o in *opts
					return true if handle_opt(o, e)
				return false

	-- constructor
	new: (systems, renderers) =>
		@entities = {}
		@systems = systems or {}
		@renderers = renderers or {}

		@data = {} -- data storage for systems

	-- methods

	addEntity: (entity) =>
		@entities[#@entities + 1] = entity

	addSystem: (system, is_renderer) =>
		@systems[#@systems + 1] = system

		if is_renderer
			@renderers[#@renderers + 1] = system

	addRenderer: (renderer) =>
		@renderers[#@renderers + 1] = renderer

	loadData: =>
		--
		-- DEBUG: test filters
		local test_system
		test_system =
			filter: with @@filters
				.all_of 'a',
					.not 'b',
					.one_of 'c', 'd',
					{ name: 'test_entity' }

		local test_entities
		test_entities = {
			{
				a: true,
				b: true,
				c: 1234,
				d: false,
				name: 'test_entity'
			}
			{
				a: true,
				b: false,
				c: 1234,
				d: false,
				name: 'test_entity'
			}
			{
				a: false,
				b: false,
				c: 1234,
				d: false,
				name: 'test_entity'
			}
			{
				a: false,
				b: true,
				c: 1234,
				d: false,
				name: 'test_entity'
			}
		}

		assert(#@filterEntities(test_system.filter, test_entities), 'test failed')

	filterEntities: (filter, entitites) =>
		entities = entities or @entities
		local filtered
		filtered = {}

		for e in *@entities
			if filter(e)
				filtered[#filtered + 1] = e

		return filtered

	update: (dt) =>
		for s in *@systems
			s.update(@filterEntities(s.filter, @entities), @data, dt)

	draw: =>
		--
		for r in *@renderers
			r.draw(@filterEntities(r.filter, @entitites), @data)