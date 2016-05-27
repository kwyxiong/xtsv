--
-- Author: kwyxiong
-- Date: 2016-04-07 10:59:51
--
local GetCardView = class("GetCardView", function() 
		return display.newNode()
	end)

function GetCardView:ctor(arg)
	local node = display.newNode()
		:addTo(self)
	local sp = display.newSprite(arg.cardId .. ".png")
		:pos(400, 300)
		:addTo(node)
	blurSprite(sp, 50.0)
	local sp = display.newSprite(arg.cardId .. ".png")
		:pos(400, 300)
		:addTo(node)
	blurSprite(sp, 30.0)
	local sp = display.newSprite(arg.cardId .. ".png")
		:pos(400, 300)
		:addTo(node)
	blurSprite(sp, 20.0)
	local sp = display.newSprite(arg.cardId .. ".png")
		:pos(400, 300)
		:addTo(node)
	whiteSprite(sp, 1.0)

	local sp = cc.ui.UIPushButton.new({normal =arg.cardId .. ".png"})
		:pos(400, 300)
		:addTo(node)
	:onButtonClicked(function() 
			if not self.touch then
				self.touch = true
				local time = 0.2
				-- local move = cc.MoveBy:create(time, cc.p(0, -20))
	   			local move_ease_inout3 = cc.EaseOut:create(cc.MoveBy:create(0.2, cc.p(0, -50)), 2)
	   			local move_ease_inout4 = cc.EaseIn:create(cc.MoveBy:create(0.8, cc.p(0, 600)), 6)
				node:runAction(cc.Sequence:create(
						-- cc.MoveBy:create(0.2, cc.p(0, -20)),
						move_ease_inout3,
						-- cc.MoveBy:create(1, cc.p(0, 600)),
						move_ease_inout4,
						cc.CallFunc:create(function() 
								-- node:setPosition(cc.p(0, 0))
								
								local sureCallback = function() 
									GameData[Global_saveData].cards[arg.cardId] = true
									save()
								end

								showView("TipsView", {type = "card",cardName = arg.cardName, sureCallback = sureCallback}, true, true)
								closeView(self)
							end)
					))

			end
		end)
 
end

return GetCardView