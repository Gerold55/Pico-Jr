-- felix

function init_felix()
    felix = {
        x = 45,
        target_x = 45,
        window_x = 2,
        y = 65,
        target_y = 65,
        window_y = 3,
        speed = 3,
        jump_height = 4,
        sprite = 1,
        last_fix_time = 0,
        animating = false,
        s_idle = 80,
        s_jump = 96,
        immune_time = 2,
        last_hit_time = 0
    }
end

function update_felix()
    if game_over then return end
    if not felix.animating then
        if btnp(buttons.x.id) then
            local x = felix.window_x
            local y = felix.window_y
            if (stage.to_fix[y][x] != windows_sprites.fixed.id and stage.to_fix[y][x] != windows_sprites.fixed_plants.id) then
                stage.to_fix[y][x] -= 1
                stage.progress += 0.5
                window_score += 1
                total_score += 1
                felix.last_fix_time = time()
                sfx(sound_effects.fix.id)
            end
        end
        if btn(buttons.left.id) then
            if validate_move(felix.window_x - 1, felix.window_y) then
                felix.window_x -= 1
                felix.target_x -= movement.jump_dist
                sfx(sound_effects.jump.id)
            end
        elseif btn(buttons.right.id) then
            if validate_move(felix.window_x + 1, felix.window_y) then
                felix.window_x += 1
                felix.target_x += movement.jump_dist
                sfx(sound_effects.jump.id)
            end
        elseif btn(buttons.up.id) then
            if validate_move(felix.window_x, felix.window_y - 1) then
                felix.window_y -= 1
                felix.target_y -= movement.climb_dist
                sfx(sound_effects.jump.id)
            end
        elseif btn(buttons.down.id) then
            if validate_move(felix.window_x, felix.window_y + 1) then
                felix.window_y += 1
                felix.target_y += movement.climb_dist
                sfx(sound_effects.jump.id)
            end
        end
        if felix.x != felix.target_x or felix.y != felix.target_y then
            felix.animating = true
        end
    else
        felix_jump_anim()
    end
    check_collision()
end

function check_collision()
    if stage_switch_animation or ending_animation then return end
    if felix.last_hit_time + felix.immune_time > time() then return end
    for b in all(bricks) do
		if abs(b.x - felix.x) < b.width + 3 and abs(b.y - (felix.y + map_scroll)) < (b.height + 3) * 2 then
            lives -= 1
            felix.last_hit_time = time()
            sfx(sound_effects.damage.id)
            return
        end
	end
    if abs(cloud.x - (felix.x + 7)) < cloud.size * 3 and abs(cloud.y - (felix.y + map_scroll)) < cloud.size * 3 then
        lives -= 1
        felix.last_hit_time = time()
        sfx(sound_effects.damage.id)
        return
    end
end

function validate_move(x, y)
    if x < 1 or y < 1 or x > 4 or y > 4 then return false end
    if stage.to_fix[y][x] == windows_sprites.closed.id then
        return false
    elseif stage.to_fix[y][x] >= windows_sprites.fixed_plants.id and felix.window_y > y then
        return false
    elseif stage.to_fix[felix.window_y][felix.window_x] >= windows_sprites.fixed_plants.id and felix.window_y < y then
        return false
    end
    return true
end

function felix_jump_anim()
    local dir_x = 0
    local dir_y = 0
    local diff_x = felix.target_x - felix.x
    local diff_y = felix.target_y - felix.y
    if diff_x < 0 then
        dir_x = felix.speed * -1
    elseif diff_x > 0 then
        dir_x = felix.speed
    elseif diff_y < 0 then
        dir_y = felix.speed * -1.2
    elseif diff_y > 0 then
        dir_y = felix.speed * 1.2
    else
        felix.animating = false
    end
    felix.x += dir_x
    felix.y += dir_y

    local control_diff_X = felix.target_x - felix.x
    local control_diff_y = felix.target_y - felix.y
    if (control_diff_X < 0 and dir_x > 0) or (control_diff_X > 0 and dir_x < 0) then
        felix.x = felix.target_x
    end
    if (control_diff_y < 0 and diff_y > 0) or (control_diff_y > 0 and diff_y < 0) then
        felix.y = felix.target_y
    end
end

function draw_felix()
    if game_over then return end
    local last_hit = felix.last_hit_time + felix.immune_time
    if last_hit > time() and flr(time() * 10) % 2 == 0 then return end
    local jump_arc = (abs(felix.target_x - felix.x) / movement.jump_dist * 2 - 1)^2 * felix.jump_height
    if felix.animating or time() - felix.last_fix_time < 0.1 then
        sspr(felix.s_idle, 32, 16, 24, felix.x, felix.y + jump_arc - felix.jump_height + map_scroll)
    else
        sspr(felix.s_jump, 32, 16, 24, felix.x, felix.y + jump_arc - felix.jump_height + map_scroll)
    end
end