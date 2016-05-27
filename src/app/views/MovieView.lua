--
-- Author: kwyxiong
-- Date: 2016-04-12 01:40:30
--

local MovieView = class("MovieView", function() 
		return cc.uiloader:load("MovieView.json")
	end)

function MovieView:ctor()
	self:init()
	self:addNodeEventListener(cc.NODE_EVENT, function(event)
        if event.name == "enter" then
            self:onEnter()
        elseif event.name == "exit" then
            self:onExit()
        end
    end)

end

function MovieView:onEnter()
	audio.pauseMusic()



	

end


function MovieView:play()
    local function onVideoEventCallback(sener, eventType)
        if eventType == ccexp.VideoPlayerEvent.PLAYING then
            -- videoStateLabel:setString("PLAYING")
            if self.sp then
                self.sp:removeSelf()
                self.sp = nil
            end
        elseif eventType == ccexp.VideoPlayerEvent.PAUSED then
            -- videoStateLabel:setString("PAUSED")
        elseif eventType == ccexp.VideoPlayerEvent.STOPPED then
            -- videoStateLabel:setString("STOPPED")
        elseif eventType == ccexp.VideoPlayerEvent.COMPLETED then
            -- videoStateLabel:setString("COMPLETED")
            closeView(self)
        end
	end

    self.sp = display.newSprite("load.png")
        :pos(400, 294)
        :addTo(self)
    self.sp:runAction(cc.RepeatForever:create(cc.RotateBy:create(1, 360)))

    if device.platform ~= "windows" then

        local videoPlayer = ccexp.VideoPlayer:create()
        videoPlayer:setPosition(400, 294)
        videoPlayer:setAnchorPoint(cc.p(0.5, 0.5))
        videoPlayer:setContentSize(cc.size(800,444))
        videoPlayer:addEventListener(onVideoEventCallback)
        self:addChild(videoPlayer)
       
    	local videoFullPath  = "res/video.mp4"
        videoPlayer:setFileName(videoFullPath)   
        videoPlayer:play()
    end


end

function MovieView:onExit()
	audio.resumeMusic()
	CUR_UI_SCENE.particleLeaf:setVisible(true)

end

function MovieView:init()

 
	addButtonPressedState(self.subChildren.ButtonSkip):onButtonClicked(function() 

			closeView(self)


		end)
	self:play()

    -- addBackEvent(self, function() 
    --         closeView(self)
    --     end)
end



return MovieView