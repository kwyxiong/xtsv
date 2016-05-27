--
-- Author: kwyxiong
-- Date: 2016-04-02 00:54:04
--

local TipsView = class("TipsView", function() 
		return cc.uiloader:load("TipsView.json")
	end)

function TipsView:ctor(arg)
	self.arg = arg or {}
	self:init()
end

function TipsView:init()

	self._richText = ccui.RichText:create()
    self._richText:ignoreContentAdaptWithSize(false)
    self._richText:setContentSize(cc.size(430, 100))
    self._richText:setAnchorPoint(cc.p(0, 1))
   	-- self._richText:setCascadeOpacityEnabled(true)

    
  
    self._richText:setPosition(cc.p(75 + 120 ,140 + 194))
    self.subChildren.Panel:addChild(self._richText)	




	self.subChildren.Panel.subChildren.ButtonSure:onButtonClicked(function() 
			if self.arg.sureCallback then
				self.arg.sureCallback()
			end
			closeView(self)
		end)	
	
	self.subChildren.Panel.subChildren.ButtonCancel:onButtonClicked(function() 
			closeView(self)
		end)	

 
 	self:update()
end

function TipsView:update()
	self.subChildren.Panel.subChildren.Label_3:enableOutline(cc.c4b(102, 45, 19, 255), 2)
	self.subChildren.Panel.subChildren.Label_3:setString("提示")
	if self.arg.type == "shop" then
		self.subChildren.Panel.subChildren.Label_3:setString("购买商品")
		
		local re1 = ccui.RichElementText:create(1 , cc.c3b(102, 45, 19), 255, "你确定要消费", "Arial", 15, true, cc.c4b(255,255,255,255), 1)
		self._richText:pushBackElement(re1)
		local re1 = ccui.RichElementText:create(1 , display.COLOR_RED, 255, " " .. self.arg.money .." ", "Arial", 15, true, cc.c4b(255,255,255,255), 1)
		self._richText:pushBackElement(re1)
		local re1 = ccui.RichElementText:create(1 , cc.c3b(102, 45, 19), 255, "金币来购买 " .. self.arg.name .. " ?", "Arial", 15, true, cc.c4b(255,255,255,255), 1)
		self._richText:pushBackElement(re1)
		-- local re1 = ccui.RichElementText:create(1 , cc.c3b(102, 45, 19), 255, "金币来购买", "Arial", 15)
		-- self._richText:pushBackElement(re1)
	elseif self.arg.type == "taskSure" then
		
		
		local re1 = ccui.RichElementText:create(1 , cc.c3b(102, 45, 19), 255, "确认装扮完毕并继续任务？", "Arial", 15, true, cc.c4b(255,255,255,255), 1)
		self._richText:pushBackElement(re1)	
	elseif self.arg.type == "taskGiveUp" then
		
		
		local re1 = ccui.RichElementText:create(1 , cc.c3b(102, 45, 19), 255, "是否放弃当前任务？", "Arial", 15, true, cc.c4b(255,255,255,255), 1)
		self._richText:pushBackElement(re1)		
	elseif self.arg.type == "taskHelp" then
		self.subChildren.Panel.subChildren.Label_3:setString("请求帮助")

		local re1 = ccui.RichElementText:create(1 , cc.c3b(102, 45, 19), 255, "消费", "Arial", 15, true, cc.c4b(255,255,255,255), 1)
		self._richText:pushBackElement(re1)	
	
		local re1 = ccui.RichElementText:create(1 , display.COLOR_RED, 255, " " .. self.arg.money .." ", "Arial", 15, true, cc.c4b(255,255,255,255), 1)
		self._richText:pushBackElement(re1)


		local re1 = ccui.RichElementText:create(1 , cc.c3b(102, 45, 19), 255, "金币给精灵购买零食，可以从时尚精灵处得到提示，确定要购买吗？", "Arial", 15, true, cc.c4b(255,255,255,255), 1)
		self._richText:pushBackElement(re1)		
	elseif 	self.arg.type == "card" then
		self.subChildren.Panel.subChildren.Label_3:setString("获得卡片")

		local re1 = ccui.RichElementText:create(1 , cc.c3b(102, 45, 19), 255, "恭喜您解锁了新的主题卡片", "Arial", 15, true, cc.c4b(255,255,255,255), 1)
		self._richText:pushBackElement(re1)	
	
		local re1 = ccui.RichElementText:create(1 , display.COLOR_RED, 255, " " .. self.arg.cardName .." ", "Arial", 15, true, cc.c4b(255,255,255,255), 1)
		self._richText:pushBackElement(re1)


		local re1 = ccui.RichElementText:create(1 , cc.c3b(102, 45, 19), 255, "！", "Arial", 15, true, cc.c4b(255,255,255,255), 1)
		self._richText:pushBackElement(re1)	
	

		self:hideCancelButton()

	elseif self.arg.type == "kuaisuqiatan" then
		
		local re1 = ccui.RichElementText:create(1 , cc.c3b(102, 45, 19), 255, "确定要消费", "Arial", 15, true, cc.c4b(255,255,255,255), 1)
		self._richText:pushBackElement(re1)	

		local re1 = ccui.RichElementText:create(1 , cc.c3b(0, 102, 255), 255, " " .. self.arg.tb .." ", "Arial", 15, true, cc.c4b(255,255,255,255), 1)
		self._richText:pushBackElement(re1)


		local re1 = ccui.RichElementText:create(1 , cc.c3b(102, 45, 19), 255, "T币来快速寻找业务？", "Arial", 15, true, cc.c4b(255,255,255,255), 1)
		self._richText:pushBackElement(re1)	
	elseif self.arg.type == "huiyue" then

		local re1 = ccui.RichElementText:create(1 , cc.c3b(102, 45, 19), 255, "解除合约需要支付违约金", "Arial", 15, true, cc.c4b(255,255,255,255), 1)
		self._richText:pushBackElement(re1)	
	
		local re1 = ccui.RichElementText:create(1 , display.COLOR_RED, 255, " " .. self.arg.money, "Arial", 15, true, cc.c4b(255,255,255,255), 1)
		self._richText:pushBackElement(re1)


		local re1 = ccui.RichElementText:create(1 , cc.c3b(102, 45, 19), 255, "！确定要解除合约么？", "Arial", 15, true, cc.c4b(255,255,255,255), 1)
		self._richText:pushBackElement(re1)	

	elseif 	self.arg.type == "cantOut" then

		local re1 = ccui.RichElementText:create(1 , cc.c3b(102, 45, 19), 255, "不能光着身子出门哟！", "Arial", 15, true, cc.c4b(255,255,255,255), 1)
		self._richText:pushBackElement(re1)	
	
	
		self:hideCancelButton()	


	elseif 	self.arg.type == "newTitle" then
		self.subChildren.Panel.subChildren.Label_3:setString("恭喜你！")
		local re1 = ccui.RichElementText:create(1 , display.COLOR_RED, 255, "获得了新的称号" .. self.arg.title .. "!", "Arial", 15, true, cc.c4b(255,255,255,255), 1)
		self._richText:pushBackElement(re1)

		self:hideCancelButton()
	elseif 	self.arg.type == "noTask" then
		local re1 = ccui.RichElementText:create(1 , cc.c3b(102, 45, 19), 255, "当前头衔似乎接不到更多的任务了，完成 剧情任务 来取得更高的头衔吧！", "Arial", 15, true, cc.c4b(255,255,255,255), 1)
		self._richText:pushBackElement(re1)

	
	
		self:hideCancelButton()
	elseif 	self.arg.type == "levelUp" then
		self.subChildren.Panel.subChildren.Label_3:setString("升级！")
		local re1 = ccui.RichElementText:create(1 , cc.c3b(102, 45, 19), 255, "恭喜！等级提升到：" .. self.arg.level, "Arial", 15, true, cc.c4b(255,255,255,255), 1)
		self._richText:pushBackElement(re1)

		
		self:hideCancelButton()
	end

end

function TipsView:hideCancelButton()

	local x = (self.subChildren.Panel.subChildren.ButtonSure:getPositionX() + 
	self.subChildren.Panel.subChildren.ButtonCancel:getPositionX()) / 2
	self.subChildren.Panel.subChildren.ButtonSure:setPositionX(x)
	self.subChildren.Panel.subChildren.ButtonCancel:setVisible(false)	
end


return TipsView