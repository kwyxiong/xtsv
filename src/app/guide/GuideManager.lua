--
-- Author: kwyxiong
-- Date: 2015-07-10 16:32:08
--

local GuideManager = class("GuideManager")

function GuideManager:ctor()
	self.guide = nil
	self.curGuideName = nil
	self.guides = nil
	self.curIndex = 1
end


function GuideManager:startGuide(guideName,arg)
	print(guideName .. "->start")

    local guide = cc.Director:getInstance():getRunningScene():getChildByName("guide")
    if guide then
        guide:removeSelf()
    end

	local scene = cc.Director:getInstance():getRunningScene()
	self.guide = require("app.guide." .. guideName).new(arg)
		:addTo(scene, 10000)
	self.guide:setName("guide")
	self.curGuideName = guideName
	self.curArg = arg
end



function GuideManager:isGuiding()
	local guide = cc.Director:getInstance():getRunningScene():getChildByName("guide")
	if guide then
		return true
	else
		return false
	end
end

function GuideManager:error()
	local guide = cc.Director:getInstance():getRunningScene():getChildByName("guide")
	if guide then
		guide:error()
	end
end

function GuideManager:netError()
	local guide = cc.Director:getInstance():getRunningScene():getChildByName("guide")
	if guide then
		guide:error()
	end
	-- --dump(self.guides,"self.guides")
	-- --dump(self.curIndex,"self.curIndex")
	-- if self.guides and self.guides[self.curIndex - 1] and self.guides[self.curIndex - 1]["checkNet"] then
	-- 	local arg = self.curArg or {}
	-- 	arg.startStep = self.curIndex - 1
	-- 	self:startGuide(self.curGuideName,arg)
	-- end

end

    

function GuideManager:nextStep()
    local guide = cc.Director:getInstance():getRunningScene():getChildByName("guide")
    if guide then
        guide:nextStep()
    end 
end

function GuideManager:checkGuide(arg)
    

  
    local hasGuide = false
    if arg == "AVGScene" then
    	local view = getViewByName("AVGView")
    	dump(view)
    	if view and view.showSkip and not GameData[Global_saveData].guides["GuideSeven"] then


    		GameData[Global_saveData].guides["GuideSeven"] = true

    		GameState.save(GameData)
    		GuideManager:startGuide("GuideSeven")
   			hasGuide = true
    	end

    elseif arg == "HomeScene" then
    	if CUR_UI_SCENE.arg and CUR_UI_SCENE.arg.id .. "" == Global_setting2.start_task .. ""
    	 and not GameData[Global_saveData].guides["GuideOne"]  then

    		GameData[Global_saveData].guides["GuideOne"] = true
    		
    		GameState.save(GameData)
    		GuideManager:startGuide("GuideOne")
   			hasGuide = true

   		elseif CUR_UI_SCENE.arg then
   			local nextTask = Global_tasks_id[tonumber(Global_setting2.start_task)].nextTask[1]
   			if CUR_UI_SCENE.arg.id .. "" == nextTask and not GameData[Global_saveData].guides["GuideFour"] then
	    		GameData[Global_saveData].guides["GuideFour"] = true
	    		
	    		GameState.save(GameData)
	    		GuideManager:startGuide("GuideFour")
	   			hasGuide = true

   			end


    	end
    elseif arg == "CityScene" then
    	if not GameData[Global_saveData].guides["GuideTwo"] then

     		GameData[Global_saveData].guides["GuideTwo"] = true
    		
    		GameState.save(GameData)
    		GuideManager:startGuide("GuideTwo")
   			hasGuide = true   	
   		elseif not GameData[Global_saveData].guides["GuideFive"] then

     		GameData[Global_saveData].guides["GuideFive"] = true
    		
    		GameState.save(GameData)
    		GuideManager:startGuide("GuideFive")
   			hasGuide = true 
    	elseif not GameData[Global_saveData].guides["GuideSix"] then

     		GameData[Global_saveData].guides["GuideSix"] = true
    		
    		GameState.save(GameData)
    		GuideManager:startGuide("GuideSix")
   			hasGuide = true 
  			 	
  		elseif not GameData[Global_saveData].guides["GuideNine"] and table.getNum(GameData[Global_saveData].cards) > 0 then
      		
      		GameData[Global_saveData].guides["GuideNine"] = true
    		GameState.save(GameData)
    		GuideManager:startGuide("GuideNine")
   			hasGuide = true 
  			 	 			
    	end
    elseif  arg == "CityScene1" then
	   	if not GameData[Global_saveData].guides["GuideTen"] then

	     		GameData[Global_saveData].guides["GuideTen"] = true
	    		
	    		GameState.save(GameData)
	    		GuideManager:startGuide("GuideTen")
	   			hasGuide = true   	
	   	end
    elseif arg == "OfficeScene" then
    	if not GameData[Global_saveData].guides["GuideThree"] then

     		GameData[Global_saveData].guides["GuideThree"] = true
    		
    		GameState.save(GameData)
    		GuideManager:startGuide("GuideThree")
   			hasGuide = true   		
    	end

    elseif arg == "OfficeScene1" then
    	if not GameData[Global_saveData].guides["GuideEight"] and GameData[Global_saveData].title >= tonumber(Global_setting2.work_titlelevel) then

     		GameData[Global_saveData].guides["GuideEight"] = true
    		
    		GameState.save(GameData)
    		GuideManager:startGuide("GuideEight")
   			hasGuide = true   		
    	end


    end



   

    return hasGuide

end

return GuideManager