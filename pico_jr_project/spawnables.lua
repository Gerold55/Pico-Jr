-- spawnable objects like windows, clouds and bricks

-- clouds

function init_cloud()
	cloud = {
		x = 150,
		y = 46,
		window_y = 1,
		size = 5,
		speed = 1.25,
		spawn_rate = 4,
		last_spawn_time = 0
	}
end

function spawn_cloud()
	cloud.window_y = flr(rnd(3))
	cloud.y = 46 + cloud.window_y * movement.climb_dist
	cloud.x = -10
end

function update_cloud()
	if cloud.last_spawn_time + cloud.spawn_rate < time() and current_stage > 1 and not stage_switch_animation then
		cloud.last_spawn_time = time()
		spawn_cloud()
	end
	cloud.x += cloud.speed
end

function draw_cloud()
	circfill(cloud.x - cloud.size, cloud.y + 2, cloud.size / 1.25, colors.white.id)
	circ(cloud.x - cloud.size, cloud.y + 2, cloud.size / 1.25, colors.light_grey.id)
	circfill(cloud.x, cloud.y, cloud.size, colors.white.id)
	circ(cloud.x, cloud.y, cloud.size, colors.light_grey.id)
	circfill(cloud.x + cloud.size, cloud.y + 2, cloud.size / 1.25, colors.white.id)
	circ(cloud.x + cloud.size, cloud.y + 2, cloud.size / 1.25, colors.light_grey.id)
end

-- bricks

function spawn_bricks()
	local brick = {
		x = 92 - (ralph.window_x - 2) * movement.jump_dist,
		y = ralph.y + map_scroll,
		width = 5,
		height = 2,
		speed = brick_speed
	}
	add(bricks, brick)
end

function update_bricks()
	for b in all(bricks) do
		b.y += b.speed
		if b.y > 130 then del(bricks, b) end
	end
end

function draw_bricks()
	for b in all(bricks) do
		rectfill(b.x - 3, b.y, b.x - 3 + b.width, b.y + b.height, colors.red.id)
		rectfill(b.x + 3, b.y + 5, b.x + 3 + b.width, b.y + 5 + b.height, colors.red.id)
		rectfill(b.x + 3, b.y - 5, b.x + 3 + b.width, b.y - 5 + b.height, colors.red.id)
		rect(b.x - 3, b.y, b.x - 3 + b.width, b.y + b.height, colors.magenta.id)
		rect(b.x + 3, b.y + 5, b.x + 3 + b.width, b.y + 5 + b.height, colors.magenta.id)
		rect(b.x + 3, b.y - 5, b.x + 3 + b.width, b.y - 5 + b.height, colors.magenta.id)
	end
end

-- windows

function draw_windows()
    -- windows
    local window_sprite_x = windows_sprites.broken.id * 16
    local window_sprite_y = 16
	local scroll = 0
	local stag = nil
	local stag_one = true
	local stag_three = false

	for s = 0, 2 do
		scroll = s * 128
		if s == 0 then
			stag = level.stage1
		elseif s == 1 then
			stag_one = false
			stag = level.stage2
		else
			stag_one = false
			stag_three = true
			stag = level.stage3
		end
		for y = 0, 3 do
			for x = 0, 3 do
				window_sprite_x = stag.to_fix[y + 1][x + 1] * 16
				if stag_three and y == 0 then
					break
				elseif not (stag_one and y == 3 and (x == 1 or x == 2)) then
					sspr(window_sprite_x, window_sprite_y, 16, 16, x * 21 + 22, 8 + y * 29 - scroll + map_scroll, 21, 21)
				end
			end
		end
	end
	sspr(16, 32, 16, 16, 48, 93 + map_scroll, 32, 32) -- door
end