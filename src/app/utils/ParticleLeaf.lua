--
-- Author: kwyxiong
-- Date: 2015-12-07 16:06:22
--
local scheduler = cc.Director:getInstance():getScheduler()
local ParticleLeaf = class("ParticleLeaf", function() 
		return display.newNode()
	end)

function ParticleLeaf:ctor(arg)
	self.arg = arg or {}
	self.image = self.arg.image
	self.width = self.arg.width or display.width
	self.height = self.arg.height or display.height
	self.isPlaying = false
	self.time = 0
	self.dur = self:getDur()

	self:init()
end

function ParticleLeaf:init()
	self:registerScriptHandler(handler(self, self.enter_exit))
	self:start()	
end

function ParticleLeaf:enter_exit(name)
	-- dump(name, "name")
	if name == "enter" then
		
	elseif name == "exit" then
		if self.ticker then
			scheduler:unscheduleScriptEntry(self.ticker)
			self.ticker = nil
		end
	end
end

function ParticleLeaf:start()
	if not self.isPlaying then
		-- print("ParticleLeaf start")
		self.ticker = scheduler:scheduleScriptFunc(handler(self, self.doTick) , 0.0, false)
		self.isPlaying = true
	end
end

function ParticleLeaf:doTick(dt)
	if self.isPlaying then
		self.time = self.time + dt
		-- print(self.time)
		if self.time > self.dur then
			self:playLeaf(self:makeLeaf())
			self.dur = self:getDur()
			self.time = 0
			-- print(self.dur)
		end
	end
end

function ParticleLeaf:getDur()
	return math.random(6, 10) / 10
end

function ParticleLeaf:makeLeaf()
	local leaf = display.newSprite(self.image)
		:addTo(self)
		:pos(math.random(0,self.width), self.height)
	leaf:setScale(math.random(2, 6) / 10)
	leaf:setRotation(math.random(0, 360))

	leaf:setOpacity(0)
	leaf:runAction(cc.FadeIn:create(1))
	return leaf
end

function ParticleLeaf:playLeaf(leaf)

	local rand = math.random(1, 2)
	if rand == 1 then
		leaf:runAction(cc.Sequence:create(
			cc.MoveBy:create(math.random(25,70)/10, cc.p(0, -display.height)),
			cc.CallFunc:create(function() 
					leaf:removeSelf()
				end)
		))
	elseif rand == 2 then
		leaf:runAction(cc.Sequence:create(
			cc.MoveBy:create(math.random(50,200)/10, cc.p(0, -display.height)),
			cc.CallFunc:create(function() 
					leaf:removeSelf()
				end)
		))	
		local time = math.random(15, 30)/10
		local time1 = math.random(30, 90)/10
		local dis = math.random(50, 200)
		-- cc.EaseBackIn:create()
		local move = cc.MoveBy:create(time, cc.p(dis, 0))
	    local move_ease_inout3 = cc.EaseInOut:create(cc.MoveBy:create(time, cc.p(dis, 0)), 2)
	    local move_ease_inout_back3 = move_ease_inout3:reverse()
	    local seq3 = cc.Sequence:create(move_ease_inout3, move_ease_inout_back3)
	    leaf:runAction(cc.RepeatForever:create(seq3))

	    leaf:runAction(cc.RepeatForever:create(cc.RotateBy:create(time1, 360)))
	end
end


return ParticleLeaf