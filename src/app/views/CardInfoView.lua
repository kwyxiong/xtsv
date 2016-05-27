--
-- Author: kwyxiong
-- Date: 2016-04-07 12:30:46
--

local CardInfoView = class("CardInfoView", function() 
		return cc.uiloader:load("CardInfoView.json")
	end)

function CardInfoView:ctor(arg)
	self.cardData = arg.cardData

	self:init()
		self:addNodeEventListener(cc.NODE_EVENT, function(event)
        if event.name == "enter" then
            self:onEnter()
        elseif event.name == "exit" then
            
        end
    end)
end

function CardInfoView:onEnter()

	GuideManager:checkGuide("CityScene1")
end

function CardInfoView:init()

 	addButtonPressedState(self.subChildren.ButtonClose):onButtonClicked(function() 

			closeView(self)
			
		end) 

 	addButtonPressedState(self.subChildren.ButtonSet):onButtonClicked(function() 
 			GameData[Global_saveData].curShowCard = self.cardData.id
 			broadCastMsg("changeCard")
			alert("更换了新的海报！")
			save()
			closeView(self)
		end) 
 	

 	self.subChildren.Card:setTexture(self.cardData.id .. ".png")
 	self.subChildren.LabelName:setString(self.cardData.name)
 	self.subChildren.LabelName:enableOutline(Global_label_color4, 2)
 	self.subChildren.LabelInfo:setString(self.cardData.des)
 	local str = ""
 	if self.cardData.addType == "money" then
 		str= "获得金币 增加 " .. tonumber(self.cardData.addValue) * 100 .."%"
 	elseif self.cardData.addType == "exp" then
 		str= "获得经验值 增加 " .. tonumber(self.cardData.addValue) * 100 .."%"
 	else
 		str= "获得风格 ".. self.cardData.addType .." 的任务概率增加 ".. self.cardData.addValue .."%"
 	end
 	self.subChildren.Label_17:setString(str)
end



return CardInfoView