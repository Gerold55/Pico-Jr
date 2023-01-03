-- title: pico jr
-- version: 1.0
-- author: internet8

function _init()
    -- game variables
    gaming = false
    game_over = false
    game_over_time = 0
    stage_switch_animation = false
    level_change = false
    window_score = 0
    time_bonus = 0
    total_score = 0
    felix_new_pos = 0
    ralph_new_pos = 0
    ending_animation = false
    nicelanders_x = 80
    starting_animation = false
    starting_anim_window_x = 1
    starting_anim_window_y = 1
    current_level = 1
    current_stage = 1
    level = nil
    stage = nil
    gameplay_start = 0
    gameplay_end = 0
    map_scroll = 0
    lives = 3
    brick_speed = 1.25
    waiting_for_name = false

    -- movement object
    movement = {
        jump_dist = 21,
        climb_dist = 29
    }

    -- define enums
    windows_sprites = enum( {"fixed", "half_fixed", "broken", "fixed_plants", "half_fixed_plants", "broken_plants", "closed", "plants"}, 0 )
    buttons = enum( {"left", "right", "up", "down", "x", "o"}, 0 )
    colors = enum( {"black", "navy", "magenta", "green", "brown", "grey", "light_grey", "white", "red", "orange", "yellow", "lime", "cyan", "purple", "pink", "beige"}, 0 )
    sound_effects = enum( {"fix", "hit1", "hit2", "damage", "jump", "walk"}, 10 )

    -- saving
    cartdata("internet8_picojr_1")
    -- uncomment save_leaderboard function to clear the leaderboard
    --for i = 0, 19 do dset(i, 0) end

    -- init some values
    init_levels()
    init_particles()
    bricks = {}
    level = level1
    stage = level.stage1
    init_colors()
    init_leaderboard()
end

function _update()
    if gaming then
        if starting_animation then
            update_starting_animation()
        elseif ending_animation then
            update_ending_animation()
        elseif stage_switch_animation then
            update_stage_switch()
            gameplay_end = flr(time())
        else
            if btn(buttons.o.id) then map_scroll += 1 end
            check_stage_switch()
            update_felix()
            update_ralph()
            gameplay_end = flr(time())
        end
        game_check()
        update_cloud()
        update_bricks()
    elseif level_change then
        update_level_change()
    elseif waiting_for_name then
        enter_name()
    else
        update_menu()
    end
end

function _draw()
    cls()
    if gaming then
        -- sky rectangle (orange color is swapped with the pal() function)
        rectfill(0, 0, 128, 128, colors.orange.id)
        sspr(32, 32, 24, 8, nicelanders_x, 18) -- nicelanders
        map(0, 10, 0, -304 + map_scroll, 16, 72)
        draw_windows()
        draw_felix()
        draw_bricks()
        draw_ralph()
        draw_cloud()
        simulate_particles()
        ui()
    elseif level_change then
        draw_level_change()
    elseif waiting_for_name then
        draw_name_enter_field()
    else
        draw_menu()
    end

end

function start_game()
    init_levels()
    init_ralph()
    init_felix()
    init_cloud()
    bricks = {}
    particle_effects = {}
    gaming = true
    game_over = false
    game_over_time = 0
    starting_animation = true
    stage_switch_animation = false
    level_change = false
    felix.x = -20
    felix.target_x = 45
    ralph.x = -20
    ralph.y = 110
    ralph.walking = true
    ralph.target_x = 10
    starting_anim_window_x = 1
    starting_anim_window_y = 1
    map_scroll = 0
    gameplay_start = time()
    gameplay_end = time()
    time_bonus = 0
    window_score = 0
    nicelanders_x = 80
    music(0)
end

function game_check()
    if lives <= 0 and not game_over then
        game_over = true
        game_over_time = time() + 3
        sfx(4)
        create_particles(100, felix.x + 4, felix.y + 8 + map_scroll, colors.cyan.id)
    elseif game_over_time < time() and game_over then
        reset_game()
    end
end

function reset_game()
    waiting_for_name = true
    game_over = false
    gaming = false
    current_level = 1
    current_stage = 1
    level = level1
    stage = level.stage1
    lives = 3
    brick_speed = 1.25
end

-- waits for the input to change to the next level
function update_level_change()
    if btnp(buttons.x.id) then
        start_game()
    end
end

-- drawing function when waiting for the next level input
function draw_level_change()
    local new_lvl = ("level " .. tostr(current_level))
    local inst = ("press ❎ to play")
    local window_s = ("windows fixed " .. tostr(window_score))
    local time_b = ("time bonus " .. tostr(time_bonus))
    local total_s = ("total score " .. tostr(total_score))

    print(new_lvl, 64 - #new_lvl / 2 * 4, 5, colors.white.id)
    print(inst, 64 - #inst / 2 * 4 - 2, 15, colors.white.id)
    print(window_s, 64 - #window_s / 2 * 4, 50, colors.white.id)
    print(time_b, 64 - #time_b / 2 * 4, 60, colors.white.id)
    print(total_s, 64 - #total_s / 2 * 4, 70, colors.white.id)
end

-- movement and window breaking animation before starting the game
function update_starting_animation()
    if ralph.x < ralph.target_x then
        ralph.x += ralph.speed
    elseif ralph.y > 10 then
        ralph.y -= ralph.speed * 2.9
        if flr(ralph.y) % 3 == 0 and starting_anim_window_y <= 3 then
            if not(starting_anim_window_y == 3 and (starting_anim_window_x == 2 or starting_anim_window_x == 3)) then
                stage.to_fix[starting_anim_window_y + 1][starting_anim_window_x] += 2
            end
            starting_anim_window_x += 1
            if starting_anim_window_x >= 5 then
                starting_anim_window_x = 1
                starting_anim_window_y += 1
            end
            sfx(sound_effects.hit1.id, 2)
            create_particles(50, rnd(127), rnd(127), colors.red.id)
        end
        screen_shake(0.05)
    else
        ralph.target_x = 66
        if ralph.x < 66 then
            ralph.y = 10
        else
            ralph.x = 66
            ralph.walking = false
        end
    end

    if not ralph.walking then
        if felix.x < felix.target_x then
            felix.x += felix.speed * 0.67
        else
            felix.x = 45
            gameplay_start = flr(time())
            gameplay_end = flr(time())
            starting_animation = false
            music(-1)
        end
    end
end

-- when all the windows are fixed, then ralph's walking off the roof, also updates the level and the stage
function update_ending_animation()
    if ralph.x < nicelanders_x - 2 and not ralph.throwing then
        nicelanders_x -= 1
    elseif ralph.x > 18 then
        ralph.throwing = true
        nicelanders_x -= 1
        ralph.x -= 1
    elseif ralph.x > -500 then
        ralph.x -= 2
        ralph.y += 1
    else
        music(-1)
        ending_animation = false
        level_change = true
        gaming = false
        current_level += 1
        if current_level % 3 == 1 then
            level = level1
        elseif current_level % 3 == 2 then
            level = level2
        elseif current_level % 3 == 0 then
            level = level3
        end
        current_stage = 1
        stage = level.stage1
        if brick_speed < 5 then brick_speed += 0.25 end
        time_bonus = mid(0, 60, 60 - flr(gameplay_end - gameplay_start))
        total_score += time_bonus
    end
end

-- checking if the current stage is completed
function check_stage_switch()
    if stage.progress >= stage.target then
        music(0)
        stage_switch_animation = true
        felix_new_pos = felix.y - 128
        ralph_new_pos = ralph.y - 128
        if current_stage == 1 then
            stage = level.stage2
        elseif current_stage == 2 then
            stage = level.stage3
        else
            stage_switch_animation = false
            ending_animation = true
            music(2)
            ralph.breaking = false
            ralph.walking = false
            ralph.target_x = -20
        end
        current_stage += 1
    end
end

-- animations for switching stages
function update_stage_switch()
    if ralph.y > ralph_new_pos then
        ralph.y -= 2
    elseif felix.y > felix_new_pos then
        felix.y -= 2
        felix.target_y -= 2
    elseif map_scroll < (current_stage - 1) * 128 then
        map_scroll += 2
    else
        stage_switch_animation = false
        music(-1)
    end
end

-- in-game ui
function ui()
    rectfill(0, -5, 127, 6, colors.black.id)
    print("stage " .. tostr(min(3, current_stage)), 100, 0, colors.white.id)
    print("time: " .. tostr(gameplay_end - gameplay_start), 0, 0, colors.white.id)
    -- lives
    for i = 1, lives do
        spr(123, 116, 1 + i * 10)
    end
end

-- waiting for user input while in menu
function update_menu()
    if btnp(buttons.x.id) then
        start_game()
    end
end

-- drawing menu text and high scores
function draw_menu()
    local name = "pico jr"
    local inst = "press ❎ to play"
    local hs = "high score"
    print(name, 64 - #name / 2 * 4, 5, colors.white.id)
    print(inst, 64 - #inst / 2 * 4 - 2, 120, colors.white.id)
    print(hs, 64 - #hs / 2 * 4, 50, colors.white.id)
    for hs = 1, 5 do
        local str = tostr(hs) .. ". " .. alphabet[leaderboard[hs][1] + 1] .. alphabet[leaderboard[hs][2] + 1] .. alphabet[leaderboard[hs][3] + 1] .. " - " .. tostr(leaderboard[hs][4])
        print(str, 64 - #str / 2 * 4, 50 + hs * 10, colors.white.id)
    end
    sspr(112, 33, 16, 16, 52, 15, 30, 30)
end

function screen_shake(offset)
    local fade = 0.95
    local offset_x = 16 - rnd(32)
    local offset_y = 16 - rnd(32)
    offset_x *= offset
    offset_y *= offset
    
    camera(offset_x, offset_y)
    offset *= fade
    if offset < 0.05 then
        offset = 0
    end
end

-- to get around pico-8's color limit, this function switches the color orange to a color table
function init_colors()
	for i = 0, 15 do
		pal(i, i + 128, 2)
	end
    -- evening sky pallet
	--pal({ [0] = 0x82, 0x82, 0x84, 0x84, 4, 4, 0x89, 0x89, 0x8e, 0x8e, 0x8f, 0x8f, 15, 15, 0x87, 0x87 }, 2)
    -- day sky pallet
	pal({ [0] = 0, 0, 129, 129, 1, 1, 140, 140, 12, 12, 6, 6, 7, 7, 0x87, 0x87 }, 2)
	poke(0x5f5f, 0x30 + colors.orange.id)
    pal(colors.purple.id, colors.purple.id + 121, 1)
    pal(colors.grey.id, colors.grey.id + 128, 1)
    pal(colors.navy.id, colors.navy.id + 128, 1)

	-- bitmask
	memset(0x5f70, 0b01010101,  16)
end

-- to do

-- lose condition
-- high score
-- sound effects and music