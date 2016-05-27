--
-- Author: kwyxiong
-- Date: 2016-04-10 11:04:12
--


local SignView = class("SignView", function() 
		return cc.uiloader:load("SignView.json")
	end)

function SignView:ctor(arg)
	self.arg = arg or {}
	self.httpLife = false
	self:addNodeEventListener(cc.NODE_EVENT, function(event)
        if event.name == "enter" then
           
        elseif event.name == "exit" then
            self:onExit()
        end
    end)

	self:init()
end

function SignView:onExit()
	self.httpLife = false
end


function SignView:init()

 
	addButtonPressedState(self.subChildren.Panel.subChildren.ButtonClose):onButtonClicked(function() 

			closeView(self)

			-- self:runAction(cc.Sequence:create(
			-- 		cc.FadeOut:create(0.2),
			-- 		cc.CallFunc:create(function() 
			-- 				closeView(self)
			-- 			end)
			-- 	))	
			
		end)
	addButtonPressedState(self.subChildren.Panel.subChildren.ButtonSure):onButtonClicked(function() 

			-- closeView(self)
			self.subChildren.Panel.subChildren.ButtonSure:setVisible(false)
		    self.subChildren.Panel.subChildren.Image_52:setVisible(true)
		    self.subChildren.Panel.subChildren.Label_23:setVisible(false)

		    GameData[Global_saveData].signTime = self.time
			GameData[Global_saveData].jb = GameData[Global_saveData].jb + Global_setting2.day_award[self.week..""].money
			GameData[Global_saveData].tb = GameData[Global_saveData].tb + Global_setting2.day_award[self.week..""].money2
			alert("获得 金币："  .. Global_setting2.day_award[self.week..""].money)
			alert("获得 T币："  .. Global_setting2.day_award[self.week..""].money2)
			broadCastMsg("buyUpdate")
			broadCastMsg("sign")
			save()


		end)
	-- self.subChildren.Panel.subChildren.test:enableOutline(cc.c4b(102, 45, 19, 255), 3)
	-- outlineSprite(self.subChildren.Panel.subChildren.test)




	for k = 1, 7 do
		local week = k
		if week == 7 then
			week = 0
		end
		local button = self.subChildren.Panel.subChildren["Button__" .. k]
		button:onButtonPressed(function()
			if not button.conditionNode then
				local conditionNode = display.newNode()
					:addTo(button,1)
					-- :setVisible(false)
				conditionNode:setScale(0.8)
				-- self.conditionNode = conditionNode
				local sp = display.newSprite("image73.png")
					:addTo(conditionNode)

				local label = cc.ui.UILabel.new({text = "金币：", size = 21})
					:pos(3, 12)
					:setColor(cc.c3b(255, 102, 0))
					:addTo(conditionNode)
				label:setAnchorPoint(cc.p(1, 0.5))

				local label = cc.ui.UILabel.new({text = Global_setting2.day_award[week..""].money, size = 21})
					:pos(3, 12)
					:setColor(cc.c3b(255, 102, 0))
					:addTo(conditionNode)
				label:setAnchorPoint(cc.p(0, 0.5))


				local label = cc.ui.UILabel.new({text = "T币：" , size = 21})
					:pos(3, -12)
					:setColor(cc.c3b(0, 102, 255))
					:addTo(conditionNode)
				label:setAnchorPoint(cc.p(1, 0.5))
				-- self.label = label

				local label = cc.ui.UILabel.new({text =Global_setting2.day_award[week..""].money2, size = 21})
					:pos(3, -12)
					:setColor(cc.c3b(0, 102, 255))
					:addTo(conditionNode)
				label:setAnchorPoint(cc.p(0, 0.5))
				button.conditionNode = conditionNode
			end
			button.conditionNode:stopAllActions()
			button.conditionNode:setVisible(true)

			button.conditionNode:runAction(cc.Sequence:create(
					cc.DelayTime:create(2),
					cc.CallFunc:create(function() 
							button.conditionNode:setVisible(false)
						end)
				))
			cascade(button.conditionNode)
		end)

		-- self.subChildren.Panel.subChildren["Button__" .. k]:onButtonRelease(function()
		-- 	if button.conditionNode then
		-- 		button.conditionNode:setVisible(false)
		-- 	end
		-- end)
	end


    self.subChildren.Panel.subChildren.ButtonSure:setVisible(false)
    self.subChildren.Panel.subChildren.Image_52:setVisible(false)
    self.subChildren.Panel.subChildren.Label_23:setVisible(false)

	-- dump(self.arg, "self.arg")
	if self.arg.week and self.arg.week ~= "noSign" then
        self.week = self.arg.week
    	self.time = self.arg.time
		self.subChildren.Panel.subChildren.ButtonSure:setVisible(true)
	    self.subChildren.Panel.subChildren.Image_52:setVisible(false)
	    self.subChildren.Panel.subChildren.Label_23:setVisible(true)
	    		local week = self.arg.week
	            if week == "0" then
            		week = "7"
            	end
            	local button = self.subChildren.Panel.subChildren["Button__" .. week]

            	local sp = display.newSprite(button.sprite_[1]:getTexture())
            	outlineSprite(sp, 0.04, 1.75)
            	sp:addTo(button)

	elseif self.arg.week == "noSign" then
		-- print("???????????????->->")
		self.subChildren.Panel.subChildren.ButtonSure:setVisible(false)
	    self.subChildren.Panel.subChildren.Image_52:setVisible(true)
	    self.subChildren.Panel.subChildren.Label_23:setVisible(false)		

	else
		self:checkSign()
	end




end

function SignView:checkSign()

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
            	self.week = week
            	self.time = stime
            	if week == "0" then
            		week = "7"
            	end
            	local button = self.subChildren.Panel.subChildren["Button__" .. week]

            	local sp = display.newSprite(button.sprite_[1]:getTexture())
            	outlineSprite(sp, 0.04, 1.75)
            	sp:addTo(button)


            	local curTab = os.date("*t",stime)
            	local preTime = GameData[Global_saveData].signTime

            	local canSign = false
            	if preTime .."" == "0" then
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
				    self.subChildren.Panel.subChildren.ButtonSure:setVisible(true)
				    self.subChildren.Panel.subChildren.Image_52:setVisible(false)
				    self.subChildren.Panel.subChildren.Label_23:setVisible(true)
            	else
 					self.subChildren.Panel.subChildren.ButtonSure:setVisible(false)
				    self.subChildren.Panel.subChildren.Image_52:setVisible(true)
				    self.subChildren.Panel.subChildren.Label_23:setVisible(false)
            	end

	        else
	        	alert("断网失去联系了...")
	        end
            -- if not tolua.isnull(labelStatusCode) then
            --     labelStatusCode:setString("Http Status Code:" .. xhr.statusText)
            -- else
            --     print("ERROR: labelStatusCode is invalid!")
            -- end
        else
        	alert("断网失去联系了...")
        end
        xhr:unregisterScriptHandler()

    end

    xhr:registerScriptHandler(onReadyStateChanged)
    xhr:send()
    self.httpLife = true
end



return SignView