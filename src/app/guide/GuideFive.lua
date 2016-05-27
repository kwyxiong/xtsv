--
-- Author: kwyxiong
-- Date: 2015-07-10 16:25:23
--

--序章结束后领取奖励

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
-- local GuideFive = class(GuideFive, function() 
-- 		return cc.LayerColor:create(cc.c4b(122,122,122,0))
-- 	end)

local GuideFive = class("GuideFive",GuideBase)


function GuideFive:ctor(arg)
	arg =arg or {}
	GuideFive.super.ctor(self,arg)

	self.guides = {
			-- {type = "delay", time = 0.2 },
			-- {type = "delay", time = 11.2 },
			-- {type = "delay", time = 5.2 },
			{type = "pos", func = handler(self, self.func1),image = "guide5",
			 pos = handler(self, self.getClothButtonPos), size = handler(self, self.getClothButtonSize), hideRing = true,
			 touchCallback =  handler(self, self.getTaskNextButtonTouch)
			 },	--任务头像
			{type = "pos",image = "guide6",firstRing = true,
			 pos = handler(self, self.getClothButton1Pos), size = handler(self, self.getClothButton1Size),
			 },	--任务头像

			{type = "pos", 
			 pos = handler(self, self.getClothButtonPos), size = handler(self, self.getClothButton2Size), hideRing = true,
			 nextStep = true
			 },	--任务头像
			-- {type = "delay", time = self.moveTime },
			-- {type = "pos", pos = handler(self, self.getTaskGetButtonPos), size = handler(self, self.getTaskGetButtonSize),checkNet = true},	--接受任务
			-- {type = "pos", pos = handler(self, self.getTaskButtonPos),touchCallback =  handler(self, self.getTaskButtonTouch), size = handler(self, self.getTaskButtonSize) },--任务头像
			-- {type = "pos", pos = handler(self, self.getTaskNextButtonPos),size= handler(self, self.getTaskNextButtonSize) , 
			-- touchCallback =  handler(self, self.getTaskNextButtonTouch),
			--  noScale = true
			-- },	--下一步
			-- {type = "pos", pos = handler(self, self.getTaskGetButtonPos),size= handler(self, self.getTaskGetButtonSize),checkNet = true },	--领取奖励
			--任务头像
			-- {type = "pos", pos = handler(self, self.getItemSureButtonPos),size= handler(self, self.getItemSureButtonSize)  },	--确定
		}

	print("GuideFive --------------")
	self:start()
end

function GuideFive:func1()
	local panel = getViewByName("CityView")
	if not panel then
		self:error()
		return
	end	
	
	local sp = display.newSprite("image521.png")
		:pos(panel.subChildren.Image_4.subChildren.ButtonShop:getPosition())
		:addTo(panel.subChildren.Image_4)
	outlineSprite(sp)

	panel.sc:setTouchEnabled(false)
end

function GuideFive:getClothButtonPos()

	local panel = getViewByName("CityView")
	if not panel then
		self:error()
		return
	end	
	
	local btnFight = panel.subChildren.Image_4.subChildren.ButtonShop

	local pos = cc.Director:getInstance():getRunningScene():convertToNodeSpace(btnFight:convertToWorldSpace(cc.p(0,0)))
	return pos
	
	
end



function GuideFive:getClothButtonSize()

	local panel = getViewByName("CityView")
	if not panel then
		self:error()
		return
	end	
	

	return cc.size(display.width * 2 , display.height * 2)
	
end



function GuideFive:getClothButton1Pos()

	local panel = getViewByName("MenuView")
	if not panel then
		self:error()
		return
	end	
	
	local btnFight = panel.subChildren.PanelRightTop.subChildren.ButtonAdd

	local pos = cc.Director:getInstance():getRunningScene():convertToNodeSpace(btnFight:convertToWorldSpace(cc.p(0,0)))

	return cc.p(pos.x, pos.y)
	
	
end



function GuideFive:getClothButton1Size()

	local panel = getViewByName("MenuView")
	if not panel then
		self:error()
		return
	end	
	

	return cc.size(display.width * 2 , display.height * 2)
	
end

function GuideFive:getTaskNextButtonTouch()

	local panel = getViewByName("CityView")
	if not panel then
		self:error()
		return
	end	
	

	
	return function() 
	-- panel.sc:setTouchEnabled(true)
	 end
end





function GuideFive:getClothButton2Pos()

	local panel = getViewByName("WardrobeView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.subChildren.Panel.subChildren["Button_" .. 5]
	
	local pos = cc.Director:getInstance():getRunningScene():convertToNodeSpace(btnFight:convertToWorldSpace(cc.p(0,0)))
	return pos
	
end



function GuideFive:getClothButton2Size()

	local panel = getViewByName("CityView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.subChildren.Image_4.subChildren.ButtonShop
	
	
	local size = btnFight.sprite_[1]:getContentSize()
	
	return size
	
end

function GuideFive:getClothButton3Pos()

	local panel = getViewByName("WardrobeView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.labelButtons.buttons[2]
	
	local pos = cc.Director:getInstance():getRunningScene():convertToNodeSpace(btnFight:convertToWorldSpace(cc.p(0,0)))
	pos = cc.pAdd(pos, cc.p(-4, 4))
	return pos
	
end



function GuideFive:getClothButton3Size()


	
	return cc.size(62, 22)
	
end


function GuideFive:getClothButton4Pos()

	local panel = getViewByName("WardrobeView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.labelButtons.buttons[1]
	
	local pos = cc.Director:getInstance():getRunningScene():convertToNodeSpace(btnFight:convertToWorldSpace(cc.p(0,0)))
	pos = cc.pAdd(pos, cc.p(-4, 4))
	return pos
	
end



function GuideFive:getClothButton4Size()


	
	return cc.size(62, 22)
	
end


function GuideFive:getClothButton5Pos()

	local panel = getViewByName("WardrobeView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.subChildren.Panel.subChildren["Button_" .. 1]
	
	local pos = cc.Director:getInstance():getRunningScene():convertToNodeSpace(btnFight:convertToWorldSpace(cc.p(0,0)))
	return pos
	
end



function GuideFive:getClothButton5Size()

	local panel = getViewByName("WardrobeView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.subChildren.Panel.subChildren["Button_" .. 1]
	
	
	local size = btnFight.sprite_[1]:getContentSize()
	
	return size
	
end


function GuideFive:over()

    ------print("mainAccept=" .. mainAccept)
    ------print("mainProcess=" .. mainProcess)

	print("GuideFive:over")
	self:removeSelf()

	-- GuideManager:startGuide("GuideFive")
end




function GuideFive:getClothButton6Pos()

	local panel = getViewByName("WardrobeView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.curViewBoxes[2].bgButton
	
	local pos = cc.Director:getInstance():getRunningScene():convertToNodeSpace(btnFight:convertToWorldSpace(cc.p(0,0)))
	return pos
	
end



function GuideFive:getClothButton6Size()

	local panel = getViewByName("WardrobeView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.curViewBoxes[2].bgButton
	
	
	local size = btnFight.sprite_[1]:getContentSize()
	
	return size
	
end


function GuideFive:getClothButton7Pos()

	local panel = getViewByName("WardrobeView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.subChildren.Panel.subChildren["Button_" .. 2]
	
	local pos = cc.Director:getInstance():getRunningScene():convertToNodeSpace(btnFight:convertToWorldSpace(cc.p(0,0)))
	return pos
	
end



function GuideFive:getClothButton7Size()

	local panel = getViewByName("WardrobeView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.subChildren.Panel.subChildren["Button_" .. 2]
	
	
	local size = btnFight.sprite_[1]:getContentSize()
	
	return size
	
end

function GuideFive:getClothButtonSurePos()

	local panel = getViewByName("WardrobeView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.subChildren.ButtonSure
	
	local pos = cc.Director:getInstance():getRunningScene():convertToNodeSpace(btnFight:convertToWorldSpace(cc.p(0,0)))
	return pos
	
end



function GuideFive:getClothButtonSureSize()

	local panel = getViewByName("WardrobeView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.subChildren.ButtonSure
	
	
	local size = btnFight.sprite_[1]:getContentSize()
	
	return size
	
end

return GuideFive