aStar = {}

local node = {}
function aStar:a_star_init(  )
	local gezi = {
		{13.1, 14  , 15  , 16},
		{9   , 10  , 11.1, 12},
		{5   , 6.1 , 7   , 8},
		{1   , 2   , 3   , 4.1},
	}
	for i = 1, #gezi do
		for j = 1, #gezi[i] do
			if not node[i] then
				node[i] = {}
			end
			if not node[i][j] then
				node[i][j] = {}
			end
			local num = gezi[i][j]
			if num % 1 > 0 then
				node[i][j].free = false;
			else
				node[i][j].free = true;
			end
			node[i][j].vector = {x = i, y = j}
			node[i][j].number = gezi[i][j]
			node[i][j].childNode = {}
			node[i][j].isClose = false;
		end
	end
	for i = 1, #gezi do
		for j = 1, #gezi[i] do
			if node[i][j] then
				if node[i-1] and node[i][j] then--上
					node[i][j].childNode[1] = {x = i-1, y = j}
				end
				if node[i+1] and node[i+1][j] then--下
					node[i][j].childNode[2] = {x = i+1, y = j}
				end
				if node[i][j-1] then--左
					node[i][j].childNode[3] = {x = i, y = j-1}
				end
				if node[i][j+1] then--右
					node[i][j].childNode[4] = {x = i, y = j+1}
				end
			end
		end
	end
end
local openList = {}
local path = {}
local endNode
function aStar:PathSearch(starPos, endPos)
	local starNode = node[starPos.x][starPos.y]
	endNode = node[endPos.x][endPos.y]
	if not starNode or not endNode then
		print("超出坐标系")
		return
	end
	local path_list = {}
	local A = starNode
	local a_index = 1;
	A.G = 0;
	A.H = math.abs(starNode.vector.x - endNode.vector.x) + math.abs(starNode.vector.y - endNode.vector.y)
	A.F = A.G + A.H
	table.insert(openList, A)
	table.insert(path_list, endNode.number)
	while #openList > 0 do
		A = openList[1]
		a_index = 1;
		for i = 1, #openList do
			if openList[i].F < A.F then
				A = openList[i]
				a_index = i;
			end
		end
		local path = self:search_Child(A)
		if path ~= nil then
			while path ~= nil and path.parentNode ~= nil do
				table.insert(path_list, path.parentNode.number)
				path = path.parentNode;
			end
		else
			table.remove(openList, a_index)
			A.isClose = true;
		end
	end
	print(util.tostring_table(path_list, "----path_list"))
end
local function distanceCurValue(A, B)
	return math.sqrt(A.vector.x - B.vector.x) + math.sqrt(A.vector.y - B.vector.y)
end
function aStar:search_Child(A)
	for index, vector in pairs(A.childNode) do
		local B = node[vector.x][vector.y]
		if B.free == true then
			if B.isClose == false then
				B.G = distanceCurValue(A, B)
				B.H = math.abs(B.vector.x - endNode.vector.x) + math.abs(B.vector.y - endNode.vector.y)
				B.F = B.G + B.H
				B.isClose = true;
				B.parentNode = A;
				table.insert(openList, B)
				if B.H < 1 then
					return B;
				end
			elseif B.isClose == true then
				local curG = distanceCurValue(A, B)
				if B.G > curG + A.G then
					B.G = curG + A.G;
					B.F = B.G + B.H;
					B.parentNode = A;
				end
			end
		end
	end
	return nil;
end
	
aStar:a_star_init();