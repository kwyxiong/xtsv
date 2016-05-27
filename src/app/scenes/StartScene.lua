--
-- Author: kwyxiong
-- Date: 2016-03-21 11:30:21
--
local CameraNode = require("app.widgets.CameraNode")
local ParticleLeaf = require("app.utils.ParticleLeaf")
local StartScene = class("StartScene", function()
    return display.newScene("StartScene")
end)

function StartScene:ctor()

	cc.GameObject.extend(self)
	self:addComponent("app.utils.UISceneProtocol"):exportMethods()



    showView("StartView") 
    self:playParticle()

    setMusicSound()

    -- local cameraNode =CameraNode.new()
    	-- :pos(display.cx, display.cy)
    	-- :addTo(self,99999)

 
    addBackEvent(self, function() 
        device.showAlert("提示", "是否确认退出游戏？", {"退出", "取消"}, function (event)
            if event.buttonIndex == 1 then
                cc.Director:getInstance():endToLua()
            end
        end)
    end)  





end

function StartScene:playParticle()
	-- self:runAction(cc.Sequence:create(
	-- 		cc.DelayTime:create(2),
	-- 		cc.CallFunc:create(function() 

					local particleLeaf = ParticleLeaf.new({image = "ball.png"})
						:addTo(self, 501)
				-- end)
		-- ))

    self.particleLeaf = particleLeaf
end

function StartScene:onEnter()
        if Global_curMusic ~= "bgm_startMenu.mp3" then
        audio.playMusic("bgm_startMenu.mp3", true)
        Global_curMusic = "bgm_startMenu.mp3"
    end

    if GameData[Global_saveData].firstPlay == 1 then
        CUR_UI_SCENE.particleLeaf:setVisible(false)
        showView("MovieView", nil, true, false)
        GameData[Global_saveData].firstPlay = 0 
        save(true)
    end
    
end

function StartScene:onExit()
end

return StartScene
