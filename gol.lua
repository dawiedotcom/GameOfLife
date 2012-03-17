-- author:	Dawie de Klerk
-- contact:	dawiedotcom@gmail.com


function constructor(s, o)
	o = o or {}
	setmetatable(o, s)
	s.__index = s
	return o
end	

--[[
--	CELL
--]]
Cell = {}
Cell.x = 0			-- The x coordinate in the grid.
Cell.y = 0			-- The y coordinate in the grid.
Cell.size = 15
Cell.index = 0
Cell.live_neighbours = 0
Cell.alive = false
function Cell.new(self, o)
	return constructor(self, o)
end

function Cell.lives(self)
	return self.live_neighbours == 3 or (self.alive and self.live_neighbours == 2)
end

--[[
--	CELLS a collection of more than one Cell
--]]
Cells = {}
Cells.grid = {}
Cells.list = {}

function Cells.new(self, o)
	return constructor(self, o)
end

function Cells.add(self, c)
	self.grid[c.x] = self.grid[c.x] or {}
	self.grid[c.x-1] = self.grid[c.x-1] or {}
	self.grid[c.x+1] = self.grid[c.x+1] or {}

	if not (self.grid[c.x][c.y]==nil) and self.grid[c.x][c.y].alive then
		return 
	end

	if self.grid[c.x][c.y]==nil then 
		c.index = #self.list + 1
	else
		c.index = self.grid[c.x][c.y].index
		self.grid[c.x][c.y] = nil
		self.list[c.index] = nil
	end

	self.grid[c.x][c.y] = c
	self.list[c.index] = c

	if c.alive then
		self:add( Cell:new{x=c.x-1	, y=c.y-1	}) 
		self:add( Cell:new{x=c.x-1	, y=c.y		}) 
		self:add( Cell:new{x=c.x-1	, y=c.y+1	}) 
		self:add( Cell:new{x=c.x+1	, y=c.y-1	}) 
		self:add( Cell:new{x=c.x+1	, y=c.y		}) 
		self:add( Cell:new{x=c.x+1	, y=c.y+1	}) 
		self:add( Cell:new{x=c.x	, y=c.y-1	}) 
		self:add( Cell:new{x=c.x	, y=c.y+1	}) 
	end

end

function Cells.countN(self)
	for _, c in ipairs(self.list) do
		local l = 0
		if not (self.grid[c.x-1][c.y-1]==nil) and self.grid[c.x-1][c.y-1].alive then l=l+1 end
		if not (self.grid[c.x-1][c.y  ]==nil) and self.grid[c.x-1][c.y  ].alive then l=l+1 end
		if not (self.grid[c.x-1][c.y+1]==nil) and self.grid[c.x-1][c.y+1].alive then l=l+1 end
		if not (self.grid[c.x+1][c.y-1]==nil) and self.grid[c.x+1][c.y-1].alive then l=l+1 end
		if not (self.grid[c.x+1][c.y  ]==nil) and self.grid[c.x+1][c.y	].alive then l=l+1 end
		if not (self.grid[c.x+1][c.y+1]==nil) and self.grid[c.x+1][c.y+1].alive then l=l+1 end
		if not (self.grid[c.x  ][c.y-1]==nil) and self.grid[c.x  ][c.y-1].alive then l=l+1 end	
		if not (self.grid[c.x  ][c.y+1]==nil) and self.grid[c.x  ][c.y+1].alive then l=l+1 end
	
		--print('c: alive='..tostring(c.alive)..' l=' .. tostring(l))
		c.live_neighbours = l	
	end
end

function Cells.step(self)
	
	local live = {}
	self:countN()
	for _, c in ipairs(self.list) do
		if c:lives() then
			c.alive = true
			live[#live+1] = c
		end
	end

	self.list = {}
	self.grid = {}

	for _, c in ipairs(live) do
		self:add(c)
	end
		
	collectgarbage()
end


