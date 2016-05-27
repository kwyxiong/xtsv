--
-- Author: kwyxiong
-- Date: 2016-04-01 23:44:40
--

local TabButton = class("TabButton", function() 
		return display.newNode()
	end)	

function TabButton:ctor(arg)
	self.text = arg.text
	self.bigPart = arg.bigPart
	self.smallPart = arg.smallPart
	self.button = nil
	self.highlighted = false
	self:init()
end

function TabButton:init()
	self.button = cc.ui.UIPushButton.new({normal = "tabButton1.png", pressed = "tabButton2.png"})
		:addTo(self)
	self.label = cc.ui.UILabel.new({text = self.text, size = 14})
		:setColor(cc.c3b(102, 45, 19))
		:addTo(self)
		-- :pos(-5 , 4)
	self.label:setAnchorPoint(cc.p(0.5, 0.5))
	-- self.button:setButtonLabel(self.label)

-- 	self.button:onButtonPressed(function() 	
-- 			-- self:setHighlighted(true)
-- 		end)
-- 	self.button:onButtonRelease(function()
-- 			-- self:setHighlighted(false)
-- 		end)
end

function TabButton:setHighlighted(boolean)
	if self.highlighted ~= boolean then
		self.highlighted = boolean 
		if self.highlighted then
			self.button:setButtonImage("normal", "tabButton2.png")
			self.button:setTouchEnabled(false)
		else
			self.button:setButtonImage("normal", "tabButton1.png")
			self.button:setTouchEnabled(true)
		end
	end
end
	
function TabButton:onButtonClicked(func)
	self.button:onButtonClicked(func)
	return self
end

return TabButton