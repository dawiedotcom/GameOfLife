-- author:	Dawie de Klerk
-- contact:	dawiedotcom@gmail.com

require('gol')

--[[
--	GRID to draw the grid, keep track of the current viewport.
--]]
Grid = {}
Grid.x_offset = 0
Grid.y_offset = 0

function Grid.new(self, o)
	return constructor(self, o)
end

function Grid.draw(self)
	love.graphics.setColor(225, 225, 225)
	local W = love.graphics.getWidth()
	local H = love.graphics.getHeight()

	for i = 0, W, Cell.size do
		x = i + self.x_offset % Cell.size 
		love.graphics.line(x, 0, x, H)
	end
			
	for i = 0, H, Cell.size do
		y = i + self.y_offset % Cell.size
		love.graphics.line(0, y, W, y)
	end
end

function Grid.drawCell(self, cell)
	if not cell.alive then return end
	
	love.graphics.setColor(30, 30, 200)
	--print("drawing a cell")
	--[[if cell.alive then
		love.graphics.setColor(30, 30, 200)
	else
		love.graphics.setColor(30, 200, 30)
	end--]]
	local x = cell.x * cell.size + self.x_offset
	local y = cell.y * cell.size + self.y_offset

	love.graphics.quad("fill", x, y + cell.size, x + cell.size, y + cell.size, x + cell.size, y, x, y)
	--love.graphics.print(tostring(cell.live_neibours), x, y)
end

--[[
--	LOVE
--]]
--
local cell1 = Cell:new{x = 3, y = 3, alive=true}
local grid = Grid:new()
local cells = Cells:new()
local r_drag = false
local dmx
local dmy

function love.load()
	love.graphics.setBackgroundColor(200,200,200)
	love.graphics.setLineWidth(1.5)
end

function love.draw()
	love.graphics.setCaption('Game of Love [FPS: ' .. love.timer.getFPS()..']')

	for _, c in ipairs(cells.list) do
		grid:drawCell(c)
	end
	if Cell.size > 5 then
		grid:draw()   
	end
end

local last_press = 0.0
function love.update(dt)
	last_press = last_press + dt

	if love.keyboard.isDown('up') then
		Cell.size = Cell.size + 1 
		--grid.y_offset = grid.y_offset + 1
	end

	if love.keyboard.isDown('down') then
		if Cell.size > 1 then
			Cell.size = Cell.size - 1 
		end
	end

	--[[if love.keyboard.isDown('left') then
		grid.x_offset = grid.x_offset + 1
	end

	if love.keyboard.isDown('right') then
		grid.x_offset = grid.x_offset - 1
	end--]]

	if love.keyboard.isDown(' ') and last_press > 0.1 then
		last_press = 0.0
		cells:step()
	end

	if r_drag then
		local mx, my = love.mouse.getPosition()
		grid.x_offset = grid.x_offset + mx - dmx 
		grid.y_offset = grid.y_offset + my - dmy 
		dmx, dmy = mx, my
	end
end

function love.mousepressed(x, y, button)
	if button == 'l' then
		local _x = math.floor((x - grid.x_offset)/Cell.size)
		local _y = math.floor((y - grid.y_offset)/Cell.size)

		if not (cells.grid[_x]==nil) and not(cells.grid[_x][_y]==nil) then
			if cells.grid[_x][_y].alive then 
				cells.grid[_x][_y].alive = false
				return
			end
		end
		
		cells:add( Cell:new{x=_x,y=_y, alive=true} )
	end

	if button == 'r' then
		if not r_drag then
			dmx, dmy = love.mouse.getPosition()
		end
		r_drag = true
	end
end

function love.mousereleased(x, y, button)
	if button == 'r' then
		r_drag = false
	end
end
