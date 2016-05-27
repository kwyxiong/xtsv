--
-- Author: kwyxiong
-- Date: 2016-04-06 17:47:59
--


local RenWuItem = require("app.widgets.RenWuItem")
local RenWuView = class("RenWuView", function() 
		return cc.uiloader:load("RenWuView.json")
		-- return ccs.GUIReader:getInstance():widgetFromJsonFile("RenWuView.json")
	end)

--15_90
--5_270
--6_230
function RenWuView:ctor(arg)
	self.arg = arg or {}
 	self.renWuItems = {}
	self.renWus = {}



 	-- for k, v in ipairs(Global_tasks) do
 	-- 	if v.needTitle <= myTitle then

 	-- 	end
 	-- end
 	self.handlers = {
 		regCallBack("giveUpRenWu", handler(self, self.giveUpRenWu)),
 		regCallBack("timeOver", handler(self, self.updateItems)),
 		regCallBack("APP_ENTER_FOREGROUND_EVENT", handler(self, self.updateItems))
 	}	

	self:addNodeEventListener(cc.NODE_EVENT, function(event)
        if event.name == "enter" then
           
        elseif event.name == "exit" then
            self:onExit()
        end
    end)



	self:init()

	self:updateItems()
end

function RenWuView:onExit()
	for k, v in ipairs(self.handlers) do
		unRegCallBack({msgId = v})
	end
end

function RenWuView:giveUpRenWu(evt)
	local id = evt.data.id
	local hasNew = evt.data.hasNew
	if hasNew then
		self:updateItems()
		return
	end

	local removeIndex 
	for k, v in ipairs(self.renWuItems) do
		if v:getData().id == id then
			removeIndex = k
			break
		end
	end

	if removeIndex then
		local removeItem = self.renWuItems[removeIndex]
		removeItem:hide()
		table.remove(self.renWuItems, removeIndex)
		self.renWuItems[#self.renWuItems + 1] = removeItem
		

		for k = 1, 5 do
			self.renWuItems[k]:pos(255,350 - (k - 1) * 85)
		end
	end
end

function RenWuView:updateItems()
	for k, v in ipairs(self.renWuItems) do
		v:pos(255,350 - (k - 1) * 85)
		v:hide()
	end

	local max_work =tonumber( Global_setting2.max_work )
 	local myTitle = GameData[Global_saveData].title
 	local curRenWus = GameData[Global_saveData].curRenWus

 	-- dump(curRenWus, "curRenWus")

 	local hasWait = false
	for k, v in ipairs(curRenWus) do
		if not v.time then
			self.renWuItems[k]:show({data = Global_tasks_id[v.id]})
		elseif v.time == -1 then
			self.renWuItems[k]:getTime({data = Global_tasks_id[v.id]})
			hasWait = true
		else
			self.renWuItems[k]:wait({data = Global_tasks_id[v.id], startTime = v.time})
			hasWait = true
		end
	end

	if not hasWait and #curRenWus < max_work then 
		if #GameData[Global_saveData].renWuPool == 0 then
			self.renWuItems[#curRenWus + 1]:noTask()
		else

			for k = #curRenWus+1, max_work do
				if #GameData[Global_saveData].renWuPool > 0 then
					local id = getTaskFromPool()
					curRenWus[#curRenWus + 1] = {id = id}

					self.renWuItems[k]:show({data = Global_tasks_id[id]})
				end
			end
		end
	end

end

function RenWuView:init()



	addButtonPressedState(self.subChildren.Panel.subChildren.ButtonClose):onButtonClicked(function() 
			
			if self.arg.overCallback then
				self.arg.overCallback()
			end
			closeView(self)
		end)
	

	addButtonPressedState(self.subChildren.Panel.subChildren.ButtonPay):onButtonClicked(function() 
			local hasWait = false
			for k, v in ipairs(GameData[Global_saveData].curRenWus) do
				if v.time then
					hasWait = true
				end
			end

			if not hasWait and #GameData[Global_saveData].renWuPool == 0 then
				showView("TipsView", {type = "noTask"}, true, true)
				return
			end


			local tb = Global_setting2["quick_fill"]
			local sureCallback = function()
				if GameData[Global_saveData].tb < tb then
					alert("T币不足！")
				else
					GameData[Global_saveData].tb = GameData[Global_saveData].tb - tb
					broadCastMsg("buyUpdate")

					if not hasWait and #GameData[Global_saveData].renWuPool > 0 then
						--不做刷新功能吗？
					else
						for k, v in ipairs(GameData[Global_saveData].curRenWus) do
							if v.time then
								v.time = nil
								break
							end
						end
						local max_work = tonumber( Global_setting2.max_work )
						if #GameData[Global_saveData].curRenWus < max_work then
							for k = 1, max_work - #GameData[Global_saveData].curRenWus do
								if #GameData[Global_saveData].renWuPool > 0 then
								
						            GameData[Global_saveData].curRenWus[#GameData[Global_saveData].curRenWus + 1] = {id = getTaskFromPool()}
       							end
							end

						end
						self:updateItems()
					end

					save()
				end
			end

			showView("TipsView", {type = "kuaisuqiatan", tb = tb, sureCallback = sureCallback}, true, true)

		end)

	self:initTask()

end	


function RenWuView:initTask()
	for k = 1, 5 do
		local renWuItem = RenWuItem.new()
			:pos(255,350 - (k - 1) * 85)
			:addTo(self.subChildren.Panel.subChildren.PanelTask)
		
		self.renWuItems[#self.renWuItems + 1] = renWuItem
	end
end

return RenWuView