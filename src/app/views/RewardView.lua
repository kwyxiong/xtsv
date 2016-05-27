--
-- Author: kwyxiong
-- Date: 2016-04-09 00:34:55
--
local ViewBox = require("app.widgets.ViewBox")
local RewardView = class("RewardView", function() 
		return cc.uiloader:load("RewardView.json")
	end)

function RewardView:ctor(arg)
	self.data =arg.data


	self:init()
end

function RewardView:init()

 
	addButtonPressedState(self.subChildren.ButtonSure):onButtonClicked(function() 

			closeView(self)
	
		end)
	
	local viewBox = ViewBox.new({data = self.data})
		:pos(415, 300)
		:addTo(self)
	-- self.subChildren.Des:setString(str)
end



return RewardView