local logic = require("main.modules.logic")

local m = {}
local my_turn = 1

function m.ai_think()
    my_turn = logic.turn()
    print('my turn: ' .. my_turn)
    local start = os.time()
    pos = m.minimax(0)
    print("x: " .. pos[1] .. ", y: " .. pos[2])
    -- print('time: ' .. os.time() - start)
    return pos
end

function m.my_turn()
    return my_turn == logic.turn()
end

function m.minimax(depth)
    -- if depth == 2 then
    --     print('minimax: ' .. depth .. ' ' .. logic.state())
    --     logic.display()
    -- end
    -- if logic.state() ~= 0 or depth > 5 then
    if logic.state() ~= 0 or depth > 3 then
        return m.evaluate(logic.state(), depth)
    end
    local best = {0, 0}
    local can_hand = {0, 0}

    local value = m.my_turn() and -10000 or 10000

    -- if depth > 4 then
    --     return -value
    -- end

    -- if depth == 0 or depth == 1 then
    --     print("!! my turn: " .. (m.my_turn() and "my" or "other"))
    --     print("!! value: " .. value)
    -- end

    for x = 0, 6 do
        for y = 0, 5 do
            if not logic.board(x, y) then
                can_hand = {x, y}
                logic.put(x, y)
                -- if depth == 0 then
                --     print('-- put: ' .. x .. ", " .. y)
                --     -- print('state: ' .. logic.state())
                -- end
                child_value = m.minimax(depth + 1)
                if depth == 0 then
                    print('-- value: ' .. value)
                    print('-- child value: ' .. child_value)
                    print('-- depth: ' .. depth)
                    print('-- state: ' .. logic.state())
                    print('-- my turn: ' .. (m.my_turn() and 'my' or 'other'))
                    logic.display()
                end
                if m.my_turn() then
                    if child_value < value then
                        value = child_value
                        best = {x, y}
                        -- if depth == 0 then
                        --     print('-- update: ' .. value)
                        --     print('-- x, y: ' .. x .. ",  " .. y)
                        -- end        
                    end
                else
                    if child_value > value then
                        value = child_value
                        best = {x, y}
                        -- if depth == 0 then
                        --     print('-- update: ' .. value)
                        --     print('-- x, y: ' .. x .. ",  " .. y)
                        -- end        
                    end
                end
                -- if depth == 0 then
                --     print('-- value: ' .. value)
                -- end
                logic.undo(x, y)
                break
            end
        end
    end
        
    if depth == 0 then
        if best[1] == 0 and best[2] == 0 and not logic.can_put(0, 0) then
            return can_hand
        end
        return best
    else
        return value
    end
end

function m.evaluate(state, depth)
    -- print("evaluate: " .. state .. " depth: " .. depth)

    if state == logic.turn() then
        return 37 - depth
    elseif state ~= 0 then
        return depth - 37
    else
        return 0
    end
end

function m.test_hit_1()
    logic.init({
        {0, 0, 0, 0, 0, 0, 2},
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0},
        {2, 2, 2, 0, 0, 0, 0},
    })
    logic.put(0, 1)
    print(logic.state())
    logic.put(3, 0)
    print(logic.state())
    logic.display()
end

-- m.test_hit_1()

function m.test_1()
    logic.init({
        {0, 0, 0, 0, 0, 0, 2},
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0},
        {1, 1, 1, 0, 0, 0, 0},
    })
    logic.display()
    local pos = m.ai_think()
    logic.put(pos[1], pos[2])
    print(logic.finished)
end

function m.test_2()
    logic.init({
        {0, 0, 0, 0, 0, 0, 2},
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0},
        {2, 2, 2, 0, 0, 0, 0},
    })
    logic.display()
    local pos = m.ai_think()
    logic.put(pos[1], pos[2])
    print(logic.finished)
    logic.display()
end

-- m.test_2()

-- logic.init()
-- while logic.finished ~= 0 do
--     logic.display()
--     local pos = m.ai_think()
--     logic.put(pos[1], pos[2])
--     print(logic.finished)
-- end

return m