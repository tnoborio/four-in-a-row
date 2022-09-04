local logic = require("main.modules.logic")

local m = {}

function m.ai_think()
    local start = os.time()
    pos = m.minimax(0)
    print("x: " .. pos[1] .. ", y: " .. pos[2])
    print('time: ' .. os.time() - start)
    return pos
end

function m.my_turn()
    return logic.turn() == 2
end

function m.minimax(depth)
    if logic.state() ~= 0 then
        return m.evaluate(logic.state(), depth)
    end
    local best = {0, 0}
    local can_hand = {0, 0}

    local value = m.my_turn() and 10000 or -10000

    if depth > 3 then
        return -value
    end

    -- if depth == 0 or depth == 1 then
    --     print("!! my turn: " .. (m.my_turn() and "my" or "other"))
    --     print("   value: " .. value)
    -- end

    for x = 0, 6 do
        for y = 0, 5 do
            if logic.can_put(x, y) then
                can_hand = {x, y}
                logic.put(x, y)
                -- if depth == 0 then
                --     print('-- put: ' .. x .. ", " .. y)
                --     -- print('state: ' .. logic.state())
                -- end
                child_value = m.minimax(depth + 1)
                -- if depth == 0 then
                --     print('-- value: ' .. value)
                --     print('-- child value: ' .. child_value)
                --     print('-- depth: ' .. depth)
                --     print('-- state: ' .. logic.state())
                --     print('-- my turn: ' .. (m.my_turn() and 'my' or 'other'))
                --     logic.display()
                -- end
                if m.my_turn() then
                    if child_value > value then
                        value = child_value
                        best = {x, y}
                        -- if depth == 0 then
                        --     print('-- update: ' .. value)
                        --     print('-- x, y: ' .. x .. ",  " .. y)
                        -- end        
                    end
                else
                    if child_value < value then
                        value = child_value
                        best = {x, y}
                        -- if depth == 0 then
                        --     print('-- update: ' .. value)
                        --     print('-- x, y: ' .. x .. ",  " .. y)
                        -- end        
                    end
                end
                -- if depth == 0 or depth == 1 then
                --     print('-- value: ' .. value)
                -- end
                logic.undo(x, y)
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

    if state == 2 then
        return 10 - depth
    elseif state == 1 then
        return depth - 10
    else
        return 0
    end
end

-- -- logic.put(6, 0)
-- logic.display()
-- local pos = m.ai_think()
-- logic.put(pos[1], pos[2])
-- logic.display()

return m