--
-- Author: kwyxiong
-- Date: 2015-12-07 16:06:22
--
local scheduler = cc.Director:getInstance():getScheduler()
local GuideRing = class("GuideRing", function() 
		return display.newNode()
	end)

function GuideRing:ctor(x, y, ringSize,first)

	self.x = x
	self.y = y

	self.time = 1
	self.minR = 40

	self.maxR = ringSize

	
	self.dis = 0.22 * ringSize - 10

	self:registerScriptHandler(handler(self, self.enter_exit))
	

	-- self:init()
	
	if first then
		self.curR = self.maxR + 100
		self.ticker = scheduler:scheduleScriptFunc(handler(self, self.doTick1) , 0.0, false)
	else
		self.curR = self.minR
		self.ticker = scheduler:scheduleScriptFunc(handler(self, self.doTick) , 0.0, false)
	end

	-- draw:drawSolidCircle(cc.p(VisibleRect:center().x + 140 ,VisibleRect:center().y), 100, math.pi/2, 50, 1.0, 2.0, cc.c4f(1,0,0,0.2))
end






function GuideRing:doTick(dt)
	self.curR = self.curR + dt * (self.maxR - self.minR) / self.time
	if self.curR > self.maxR then
		self.curR = self.minR
	end
	if self.ring then
		self.ring:removeSelf()
		-- self.ring1:removeSelf()
	end
	if self.ring1 then
		-- self.ring:removeSelf()
		self.ring1:removeSelf()
	end
	local opacity 
	if self.curR <(self.maxR - 20) then
		opacity = 1/(self.minR - (self.maxR - 20)) * self.curR - (self.maxR - 20) / (self.minR - (self.maxR - 20))
	else
		opacity = 0
	end

	-- self.ring = MySprite:create(self.curR, self.x,self.y,self.dis,1)
	-- 	:addTo(self)

	-- print(opacity)
	local draw = cc.DrawNode:create()
		:pos(self.x, self.y)
		
	draw:drawSolidCircle( cc.p(0 ,0), self.curR, math.rad(90), 50, 1.0, 1.0, cc.c4f(1,1,0,opacity*0.8))

	self.ring = circleClippingNode1(draw, self.curR - self.dis, self.x, self.y)
	:addTo(self)

	local draw = cc.DrawNode:create()
		:pos(self.x, self.y)
		
	draw:drawSolidCircle( cc.p(0 ,0), self.curR - self.dis + 1, math.rad(90), 50, 1.0, 1.0, cc.c4f(1,1,0,opacity * 0.5))

	self.ring1 = circleClippingNode1(draw, self.curR - self.dis - self.dis*0.5, self.x, self.y)
	:addTo(self)


end

function GuideRing:doTick1(dt)
	self.curR = self.curR - dt * (self.maxR +100  - self.minR) / 0.5
	if self.curR < self.dis + 10 then
		-- self.curR = self.minR
		if self.ticker then
			scheduler:unscheduleScriptEntry(self.ticker)
		end
		self.curR = self.minR
		self.ticker = scheduler:scheduleScriptFunc(handler(self, self.doTick) , 0.0, false)
		return
	end

	if self.ring then
		self.ring:removeSelf()
	end
	local opacity = 0.8
	-- if self.curR <(self.maxR - 20) then
	-- 	opacity = 1/(self.minR - (self.maxR - 20)) * self.curR - (self.maxR - 20) / (self.minR - (self.maxR - 20))
	-- else
	-- 	opacity = 0
	-- end

	-- self.ring = MySprite:create(self.curR, self.x,self.y,self.dis,1)
	-- 	:addTo(self)

	-- print(opacity)
	local draw = cc.DrawNode:create()
		:pos(self.x, self.y)
		
	draw:drawSolidCircle( cc.p(0 ,0), self.curR, math.rad(90), 50, 1.0, 1.0, cc.c4f(1,1,0,opacity))

	self.ring = circleClippingNode1(draw, self.curR - self.dis, self.x, self.y)
	:addTo(self)




end

function GuideRing:enter_exit(name)
	-- dump(name, "name")
	if name == "enter" then
		
	elseif name == "exit" then
		if self.ticker then
			scheduler:unscheduleScriptEntry(self.ticker)
			self.ticker = nil
		end
	end
end



return GuideRing