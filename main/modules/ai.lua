-- local logic = loadfile("./main/modules/logic.lua")()
local logic = require("main.modules.logic")

local m = {}

-- logic.put(0, 0)

function m.ai_think()
    print("AI")
    logic.display()
    pos = m.minimax(0)
    print(pos[1], pos[2])
    -- logic.put(pos[1], pos[2])
    -- logic.display()
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

    local value = m.my_turn() and -100 or 100

    if depth > 3 then
        return value
    end

    if depth == 0 then
        print("my turn: " .. (m.my_turn() and "my" or "other"))
        print("value: " .. value)
    end

    for x = 0, 6 do
        for y = 0, 5 do
            if logic.can_put(x, y) then
                logic.put(x, y)
                child_value = m.minimax(depth + 1)
                if depth == 0 then
                    print('child value: ' .. child_value)
                    print('depth: ' .. depth)
                    logic.display()
                end
                if not m.my_turn() then
                    if child_value > value then
                        value = child_value
                        best = {x, y}
                        if depth == 0 then
                            print('update: ' .. value)
                            print('x, y: ' .. x .. ",  " .. y)
                        end        
                    end
                else
                    if child_value < value then
                        value = child_value
                        best = {x, y}
                    end
                end
                logic.undo(x, y)
            end
        end
    end
        
    if depth == 0 then
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

m.ai_think()

return m