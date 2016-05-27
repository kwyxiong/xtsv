
local CityScene = class("CityScene", function()
    return display.newScene("CityScene")
end)

function CityScene:ctor(moveLabel)
	cc.GameObject.extend(self)
	self:addComponent("app.utils.UISceneProtocol"):exportMethods()

    showView("CityView", {moveLabel = moveLabel})
    showView("MenuView", {showSign = true})

    showTips()

    addBackEvent(self, function() 
        device.showAlert("提示", "是否确认退出游戏？", {"退出", "取消"}, function (event)
            if event.buttonIndex == 1 then
                cc.Director:getInstance():endToLua()
            end
        end)
    end)  
    
end

function CityScene:onEnter()
    if Global_curMusic ~= "bgm_mainStage.mp3" then
    	audio.playMusic("bgm_mainStage.mp3", true)
    	Global_curMusic = "bgm_mainStage.mp3"
    end

    GuideManager:checkGuide("CityScene")
end

function CityScene:onExit()
	
end

return CityScene
