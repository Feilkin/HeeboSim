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

	width: 176
	height: 96

	sockets: {
		entrance: {
			x: 0
			y: 72
			radius: 10
		}
	}

	jobs: {
		coalplant_worker: {
			name: 'Coalplant Worker'
			count: 3
			shifts: {
				monday:    { 420, 900 }
				tuesday:   { 420, 900 }
				wednesday: { 420, 900 }
				thursday:  { 420, 900 }
				friday:    { 420, 900 }
			}
			socket: 'entrance'
		}
	}

	new: (x, y) =>
		@x = x or 0
		@y = y or 0

		@sockets = {}
		for name, socket in pairs @@sockets
			@sockets[name] = {
				x: socket.x
				y: socket.y
				radius: socket.radius
				connections: {}
			}

		copy_job = (job) ->
			return {
				name: job.name
				shifts: { day, {time[1], time[2]} for day, time in pairs job.shifts }
				socket: @sockets[job.socket]
				building: @
			}

		if @@jobs
			@jobs = {}
			for name, job in pairs @@jobs
				if job.count
					for i = 1, job.count
						@jobs[name .. '_' .. i] = copy_job job
				else
					@jobs[name] = copy_job job

