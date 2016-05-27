--
-- Author: kwyxiong
-- Date: 2016-04-07 10:53:03
--

local CameraView = class("CameraView", function() 
		return cc.uiloader:load("CameraView.json")
	end)

function CameraView:ctor(arg)


	self:init()
end

function CameraView:init()

 

end



return CameraView