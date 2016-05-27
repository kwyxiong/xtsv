--
-- Author: kwyxiong
-- Date: 2015-07-10 16:25:23
--

--序章结束后领取奖励

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
-- local GuideNine = class(GuideNine, function() 
-- 		return cc.LayerColor:create(cc.c4b(122,122,122,0))
-- 	end)

local GuideNine = class("GuideNine",GuideBase)


function GuideNine:ctor(arg)
	arg =arg or {}
	GuideNine.super.ctor(self,arg)

	self.guides = {
			-- {type = "delay", time = 0.2 },
			-- {type = "delay", time = 11.2 },
			-- {type = "delay", time = 5.2 },
			{type = "pos",image = "guide11",firstRing = true, ringSize = 100,
			 pos = handler(self, self.getClothButtonPos), size = handler(self, self.getClothButtonSize),
			 },	--任务头像
			-- {type = "pos", 
			--  pos = handler(self, self.getClothButtonPos), size = handler(self, self.getClothButton1Size), hideRing = false,
			--  nextStep = true

			--  },	--任务头像
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

	print("GuideNine --------------")
	self:start()
end


function GuideNine:getClothButtonPos()

	local panel = getViewByName("MenuView")
	if not panel then
		self:error()
		return
	end	
	
	local btnFight = panel.head

	local pos = cc.Director:getInstance():getRunningScene():convertToNodeSpace(btnFight:convertToWorldSpace(cc.p(0,0)))
	return pos
	
	
end



function GuideNine:getClothButtonSize()

	local panel = getViewByName("MenuView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.head
	
	
	local size = btnFight.sprite_[1]:getContentSize()
	
	return size
	
	
end


function GuideNine:getTaskNextButtonTouch()

	local panel = getViewByName("CityView")
	if not panel then
		self:error()
		return
	end	
	

	
	return function() 
	-- panel.sc:setTouchEnabled(true)
	 end
end



function GuideNine:getClothButton1Size()

	local panel = getViewByName("CityView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.subChildren.Image_4.subChildren.ButtonOffice
	
	
	local size = btnFight.sprite_[1]:getContentSize()
	
	return size
	
end

function GuideNine:getClothButton2Pos()

	local panel = getViewByName("WardrobeView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.subChildren.Panel.subChildren["Button_" .. 5]
	
	local pos = cc.Director:getInstance():getRunningScene():convertToNodeSpace(btnFight:convertToWorldSpace(cc.p(0,0)))
	return pos
	
end



function GuideNine:getClothButton2Size()

	local panel = getViewByName("WardrobeView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.subChildren.Panel.subChildren["Button_" .. 5]
	
	
	local size = btnFight.sprite_[1]:getContentSize()
	
	return size
	
end

function GuideNine:getClothButton3Pos()

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



function GuideNine:getClothButton3Size()


	
	return cc.size(62, 22)
	
end


function GuideNine:getClothButton4Pos()

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



function GuideNine:getClothButton4Size()


	
	return cc.size(62, 22)
	
end


function GuideNine:getClothButton5Pos()

	local panel = getViewByName("WardrobeView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.subChildren.Panel.subChildren["Button_" .. 1]
	
	local pos = cc.Director:getInstance():getRunningScene():convertToNodeSpace(btnFight:convertToWorldSpace(cc.p(0,0)))
	return pos
	
end



function GuideNine:getClothButton5Size()

	local panel = getViewByName("WardrobeView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.subChildren.Panel.subChildren["Button_" .. 1]
	
	
	local size = btnFight.sprite_[1]:getContentSize()
	
	return size
	
end


function GuideNine:over()

    ------print("mainAccept=" .. mainAccept)
    ------print("mainProcess=" .. mainProcess)

	print("GuideNine:over")
	self:removeSelf()

	-- GuideManager:startGuide("GuideNine")
end




function GuideNine:getClothButton6Pos()

	local panel = getViewByName("WardrobeView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.curViewBoxes[2].bgButton
	
	local pos = cc.Director:getInstance():getRunningScene():convertToNodeSpace(btnFight:convertToWorldSpace(cc.p(0,0)))
	return pos
	
end



function GuideNine:getClothButton6Size()

	local panel = getViewByName("WardrobeView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.curViewBoxes[2].bgButton
	
	
	local size = btnFight.sprite_[1]:getContentSize()
	
	return size
	
end


function GuideNine:getClothButton7Pos()

	local panel = getViewByName("WardrobeView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.subChildren.Panel.subChildren["Button_" .. 2]
	
	local pos = cc.Director:getInstance():getRunningScene():convertToNodeSpace(btnFight:convertToWorldSpace(cc.p(0,0)))
	return pos
	
end



function GuideNine:getClothButton7Size()

	local panel = getViewByName("WardrobeView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.subChildren.Panel.subChildren["Button_" .. 2]
	
	
	local size = btnFight.sprite_[1]:getContentSize()
	
	return size
	
end

function GuideNine:getClothButtonSurePos()

	local panel = getViewByName("WardrobeView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.subChildren.ButtonSure
	
	local pos = cc.Director:getInstance():getRunningScene():convertToNodeSpace(btnFight:convertToWorldSpace(cc.p(0,0)))
	return pos
	
end



function GuideNine:getClothButtonSureSize()

	local panel = getViewByName("WardrobeView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.subChildren.ButtonSure
	
	
	local size = btnFight.sprite_[1]:getContentSize()
	
	return size
	
end

return GuideNine