-- leaderboard

leaderboard = {}
alphabet = {
    "a", "b", "c", "d", "e", "f", "g",
    "h", "i", "j", "k", "l", "m", "n",
    "o", "p", "q", "r", "s", "t", "u",
    "v", "w", "x", "y", "z"
}

function init_leaderboard()
    leaderboard = { { dget(0), dget(1), dget(2), dget(3) }, 
                    { dget(4), dget(5), dget(6), dget(7) }, 
                    { dget(8), dget(9), dget(10), dget(11) }, 
                    { dget(12), dget(13), dget(14), dget(15) }, 
                    { dget(16), dget(17), dget(18), dget(19) } }
    letters = {0, 0, 0}
    cursor_pos = 1
    letter_pos = 0
end

function enter_name()
    -- check for d-pad input
    if btnp(buttons.down.id) then
        letter_pos = mid(0, 25, letter_pos + 1)
        letters[cursor_pos] = letter_pos
    elseif btnp(buttons.up.id) then
        letter_pos = mid(0, 25, letter_pos - 1)
        letters[cursor_pos] = letter_pos
    elseif btnp(buttons.x.id) or btnp(buttons.right.id) then
        cursor_pos += 1
        letter_pos = 0
    elseif btnp(buttons.o.id) or btnp(buttons.left.id) then
        cursor_pos = mid(cursor_pos - 1, 1, cursor_pos)
        letter_pos = letters[cursor_pos]
        letters[cursor_pos] = letter_pos
    end

    if cursor_pos >= 4 then
        add_to_leaderboard({ letters[1], letters[2], letters[3], total_score })
        window_score = 0
        time_bonus = 0
        total_score = 0
        waiting_for_name = false
    end
end

function draw_name_enter_field()
    local inst1 = "use ⬆️ ⬇️ ⬅️ ➡️ to "
    local inst2 = "enter the name"
    local score = "score: " .. tostr(total_score)
    print(score, 64 - #score / 2 * 4, 10, colors.white.id)
    print(inst1, 64 - #inst1 / 2 * 4 - 7, 30, colors.white.id)
    print(inst2, 64 - #inst2 / 2 * 4, 40, colors.white.id)
    for i = 1, count(letters) do
        local color = colors.white.id
        if i == cursor_pos then color = colors.red.id end
        print(alphabet[letters[i] + 1], 40 + i * 10, 60, color)
    end
end
  
function add_to_leaderboard(data)
    add(leaderboard, data)
    leaderboard = bubble_sort(leaderboard)
    save_leaderboard()
    letters = {0, 0, 0}
    cursor_pos = 1
    letter_pos = 0
end

function save_leaderboard()
    local index = 0
    for hs in all(leaderboard) do
        for i = 1, 4 do
            dset(index, hs[i])
            index +=1
        end
    end
end

function bubble_sort(t)
    local n = #t
    
    while true do
        local swapped = false
    
        for i = 1, n - 1 do
            if t[i][4] < t[i + 1][4] then
                t[i], t[i + 1] = t[i + 1], t[i]
                swapped = true
            end
        end
    
        if not swapped then
            break
        end
    end
    return t
end