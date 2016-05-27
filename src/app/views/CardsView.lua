--
-- Author: kwyxiong
-- Date: 2016-04-07 12:30:27
--


local CardsView = class("CardsView", function() 
		return cc.uiloader:load("CardsView.json")
	end)

function CardsView:ctor(arg)


	self:init()
end

function CardsView:init()

 	addButtonPressedState(self.subChildren.ButtonClose):onButtonClicked(function() 

			closeView(self)
			
		end)



 	local firstPos = cc.p(133, 377)
 	local disX, disY = 170, 200
 	local index = 1
 	for k, v in ipairs(Global_cards.cards) do
 		if GameData[Global_saveData].cards[v.id] then
	 		local p = cc.p(firstPos.x + (index-1)%4*disX, firstPos.y - disY*math.floor((index-1)/4))
	 		local sp =display.newSprite(v.id .. ".png")
	 		local sp = cc.ui.UIPushButton.new({normal = v.id .. ".png"})
	 			:pos(p.x, p.y)
	 			:addTo(self)
	 			:setScale(145/372)
	 		addButtonPressedState(sp, 0.02):onButtonClicked(function() 
	 				showView("CardInfoView",{cardData = v}, true, true)
 			end)

	 		index = index + 1
	 	end
 		-- drug(sp)
 	end

end



return CardsView