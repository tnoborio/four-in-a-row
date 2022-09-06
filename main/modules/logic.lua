local module = {}

local turn = 1 -- 1 or 2
local board = {}
local board_id_mapping = {}
local count = 0
local finished = 0

for i = 0, 6 do
	board_id_mapping[i] = {}
end

function module.init(init_board)
	count = 0
	board = {}
	board_id_mapping = {}
	for i = 0, 6 do
		board[i] = {}
		board_id_mapping[i] = {}
	end

	if init_board then
		for x  = 0, 6 do
			for y = 0, 5 do
				local v = init_board[6 - y][x + 1]
				if v == 1 or v == 2 then
					board[x][y] = v
					count = count + 1
				end
			end
		end
	end

	-- board[0][0] = 2
	-- board[1][0] = 1
	-- board[2][0] = 1
	-- board[3][0] = 1
	-- -- board[4][0] = 1
	-- board[6][0] = 2

	turn = 1
	finished = 0
end

function module.turn()
	return turn
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
end

function module.undo(x, y)
	board[x][y] = nil
	if turn == 1 then
		turn = 2
	else
		turn = 1
	end
	count = count - 1

	finished = module.is_finish()
	-- finished = 0
end

function module.display()
	for y = 5, 0, -1 do
		for x = 0, 6 do
			local v = board[x][y]
			if v == 1 then
				io.write('o')
			elseif v == 2 then
				io.write('x')
			else 
				io.write(' ')
			end
		end
		io.write("\n")
		io.flush()
	end
end

function module.board(x, y)
	return board[x][y]
end

function module.can_put(x, y)
	-- print('can_put', x, y)

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

function check_line(turn, x, y, inc_x, inc_y)
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
				if check_line(turn, x, y, 1, 0) then
					return turn
				end
			end
		end
		for y = 5, 3, -1 do
			for x = 0, 6 do
				if check_line(turn, x, y, 0, -1) then
					return turn
				end
			end
		end
		for y = 0, 2 do
			for x = 0, 3 do
				if check_line(turn, x, y, 1, 1) then
					return turn
				end
			end
		end
		for y = 3, 5 do
			for x = 0, 3 do
				if check_line(turn, x, y, 1, -1) then
					return turn
				end
			end
		end
	end
	return 0
end

function module.state()
	return finished
end

function module.register_id(x, y, id)
	board_id_mapping[x][y] = id
	-- print(id)
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