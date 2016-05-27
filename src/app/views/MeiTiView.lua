--
-- Author: kwyxiong
-- Date: 2016-04-06 18:19:46
--


local MeiTiView = class("MeiTiView", function() 
		return cc.uiloader:load("MeiTiView.json")
		-- return ccs.GUIReader:getInstance():widgetFromJsonFile("MeiTiView.json")
	end)

--15_90
--5_270
--6_230
function MeiTiView:ctor(arg)
 	self.arg = arg or {}
	
	self:init()
end

function MeiTiView:init()



	addButtonPressedState(self.subChildren.Panel.subChildren.ButtonClose):onButtonClicked(function() 
			

			if self.arg.overCallback then
				self.arg.overCallback()
			end
			closeView(self)
		end)
	
	local sp = display.newSprite("fashion.png")
		:pos(273, 187)
		:addTo(self.subChildren.Panel.subChildren.PanelTask)
	-- sp:setCascadeOpacityEnabled(true)
end	


function MeiTiView:initTask()

end

return MeiTiView