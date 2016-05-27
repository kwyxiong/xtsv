--
-- Author: kwyxiong
-- Date: 2016-03-22 10:52:25
--

local function getImgFileName(para)
	local img
	if para.layer == "bg" then
		img = para.img .. ".jpg"
	else
		img = para.img .. ".png"
	end
	return img
end


local TransSprite = class("TransSprite", function(para)

		return display.newSprite(getImgFileName(para))
	end)	



function TransSprite:ctor(para)

	self:setAnchorPoint(cc.p(0, 1))

	self.bright = para.bright or 1.0
	self.alpha = para.alpha or 1.0
	brightSprite(self, self.bright, self.alpha)

	self:pos(para.x , 600 - para.y )

	self.posnag_bright = 1
	self.posnag_alpha = 1

	self.target_bright = 0
	self.target_alpha = 0

	self.speed_bright = 0
	self.speed_alpha = 0

	self.dur = 0

	self.inTrans = false
	self.transTime = 0

	self.transOverCallback = nil

	-- self:setCascadeOpacityEnabled(true)
	    -- 注册帧事件
    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.tick))
    self:scheduleUpdate()




end

function TransSprite:tick(dt)
	if self.inTrans then
		self.dur = self.dur - dt
		if self.dur < 0 then
			self:setBright(self.target_bright)
			self:setAlpha(self.target_alpha)
			self.inTrans = false
			if self.transOverCallback then
				self.transOverCallback()
				self.transOverCallback = nil
			end
			return
		end
		if self.posnag_bright ~= 0 then
			self:setBright(self:getBright() + self.speed_bright * dt)
			if (self.target_bright - self:getBright()) * self.posnag_bright < 0 then
				self:setBright(self.target_bright)
				self.posnag_bright = 0
			end
		end

		if self.posnag_alpha ~= 0 then
			self:setAlpha(self:getAlpha() + self.speed_alpha * dt)
			if (self.target_alpha - self:getAlpha()) * self.posnag_alpha < 0 then
				self:setAlpha(self.target_alpha)
				self.posnag_alpha = 0
			end
		end


	end
end

function TransSprite:setPara(para)
	self:setBright(para.bright)
	self:setAlpha(para.alpha)
	self:pos(para.x , 600 - para.y )
	self:setTexture(getImgFileName(para))
end


function TransSprite:trans(dur, para, transOverCallback)

	self.dur = dur
	if dur == 0 then
		dur = 1
	end
	self.transOverCallback = transOverCallback

	self.target_bright = para.bright
	self.target_alpha = para.alpha

	self.speed_bright = (para.bright - self.bright) / dur
	self.speed_alpha = (para.alpha - self.alpha) / dur

	self.posnag_bright = para.bright - self.bright
	self.posnag_alpha = para.alpha - self.alpha


	self.inTrans = true

	if self:getPositionX() ~= para.x or self:getPositionY() ~= 600 - para.y then
		self:runAction(cc.Sequence:create(
			cc.MoveTo:create(self.dur, cc.p(para.x, 600 - para.y)),
			cc.CallFunc:create(function() 
					if self.transOverCallback then
						self.transOverCallback()
						self.transOverCallback = nil
					end
				end)
			))
	end
end

function TransSprite:getBright()
	return self.bright
end

function TransSprite:getAlpha()
	return self.alpha
end

function TransSprite:setBright(bright)
	self.bright = bright
	-- print("bright = " .. bright)
	self:getGLProgramState():setUniformFloat("bright", bright or 1.0)
end

function TransSprite:setAlpha(alpha)
	self.alpha = alpha
	-- print("alpha = " .. alpha)
	self:getGLProgramState():setUniformFloat("alpha", alpha or 1.0)

end

return TransSprite