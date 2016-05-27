--
-- Author: kwyxiong
-- Date: 2016-03-30 20:53:24
--

local ViewBox = require("app.widgets.ViewBox")
local LabelButtons = require("app.widgets.LabelButtons")
local WardrobeView = class("WardrobeView", function() 
		return cc.uiloader:load("WardrobeView.json")
		-- return ccs.GUIReader:getInstance():widgetFromJsonFile("WardrobeView.json")
	end)

function WardrobeView:ctor(arg)
	self.arg = arg
	self.state = "in"--moving out
	self.moveDis = 425
	self.outPosX = 0
	self.selectedBigButton = nil

	self.payHelp = false

	self.curBigPart = 0
	self.curShowCloth = {}
	self.curViewBoxes = {}


	self.sortKey = "id"-- "timeUp" "timeDown" "rqUp" "rqDown" 

	self.curPage = 1
	self.dress = {
		"dress_fx",
		"dress_sz",
		"dress_xz",
		"dress_lyz",
		"dress_xw",
		"dress_sp",
		"dress_mr"
	}
	self.handlers = {
		regCallBack("showLayers", handler(self, self.showLayers)),
		regCallBack("updateViewBox", handler(self, self.updateViewBox)),
		regCallBack("playCamera", handler(self, self.hide)),
		regCallBack("showAllWearClothes", handler(self, self.showAllWearClothes)),
	}

	self:addNodeEventListener(cc.NODE_EVENT, function(event)
        if event.name == "enter" then
            self:onEnter()
        elseif event.name == "exit" then
            self:onExit()
        end
    end)

	self:init()

end

function WardrobeView:showAllWearClothes(evt)
	local clothes = evt.data.clothes


	self.dress = {
		"dress_fx",
		"dress_sz",
		"dress_xz",
		"dress_lyz",
		"dress_xw",
		"dress_sp",
		"dress_mr"
	}
	local allLayers = {}
	for k, v in ipairs(self.dress) do
		for k1, v1 in ipairs(Global_setting2[v]) do
			local showLayers = v1[table.getFirstKey(v1)]
			for k2, v2 in ipairs(showLayers) do
				allLayers[v2] = true
			end
		end

	end
	local res = {}
	for k, v in pairs(allLayers) do
		res[#res + 1] = k
	end


	-- dump(data, "data")
	self.curShowCloth = {}

	-- dump(clothes, "clothes")

	local hasClothes = GameData[Global_saveData].clothes
	for k , v in ipairs(res) do
		if Global_clothes_layer[v] then
			for k1, v1 in ipairs(Global_clothes_layer[v]) do
				-- print("v", v)
				if hasClothes[v1.id .. ""] and clothes[v] and clothes[v].data.id == v1.id then
					v1.time = hasClothes[v1.id .. ""]
					self.curShowCloth[#self.curShowCloth + 1] = v1
				end
				-- local viewBox = ViewBox.new()
				-- 	:pos((index-1)%3*disX + firstPosX, math.floor((index-1) / 3) *(-disY) + firstPosY)
				-- 	:addTo(self.subChildren.Panel.subChildren.PanelCloth)
				-- index = index + 1
			end
		end
	end
	
	table.sort(self.curShowCloth, function(a, b) 
			return a.id < b.id
		end)
	
	self.pageNum = math.ceil(#self.curShowCloth/6)
	if self.pageNum > 1 then
		self.subChildren.Panel.subChildren.ButtonPre:setVisible(true)
		self.subChildren.Panel.subChildren.ButtonNext:setVisible(true)
		self.subChildren.Panel.subChildren.Image_37:setVisible(true)
		self.subChildren.Panel.subChildren.LabelPage:setVisible(true)
	else
		self.subChildren.Panel.subChildren.ButtonPre:setVisible(false)
		self.subChildren.Panel.subChildren.ButtonNext:setVisible(false)
		self.subChildren.Panel.subChildren.Image_37:setVisible(false)
		self.subChildren.Panel.subChildren.LabelPage:setVisible(false)
	end

	self:showPage(1)




	
	-- for k, v in ipairs(self.curViewBoxes) do
	-- 	local layer = v:getData().parts[1].layer
	-- 	if clothes[layer] and clothes[layer].data.id == v:getData().id then
	-- 		v:setWearState(true)
	-- 	else
	-- 		v:setWearState(false)
	-- 	end 	
	-- end

end

function WardrobeView:onEnter()

end

function WardrobeView:onExit()
	for k, v in ipairs(self.handlers) do
		unRegCallBack({msgId = v})
	end
end

function WardrobeView:init()
	-- local button = self:getChildByName("ButtonClose")
	-- print("button", button)
	-- button:addTouchEventListener(function(a, b) 
	-- 		dump(a)
	-- 		dump(b)
	-- 	end)
	if self.arg then--任务
		self.subChildren.ButtonGiveUp:setVisible(true)
		self.subChildren.ButtonBack:setVisible(false)
		self.subChildren.ButtonSure:setVisible(true)
		self.subChildren.ButtonReview:setVisible(true)
		self.subChildren.ButtonHelp:setVisible(true)
		-- dump(self.arg, "self.arg")
	else
		self.subChildren.ButtonGiveUp:setVisible(false)
		self.subChildren.ButtonBack:setVisible(true)
		self.subChildren.ButtonSure:setVisible(false)
		self.subChildren.ButtonReview:setVisible(false)
		self.subChildren.ButtonHelp:setVisible(false)
	end
	

	addButtonPressedState(self.subChildren.Panel.subChildren.ButtonClose):onButtonClicked(function() 
			self:hide()
		end)

	addButtonPressedState(self.subChildren.Panel.subChildren.ButtonLeft):onButtonClicked(function() 
			--按人气
			if self.sortKey == "rqDown" then
				self:sort("rqUp")
			else
				self:sort("rqDown")
			end
			
		end)	

	addButtonPressedState(self.subChildren.Panel.subChildren.ButtonRight):onButtonClicked(function() 
			--按时间
			if self.sortKey == "timeDown" then
				self:sort("timeUp")
			else
				self:sort("timeDown")
			end
		end)

	addButtonPressedState(self.subChildren.Panel.subChildren.ButtonAll):onButtonClicked(function() 

			self.dress = {
				"dress_fx",
				"dress_sz",
				"dress_xz",
				"dress_lyz",
				"dress_xw",
				"dress_sp",
				"dress_mr"
			}
			local allLayers = {}
			for k, v in ipairs(self.dress) do
				for k1, v1 in ipairs(Global_setting2[v]) do
					local showLayers = v1[table.getFirstKey(v1)]
					for k2, v2 in ipairs(showLayers) do
						allLayers[v2] = true
					end
				end

			end
			local res = {}
			for k, v in pairs(allLayers) do
				res[#res + 1] = k
			end

			broadCastMsg("showLayers", {layers = res})
		end)
	addButtonPressedState(self.subChildren.Panel.subChildren.ButtonCur):onButtonClicked(function() 


			broadCastMsg("getAllWearClothes")
		end)
	addButtonPressedState(self.subChildren.Panel.subChildren.ButtonPre):onButtonClicked(function() 
			if self.curPage > 1 then
				self:showPage(self.curPage - 1)
			end
		end)
	addButtonPressedState(self.subChildren.Panel.subChildren.ButtonNext):onButtonClicked(function() 
			if self.curPage < self.pageNum then
				self:showPage(self.curPage + 1)
			end
		end)
	
	addButtonPressedState(self.subChildren.ButtonReset):onButtonClicked(function ( )
		broadCastMsg("reset")
	end)
	addButtonPressedState(self.subChildren.ButtonSure):onButtonClicked(function ( )
		broadCastMsg("taskSure")




	end)


	addButtonPressedState(self.subChildren.ButtonBack):onButtonClicked(function ( )
		app:enterScene("CityScene")
	end)
	addButtonPressedState(self.subChildren.ButtonGiveUp):onButtonClicked(function ( )
		local sureCallback = function() 
			if not GameData[Global_saveData].guides["GuideFive"] then

				app:enterScene("CityScene")
			else
				app:enterScene("OfficeScene", {true})
			end
		end

		showView("TipsView", {type = "taskGiveUp",sureCallback = sureCallback}, true, true)
	end)
	addButtonPressedState(self.subChildren.ButtonReview):onButtonClicked(function ( )
		-- app:enterScene("CityScene")
		showView("JuQingReview", {story = self.arg.story}, true, true)
	end)
	addButtonPressedState(self.subChildren.ButtonHelp):onButtonClicked(function ( )
		-- app:enterScene("CityScene")
		if not self.payHelp then
			local money = math.floor(self.arg.money * Global_setting2["tip_cost"])
			local sureCallback = function() 

				if GameData[Global_saveData].jb < money then
					alert("金币不足！")
				else
					GameData[Global_saveData].jb = GameData[Global_saveData].jb - money
					GameState.save(GameData)
					showView("TaskHelpView", {taskData = self.arg}, true, true)
					self.payHelp = true
				end
			end
			showView("TipsView", {type = "taskHelp", money = money, sureCallback = sureCallback}, true, true)
		else
			showView("TaskHelpView", {taskData = self.arg}, true, true)
		end
	end)
	-- autoAdjust(self.subChildren.ButtonReview, 1)
	-- autoAdjust(self.subChildren.ButtonHelp, 1)

	autoAdjust(self.subChildren.Panel, 6)
	self.outPosX = self.subChildren.Panel:getPositionX()
	self.subChildren.Panel:setPositionX(self.outPosX + self.moveDis)
	self.state = "in"

	for k = 1, 7 do
		local button = self.subChildren.Panel.subChildren["Button_" .. k]
		-- dump(button.images_)
		local buttonCallback = function() 
			if self.selectedBigButton then
				self.selectedBigButton:setButtonImage("normal", "iconBtnBg0001.png")
				-- self.selectedBigButton:setButtonEnabled(true)
			end
			self.selectedBigButton = button
			self.selectedBigButton:setButtonImage("normal", "iconBtnBg0003.png")
			-- self.selectedBigButton:setButtonEnabled(false)
			-- button:setButtonImage("normal", "iconBtnBg0003.png")
			self:show(k)
			self:initTopButton(k)
		end
		button:onButtonClicked(buttonCallback)
		button.buttonCallback = buttonCallback
		-- dump(buttonCallback, "buttonCallback")
	end

	

	-- self:initTopButton()
end	

function WardrobeView:initTopButton(bigPart)
	if self.curBigPart == bigPart then
		return
	end
	self.curBigPart = bigPart

	self.subChildren.Panel.subChildren.PanelTopButtons:removeAllChildren()
	local labelButtons = LabelButtons.new({dress = Global_setting2[self.dress[self.curBigPart]]})
		:addTo(self.subChildren.Panel.subChildren.PanelTopButtons)


	self.labelButtons = labelButtons
	
end

function WardrobeView:showLayers(event)
	
	local data = event.data
	-- dump(data, "data")
	self.curShowCloth = {}
	local hasClothes = GameData[Global_saveData].clothes
	for k , v in ipairs(data.layers) do
		if Global_clothes_layer[v] then
			for k1, v1 in ipairs(Global_clothes_layer[v]) do
				if hasClothes[v1.id .. ""] then
					v1.time = hasClothes[v1.id .. ""]
					self.curShowCloth[#self.curShowCloth + 1] = v1
				end
				-- local viewBox = ViewBox.new()
				-- 	:pos((index-1)%3*disX + firstPosX, math.floor((index-1) / 3) *(-disY) + firstPosY)
				-- 	:addTo(self.subChildren.Panel.subChildren.PanelCloth)
				-- index = index + 1
			end
		end
	end
	
	table.sort(self.curShowCloth, function(a, b) 
			return a.id < b.id
		end)
	
	self.pageNum = math.ceil(#self.curShowCloth/6)
	if self.pageNum > 1 then
		self.subChildren.Panel.subChildren.ButtonPre:setVisible(true)
		self.subChildren.Panel.subChildren.ButtonNext:setVisible(true)
		self.subChildren.Panel.subChildren.Image_37:setVisible(true)
		self.subChildren.Panel.subChildren.LabelPage:setVisible(true)
	else
		self.subChildren.Panel.subChildren.ButtonPre:setVisible(false)
		self.subChildren.Panel.subChildren.ButtonNext:setVisible(false)
		self.subChildren.Panel.subChildren.Image_37:setVisible(false)
		self.subChildren.Panel.subChildren.LabelPage:setVisible(false)
	end

	self:showPage(1)
end

function WardrobeView:sort(sortKey)
	if sortKey == "timeUp" then
		table.sort(self.curShowCloth, function(a, b) 
				return a.time < b.time
			end)

	elseif sortKey == "timeDown" then
		table.sort(self.curShowCloth, function(a, b) 
				return a.time > b.time
			end)
	elseif sortKey == "rqUp" then
		table.sort(self.curShowCloth, function(a, b) 
				if a.rq ~= b.rq then
					return a.rq < b.rq
				else
					return a.id < b.id
				end
			end)
	elseif sortKey == "rqDown" then
		table.sort(self.curShowCloth, function(a, b) 
				if a.rq ~= b.rq then
					return a.rq > b.rq
				else
					return a.id > b.id
				end
			end)
	end 
	self.sortKey = sortKey


	self.pageNum = math.ceil(#self.curShowCloth/6)
	if self.pageNum > 1 then
		self.subChildren.Panel.subChildren.ButtonPre:setVisible(true)
		self.subChildren.Panel.subChildren.ButtonNext:setVisible(true)
		self.subChildren.Panel.subChildren.Image_37:setVisible(true)
		self.subChildren.Panel.subChildren.LabelPage:setVisible(true)
	else
		self.subChildren.Panel.subChildren.ButtonPre:setVisible(false)
		self.subChildren.Panel.subChildren.ButtonNext:setVisible(false)
		self.subChildren.Panel.subChildren.Image_37:setVisible(false)
		self.subChildren.Panel.subChildren.LabelPage:setVisible(false)
	end

	self:showPage(1)
end

function WardrobeView:updateBottom()
	
	self.subChildren.Panel.subChildren.LabelPage:setString(self.curPage .. "/" .. self.pageNum)

end

function WardrobeView:showPage(pageIndex)
	self.curPage = pageIndex
	self.curViewBoxes = {}

	self.subChildren.Panel.subChildren.PanelCloth:removeAllChildren()

	local firstPosX = 72
	local firstPosY = 280
	local disX = 130
	local disY = 188
	local index = 1
	

	local minIndex = (pageIndex - 1)*6 + 1
	local maxIndex = (pageIndex - 1)*6 + 6	

	for k, v in ipairs(self.curShowCloth) do
		if k >= minIndex and k <= maxIndex then
			local viewBox = ViewBox.new({data = v})
				:pos((index-1)%3*disX + firstPosX, math.floor((index-1) / 3) *(-disY) + firstPosY)
				:addTo(self.subChildren.Panel.subChildren.PanelCloth)
			index = index + 1
			self.curViewBoxes[#self.curViewBoxes + 1] = viewBox
		end
	end
	
	self:updateBottom()
	broadCastMsg("HomeSceneBroadCast_updateViewBox")
end

function WardrobeView:updateViewBox(evt)
	-- dump(evt.data)
	local clothes = evt.data.clothes
	for k, v in ipairs(self.curViewBoxes) do
		local layer = v:getData().parts[1].layer
		if clothes[layer] and clothes[layer].data.id == v:getData().id  then
			v:setWearState(true, clothes[layer].switch)
		else
			v:setWearState(false)
		end 	
	end
end

function WardrobeView:hide()
	if self.state == "out" then
		self.state = "moving"
		broadCastMsg("scrollIn")
		self.subChildren.Panel:runAction(cc.Sequence:create(
			cc.MoveTo:create(0.5, cc.p(self.outPosX + self.moveDis, 0)),
			cc.CallFunc:create(function() 
					self.state = "in"
				end)
			))
	end
end

function WardrobeView:show(index)
	if self.state == "in" then
		self.state = "moving"
		broadCastMsg("scrollOut", {index = index})
		self.subChildren.Panel:runAction(cc.Sequence:create(
			cc.MoveTo:create(0.5, cc.p(self.outPosX, 0)),
			cc.CallFunc:create(function() 
					self.state = "out"
				end)
			))
	elseif self.state == "out" then
		broadCastMsg("change", {index = index})
	end
end

return WardrobeView