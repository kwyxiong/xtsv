--
-- Author: kwyxiong
-- Date: 2016-04-03 11:31:18
--

local scheduler = cc.Director:getInstance():getScheduler()
local ResultView = class("ResultView", function() 
		return cc.uiloader:load("ResultView.json")
	end)

function ResultView:ctor(arg)
	self.arg = arg or {}
	self.score = arg.score
	self.grade = arg.grade
	self.dt = 0.01
	self.curScore = 0

	self:addNodeEventListener(cc.NODE_EVENT, function(event)
        if event.name == "enter" then
            self:onEnter()
        elseif event.name == "exit" then
            self:onExit()
        end
    end)	

	self.speed = 15

	if self.grade == "S" then
		self.speed = 15
	elseif self.grade == "A" then
		self.speed = 20 
	elseif self.grade == "B" then
		self.speed = 25
	elseif self.grade == "C" then
		self.speed = 30 
	elseif self.grade == "D" then
		self.speed = 35
	elseif self.grade == "E" then
		self.speed = 40
	elseif self.grade == "F" then
		self.speed = 45
	end

	if self.score > 1000 then
		self.speed = (self.speed + 30) * 0.5
	elseif self.score > 2000 then
		self.speed = (self.speed + 45) * 0.5
	end

	self.ticker = scheduler:scheduleScriptFunc(handler(self, self.doTick) , 0.0, false)
	self:init()
end

function ResultView:doTick(dt)
	self.curScore = self.curScore + math.random(1, self.speed )
	if self.curScore >= self.score then
		self.curScore = self.score
		self:countOver()
		self:rotate()
	end
	self.subChildren.Panel.subChildren.Score:setString(self.curScore)
end

function ResultView:countOver()
	if self.ticker then
		scheduler:unscheduleScriptEntry(self.ticker)
		self.ticker = nil
	end		
	local img
	if self.grade == "S" then
		img  = "mc0001.png" 
	elseif self.grade == "A" then
		img  = "mc0002.png" 
	elseif self.grade == "B" then
		img  = "mc0003.png" 
	elseif self.grade == "C" then
		img  = "mc0004.png" 
	elseif self.grade == "D" then
		img  = "mc0005.png" 
	elseif self.grade == "E" then
		img  = "mc0006.png" 
	elseif self.grade == "F" then
		img  = "mc0007.png" 
	end

	local grade = display.newSprite(img)
		:pos(592, 470)
		:addTo(self.subChildren.Panel)

	self.subChildren.Panel.subChildren.Money:setString(self.arg.money)
	self.subChildren.Panel.subChildren.Exp:setString(self.arg.exp)
	self.subChildren.Panel.subChildren.ML:setString(self.arg.ml)

	if self.arg.newTitle then
		showView("TipsView", {type = "newTitle", title = "【".. self.arg.newTitle.name .. "】"}, true, true)
	end
	if self.arg.newTask then
		print("解锁了新的任务 【" .. Global_tasks_id[self.arg.newTask].name .. "】")
		alert("解锁了新的任务 【" .. Global_tasks_id[self.arg.newTask].name .. "】")
	end

	self.subChildren.Panel.subChildren.ButtonContinue:runAction(cc.FadeIn:create(0.2))
end

function ResultView:onEnter()

end

function ResultView:onExit()
	if self.ticker then
		scheduler:unscheduleScriptEntry(self.ticker)
		self.ticker = nil
	end	
end

function ResultView:init()
	addButtonPressedState(self.subChildren.Panel.subChildren.ButtonContinue):onButtonClicked(function()
		-- body
		-- self:rotate()
		-- dump(self.arg.afterStory)

		if not GameData[Global_saveData].guides["GuideTwo"] then
				app:enterScene("CityScene")
		else

			if self.arg.afterStory and self.arg.afterStory ~= "" then
				app:enterScene("AVGScene", {{self.arg.afterStory}})
			else
				app:enterScene("OfficeScene", {true})
			end
		end
	end)
	self:rotate()
	self.subChildren.Panel.subChildren.ButtonContinue:setOpacity(0)

	self.subChildren.Panel.subChildren.Score:setString("0")
	self.subChildren.Panel.subChildren.Money:setString("0")
	self.subChildren.Panel.subChildren.Exp:setString("0")
	self.subChildren.Panel.subChildren.ML:setString("0")


	self.subChildren.Panel.subChildren.Money:enableOutline(Global_label_color4, 2)
	self.subChildren.Panel.subChildren.Exp:enableOutline(Global_label_color4, 2)
	self.subChildren.Panel.subChildren.ML:enableOutline(Global_label_color4, 2)

	self.subChildren.Panel.subChildren.Label_1:enableOutline(Global_label_color4, 2)
	self.subChildren.Panel.subChildren.Label_2:enableOutline(Global_label_color4, 2)
	self.subChildren.Panel.subChildren.Label_3:enableOutline(Global_label_color4, 2)
-- 
end



function ResultView:rotate()
	local time = 0.6
	local hua = self.subChildren.Panel.subChildren.PanelHua.subChildren.ImageHua
	hua:setScale(1.5)
	hua:runAction(cc.RotateBy:create(time, -360))
	hua:runAction(cc.ScaleTo:create(time, 1))

	local box = self.subChildren.Panel.subChildren.PanelHua.subChildren.ImageBox
	box:setScale(1.3)
	box:runAction(cc.RotateBy:create(time, 360))
	box:runAction(cc.ScaleTo:create(time, 1))	

end

return ResultView