local module = {}

local turn = 1 -- 1 or 2
local board = {}
local board_id_mapping = {}
local count = 0

function module.init()
	board = {}
	board_id_mapping = {}
	for i = 0, 6 do
		board[i] = {}
		board_id_mapping[i] = {}
	end
	turn = 1
	count = 0
end

function module.put(x, y)
	board[x][y] = turn
	if turn == 1 then
		turn = 2
	else
		turn = 1
	end
	count = count + 1

	for y = 5, 0, -1 do
		for x = 0, 6 do
			io.write('' .. (board[x][y] or ' '))
		end
		io.write("\n")
		io.flush()
	end
end

function module.can_put(x, y)
	print('can_put', x, y)
	for _y = 0, y - 1 do
		if not board[x][_y] then
			return
		end
	end
	return not board[x][y]
end

function module.turn()
	return turn
end

function calc_sum(turn, x, y, inc_x, inc_y)
	for i = 0, 3 do
		if turn ~= board[x][y] then
			return false
		end
	end
	return x
end

function module.is_finish()
	if count < 4 then
		return 0
	end

	for y = 0, 5 do
		local sum = 0
		for x = 0, 3 do
			print(calc_sum(1, x, y, 1, 0))
		end
	end
	return 0
end

function module.register_id(x, y, id)
	board_id_mapping[x][y] = id
	print(id)
end

function module.find_position_by_id(id)
	print('module.find_position_by_id', id)
	for y = 0, 5 do
		for x = 0, 6 do
			if board_id_mapping[x][y] == id then
				return x, y
			end
		end
	end
end

module.init()

return module