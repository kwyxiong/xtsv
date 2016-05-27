--
-- Author: kwyxiong
-- Date: 2016-03-24 11:39:03
--

local MenuView = class("MenuView", function() 
		return cc.uiloader:load("MenuView.json")
	end)

function MenuView:ctor(arg)
	self.httpLife = false
	self.arg = arg or {}
	self.handlers ={
		regCallBack("buyUpdate", function() 	
				self.subChildren.PanelRightTop.subChildren.Money:setString(GameData[Global_saveData].jb)
				self.subChildren.PanelRightTop.subChildren.TB:setString(GameData[Global_saveData].tb)
			end),
		regCallBack("changeCard", handler(self, self.updateHead)),		
		regCallBack("sign", function() 
				self.subChildren.PanelRightTop.subChildren.ImageSigin:setVisible(false)
				self.week = nil
				self.time = nil
			end),	
	}
	self:init()
	self:addNodeEventListener(cc.NODE_EVENT, function(event)
        if event.name == "enter" then
            self:onEnter()
        elseif event.name == "exit" then
            self:onExit()
        end
    end)


	autoAdjust(self.subChildren.PanelLeftTop, 7)
	autoAdjust(self.subChildren.PanelRightTop, 9)
end

function MenuView:onEnter()

end

function MenuView:onExit()
	for k, v in ipairs(self.handlers) do
		unRegCallBack({msgId = v})
	end
	self.httpLife = false
end

function MenuView:init()
	addButtonPressedState(self.subChildren.PanelRightTop.subChildren.ButtonSet):onButtonClicked(function() 
			showView("SetView", {}, true, true)
		end)	
	addButtonPressedState(self.subChildren.PanelRightTop.subChildren.ButtonSign):onButtonClicked(function() 
			showView("SignView", {week = self.week, time = self.time}, true, true)
		end)	

	-- addButtonPressedState(
		self.subChildren.PanelRightTop.subChildren.ButtonAdd
		-- )
	:onButtonClicked(function() 
			showView("ExchangeMoneyView", {}, true, true)
		end)	
	-- addButtonPressedState(
		self.subChildren.PanelRightTop.subChildren.ButtonAdd_0
		-- )
	:onButtonClicked(function() 
			-- showView("ExchangeMoneyView", {}, true, true)
		end)	
	-- self.subChildren.PanelRightTop.subChildren.ButtonAdd_0:setVisible(false)
	self.subChildren.PanelRightTop.subChildren.Money:setString(GameData[Global_saveData].jb)
	self.subChildren.PanelRightTop.subChildren.TB:setString(GameData[Global_saveData].tb)

	-- self.subChildren.PanelLeftTop.subChildren.Level:enableOutline(cc.c4b(102, 45, 19, 255), 1)
	self:updateExp()
	self:updateML()

	-- local head = display.newSprite("107_1.png")
	self:updateHead()

    if self.arg.showSign then
    	self.subChildren.PanelRightTop.subChildren.ButtonSign:setVisible(true)
    	self.subChildren.PanelRightTop.subChildren.ImageSigin:setVisible(false)
 		outlineSprite(self.subChildren.PanelRightTop.subChildren.ImageSigin, 0.04, 1.0)


 		self:checkSign()
    else
    	self.subChildren.PanelRightTop.subChildren.ButtonSign:setVisible(false)
    	self.subChildren.PanelRightTop.subChildren.ImageSigin:setVisible(false)
    end

end

function MenuView:checkSign()


    local xhr = getXHR()
    local function onReadyStateChanged()
    	if not self.httpLife then
    		xhr:unregisterScriptHandler()
    		return
    	end
        if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
            -- print(xhr.response)

            local res = json.decode(xhr.response)
            if type(res) == "table" and res.success == "1" then
            	local week = res.result.week_1
            	local stime = res.result.timestamp
           
           	

            	local curTab = os.date("*t",stime)
            	local preTime = GameData[Global_saveData].signTime

            	local canSign = false
            	if preTime == 0 then
            		canSign = true
            	else

            		local preTab = os.date("*t",preTime)
            		           		-- dump(preTab, "preTab")
            		-- dump(curTab, "curTab")
            		if curTab.year > preTab.year or (curTab.year == preTab.year and curTab.month > preTab.month )
            			or (curTab.year == preTab.year and curTab.month == preTab.month and curTab.day > preTab.day) then
            			canSign = true
            		end
            	end

            	if canSign then
					self.subChildren.PanelRightTop.subChildren.ImageSigin:setVisible(true)
					
    				self.week = week
    				self.time = stime
            	else
            		self.week = "noSign"
            		self.subChildren.PanelRightTop.subChildren.ImageSigin:setVisible(false)

            	end

	        else
	        	-- alert("断网失去联系了...")
	        end
            -- if not tolua.isnull(labelStatusCode) then
            --     labelStatusCode:setString("Http Status Code:" .. xhr.statusText)
            -- else
            --     print("ERROR: labelStatusCode is invalid!")
            -- end
        else
        	-- alert("断网失去联系了...")
        end
        xhr:unregisterScriptHandler()

    end

    xhr:registerScriptHandler(onReadyStateChanged)
    xhr:send()
    self.httpLife = true
end

function MenuView:updateHead()
	self.subChildren.PanelLeftTop.subChildren.PanelHead:removeAllChildren()

	local head = cc.ui.UIPushButton.new({normal = GameData[Global_saveData].curShowCard .. "_1.png"})
	addButtonPressedState(head, 0.01):onButtonClicked(function() 
				showView("CardsView",nil, true, true)
			end)
	circleClippingNode(head):addTo(self.subChildren.PanelLeftTop.subChildren.PanelHead)
		:pos(47, 47)
	self.head = head
end

function MenuView:updateML()

	self.subChildren.PanelLeftTop.subChildren.ML:setString(GameData[Global_saveData].ml)
	self.subChildren.PanelLeftTop.subChildren.ProgressBar_6:setPercent(100)	
end

function MenuView:updateExp()
	local curExp = GameData[Global_saveData].exp
	-- curExp = 160000
	local datas = Global_levels.datas
	local addExp = 0
	local resLevel = 0
	local resExp = 0
	local resMaxExp = 0
	for k = 0 , 20 do
		local curLevelNeedExp = tonumber(datas[k .. ""].exp)
		if curExp < curLevelNeedExp then
			resLevel = k
			resExp = curExp
			resMaxExp = curLevelNeedExp
			break
		else
			resLevel = resLevel + 1
			curExp = curExp - curLevelNeedExp
			resMaxExp = curLevelNeedExp
		end
	end

	if resLevel == 21 then
		resLevel = 20
		resExp = resMaxExp
	end

	-- self.subChildren.PanelLeftTop.subChildren.Exp:setString(resExp .. "/" .. resMaxExp)
	self.subChildren.PanelLeftTop.subChildren.Exp1:setString(resExp )
	self.subChildren.PanelLeftTop.subChildren.Exp2:setString(resMaxExp)

	self.subChildren.PanelLeftTop.subChildren.ProgressBar_3:setPercent(resExp/resMaxExp*100)


	self.subChildren.PanelLeftTop.subChildren.Level:setString(resLevel)
end


return MenuView