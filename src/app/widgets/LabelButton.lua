
--
-- Author: kwyxiong
-- Date: 2016-01-20 15:07:45
--
local LabelButton = class("LabelButton", function() 
		return display.newNode()
	end)	

function LabelButton:ctor(arg)
	self.text = arg.text
	self.bigPart = arg.bigPart
	self.smallPart = arg.smallPart
	self.button = nil
	self.highlighted = false
	self:init()
end

function LabelButton:init()
	self.button = cc.ui.UIPushButton.new({normal = "imgbtn.png", pressed = "imgbtn.png"})
		:addTo(self)
	self.button:setScaleX(0.9)
	self.button:setScaleY(1.4)
	self.label = cc.ui.UILabel.new({text = self.text, size = 14})
		:setTextColor(cc.c4b(255, 255, 153, 255))
		self.label:addTo(self)
		:pos(-5 , 4)
	self.label:enableOutline(cc.c4b(102, 45, 19, 255), 2)
	self.label:setAnchorPoint(cc.p(0.5, 0.5))
	-- self.button:setButtonLabel(self.label)

	self.button:onButtonPressed(function() 	
			self:setHighlighted(true)
		end)
	self.button:onButtonRelease(function()
			self:setHighlighted(false)
		end)
end

function LabelButton:setHighlighted(boolean)
	if self.highlighted ~= boolean then
		self.highlighted = boolean 
		if self.highlighted then
			self.button:setPositionY(6)
			self.label:setPositionY(7)
			self.button:setTouchEnabled(false)
		else
			self.button:setPositionY(0)
			self.label:setPositionY(4)
			self.button:setTouchEnabled(true)
		end
	end
end
	
function LabelButton:onButtonClicked(func)

	self.button:onButtonClicked(function() 
				if GuideManager:isGuiding() then
					GuideManager:nextStep()
				end
				func()
		end)
	return self
end

return LabelButton