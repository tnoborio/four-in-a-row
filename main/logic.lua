-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.

local module = {}

local turn = 1 -- 1 or 2
local board = {}
local count = 0

function module.init()
	board = {}
	for i = 0, 6 do
		board[i] = {}
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

module.init()

return module