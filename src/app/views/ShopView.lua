--
-- Author: kwyxiong
-- Date: 2016-03-24 11:57:48
--
local ShopViewBox = require("app.widgets.ShopViewBox")
local TabButtons = require("app.widgets.TabButtons")
local ShopView = class("ShopView", function() 
		return cc.uiloader:load("ShopView.json")
		-- return ccs.GUIReader:getInstance():widgetFromJsonFile("ShopView.json")
	end)

function ShopView:ctor()
	self.state = "in"--moving out
	self.moveDis = 500
	self.outPosX = 0
	self.selectedBigButton = nil
	self.curBigPart = 0
	self.curShowCloth = {}
	self.curShopViewBoxes = {}

	self.sortKey = "id"

	self.curPage = 1
	self.dress = {
		"shop_fz",
		"shop_mrmf",
		"shop_xbsp",
	}

	self.handlers = {
		regCallBack("showLayers", handler(self, self.showLayers)),	
		regCallBack("buyUpdate", handler(self, self.buyUpdate)),
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

function ShopView:buyUpdate()
	local data = self.event.data
	-- dump(data, "data")
	self.curShowCloth = {}
	local hasClothes = GameData[Global_saveData].clothes
	-- dump(hasClothes, "hasClothes")
	for k , v in ipairs(data.layers) do
		if Global_clothes_layer[v] then
			for k1, v1 in ipairs(Global_clothes_layer[v]) do
				if not hasClothes[v1.id .. ""] then
					self.curShowCloth[#self.curShowCloth + 1] = v1
				end
				-- local ShopViewBox = ShopViewBox.new()
				-- 	:pos((index-1)%3*disX + firstPosX, math.floor((index-1) / 3) *(-disY) + firstPosY)
				-- 	:addTo(self.subChildren.Panel.subChildren.PanelCloth)
				-- index = index + 1
			end
		end
	end
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
	if self.curPage <= self.pageNum then
		self:showPage(self.curPage)
	else
		self:showPage(self.pageNum)
	end
end


function ShopView:showLayers(event)
	local data = event.data
	self.event = event
	-- dump(data, "data")
	self.curShowCloth = {}

	local canShowRQ = Global_setting2.rq_titlebase_value + Global_setting2.rq_titlelevel_value * GameData[Global_saveData].title 



	local hasClothes = GameData[Global_saveData].clothes
	for k , v in ipairs(data.layers) do
		if Global_clothes_layer[v] then
			for k1, v1 in ipairs(Global_clothes_layer[v]) do
				if not hasClothes[v1.id .. ""]  and v1.rq <= canShowRQ then
					self.curShowCloth[#self.curShowCloth + 1] = v1
				end
				-- local ShopViewBox = ShopViewBox.new()
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


function ShopView:sort(sortKey)
	if sortKey == "moneyUp" then
		table.sort(self.curShowCloth, function(a, b) 
				if a.money ~= b.money then
					return a.money < b.money
				else
					return a.id < b.id
				end
			end)

	elseif sortKey == "moneyDown" then
		table.sort(self.curShowCloth, function(a, b) 
				if a.money ~= b.money then
					return a.money > b.money
				else
					return a.id > b.id
				end
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



function ShopView:updateBottom()
	
	self.subChildren.Panel.subChildren.LabelPage:setString(self.curPage .. "/" .. self.pageNum)

end

function ShopView:showPage(pageIndex)
	self.curPage = pageIndex
	self.curShopViewBoxes = {}

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
			local shopViewBox = ShopViewBox.new({data = v})
				:pos((index-1)%3*disX + firstPosX, math.floor((index-1) / 3) *(-disY) + firstPosY)
				:addTo(self.subChildren.Panel.subChildren.PanelCloth)
			index = index + 1
			self.curShopViewBoxes[#self.curShopViewBoxes + 1] = shopViewBox
		end
	end
	
	self:updateBottom()
	
end

function ShopView:onEnter()

end

function ShopView:onExit()
	for k, v in ipairs(self.handlers) do
		unRegCallBack({msgId = v})
	end
end


function ShopView:initLeftButton(bigPart)
	if self.curBigPart == bigPart then
		return
	end

	local button = self.subChildren.Panel.subChildren.PanelTopButtons.subChildren["Button_" .. bigPart]
	if self.selectedBigButton then
		self.selectedBigButton:setScale(1)
		self.selectedBigButton:setButtonEnabled(true)
	end
	self.selectedBigButton = button
	self.selectedBigButton:setScale(1.2)
	self.selectedBigButton:setButtonEnabled(false)

	self.curBigPart = bigPart

	self.subChildren.Panel.subChildren.PanelLeftButtons:removeAllChildren()
	local tabButtons = TabButtons.new({dress = Global_setting2[self.dress[self.curBigPart]]})
		:pos(26, 413)
		:addTo(self.subChildren.Panel.subChildren.PanelLeftButtons)



	
end

function ShopView:init()
	-- local button = self:getChildByName("ButtonClose")
	-- print("button", button)
	-- button:addTouchEventListener(function(a, b) 
	-- 		dump(a)
	-- 		dump(b)
	-- 	end)
	addButtonPressedState(self.subChildren.PanelButtons.subChildren.ButtonFuZhuang):onButtonClicked(function() 
		self:initLeftButton(1)
		self:show()
	end)
	addButtonPressedState(self.subChildren.PanelButtons.subChildren.ButtonShiPin):onButtonClicked(function() 
		self:initLeftButton(3)
		self:show()
	end)
	addButtonPressedState(self.subChildren.PanelButtons.subChildren.ButtonMeiRong):onButtonClicked(function() 
		self:initLeftButton(2)
		self:show()
	end)
	

	addButtonPressedState(self.subChildren.ButtonClose):onButtonClicked(function() 
			app:enterScene("CityScene")

		end)

	-- dump(ccs, "ccs")

	local ui =  ccs.GUIReader:getInstance():widgetFromJsonFile("ShopActionView.json")
		:addTo(self.subChildren.PanelPerson1)
	local action = ccs.ActionManagerEx:getInstance():getActionByName("ShopActionView.json", "Animation0")

	action:play()


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
			--按价格
			if self.sortKey == "moneyDown" then
				self:sort("moneyUp")
			else
				self:sort("moneyDown")
			end
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

	-- autoAdjust(self.subChildren.Panel, 6)
	-- local worldX = self.subChildren.Panel:convertToWorldSpace(cc.p(0,0)).x
	-- self.moveDis = display.width - 420
	autoAdjust(self.subChildren.Panel, 6)
	self.outPosX = self.subChildren.Panel:getPositionX()
	self.subChildren.Panel:setPositionX(self.outPosX + self.moveDis)

	for k = 1, 3 do
		local button = self.subChildren.Panel.subChildren.PanelTopButtons.subChildren["Button_" .. k]
		-- dump(button.images_)
		addButtonPressedState(button)
		button:onButtonClicked(function() 

			-- button:setButtonImage("normal", "iconBtnBg0003.png")
			-- self:show()
			self:initLeftButton(k)
		end)
	end

	self:initLeftButton(1)
	
end	


function ShopView:hide()
	if self.state == "out" then
		self.state = "moving"
		self.subChildren.PanelButtons:setVisible(true)
		-- broadCastMsg("scrollIn")
		self.subChildren.Panel:runAction(cc.Sequence:create(
			cc.MoveTo:create(0.3, cc.p(self.outPosX + self.moveDis, -35)),
			cc.CallFunc:create(function() 
					self.state = "in"
				end)
			))
	end
end

function ShopView:show()
	if self.state == "in" then
		self.state = "moving"
		self.subChildren.PanelButtons:setVisible(false)
		-- broadCastMsg("scrollOut")
		self.subChildren.Panel:runAction(cc.Sequence:create(
			cc.MoveTo:create(0.3, cc.p(self.outPosX, -35)),
			cc.CallFunc:create(function() 
					self.state = "out"
				end)
			))
	end
end

return ShopView