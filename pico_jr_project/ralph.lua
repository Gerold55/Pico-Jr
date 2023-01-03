-- ralph

function init_ralph()
    ralph = {
        x = 66,
        y = 10,
        target_x = 66,
        window_x = 3,
        speed = 0.75,
        breaking_len = 60,
        breaking_prog = 0,
        walking = false,
        breaking = false,
        throwing = false,
        s_idle = 8,
        s_mad = 24,
        s_walk1 = 40,
        s_walk2 = 56,
        s_fall = 72
    }
end

function update_ralph()
    if ralph.breaking then
        ralph.breaking_prog += 1
    end
    if not ralph.walking and not ralph.breaking then
        target_win = flr(rnd(4)) + 2
        while (target_win == ralph.window_x) do
            target_win = flr(rnd(4)) + 2
        end
        ralph.target_x = ralph.x + (ralph.window_x - target_win) * movement.jump_dist
        ralph.window_x = target_win
        ralph.walking = true
    elseif ralph.breaking then
        if ralph.breaking_len < ralph.breaking_prog then
            ralph.breaking = false
            ralph.walking = false
        end
        ralph.breaking_prog += 1
    elseif not ralph.breaking then
        ralph_walk_anim()
    end
end

function ralph_walk_anim()
    local dir_x = 0
    local diff_x = ralph.target_x - ralph.x
    if diff_x < 0 then
        dir_x = ralph.speed * -1
    elseif diff_x > 0 then
        dir_x = ralph.speed
    else
        ralph.breaking = true
        ralph.walking = false
        ralph.breaking_prog = 0
        clear_particles()
        create_particles(50, ralph.x + 8, ralph.y + 20 + map_scroll, colors.red.id)
        spawn_bricks()
    end
    ralph.x += dir_x

    local control_diff_X = ralph.target_x - ralph.x
    if (control_diff_X < 0 and dir_x > 0) or (control_diff_X > 0 and dir_x < 0) then
        ralph.x = ralph.target_x
    end
end

function draw_ralph()
    local sprite = ralph.s_idle
    local reflect = 0
    local height_add = 0
    if stage_switch_animation then
        sprite = ralph.s_idle
    elseif ralph.throwing then
        sprite = ralph.s_fall
        height_add = 5
    elseif ralph.walking then
        sprite = ralph.s_walk2
        if flr(ralph.x / 3) % 2 == 0 then sprite = ralph.s_walk1 end
        if flr(ralph.x / 1.5) % 5 == 0 then
            sfx(sound_effects.walk.id)
        end
        reflect = (ralph.target_x - ralph.x) > 0
    elseif ralph.breaking then
        screen_shake(0.05)
        sprite = ralph.s_mad
        reflect = flr(ralph.breaking_prog / 5) % 2 == 0
        if flr(ralph.breaking_prog) % 2 == 0 then
            sfx(sound_effects.hit2.id)
        end
    end
    sspr(sprite, 0, 16, 16, ralph.x, ralph.y + map_scroll - height_add, 16, 16, reflect)
end