--
-- Author: kwyxiong
-- Date: 2015-07-10 16:25:23
--

--序章结束后领取奖励

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
-- local GuideSix = class(GuideSix, function() 
-- 		return cc.LayerColor:create(cc.c4b(122,122,122,0))
-- 	end)

local GuideSix = class("GuideSix",GuideBase)


function GuideSix:ctor(arg)
	arg =arg or {}
	GuideSix.super.ctor(self,arg)

	self.guides = {
			-- {type = "delay", time = 0.2 },
			-- {type = "delay", time = 11.2 },
			-- {type = "delay", time = 5.2 },
			{type = "pos", func = handler(self, self.func1),image = "guide7",
			 pos = handler(self, self.getClothButtonPos), size = handler(self, self.getClothButtonSize), hideRing = true,
			 touchCallback =  handler(self, self.getTaskNextButtonTouch)
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

	print("GuideSix --------------")
	self:start()
end

function GuideSix:func1()
	local panel = getViewByName("CityView")
	if not panel then
		self:error()
		return
	end	
	
	local sp = display.newSprite("image515.png")
		:pos(panel.subChildren.Image_4.subChildren.ButtonHome:getPosition())
		:addTo(panel.subChildren.Image_4)
	outlineSprite(sp)

	panel.sc:setTouchEnabled(false)
end

function GuideSix:getClothButtonPos()

	local panel = getViewByName("CityView")
	if not panel then
		self:error()
		return
	end	
	
	local btnFight = panel.subChildren.Image_4.subChildren.ButtonHome

	local pos = cc.Director:getInstance():getRunningScene():convertToNodeSpace(btnFight:convertToWorldSpace(cc.p(0,0)))
	return pos
	
	
end



function GuideSix:getClothButtonSize()

	local panel = getViewByName("CityView")
	if not panel then
		self:error()
		return
	end	
	

	return cc.size(display.width * 2 , display.height * 2)
	
end



function GuideSix:getClothButton1Pos()

	local panel = getViewByName("MenuView")
	if not panel then
		self:error()
		return
	end	
	
	local btnFight = panel.subChildren.PanelRightTop.subChildren.Image_7

	local pos = cc.Director:getInstance():getRunningScene():convertToNodeSpace(btnFight:convertToWorldSpace(cc.p(0,0)))

	return cc.p(pos.x + 63, pos.y + 24)
	
	
end



function GuideSix:getClothButton1Size()

	local panel = getViewByName("MenuView")
	if not panel then
		self:error()
		return
	end	
	

	return cc.size(display.width * 2 , display.height * 2)
	
end

function GuideSix:getTaskNextButtonTouch()

	local panel = getViewByName("CityView")
	if not panel then
		self:error()
		return
	end	
	

	
	return function() 
	-- panel.sc:setTouchEnabled(true)
	 end
end





function GuideSix:getClothButton2Pos()

	local panel = getViewByName("WardrobeView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.subChildren.Panel.subChildren["Button_" .. 5]
	
	local pos = cc.Director:getInstance():getRunningScene():convertToNodeSpace(btnFight:convertToWorldSpace(cc.p(0,0)))
	return pos
	
end



function GuideSix:getClothButton2Size()

	local panel = getViewByName("CityView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.subChildren.Image_4.subChildren.ButtonHome
	
	
	local size = btnFight.sprite_[1]:getContentSize()
	
	return size
	
end

function GuideSix:getClothButton3Pos()

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



function GuideSix:getClothButton3Size()


	
	return cc.size(62, 22)
	
end


function GuideSix:getClothButton4Pos()

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



function GuideSix:getClothButton4Size()


	
	return cc.size(62, 22)
	
end


function GuideSix:getClothButton5Pos()

	local panel = getViewByName("WardrobeView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.subChildren.Panel.subChildren["Button_" .. 1]
	
	local pos = cc.Director:getInstance():getRunningScene():convertToNodeSpace(btnFight:convertToWorldSpace(cc.p(0,0)))
	return pos
	
end



function GuideSix:getClothButton5Size()

	local panel = getViewByName("WardrobeView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.subChildren.Panel.subChildren["Button_" .. 1]
	
	
	local size = btnFight.sprite_[1]:getContentSize()
	
	return size
	
end


function GuideSix:over()

    ------print("mainAccept=" .. mainAccept)
    ------print("mainProcess=" .. mainProcess)

	print("GuideSix:over")
	self:removeSelf()

	-- GuideManager:startGuide("GuideSix")
end




function GuideSix:getClothButton6Pos()

	local panel = getViewByName("WardrobeView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.curViewBoxes[2].bgButton
	
	local pos = cc.Director:getInstance():getRunningScene():convertToNodeSpace(btnFight:convertToWorldSpace(cc.p(0,0)))
	return pos
	
end



function GuideSix:getClothButton6Size()

	local panel = getViewByName("WardrobeView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.curViewBoxes[2].bgButton
	
	
	local size = btnFight.sprite_[1]:getContentSize()
	
	return size
	
end


function GuideSix:getClothButton7Pos()

	local panel = getViewByName("WardrobeView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.subChildren.Panel.subChildren["Button_" .. 2]
	
	local pos = cc.Director:getInstance():getRunningScene():convertToNodeSpace(btnFight:convertToWorldSpace(cc.p(0,0)))
	return pos
	
end



function GuideSix:getClothButton7Size()

	local panel = getViewByName("WardrobeView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.subChildren.Panel.subChildren["Button_" .. 2]
	
	
	local size = btnFight.sprite_[1]:getContentSize()
	
	return size
	
end

function GuideSix:getClothButtonSurePos()

	local panel = getViewByName("WardrobeView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.subChildren.ButtonSure
	
	local pos = cc.Director:getInstance():getRunningScene():convertToNodeSpace(btnFight:convertToWorldSpace(cc.p(0,0)))
	return pos
	
end



function GuideSix:getClothButtonSureSize()

	local panel = getViewByName("WardrobeView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.subChildren.ButtonSure
	
	
	local size = btnFight.sprite_[1]:getContentSize()
	
	return size
	
end

return GuideSix