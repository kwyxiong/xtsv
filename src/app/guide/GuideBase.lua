--
-- Author: kwyxiong
-- Date: 2015-07-13 10:11:05
--
local GuideRing = require("app.widgets.GuideRing")
local scheduler = cc.Director:getInstance():getScheduler()
local GuideBase = class("GuideBase", function() 
		return display.newLayer()
	end)


function GuideBase:ctor(arg)
	self.arg = arg or {}
	self.time = 0
	self.moveTime = 1.8
	self.flag = false
	self.must = true
	-- self.ticker = scheduler.scheduleGlobal(handler(self, self.doTick) , 0.0)
	self.ticker = scheduler:scheduleScriptFunc(handler(self, self.doTick) , 0.0, false)
	-- dump(self.ticker, "self.ticker")
	self.index = 1
	self.guides = {}
	self:addNodeEventListener(cc.NODE_EVENT, function(evt) 
		self:exit(evt)
	end)

	self.startStep = self.arg.startStep
end

function GuideBase:transGuides()
	local res = {}
	local index = 1
	for k = 1, #self.guides do
		res[#res + 1] = {type = "delay", time = 0.2 }
		res[#res + 1] = self.guides[k]
	end
	res[#res + 1] = {type = "delay", time = 0.2 }
	self.guides = res
end

function GuideBase:exit(evt)
	-- dump(evt, "evt")
	if evt.name == "exit" then
		if self.ticker then
			scheduler:unscheduleScriptEntry(self.ticker)
			self.ticker = nil
		end		
	end
end

function GuideBase:error()
	dump("error")
	self:removeSelf()
end



function GuideBase:start()
	self:transGuides()
	GuideManager.guides = self.guides

	if self.startStep then
		self.index = self.startStep
	end

	self:guide()
end

function GuideBase:over()
	-- print("over ==========")
	self:removeSelf()
end

function GuideBase:doTick(dt)

	-- print(self.time)
	self.time = self.time - dt
	
	if self.time<=0 and self.flag then
		self.flag = false
		self.index = self.index + 1
		self:guide()
	end
end

function GuideBase:guide()
	local guideTb = self.guides[self.index]
	GuideManager.curIndex = self.index
	-- dump(guideTb, "guideTb")
	if guideTb then
		if guideTb["type"] == "delay" then
			self:delay(guideTb)
		elseif guideTb["type"] == "pos" then
			self:showPos(guideTb)
		end
	else
		self:over()
	end
end

function GuideBase:delay(delayTb)
	self:setTouchSwallowEnabled(true)
	self.time = delayTb["time"]
	self.flag = true
	-- print(">>>>>>>>>>>>>>>>>>>>")
	-- self:runAction(cc.Sequence:create(
	-- 	cc.DelayTime:create(delayTb["time"]),
	-- 	cc.CallFunc:create(function() 
	-- 			self.index = self.index + 1
	-- 			self:guide()
	-- 		end)
	-- 	))

end


function GuideBase:nextStep()
	self.index = self.index + 1
	self:removeAllChildren()		
	self:guide()	
end


function GuideBase:showPos(posTb)
	if posTb["showType"] ~= 2 then
		-- print("?????????????????????>>>>")
		self:setTouchSwallowEnabled(false)
		local touSize
		local pos
		-- ------print(type(pos))
		if type(posTb.pos) == "table" then
			pos = posTb.pos
		else
			pos = posTb.pos()
			if not pos then
				return
			end
		end
		if type(posTb.size) == "table" then
			touSize = posTb.size
		elseif not posTb.size then
			touSize = cc.size(60, 30)
		else
			touSize = posTb.size()
			if not touSize then
				return
			end
		end

		
		local swallowButton1 = cc.ui.UIPushButton.new({images ={normal = "#Null.png"}})
			:size(display.width,display.height)
			:pos(0, pos.y + touSize.height/2)
			:addTo(self)
		swallowButton1:setAnchorPoint(cc.p(0, 0))
		

		local swallowButton2 = cc.ui.UIPushButton.new({images ={normal = "#Null.png"}})
			:size(display.width,display.height)
			:pos(0, pos.y - touSize.height/2)	
			:addTo(self)
		swallowButton2:setAnchorPoint(cc.p(0, 1)) 
		
		local swallowButton3 = cc.ui.UIPushButton.new({images ={normal = "#Null.png"}})
			:size(display.width,display.height)
			:pos(pos.x - touSize.width/2, 0)	
			:addTo(self)
		swallowButton3:setAnchorPoint(cc.p(1, 0)) 
	
		local swallowButton4 = cc.ui.UIPushButton.new({images ={normal = "#Null.png"}})
			:size(display.width,display.height)
			:pos(pos.x + touSize.width/2, 0)	
			:addTo(self)
		swallowButton4:setAnchorPoint(cc.p(0, 0)) 
		
		if posTb["image"] == "guide00001" then
			local sp = display.newSprite("guide00001.png")
				:pos(pos.x - 50, pos.y)
				:addTo(self)
			sp:setAnchorPoint(cc.p(1, 0.5))

		elseif posTb["image"] == "guide00013" then
			local sp = display.newSprite("guide00013.png")
				:pos(pos.x, pos.y + 80)
				:addTo(self)
			sp:setAnchorPoint(cc.p(1, 1))
		elseif posTb["image"] == "guide1" then
			local sp = display.newSprite("guide1.png")
				:pos(pos.x, pos.y - 130)
				:addTo(self)
			sp:setAnchorPoint(cc.p(0.5, 1))	
		elseif posTb["image"] == "guide2" then
			local sp = display.newSprite("guide2.png")
				:pos(pos.x, pos.y - 60)
				:addTo(self)
			sp:setAnchorPoint(cc.p(0.5, 1))		
		elseif posTb["image"] == "guide4" then
			local sp = display.newSprite("guide4.png")
				:pos(pos.x - 20, pos.y + 80)
				:addTo(self)
			sp:setAnchorPoint(cc.p(0.5, 1))	

		elseif posTb["image"] == "guide5" then
			local sp = display.newSprite("guide5.png")
				:pos(pos.x + 130, pos.y - 130)
				:addTo(self)
			sp:setAnchorPoint(cc.p(1, 1))	

		elseif posTb["image"] == "guide6" then
			local sp = display.newSprite("guide6.png")
				:pos(pos.x , pos.y - 60)
				:addTo(self)
			sp:setAnchorPoint(cc.p(0.5, 1))	
		elseif posTb["image"] == "guide7" then
			local sp = display.newSprite("guide7.png")
				:pos(pos.x + 120 , pos.y - 120)
				:addTo(self)
			sp:setAnchorPoint(cc.p(0.5, 1))	

		elseif posTb["image"] == "guide8" then
			local sp = display.newSprite("guide8.png")
				:pos(pos.x + 50 , pos.y - 40)
				:addTo(self)
			sp:setAnchorPoint(cc.p(1, 1))	

		elseif posTb["image"] == "guide9" then
			local sp = display.newSprite("guide9.png")
				:pos(pos.x- 150, pos.y - 60)
				:addTo(self)
			sp:setAnchorPoint(cc.p(0.5, 1))	

		elseif posTb["image"] == "guide10" then
			local sp = display.newSprite("guide10.png")
				:pos(pos.x, pos.y + 60)
				:addTo(self)
			sp:setAnchorPoint(cc.p(0.5, 0))	
		elseif posTb["image"] == "guide11" then
			local sp = display.newSprite("guide11.png")
				:pos(pos.x, pos.y - 80)
				:addTo(self)
			sp:setAnchorPoint(cc.p(0, 1))	
		elseif posTb["image"] == "guide12" then
			local sp = display.newSprite("guide12.png")
				:pos(pos.x- 50, pos.y - 40)
				:addTo(self)
			sp:setAnchorPoint(cc.p(0.5, 1))						
												
		end



		if not posTb["hideRing"] then
			local ringSize = posTb.ringSize or 90
			local ring = GuideRing.new(pos.x, pos.y,ringSize, posTb.firstRing)
			-- local ring = getGuideRing(pos.x, pos.y)
				-- :pos(pos.x, pos.y)
				:addTo(self)
		end

		if posTb["func"] then
			posTb["func"]()
		end


		local touchButton 
		touchButton= cc.ui.UIPushButton.new({normal = "Null.png"})
			-- :size(touSize.width,touSize.height)
			:pos(pos.x, pos.y)
			:addTo(self)
		
		touchButton:setButtonSize(touSize.width,touSize.height)
		if not posTb["touchCallback"] then
			touchButton:onButtonClicked(function() 
						if posTb["nextStep"] then

							
						else
							self:nextStep()
						end
					
				end)	
			touchButton:setTouchSwallowEnabled(false)
		else
			-- touchButton:setTouchSwallowEnabled(false)
			if posTb["image"] == "guide1" or posTb["image"] == "guide5"  or posTb["image"] == "guide7" or posTb["image"] == "guide8"  then
				touchButton:onButtonClicked(function() 
						
						posTb["touchCallback"]()()
						self:nextStep()
					end)
			else
				touchButton:onButtonClicked(function() 
						
						posTb["touchCallback"]()()

					end)				
			end
		end

		if posTb["image"] == "guide1" or posTb["image"] == "guide6" then 
			touchButton:setTouchSwallowEnabled(true)
		end

		-- if not self.must then
		-- 	swallowButton1:onButtonClicked(handler(self, self.error))
		-- 	swallowButton2:onButtonClicked(handler(self, self.error))
		-- 	swallowButton3:onButtonClicked(handler(self, self.error))
		-- 	swallowButton4:onButtonClicked(handler(self, self.error))
		-- end
	end
end



function GuideBase:transCenterPos(button, pos)
	local anchor = button:getAnchorPoint()
	-- --dump(pos, "pos")
	-- --dump(anchor, "anchor")
	local targetAnchor = cc.p(0.5, 0.5)

	local size
	if button.sprite_ then
		size = button.sprite_[1]:getContentSize()
	else
		size = button:getContentSize()
	end
	-- --dump(size, "size")
	local resPos = cc.p(pos.x + (targetAnchor.x - anchor.x) * size.width,  pos.y + (targetAnchor.y - anchor.y) * size.height)
	-- --dump(resPos, "resPos")
	return resPos
end


--右上角任务图标
function GuideBase:getTaskButtonPos()
	local panel = getPanelByName("MainView")
	if not panel then
		self:error()
		return
	end	


	if CURR_UI_SCENE and table.nums(CURR_UI_SCENE:getComponent("app.util.UISceneProtocol").listPanel_ ) >2 then
		self:error()
		return
	end

	local button = panel.taskHelper.taskIcon
	
	local pos = cc.Director:getInstance():getRunningScene():convertToNodeSpace(button:convertToWorldSpace(cc.p(0,0)))
	return self:transCenterPos(button, pos)
end


--右上角任务图标
function GuideBase:getTaskButtonSize()
	local panel = getPanelByName("MainView")
	if not panel then
		self:error()
		return
	end	

	local button = panel.taskHelper.taskIcon
	local size = button.sprite_[1]:getContentSize()
	
	return size
end




--任务界面下一步
function GuideBase:getTaskNextButtonPos()
	local panel = getPanelByName("CCTaskInfoView")
	if not panel then
		self:error()
		return
	end	

	local button = panel.nextStepButton_
	if not button then
		self:error()
		return
	end
	
	local pos = cc.Director:getInstance():getRunningScene():convertToNodeSpace(button:convertToWorldSpace(cc.p(0,0)))
	return self:transCenterPos(button, pos)
end

--任务界面下一步
function GuideBase:getTaskNextButtonSize()
	local panel = getPanelByName("CCTaskInfoView")
	if not panel then
		self:error()
		return
	end	

	local button = panel.nextStepButton_
	if not button then
		self:error()
		return
	end

	
	local size = button.sprite_[1]:getContentSize()
	
	return cc.size(960, 720)
end

function GuideBase:getTaskNextButtonTouch()
	local panel = getPanelByName("CCTaskInfoView")
	if not panel then
		self:error()
		return
	end	

	local touchCallback = function() 
			-- ------print("touchCallback->1")
			panel:nextStepButtonEvent()

		end

	return touchCallback
end



--任务界面领取奖励或接受任务
function GuideBase:getTaskGetButtonPos()
	local panel = getPanelByName("CCTaskInfoView")
	if not panel then
		self:error()
		return
	end	

	local button = panel.btn_
	
	local pos = cc.Director:getInstance():getRunningScene():convertToNodeSpace(button:convertToWorldSpace(cc.p(0,0)))
	return self:transCenterPos(button, pos)
end

--任务界面领取奖励或接受任务
function GuideBase:getTaskGetButtonSize()
	local panel = getPanelByName("CCTaskInfoView")
	if not panel then
		self:error()
		return
	end	

	local button = panel.btn_
	local size = button.sprite_[1]:getContentSize()
	
	return size
end

--获取物品界面确定
function GuideBase:getItemSureButtonPos()
	local panel = getPanelByName("GetItemView")
	if not panel then
		self:error()
		return
	end	

	local button = panel.sureButton
	
	local pos = cc.Director:getInstance():getRunningScene():convertToNodeSpace(button:convertToWorldSpace(cc.p(0,0)))
	return self:transCenterPos(button, pos)
end

--获取popAlert界面确定
function GuideBase:getPopAlertSureButtonPos()
	local panel = getPanelByName("PopupAlertView")
	if not panel then
		self:error()
		return
	end	

	local button = panel.sureButton
	
	local pos = cc.Director:getInstance():getRunningScene():convertToNodeSpace(button:convertToWorldSpace(cc.p(0,0)))
	return self:transCenterPos(button, pos)
end


function GuideBase:getPopAlertSureButtonSize()
	local panel = getPanelByName("PopupAlertView")
	if not panel then
		self:error()
		return
	end	

	local button = panel.sureButton
	local size = button.sprite_[1]:getContentSize()
	
	return size
end

--获取物品界面确定
function GuideBase:getItemSureButtonSize()
	local panel = getPanelByName("GetItemView")
	if not panel then
		self:error()
		return
	end	

	local button = panel.sureButton
	local size = button.sprite_[1]:getContentSize()
	
	return size
end


return GuideBase