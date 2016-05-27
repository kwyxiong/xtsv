--
-- Author: kwyxiong
-- Date: 2016-04-06 17:50:21
--

local scheduler = cc.Director:getInstance():getScheduler()
local RenWuItem = class("RenWuItem", function() 
		return display.newNode()
	end)

function RenWuItem:ctor(arg)
	-- self:setCascadeOpacityEnabled(true)
	arg = arg or {}
	self.index = arg.index or 1

	self.httpLife = false

	self.curServerTime = nil
	self.startTime = nil
	self.needTime = Global_setting2.worker_time
	self:init()
	


	self:addNodeEventListener(cc.NODE_EVENT, function(event)
		-- dump(event, "event")
        if event.name == "enter" then
            self:onEnter()
        elseif event.name == "exit" then
            self:onExit()
        end
    end)	

end



function RenWuItem:onEnter()
end

function RenWuItem:onExit()
	if self.ticker then
		scheduler:unscheduleScriptEntry(self.ticker)
		self.ticker = nil
	end		
	self.httpLife = false
end

function RenWuItem:init()


	local sp = display.newSprite("image250.png")
		:addTo(self)

	local taskType = display.newSprite("renwu1.png")
		:pos(-150, 6)
		:addTo(self)		
	self.taskType = taskType

	local title = cc.ui.UILabel.new({text = self.index .. ".遗失的信封", size = 16})
		:setColor(Global_label_color3)
		:pos(-108,20)
		:addTo(self)
	title:setAnchorPoint(cc.p(0, 0.5))
	self.title = title
	-- drug(self)
	-- drug(taskCom)

	local exp = cc.ui.UILabel.new({text = "1000", size = 12})
		:setColor(display.COLOR_RED)
		:pos(170,18)
		:addTo(self)
	exp:setAnchorPoint(cc.p(0, 0.5))
	self.exp = exp	

	local money = cc.ui.UILabel.new({text = "1000", size = 12})
		:setColor(display.COLOR_BLACK)
		:pos(170,-14)
		:addTo(self)
	money:setAnchorPoint(cc.p(0, 0.5))
	self.money = money	


	local time = cc.ui.UILabel.new({text = "00:00", size = 16})
		:setColor(Global_label_color3)
		:pos(-108, -10)
		:addTo(self)
	time:setAnchorPoint(cc.p(0, 0.5))
	self.time = time
	self.time:setVisible(false)

	self.startButton = cc.ui.UIPushButton.new({normal = "taskstart.png"})
		:pos(-60, -10)
		:addTo(self)
	addButtonPressedState(self.startButton)
		:onButtonClicked(function() 
			Global_task_type = 3
			app:enterScene("AVGScene", {self.data})
			end)
	self.abandomButton = cc.ui.UIPushButton.new({normal = "task_abandon.png"})
		:pos(40, -10)
		:addTo(self)
	addButtonPressedState(self.abandomButton)
		:onButtonClicked(function() 
				if #GameData[Global_saveData].renWuPool == 0 then
					showView("TipsView", {type = "noTask"}, true, true)
					return
				end


				local money = 500 * tonumber(Global_setting2["abandon_money"])
				local sureCallback = function() 
					if GameData[Global_saveData].jb < money then
						alert("金币不足！")
					else 

						GameData[Global_saveData].jb = GameData[Global_saveData].jb - money
						broadCastMsg("buyUpdate")
						alert("解除了任务合约")

						for k, v in ipairs(GameData[Global_saveData].curRenWus) do
							if v.id == self.data.id then
								table.remove(GameData[Global_saveData].curRenWus, k)
								GameData[Global_saveData].renWuPool[#GameData[Global_saveData].renWuPool + 1] = v.id
								local hasNew = qiatan()
								broadCastMsg("giveUpRenWu", {id = v.id, hasNew = hasNew})
								break
							end
						end
						save()

					end
				end
				showView("TipsView", {type = "huiyue", money = money ,sureCallback = sureCallback}, swallowTouch, fade)
			end)
end

function RenWuItem:getData()
	return self.data
end


function RenWuItem:show(para)

	local data = para.data
	self.data = data
	
	self.title:setString(data.name)

	self.taskType:setVisible(true)
	self.taskType:setTexture("renwu" .. data.pz .. ".png")
	self.startButton:setVisible(true)
	self.abandomButton:setVisible(true)	
	self.time:setVisible(false)
	--经验
	self.exp:setString(data.exp)
	--酬劳
	self.money:setString(data.money)

	self:setVisible(true)




end

function RenWuItem:noTask()
	self.startButton:setVisible(false)
	self.abandomButton:setVisible(false)
	self.time:setVisible(false)
	self.taskType:setVisible(false)

	self.title:setString("找不到更多的任务了...")
	--经验
	self.exp:setString("???")
	--酬劳
	self.money:setString("???")

	self:setVisible(true)

end

function RenWuItem:getTime(para)
	print("----------------------- getTime " .. para.data.name )
	local data = para.data
	self.data = data
	self.taskType:setVisible(false)
	self.time:setVisible(false)
	self.startButton:setVisible(false)
	self.abandomButton:setVisible(false)

	self.title:setString("业务洽谈中...")
	--经验
	self.exp:setString("???")
	--酬劳
	self.money:setString("???")

	
    local xhr = getXHR()
    local function onReadyStateChanged()
    	-- dump(self.httpLife, "self.httpLife")
    	if not self.httpLife then
    		xhr:unregisterScriptHandler()
    		return
    	end
        if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
            -- print(xhr.response)

            local res = json.decode(xhr.response)
            if type(res) == "table" and res.success == "1" then

	            local stime = res.result["timestamp"]
	            for k, v in ipairs(GameData[Global_saveData].curRenWus) do
	            	if v.id == self.data.id then
	            		v.time = stime
	            	end
	            end
	            GameState.save(GameData)
	            self.startTime = stime

	            self.curServerTime = stime
	            self.time:setVisible(true)
	            -- self.time:setString(string.formatNumberToTimeString( math.floor() ))
	            if not self.ticker then
	            	self.ticker = scheduler:scheduleScriptFunc(handler(self, self.doTick) , 0.0, false)
	            end
	            self:doTick(0.016)
	        else
	        	self.title:setString("断网失去联系了...")
	        end
            -- if not tolua.isnull(labelStatusCode) then
            --     labelStatusCode:setString("Http Status Code:" .. xhr.statusText)
            -- else
            --     print("ERROR: labelStatusCode is invalid!")
            -- end
        else
        	self.title:setString("断网失去联系了...")
            print("xhr.readyState is:", xhr.readyState, "xhr.status is: ",xhr.status)
        end
        xhr:unregisterScriptHandler()

    end

    print("handler = " ,xhr:registerScriptHandler(onReadyStateChanged))
    xhr:send()
    self:setVisible(true)
    self.xhr = xhr
    self.httpLife = true
end



function RenWuItem:timeOver(remTime)
	print("remTime", remTime)
	for k, v in ipairs(GameData[Global_saveData].curRenWus) do
        if v.id == self.data.id then
            v.time = nil
            break
        end
    end
    local moreTime = -remTime 
	for k = #GameData[Global_saveData].curRenWus + 1, tonumber( Global_setting2.max_work ) do
		if #GameData[Global_saveData].renWuPool >0 then
    		if moreTime >= self.needTime then
    			GameData[Global_saveData].curRenWus[#GameData[Global_saveData].curRenWus + 1] = {id = getTaskFromPool()}
    			moreTime = moreTime - self.needTime
    		elseif moreTime >= 0 then
    			GameData[Global_saveData].curRenWus[#GameData[Global_saveData].curRenWus + 1] = {id = getTaskFromPool(), 
    			time = self.curServerTime - moreTime }
    			break
    		end
    	end
	end

	broadCastMsg("timeOver")
	GameState.save(GameData)
end

function RenWuItem:doTick(dt)
	if dt > 1 then
		print("dt", dt)
	end
	if self.curServerTime and self.startTime then
		self.curServerTime = self.curServerTime + dt
		local remTime = self.needTime - (self.curServerTime - self.startTime)
		if remTime <= 0 then
			print("self.curServerTime", string.getOsTime(self.curServerTime))
			print("self.startTime", self.startTime)
			self:timeOver(remTime)

			-- for k, v in ipairs(GameData[Global_saveData].curRenWus) do
   --              if v.id == self.data.id then
   --                  v.time = nil
   --                  break
   --              end
   --          end
   --          qiatan()

		else
			self.time:setString("剩余时间：" .. string.formatNumberToTimeString( math.floor(remTime)))
		end
		
	end
end




function RenWuItem:wait(para)
	print("----------------------- wait " .. para.data.name )
	local data = para.data
	self.data = data
	self.taskType:setVisible(false)
	self.startButton:setVisible(false)
	self.abandomButton:setVisible(false)

	self.title:setString("业务洽谈中...")
	--经验
	self.exp:setString("???")
	--酬劳
	self.money:setString("???")

    local xhr = getXHR()

    local function onReadyStateChanged()
    	-- dump(self.httpLife, "self.httpLife")
    	if not self.httpLife then
    		xhr:unregisterScriptHandler()
    		return
    	end
        if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
            -- print(xhr.response)
            local res = json.decode(xhr.response)
            if type(res) == "table" and res.success == "1" then
	            local stime = res.result["timestamp"]
	            self.startTime = para.startTime
	            -- print("self.startTime " .. self.startTime)
	            self.curServerTime = stime

	            local remTime = self.needTime - (self.curServerTime - self.startTime)
	            if remTime > 0 or #GameData[Global_saveData].renWuPool == 0 
	            	or #GameData[Global_saveData].curRenWus >= tonumber( Global_setting2.max_work ) then
		            self.time:setVisible(true)
		            -- self.time:setString(string.formatNumberToTimeString( math.floor() ))
		            if not self.ticker then
		            	self.ticker = scheduler:scheduleScriptFunc(handler(self, self.doTick) , 0.0, false)
		            end
		            self:doTick(0.016)
		        else

				    self:timeOver(remTime)

		        	
		        end
	        else
	        	self.title:setString("断网失去联系了...")
	        end
            -- if not tolua.isnull(labelStatusCode) then
            --     labelStatusCode:setString("Http Status Code:" .. xhr.statusText)
            -- else
            --     print("ERROR: labelStatusCode is invalid!")
            -- end
        else
        	self.title:setString("断网失去联系了...")
            print("xhr.readyState is:", xhr.readyState, "xhr.status is: ",xhr.status)
        end
        xhr:unregisterScriptHandler()
    end
	xhr:registerScriptHandler(onReadyStateChanged)
    xhr:send()
   
    self:setVisible(true)
    self.httpLife = true
end

function RenWuItem:hide()
	self:setVisible(false)
	if self.ticker then
		scheduler:unscheduleScriptEntry(self.ticker)
		self.ticker = nil
	end	
	self.httpLife = false
end

return RenWuItem