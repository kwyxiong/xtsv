--
-- Author: kwyxiong
-- Date: 2016-04-01 11:59:21
--

local TaskItem = require("app.widgets.TaskItem")
local JuQingView = class("JuQingView", function() 
		return cc.uiloader:load("JuQingView.json")
		-- return ccs.GUIReader:getInstance():widgetFromJsonFile("JuQingView.json")
	end)

--15_90
--5_270
--6_230
function JuQingView:ctor(arg)
	dump(arg, "arg")
 	self.arg = arg or {}
	
	self.curShowIndex = 0

	self.selectedButton = 1

	-- for k, v in ipairs(Global_tasks) do

	-- end
	self.tasks = {}
	local completeTasks = GameData[Global_saveData].completeTasks
	-- local tb = {}
	-- for k, v in ipairs(completeTasks) do
	-- 	tb[v] = true
	-- end
	-- completeTasks = tb
	-- if #completeTasks == 0 then
	-- 	self.tasks[1] = {data = Global_tasks[1], complete = false}
	-- else

	-- end
	local comTasks = {}
	local uncomTasks = {}
	local unlockTasks = GameData[Global_saveData].unlockTasks


	-- dump(unlockTasks, "unlockTasks")
	dump(completeTasks, "completeTasks")
	-- dump(Global_tasks_id)
	for k, v in ipairs(unlockTasks) do
		if completeTasks[v .. ""] then
			comTasks[#comTasks + 1] = {data = Global_tasks_id[v], complete = completeTasks[v .. ""]}
		else
			uncomTasks[#uncomTasks + 1] = {data = Global_tasks_id[v], complete = completeTasks[v .. ""]}
		end
	end
	-- dump(uncomTasks)
	table.sort(comTasks, function(a, b) 
			return a.data.id < b.data.id
		end)
	table.sort(uncomTasks, function(a, b) 
			return a.data.id > b.data.id
		end)
	for k, v in ipairs(uncomTasks) do
		table.insert(self.tasks,v)
	end
	for k, v in ipairs(comTasks) do
		table.insert(self.tasks,v)
	end

	self.taskNum = #self.tasks
	self.moveDisNum = self.taskNum - 3


	self.taskItems = {}
	self:init()


	self.subChildren.Panel.subChildren.ButtonZhiXian:onButtonClicked(function() 
			self.selectedButton = 2

			self.subChildren.Panel.subChildren.ButtonZhuXian:setScale(0.66)
			self.subChildren.Panel.subChildren.ButtonZhiXian:setScale(0.55)
			self.subChildren.Panel.subChildren.ButtonZhiXian:setButtonEnabled(false)
			self.subChildren.Panel.subChildren.ButtonZhuXian:setButtonEnabled(true)

						self.subChildren.Panel.subChildren.PanelTask:setVisible(false)
			self.subChildren.Panel.subChildren.PanelTask_0:setVisible(true)
		end)

	self.subChildren.Panel.subChildren.ButtonZhuXian:onButtonClicked(function() 
		self.selectedButton = 1

		self.subChildren.Panel.subChildren.ButtonZhiXian:setScale(0.66)
		self.subChildren.Panel.subChildren.ButtonZhuXian:setScale(0.55)
					self.subChildren.Panel.subChildren.ButtonZhiXian:setButtonEnabled(true)
			self.subChildren.Panel.subChildren.ButtonZhuXian:setButtonEnabled(false)

			self.subChildren.Panel.subChildren.PanelTask:setVisible(true)
			self.subChildren.Panel.subChildren.PanelTask_0:setVisible(false)
	end)


end



function JuQingView:init()



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
			if self.arg.overCallback then
				self.arg.overCallback()
			end		
			closeView(self)
			GuideManager:checkGuide("OfficeScene1")
		end)
	self:initTask()

	local node = self.subChildren.Panel.subChildren.PanelTask.subChildren.ImageTouch
	if self.taskNum > 4 then
		node:size(cc.size(27, self:getHeight(self.taskNum)))
	end
	local initPos 
	local initNodePos

	local topY = 196 + 180 - self:getHeight(self.taskNum) /2
    local minY = 196 - 180 + self:getHeight(self.taskNum) /2

    node:setPositionY(topY)
    self:showIndex(1)
    local getIndex = function(posY)
    	 return math.ceil((topY - posY) / (topY - minY)*self.moveDisNum)
	end
	
	node:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event_)
		-- dump(event_)
        if event_.name == "ended" then
        
		elseif event_.name == "moved"  then
			local posY = cc.pAdd(initNodePos, cc.pSub(event_, initPos)).y
			if posY > topY then
				posY = topY
			elseif posY < minY then
				posY = minY
			end
			node:setPosition(initNodePos.x, posY)
			self:showIndex(getIndex(posY))
        elseif event_.name == "began"  then
        	-- isDrugging = true
        	initNodePos = cc.p(node:getPosition())
        	-- dump(initWorldPos, "initWorldPos")
        	initPos = event_
        	return true
        end
    end)
    node:setTouchEnabled(true)
   


end	

function JuQingView:showIndex(index)
	if self.curShowIndex ~= index then
		self.curShowIndex = index
		local i = 1
		for k, v in ipairs(self.tasks) do
			if k >= index and k <= index + 3 then
				self.taskItems[i]:show(v)
				i = i + 1
			end
		end

		if self.taskNum <= 4 then
			for k = 1, 4 do
				if k <= self.taskNum then
					self.taskItems[k]:setVisible(true)
				else
					self.taskItems[k]:setVisible(false)
				end
			end
			self.subChildren.Panel.subChildren.PanelTask.subChildren.ImageTouch:setVisible(false)
		else
			for k = 1, 4 do
				self.taskItems[k]:setVisible(true)
			end
			self.subChildren.Panel.subChildren.PanelTask.subChildren.ImageTouch:setVisible(true)
		end

	end
end


function JuQingView:getHeight(num)
	local h = 1200 / num  + 30
	return h

end

function JuQingView:initTask()
	for k = 1, 4 do
		local taskItem = TaskItem.new()
			:pos(239,334 - (k - 1) * 92)
			:addTo(self.subChildren.Panel.subChildren.PanelTask)
		self.taskItems[#self.taskItems + 1] = taskItem
	end
end

return JuQingView