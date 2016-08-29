---
-- Holds Objects
--

ECS = require 'ecs'
AAS = require 'aas'

class World extends ECS

    AnimationSystem = require 'ecs.systems.animation_system'

    class Person
        animated: true

    class PopulationSystem
        filter: ECS.filters.empty!

        update: (entities, data, dt) ->
            while #data.available_beds > 0
                bed = table.remove(data.available_beds)
                person = Person()
                person.bed = bed
                person.x = bed.x
                person.y = bed.y

                print 'new person', person.x, person.y
                table.insert(data.toAdd, person)

    class JobSystem
        filter: ECS.filters.not {job: true}

        update: (entities, data, dt) ->
            i, e = next(entities, nil)
            while i and (#data.available_jobs > 0)
                job = table.remove(data.available_jobs, 1)
                e.job = job

                print tostring(e) .. ' now works as ' .. job.name

                i, e = next(entities, i)

    class SchedulerSystem
        filter: ECS.filters.empty!

        update: (entities, data, dt) ->

    class AISystem
        filter: ECS.filters.empty!

        update: (entities, data, dt) ->

    class PathFinderSystem
        filter: ECS.filters.empty!

        update: (entities, data, dt) ->

    class MovementSystem
        filter: ECS.filters.empty!

        update: (entities, data, dt) ->

    new: () =>
        super {
            PopulationSystem -- spawns ppl when possible
            JobSystem -- gives jobs to ppl
            SchedulerSystem  -- tells ppl what they should do
            AISystem         -- figures what the ppl do
            PathFinderSystem -- finds paths?
            MovementSystem   -- moves ppl
            AnimationSystem
        }, {
            AnimationSystem  -- draws ppl
        }

        @data.available_beds = {}
        @data.available_jobs = {}

    loadData: =>
        --
        Person.__base.aas = AAS.fromFile('person.lua', 'resources/assets/')
        assert(Person.aas)

    addBed: (bed) =>
        table.insert(@data.available_beds, bed)

    addJob: (job) =>
        table.insert(@data.available_jobs, job)