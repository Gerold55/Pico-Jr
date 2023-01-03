-- particles

function init_particles()
	particle_effects = {}
	bounciness = 0.35
end

function create_particles(c, x, y, col)
	positions = {}
	velocities = {}
	iterations = 0
	lifespan = 180
	for i=1,c do
		add(positions, x)
		add(positions, y)
		add(velocities, 4 - rnd(8))
		add(velocities, 4 - rnd(8))
	end
	add(particle_effects, {positions, velocities, iterations, lifespan,col})
end

function simulate_particles()
	for p in all(particle_effects) do
		for i = 1, count(p[1]),2 do
			p[1][i] += p[2][i]
			p[1][i+1] += p[2][i + 1]
			p[2][i] *= 0.99
			p[2][i+1] += 0.2
			if (p[1][i] > 127 or p[1][i] <0 ) then
				p[2][i] *= -1
			end
			if (p[1][i+1] > 130 or p[1][i+1] < 0) then
				p[2][i+1] *= -bounciness
			end
			pset(p[1][i],p[1][i + 1],p[5])
		end
		p[3] += 1
		if (p[3] > p[4]) then
            del(particle_effects,p)
		end
	end
end

function clear_particles()
    particle_effects = {}
end