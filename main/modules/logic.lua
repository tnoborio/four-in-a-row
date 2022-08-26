local module = {}

local turn = 1 -- 1 or 2
local board = {}
local board_id_mapping = {}
local count = 0
local finished = 0

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

	finished = module.is_finish()

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

	if finished > 0 then
		return false
	end
	
	for _y = 0, y - 1 do
		if not board[x][_y] then
			return false
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
		x = x + inc_x
		y = y + inc_y
	end
	return true
end

function module.is_finish()
	if count < 4 then
		return 0
	end

	for turn = 1, 2 do
		for y = 0, 5 do
			for x = 0, 3 do
				if calc_sum(turn, x, y, 1, 0) then
					return turn
				end
			end
		end
		for y = 5, 3, -1 do
			for x = 0, 6 do
				if calc_sum(turn, x, y, 0, -1) then
					return turn
				end
			end
		end
		for y = 0, 2 do
			for x = 0, 3 do
				if calc_sum(turn, x, y, 1, 1) then
					return turn
				end
			end
		end
		for y = 3, 5 do
			for x = 0, 3 do
				if calc_sum(turn, x, y, 1, -11) then
					return turn
				end
			end
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