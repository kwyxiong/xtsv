--
-- Author: kwyxiong
-- Date: 2016-04-01 00:01:09
--

local OfficeScene = class("OfficeScene", function()
    return display.newScene("OfficeScene")
end)

function OfficeScene:ctor(fromTask)
	-- print("fromTask", fromTask)
  self.checkGuide = true
	cc.GameObject.extend(self)
	self:addComponent("app.utils.UISceneProtocol"):exportMethods()

    local officeView = showView("OfficeView")
   	showView("MenuView")

   if fromTask then
    if Global_task_type == 1 then
      local overCallback = function() 
                officeView.subChildren.Panel:setVisible(true)
                officeView.subChildren.Panel:setOpacity(0)
                officeView.subChildren.Panel:runAction(cc.FadeIn:create(0.2))
              end
      officeView.subChildren.Panel:setVisible(false)
  		local juQingView = showView("JuQingView", {overCallback = overCallback}, false, true)
      juQingView:stopAllActions()
      juQingView:setOpacity(255)
    elseif Global_task_type == 3 then
      local overCallback = function() 
                officeView.subChildren.Panel:setVisible(true)
                officeView.subChildren.Panel:setOpacity(0)
                officeView.subChildren.Panel:runAction(cc.FadeIn:create(0.2))
              end
      officeView.subChildren.Panel:setVisible(false)
      local renWuView = showView("RenWuView", {overCallback = overCallback}, false, true)
      renWuView:stopAllActions()
      renWuView:setOpacity(255)

    end
    self.checkGuide = false
	end


    showTips()


    addBackEvent(self, function() 
      app:enterScene("CityScene")
    end)  
    
end

function OfficeScene:onEnter()
      if Global_curMusic ~= "bgm_mainStage.mp3" then
      audio.playMusic("bgm_mainStage.mp3", true)
      Global_curMusic = "bgm_mainStage.mp3"
    end
    
    local hasGuide = false
    if self.checkGuide then
      hasGuide = GuideManager:checkGuide("OfficeScene1")
    end
    if not hasGuide then
      GuideManager:checkGuide("OfficeScene")
    end
    
end

function OfficeScene:onExit()
end

return OfficeScene
