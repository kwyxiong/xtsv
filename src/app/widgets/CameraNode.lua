--
-- Author: kwyxiong
-- Date: 2016-04-06 22:17:16
--
local scheduler = cc.Director:getInstance():getScheduler()
local CameraNode = class("CameraNode", function() 
		return display.newNode()
	end)

function CameraNode:ctor(arg)
	self.arg = arg
	self.height = 0
	self:init()
	

	self:addNodeEventListener(cc.NODE_EVENT, function(event)
    if event.name == "enter" then
            self:onEnter()
        elseif event.name == "exit" then
            self:onExit()
        end
    end)


end

function CameraNode:play()
	self.bg:setOpacity(0)
	self.bg:runAction(cc.Sequence:create(
			cc.FadeIn:create(0.7),
			cc.CallFunc:create(function() 
					self.ticker = scheduler:scheduleScriptFunc(handler(self, self.doTick) , 0.0, false)
				end)
		))
	
end



function CameraNode:wear(id)
	id = tonumber(id)
	-- dump(Global_clothes, "Global_clothes")
	-- print("id", id)
	local data = Global_clothes[id]
	-- dump(data, "data")
	local sps = {}
	local layer = "0"	
	for k, v in ipairs(data.parts) do
		if v.img ~= "" then
			if k == 1 then
				layer = v.layer
			end
			local sp = display.newSprite(v.img)
				:pos(v.fix.x, 600 - v.fix.y)
				:zorder(tonumber(v.layer) * 10)
				:addTo(self.bodyNode)
			sp:setAnchorPoint(cc.p(0, 1))
			sps[#sps + 1] = sp
			-- print("hhhhhhhhhhhhhhhh")
		end
	end

end

function CameraNode:doTick(dt)
	-- print(dt)
	self.height = self.height + dt * 600
	if self.height >= 600 then
		self.height = 600
		self.sp1:setTextureRect(cc.rect(0,0,800,self.height))
		scheduler:unscheduleScriptEntry(self.ticker)
		self.ticker = nil
		self:sp1Over()
	else
		self.sp1:setTextureRect(cc.rect(0,0,800,self.height))
	end
	
end

function CameraNode:sp1Over()
	self.camera2 = display.newSprite("image127.png")
		:pos(0, -290)
		:addTo(self, 5)
	self.camera3 = display.newSprite("image129.png")
		:pos(0, -290)
		:addTo(self, 5)
	
	self.camera2:runAction(cc.MoveTo:create(0.5, cc.p(0, 0)))
	self.camera3:runAction(cc.Sequence:create(
			cc.MoveTo:create(0.5, cc.p(0, 0)),
			cc.CallFunc:create(function() 
					self:camera3Over()
				end)
		))
end

function CameraNode:camera3Over()
	self.camera1 = display.newSprite("image135.png")
		:pos(-400, 0)
		:addTo(self, 4)
	self.camera4 = display.newSprite("image131.png")
		:pos(400, 0)
		:addTo(self, 4)



	self.camera1:runAction(cc.MoveTo:create(0.5, cc.p(0, 0)))
	self.camera4:runAction(cc.Sequence:create(
			cc.MoveTo:create(0.5, cc.p(0, 0)),
			cc.CallFunc:create(function() 
					self:camera4Over()
				end)
		))		
end

function CameraNode:camera4Over()
	self.camera5 = display.newSprite("image143.png")
		:pos(-400, 0)
		:addTo(self, 3)
	self.camera6 = display.newSprite("image138.png")
		:pos(400, 0)
		:addTo(self, 3)



	self.camera5:runAction(cc.MoveTo:create(0.5, cc.p(0, 0)))
	self.camera6:runAction(cc.Sequence:create(
			cc.MoveTo:create(0.5, cc.p(0, 0)),
			cc.CallFunc:create(function() 
					self:camera6Over()
				end)
		))		
end

function CameraNode:camera6Over()
	local sp2 = display.newSprite("image140.png")
		:addTo(self, 2)
	local sp2 = display.newSprite("image145.png")
		:addTo(self, 2)
	local sp2 = display.newSprite("image148.png")
		:addTo(self, 2)
	local sp3 = display.newSprite("image150.png")
		:addTo(self, 2)

	local sp4 = display.newSprite("image150.png")
		:pos(-50, 0)
		:addTo(self, 2)
	sp4:setScaleX(-1)

	sp3:setVisible(false)
	sp4:setVisible(false)
	sp3:runAction(cc.Sequence:create(
			cc.DelayTime:create(0.1),
			cc.CallFunc:create(function() 
					sp3:setVisible(true)
					sp4:setVisible(true)
					self.sp2:setVisible(true)
				end),
			cc.DelayTime:create(0.1),
			cc.CallFunc:create(function() 
					sp3:setVisible(false)
					sp4:setVisible(false)
					self.sp2:setVisible(false)
				end),
			cc.DelayTime:create(0.1),
			cc.CallFunc:create(function() 
					sp3:setVisible(true)
					sp4:setVisible(true)
					self.sp2:setVisible(true)
				end),
			cc.DelayTime:create(0.1),
			cc.CallFunc:create(function() 
					sp3:setVisible(false)
					sp4:setVisible(false)
					self.sp2:setVisible(false)
				end),
			cc.CallFunc:create(function() 
					cascade(self)
					self.arg[3]()
					for k, v in ipairs(self:getChildren()) do
						if v ~= self.bodyNode then
							v:runAction(cc.Sequence:create(
								cc.FadeOut:create(0.7),
								cc.CallFunc:create(function() 
										if not self.remove then
											self.remove = true
											self:removeSelf()
										end
									end)
							))
						end
					end
					
				end)
		))
end


function CameraNode:onEnter()

end

function CameraNode:onExit()
	if self.ticker then
		scheduler:unscheduleScriptEntry(self.ticker)
		self.ticker = nil
	end	
end


function CameraNode:init()
	local bg = display.newSprite("image119.jpg")
		-- :pos(-400, 300)
		:addTo(self)
	self.bg = bg
	local sp1 = display.newSprite("image123.png")
		:pos(-400, 300)
		:addTo(self)
	local sp2 = display.newSprite("image153.png")
		:pos(-400, 300)
		:addTo(self)	
	self.sp2 = sp2
	sp2:setVisible(false)
	sp1:setAnchorPoint(cc.p(0, 1))
	sp2:setAnchorPoint(cc.p(0, 1))
	self.sp1 = sp1


	self.sp1:setTextureRect(cc.rect(0,0,800,0))
	self.bodyNode = display.newNode()
		:pos(88 + 70 - 400 , -17 - 300)
		:addTo(self, 1)

	for k, v in pairs(self.arg[1]) do
		self:wear(v.data.id)
	end
end

return CameraNode