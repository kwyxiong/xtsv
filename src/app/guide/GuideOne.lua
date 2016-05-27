--
-- Author: kwyxiong
-- Date: 2015-07-10 16:25:23
--

--序章结束后领取奖励

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
-- local GuideOne = class(GuideOne, function() 
-- 		return cc.LayerColor:create(cc.c4b(122,122,122,0))
-- 	end)

local GuideOne = class("GuideOne",GuideBase)


function GuideOne:ctor(arg)
	arg =arg or {}
	GuideOne.super.ctor(self,arg)

	self.guides = {
			-- {type = "delay", time = 0.2 },
			-- {type = "delay", time = 11.2 },
			-- {type = "delay", time = 5.2 },
			{type = "pos", pos = handler(self, self.getClothButtonPos),
			func = handler(self, self.func1),
			 size = handler(self, self.getClothButtonSize), image = "guide00001", firstRing = true},	--任务头像
			-- {type = "delay", time = self.moveTime },
			-- {type = "pos", pos = handler(self, self.getTaskGetButtonPos), size = handler(self, self.getTaskGetButtonSize),checkNet = true},	--接受任务
			-- {type = "pos", pos = handler(self, self.getTaskButtonPos),touchCallback =  handler(self, self.getTaskButtonTouch), size = handler(self, self.getTaskButtonSize) },--任务头像
			-- {type = "pos", pos = handler(self, self.getTaskNextButtonPos),size= handler(self, self.getTaskNextButtonSize) , 
			-- touchCallback =  handler(self, self.getTaskNextButtonTouch),
			--  noScale = true
			-- },	--下一步
			-- {type = "pos", pos = handler(self, self.getTaskGetButtonPos),size= handler(self, self.getTaskGetButtonSize),checkNet = true },	--领取奖励
			{type = "delay", time = 0.7 },
			{type = "pos", ringSize = 130, pos = handler(self, self.getClothButton1Pos), size = handler(self, self.getClothButton1Size)},	--任务头像
			{type = "pos", pos = handler(self, self.getClothButton2Pos), size = handler(self, self.getClothButton2Size)},	--任务头像
			{type = "pos", ringSize = 80, pos = handler(self, self.getClothButton3Pos), size = handler(self, self.getClothButton3Size), nextStep = true},	--任务头像
			{type = "pos", ringSize = 130,pos = handler(self, self.getClothButton1Pos), size = handler(self, self.getClothButton1Size)},	--任务头像
			{type = "pos", ringSize = 80,pos = handler(self, self.getClothButton4Pos), size = handler(self, self.getClothButton4Size), nextStep = true},
			{type = "pos", ringSize = 130,pos = handler(self, self.getClothButton1Pos), size = handler(self, self.getClothButton1Size)},	--任务头像
			{type = "pos", pos = handler(self, self.getClothButton5Pos), size = handler(self, self.getClothButton5Size)},	--任务头像
			{type = "pos", ringSize = 130,pos = handler(self, self.getClothButton6Pos), size = handler(self, self.getClothButton6Size)},	--任务头像
			{type = "pos", pos = handler(self, self.getClothButton7Pos), size = handler(self, self.getClothButton7Size)},	--任务头像
			{type = "pos", ringSize = 80,pos = handler(self, self.getClothButton3Pos), size = handler(self, self.getClothButton3Size), nextStep = true},
			{type = "pos", ringSize = 130,pos = handler(self, self.getClothButton1Pos), size = handler(self, self.getClothButton1Size)},	--任务头像
			{type = "pos", ringSize = 80,pos = handler(self, self.getClothButtonSurePos), size = handler(self, self.getClothButtonSureSize), image = "guide00013"},	--任务头像
				--任务头像
			-- {type = "pos", pos = handler(self, self.getItemSureButtonPos),size= handler(self, self.getItemSureButtonSize)  },	--确定
		}

	print("GuideOne --------------")
	self:start()
end

function GuideOne:func1()
	
	local panel = getViewByName("WardrobeView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.subChildren.ButtonGiveUp
	btnFight:setButtonEnabled(false)
end

function GuideOne:getClothButtonPos()

	local panel = getViewByName("WardrobeView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.subChildren.Panel.subChildren["Button_" .. 4]
	
	local pos = cc.Director:getInstance():getRunningScene():convertToNodeSpace(btnFight:convertToWorldSpace(cc.p(0,0)))
	return pos
	
end



function GuideOne:getClothButtonSize()

	local panel = getViewByName("WardrobeView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.subChildren.Panel.subChildren["Button_" .. 4]
	
	
	local size = btnFight.sprite_[1]:getContentSize()
	
	return size
	
end


function GuideOne:getClothButton1Pos()

	local panel = getViewByName("WardrobeView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.curViewBoxes[1].bgButton
	
	local pos = cc.Director:getInstance():getRunningScene():convertToNodeSpace(btnFight:convertToWorldSpace(cc.p(0,0)))
	return pos
	
end



function GuideOne:getClothButton1Size()

	local panel = getViewByName("WardrobeView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.curViewBoxes[1].bgButton
	
	
	local size = btnFight.sprite_[1]:getContentSize()
	
	return size
	
end

function GuideOne:getClothButton2Pos()

	local panel = getViewByName("WardrobeView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.subChildren.Panel.subChildren["Button_" .. 5]
	
	local pos = cc.Director:getInstance():getRunningScene():convertToNodeSpace(btnFight:convertToWorldSpace(cc.p(0,0)))
	return pos
	
end



function GuideOne:getClothButton2Size()

	local panel = getViewByName("WardrobeView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.subChildren.Panel.subChildren["Button_" .. 5]
	
	
	local size = btnFight.sprite_[1]:getContentSize()
	
	return size
	
end

function GuideOne:getClothButton3Pos()

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



function GuideOne:getClothButton3Size()


	
	return cc.size(62, 22)
	
end


function GuideOne:getClothButton4Pos()

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



function GuideOne:getClothButton4Size()


	
	return cc.size(62, 22)
	
end


function GuideOne:getClothButton5Pos()

	local panel = getViewByName("WardrobeView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.subChildren.Panel.subChildren["Button_" .. 1]
	
	local pos = cc.Director:getInstance():getRunningScene():convertToNodeSpace(btnFight:convertToWorldSpace(cc.p(0,0)))
	return pos
	
end



function GuideOne:getClothButton5Size()

	local panel = getViewByName("WardrobeView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.subChildren.Panel.subChildren["Button_" .. 1]
	
	
	local size = btnFight.sprite_[1]:getContentSize()
	
	return size
	
end


function GuideOne:over()

    ------print("mainAccept=" .. mainAccept)
    ------print("mainProcess=" .. mainProcess)

	print("GuideOne:over")
	self:removeSelf()

	-- GuideManager:startGuide("GuideTwo")
end




function GuideOne:getClothButton6Pos()

	local panel = getViewByName("WardrobeView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.curViewBoxes[2].bgButton
	
	local pos = cc.Director:getInstance():getRunningScene():convertToNodeSpace(btnFight:convertToWorldSpace(cc.p(0,0)))
	return pos
	
end



function GuideOne:getClothButton6Size()

	local panel = getViewByName("WardrobeView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.curViewBoxes[2].bgButton
	
	
	local size = btnFight.sprite_[1]:getContentSize()
	
	return size
	
end


function GuideOne:getClothButton7Pos()

	local panel = getViewByName("WardrobeView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.subChildren.Panel.subChildren["Button_" .. 2]
	
	local pos = cc.Director:getInstance():getRunningScene():convertToNodeSpace(btnFight:convertToWorldSpace(cc.p(0,0)))
	return pos
	
end



function GuideOne:getClothButton7Size()

	local panel = getViewByName("WardrobeView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.subChildren.Panel.subChildren["Button_" .. 2]
	
	
	local size = btnFight.sprite_[1]:getContentSize()
	
	return size
	
end

function GuideOne:getClothButtonSurePos()

	local panel = getViewByName("WardrobeView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.subChildren.ButtonSure
	
	local pos = cc.Director:getInstance():getRunningScene():convertToNodeSpace(btnFight:convertToWorldSpace(cc.p(0,0)))
	return pos
	
end



function GuideOne:getClothButtonSureSize()

	local panel = getViewByName("WardrobeView")
	if not panel then
		self:error()
		return
	end	
	

	local btnFight = panel.subChildren.ButtonSure
	
	
	local size = btnFight.sprite_[1]:getContentSize()
	
	return size
	
end

return GuideOne