--
-- Author: kwyxiong
-- Date: 2016-04-01 12:22:09
--
local TaskItem = class("TaskItem", function() 
		return display.newNode()
	end)

function TaskItem:ctor(arg)
	-- self:setCascadeOpacityEnabled(true)
	arg = arg or {}
	self.complete = false
	self.index = arg.index or 1
	self:init()
end

function TaskItem:init()


	-- self.button = cc.ui.UIPushButton.new({normal = "image250.png"})
	-- 	:addTo(self)
	-- 	:onButtonPressed(function(a, b) 
	-- 		dump(a, "a")
	-- 		dump(b, "b")
	-- 		end)
	-- 	:onButtonRelease(function() end)
	-- 	:onButtonClicked(function() 
				
	-- 			-- print(self.data.story)
	-- 			-- dump(self.data, "self.data")
	-- 			if self.complete then
	-- 				if self.data.afterStory ~= "" then
	-- 					app:enterScene("AVGScene", {{self.data.story, self.data.afterStory}})
	-- 				else
	-- 					app:enterScene("AVGScene", {{self.data.story}})
	-- 				end
					

	-- 			else
	-- 				app:enterScene("AVGScene", {self.data})
	-- 			end
	-- 		end)

	local move = function(event_)
			local worldPos = self:convertToWorldSpace(cc.p(0,0))
			local x = event_.x - worldPos.x - 60
			local y = event_.y - worldPos.y + 30
			if y <= -18 then
				y = -18
			elseif y >=71 then
				y = 71
			end
			if x <= -241 then
				x = -241
			elseif x >=171 then
				x = 171
			end
			self.conditionNode:setPosition(x, y)

	end

	local touch = function() 
		Global_task_type = 1
		if self.complete then
			if self.data.afterStory ~= "" then
				app:enterScene("AVGScene", {{self.data.story, self.data.afterStory}})
			else
				app:enterScene("AVGScene", {{self.data.story}})
			end
			

		else
			if self.taskLock:isVisible() then

			else
				app:enterScene("AVGScene", {self.data})
			end
		end	
	end


	self.button = display.newSprite("image250.png")
		:addTo(self)
	self.button:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event_)
		-- dump(event_)



        if event_.name == "ended" then
        	-- if self.arg.sellMode then
        	local worldPos = self:convertToWorldSpace(cc.p(0,0))
        	local x = event_.x - worldPos.x 
			local y = event_.y - worldPos.y 
			if x >= -191 and x <= 229 and y >= -38 and y <= 42 then
				touch()
			end
			self.conditionNode:setVisible(false)
			self.star:setVisible(false)
			self.star:stopAllActions()
		elseif event_.name == "moved"  then
			move(event_)
			local worldPos = self:convertToWorldSpace(cc.p(0,0))
        	local x = event_.x - worldPos.x 
			local y = event_.y - worldPos.y 
			if x >= -191 and x <= 229 and y >= -38 and y <= 42 then
				if self.taskLock:isVisible() or self.complete  then
	        		self.conditionNode:setVisible(true)
	        	else
	        		self.conditionNode:setVisible(false)
	        	end
	        	self.star:setVisible(true)
			else
				self.conditionNode:setVisible(false)
				self.star:setVisible(false)
			end
        elseif event_.name == "began"  then
      
			move(event_)
			self.star:stopAllActions()
			self.star:setVisible(true)
			self.star:runAction(cc.RepeatForever:create(cc.RotateBy:create(1, 360)))
        	if self.taskLock:isVisible() or self.complete  then
        		self.conditionNode:setVisible(true)
        	else
        		self.conditionNode:setVisible(false)
        	end
        	return true
        end
    end)
	self.button:setTouchEnabled(true)
	local bg = display.newSprite("image250.png")
		:addTo(self)
	self.bg = bg
	local bg = display.newFilteredSprite("image250.png", "GRAY")
		:addTo(self)
	self.grayBg = bg

	local bg = display.newSprite("taskLock.png")
		:addTo(self, 99)
	self.taskLock = bg

	local star = display.newSprite("star.png")
		:pos(-205, 2)
		:addTo(self, 100)
	
	self.star = star
	self.star:setVisible(false)

	local conditionNode = display.newNode()
		:addTo(self, 101)
		:setVisible(false)
	conditionNode:setScale(0.8)
	self.conditionNode = conditionNode
	local sp = display.newSprite("image73.png")
		:addTo(conditionNode)

	local label = cc.ui.UILabel.new({text = "需要等级：1\n需要魅力：0", size = 18})
		:setColor(Global_textColor)
		:addTo(conditionNode)
	label:setAnchorPoint(cc.p(0.5, 0.5))
	self.label = label
	-- label:setDimensions(630, 0)
	-- local touchLayer = display.newColorLayer(cc.c4b(122,122,122,0))
	-- 	:pos(-190, -35)
	-- 	:size(415, 77)
	-- 	:addTo(self)
	
	-- local node = touchLayer
	-- node:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event_)
	-- 	dump(event_)
 --        if event_.name == "ended" then
        
	-- 	elseif event_.name == "moved"  then
			
 --        elseif event_.name == "began"  then
        	
 --        	return true
 --        end
 --    end)
 --    node:setTouchEnabled(true)



	local taskType = display.newSprite("zx0001.png")
		:pos(-150, 6)
		:addTo(self)		

	local taskCom = display.newSprite("taskCom.png")
		:pos(-118,-13)
		:addTo(self)
	taskCom:setAnchorPoint(cc.p(0, 0.5))
	self.taskCom = taskCom

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

end

function TaskItem:show(para)

	local data = para.data
	self.data = data
	local complete = para.complete
	self.title:setString(data.name)

	if complete then
		self.grayBg:setVisible(true)
		self.bg:setVisible(false)
		self.taskCom:setVisible(true)
		self.label:setString("回顾剧情")
	else
		self.grayBg:setVisible(false)
		self.bg:setVisible(true)
		self.taskCom:setVisible(false)
		self.label:setString("需要等级：".. data.needLevel .."\n需要魅力：".. data.needMl)
	end
	self.complete = complete

	--经验
	self.exp:setString(data.exp)
	--酬劳
	self.money:setString(data.money)

	local level = getLevel()
	local ml = GameData[Global_saveData].ml

	if level < data.needLevel or ml < data.needMl then
		self.taskLock:setVisible(true)
		-- self.button:setButtonEnabled(false)
	else
		self.taskLock:setVisible(false)
		-- self.button:setButtonEnabled(true)
	end


end

return TaskItem