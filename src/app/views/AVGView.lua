--
-- Author: kwyxiong
-- Date: 2016-03-21 23:22:09
--
local AVGView = class("AVGView", function() 
		return display.newNode()
	end)

function AVGView:ctor(arg)
	-- dump(arg, "arg")
	self.showSkip = false
	if arg.story then
		self:init1(arg)
	else
		self:init2(arg)
	end
	-- local index = 100001
	-- local overCallback 
	-- overCallback = function() 
	-- 	if index == 100031 then
	-- 		index = 180001
	-- 	elseif index == 180006 then
	-- 		index = 300001
	-- 	elseif index == 300095 then
	-- 		index = 500001
	-- 	end

	-- 	Nano.new(overCallback)
	-- 	:addTo(self)
	-- 	:loadFile("script/".. index ..".json")	
	-- 	index = index + 1
	-- end

	-- overCallback()

	
-- self.skip:setVisible(true)
end

function AVGView:init1(arg)
	local story = arg.story
	local overCallback = function()
		if not GameData[Global_saveData].viewTasks[arg.story .. ""] then
			GameData[Global_saveData].viewTasks[arg.story .. ""] = true
			GameState.save(GameData)
		end

		-- if GameData[Global_saveData].completeTasks[arg.id .. ""] then

		-- 	if arg.afterStory ~= "" then

		-- 		app:enterScene("AVGScene", {{arg.afterStory}})

		-- 	else
		-- 		app:enterScene("OfficeScene", {true})
		-- 	end

		-- else
			app:enterScene("HomeScene", {arg})
		-- end

	end


	local skip = cc.ui.UIPushButton.new({normal = "image161.png"})
		:pos(740, 550)
		:addTo(self,9999)	
	

	if GameData[Global_saveData].viewTasks[arg.story .. ""] then
		skip:setVisible(true)
		self.showSkip = true
	else
		skip:setVisible(false)
	end

	self.skip = skip

	local nano = Nano.new(overCallback)

	nano:addTo(self)
	:loadFile("script/".. story ..".json")	
	addButtonPressedState(skip):onButtonClicked(nano.overCallback)
end

function AVGView:init2(arg)
	local story
	local skip
	if #arg == 1 then
		story = arg[1]
		local overCallback = function()
			

			if not GameData[Global_saveData].viewTasks[story .. ""] then
				GameData[Global_saveData].viewTasks[story .. ""] = true
				GameState.save(GameData)
			end


				app:enterScene("OfficeScene", {true})
			

		end


		skip = cc.ui.UIPushButton.new({normal = "image161.png"})
			:pos(740, 550)
			:addTo(self,9999)	
		self.skip = skip
		local nano = Nano.new(overCallback)
		nano:addTo(self)
		:loadFile("script/".. story ..".json")	
addButtonPressedState(skip):onButtonClicked(nano.overCallback)
	elseif #arg == 2 then
		story = arg[1]
		local overCallback = function()
			
			if not GameData[Global_saveData].viewTasks[story .. ""] then
				GameData[Global_saveData].viewTasks[story .. ""] = true
				GameState.save(GameData)
			end

			app:enterScene("AVGScene", {{arg[2]}})
			

		end


		skip = cc.ui.UIPushButton.new({normal = "image161.png"})
			:pos(740, 550)
			:addTo(self,9999)	
		self.skip = skip
		local nano = Nano.new(overCallback)
		nano:addTo(self)
		:loadFile("script/".. story ..".json")		
		addButtonPressedState(skip):onButtonClicked(nano.overCallback)		
	end

	if GameData[Global_saveData].viewTasks[story .. ""] then
		skip:setVisible(true)
		self.showSkip = true
	else
		skip:setVisible(false)
	end

	
end

return AVGView