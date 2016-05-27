--
-- Author: kwyxiong
-- Date: 2016-04-01 00:32:41
--

local OfficeView = class("OfficeView", function() 
		return cc.uiloader:load("OfficeView.json")
		-- return ccs.GUIReader:getInstance():widgetFromJsonFile("OfficeView.json")
	end)

function OfficeView:ctor(arg)
	-- dump(arg)

	self.grays = {}
	self.myTitle = GameData[Global_saveData].title
	-- self.grays[2] = true
	-- self.grays[1] = true
	-- self.grays[3] = true
	if  self.myTitle <  tonumber(Global_setting2.work_titlelevel) then
		self.grays[2] = true
	else
		if GameData[Global_saveData].initRenWu == 0 then
			GameData[Global_saveData].initRenWu = 1
			local max_work = tonumber(Global_setting2.max_work)


			for k = 1, max_work do
				if #GameData[Global_saveData].renWuPool > 0 then
					
		            GameData[Global_saveData].curRenWus[#GameData[Global_saveData].curRenWus + 1] = {id = getTaskFromPool()}
    			end
			end

			
		 	GameState.save(GameData)
		end
	end

	self.arg = arg or {}
	self:init()

end

function OfficeView:init()
	-- local button = self:getChildByName("ButtonClose")
	-- print("button", button)
	-- button:addTouchEventListener(function(a, b) 
	-- 		dump(a)
	-- 		dump(b)
	-- 	end)
	-- addButtonPressedState(self.subChildren.PanelButtons.subChildren.ButtonFuZhuang)
	-- addButtonPressedState(self.subChildren.PanelButtons.subChildren.ButtonShiPin)
	-- addButtonPressedState(self.subChildren.PanelButtons.subChildren.ButtonMeiRong)
	

	addButtonPressedState(self.subChildren.Panel.subChildren.ButtonClose):onButtonClicked(function() 
			app:enterScene("CityScene")

		end)
	cascade(self.subChildren.Panel)


	for k = 1, 3 do
		local button = self.subChildren.Panel.subChildren["Panel_" .. k].subChildren.Button
		if not self.grays[k] then
			button:onButtonPressed(function() 
						self.subChildren.Panel.subChildren["Panel_" .. k].subChildren.Image_13:stopAllActions()
						self.subChildren.Panel.subChildren["Panel_" .. k].subChildren.Image_14:stopAllActions()
						self.subChildren.Panel.subChildren["Panel_" .. k].subChildren.Image_13:runAction(cc.ScaleTo:create(0.2, 1.5))
						self.subChildren.Panel.subChildren["Panel_" .. k].subChildren.Image_14:runAction(cc.ScaleTo:create(0.2, 1.2))
					end)
				:onButtonRelease(function() 
						self.subChildren.Panel.subChildren["Panel_" .. k].subChildren.Image_13:stopAllActions()
						self.subChildren.Panel.subChildren["Panel_" .. k].subChildren.Image_14:stopAllActions()
						self.subChildren.Panel.subChildren["Panel_" .. k].subChildren.Image_13:runAction(cc.ScaleTo:create(0.2, 1))
						self.subChildren.Panel.subChildren["Panel_" .. k].subChildren.Image_14:runAction(cc.ScaleTo:create(0.2, 1))
					end)
				:onButtonClicked(function() 
						local overCallback = function() 
							self.subChildren.Panel:setVisible(true)
							self.subChildren.Panel:runAction(cc.FadeIn:create(0.2))
						end
						if k == 1 then
							self.subChildren.Panel:runAction(cc.FadeOut:create(0.15))
							self.subChildren.Panel:runAction(cc.Sequence:create(
									cc.FadeOut:create(0.15),
									cc.CallFunc:create(function() 
											self.subChildren.Panel:setVisible(false)
										end)
								))

							showView("JuQingView", {overCallback = overCallback}, false, true)
						elseif k == 2 then
							self.subChildren.Panel:runAction(cc.FadeOut:create(0.15))
							self.subChildren.Panel:runAction(cc.Sequence:create(
									cc.FadeOut:create(0.15),
									cc.CallFunc:create(function() 
											self.subChildren.Panel:setVisible(false)
										end)
								))
							showView("RenWuView", {overCallback = overCallback}, false, true)
						elseif k == 3 then
							self.subChildren.Panel:runAction(cc.FadeOut:create(0.15))
							self.subChildren.Panel:runAction(cc.Sequence:create(
									cc.FadeOut:create(0.15),
									cc.CallFunc:create(function() 
											self.subChildren.Panel:setVisible(false)
										end)
								))
							showView("MeiTiView", {overCallback = overCallback}, false, true)						
						end
					end)
			self.subChildren.Panel.subChildren["Panel_" .. k].subChildren.Image_13:setScale(1.5)
			self.subChildren.Panel.subChildren["Panel_" .. k].subChildren.Image_14:setScale(1.2)
			self.subChildren.Panel.subChildren["Panel_" .. k].subChildren.Image_13:runAction(cc.ScaleTo:create(0.3, 1))
			self.subChildren.Panel.subChildren["Panel_" .. k].subChildren.Image_14:runAction(cc.ScaleTo:create(0.3, 1))
		else
			button:setButtonEnabled(false)
			if k == 2 then
				self.subChildren.Panel.subChildren["Panel_" .. k].subChildren.Image_12:setTexture("renwu_1.png")

			elseif k == 1 then
				self.subChildren.Panel.subChildren["Panel_" .. k].subChildren.Image_12:setTexture("juqing_1.png")

			elseif k == 3 then
				self.subChildren.Panel.subChildren["Panel_" .. k].subChildren.Image_12:setTexture("meiti_1.png")
			end
		end
	end
	-- local ui =  ccs.GUIReader:getInstance():widgetFromJsonFile("ShopActionView.json")
	-- 	:addTo(self.subChildren.PanelPerson1)
	-- local action = ccs.ActionManagerEx:getInstance():getActionByName("ShopActionView.json", "Animation0")

	-- action:play()
	-- self:grayRenWu()
	self:updateTitle()
end	

function OfficeView:updateTitle()
	if self.myTitle == 0 then
		self.subChildren.Title:setVisible(false)
	else
		self.subChildren.Title:setVisible(true)
		self.subChildren.Title:setTexture("title_" .. self.myTitle  .. ".png")
	end
end



return OfficeView