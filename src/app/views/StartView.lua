--
-- Author: kwyxiong
-- Date: 2016-03-21 15:49:58
--
local GuideRing = require("app.widgets.GuideRing")
local StartView = class("StartView", function() 
		return cc.uiloader:load("StartView.json")
	end)

function StartView:ctor()

	self:init()
end

function StartView:init()

	self.subChildren.Button_Start:onButtonClicked(function() 
			if not GameData[Global_saveData] or not GameData[Global_saveData].name or GameData[Global_saveData].name == "" then
				showView("CreateRoleView", nil, true, true)
			else
				app:enterScene("CityScene", {true})
			end
		end)	
	scaleButton(self.subChildren.Button_Start)


	self.subChildren.Button_Movie:onButtonClicked(function() 

		CUR_UI_SCENE.particleLeaf:setVisible(false)
		showView("MovieView", nil, true, false)
		-- showView("MovieView")
	end)
	scaleButton(self.subChildren.Button_Movie)

	self.subChildren.Button_Info:onButtonClicked(function() 

		CUR_UI_SCENE.particleLeaf:setVisible(false)
		showView("InfoView", nil, true, true)
		-- showView("MovieView")
	end)
	scaleButton(self.subChildren.Button_Info)



	-- local ring = GuideRing.new(333,333)
	-- 	-- :pos(333,333)
	-- 	:addTo(self, 99999)
	-- local circle = MySprite:create(100, 333,333,50,1)
	-- self:addChild(circle, 99999)


end

-- 

return StartView