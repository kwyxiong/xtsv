--
-- Author: kwyxiong
-- Date: 2016-03-21 23:29:19
--

local AVGScene = class("AVGScene", function()
    return display.newScene("AVGScene")
end)

function AVGScene:ctor(arg)
	cc.GameObject.extend(self)
	self:addComponent("app.utils.UISceneProtocol"):exportMethods()
	-- dump(arg)
	audio.stopMusic()
	Global_curMusic = ""
	showView("AVGView", arg)
	
end

function AVGScene:onEnter()
	GuideManager:checkGuide("AVGScene")
end

function AVGScene:onExit()
end

return AVGScene
