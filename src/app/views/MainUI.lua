--
-- Author: Your Name
-- Date: 2016-01-16 16:09:35
--
local LabelButton = require("app.views.widgets.LabelButton")
local MyPageView = require("app.views.widgets.MyPageView")
local MainUIButton = require("app.views.widgets.MainUIButton")
local MainUI = class("MainUI", function() 
		return display.newNode()
	end)

function MainUI:ctor()
	self.partData = {
		{G_EXCEL_TABLE_faxing},
		{G_EXCEL_TABLE_shangyi,G_EXCEL_TABLE_waitao},
		{G_EXCEL_TABLE_kuzi,G_EXCEL_TABLE_qunzi,G_EXCEL_TABLE_jiyaozhuang},
		{G_EXCEL_TABLE_lianyizhuang},
		{G_EXCEL_TABLE_xiezi,G_EXCEL_TABLE_wazi},
		{G_EXCEL_TABLE_shipin},
		{G_EXCEL_TABLE_yanjing,G_EXCEL_TABLE_meimao, G_EXCEL_TABLE_fuse}
	}
	self.buttonLabels = {
		{""},
		{"上衣", "外套"},
		{"裤子","裙子","及腰装"},
		{""},
		{"鞋子", "袜子"},
		{""},
		{"眼睛", "眉毛", "肤色"}
	}
	self.myPageViews = {}
	self.topButtons = {}
	self.bigPart = 1
	self.smallPart = 1
	self.pageView = nil
	self.state = "in"--in out scrolling
	self:init()

	-- local labelButton = LabelButton.new()
	-- 	:addTo(self, 9999)
	self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(...)
			self:update_(...)
		end)
	self:scheduleUpdate()
	self.scrollNode:setPositionX(340)
	self:update_()
end


function MainUI:initLeftButton()
	for k = 1, 7 do
		local button = MainUIButton.new("button".. k ..".png")
		:pos(-170, 215 + (k-1)*(-70))
		:addTo(self.scrollNode)
		:onButtonClicked(function(event) 
			-- dump(event)

			if self.bigPart == k then
				if self.state == "out" then
					self:scrollIn()
				end
			else
				-- self.pageView:setVisible(false)
				self:showPart(k, 1)
			end
			if self.state == "in" then
				self:scrollOut()
			end

		end)
		button:setScale(7/8)
	end
end

function MainUI:initTopButton()

	for k, v in ipairs(self.buttonLabels) do
		if #v > 1 then
			for k1, v1 in ipairs(v) do
				local button 
				button = LabelButton.new({text = v1,bigPart = k, smallPart = k1})
					:pos(k1*50 - 140, 240)
					:addTo(self.pageViewNode)
					:onButtonClicked(function() 
						if self.bigPart ~= button.bigPart or self.smallPart ~= button.smallPart then
							-- self.pageView:setVisible(false)
							self:showPart(button.bigPart, button.smallPart)
						end
					end)	
				self.topButtons[#self.topButtons + 1] = button			
			end
		end
	end

	local button 
	button = LabelButton.new({text = "重来"})
		:pos(5*50 - 140, 240)
		:addTo(self.pageViewNode)
		:onButtonClicked(function() 
			broadCastMsg("reset")
		end)	
	local button 
	button = LabelButton.new({text = "关闭"})
		:pos(6*50 - 140, 240)
		:addTo(self.pageViewNode)
		:onButtonClicked(function() 
			-- self:scrollIn()
			app:enterScene("CityScene")
		end)
end


function MainUI:init()

	self.scrollNode = display.newNode()
		-- :addTo(self)

	

	

	self.bg = display.newScale9Sprite("scale9_1.png", 0, 0, cc.size(420, 520), cc.rect(35, 35,10,10))
		:addTo(self.scrollNode)


	local bg = display.newScale9Sprite("scale9_1.png", 0, 0, cc.size(80, 520), cc.rect(35, 35,10,10))
		:pos(-170, 0)
		:addTo(self.scrollNode)

	self.clippingNode = cc.ClippingRegionNode:create()
	self.clippingNode:setClippingRegion(cc.rect(self.bg:getBoundingBox().x + 80, self.bg:getBoundingBox().y, 340, 520))
	self.scrollNode:addChild(self.clippingNode)

	

	self.pageViewNode = display.newNode()
		:addTo(self.clippingNode)


	self:initScrollView()


	self:initLeftButton()
	self:initTopButton()

	self:showPart(self.bigPart, self.smallPart)
	

	
end

function MainUI:initScrollView()
    local bound = self.bg:getBoundingBox()
    -- dump(bound)
    -- bound.width = 300
    -- bound.height = 200


	self.scrolliew =  cc.ui.UIScrollView.new({viewRect = bound,
		-- bgColor = cc.c4b(222,222,222,222)
		})
        :addScrollNode(self.scrollNode)
        :setDirection(cc.ui.UIScrollView.DIRECTION_HORIZONTAL)
        -- :onScroll(handler(self, self.scrollListener))
        :addTo(self)
    self.scrolliew.touchNode_:setTouchEnabled(false)

end

function MainUI:update_(dt)
	-- dump(event)
	-- print("TestUIScrollViewScene - scrollListener:" .. event.name)
	local disX = self.scrollNode:getPositionX()
	self.pageViewNode:setPositionX(-disX)
	-- self.clippingNode:setClippingRegion(cc.rect(self.bg:getBoundingBox().x + 80 + disX, self.bg:getBoundingBox().y, 340 - disX, 520))
end

function MainUI:scrollIn( ... )
	-- body
	if self.state == "out" then
		self.state = "scrolling"
		broadCastMsg("scrollIn")
		self.scrollNode:runAction(cc.Sequence:create(
				cc.MoveTo:create(1, cc.p(340, 0)),
				cc.CallFunc:create(function() 
						self.state = "in"
					end)
			))
	end
end

function MainUI:scrollOut( ... )
	-- body
	if self.state == "in" then
		self.state = "scrolling"
		broadCastMsg("scrollOut")
		self.scrollNode:runAction(cc.Sequence:create(
				cc.MoveTo:create(1, cc.p(0, 0)),
				cc.CallFunc:create(function() 
						self.state = "out"
					end)
			))
	end
end

function MainUI:showPart(bigPart, smallPart)
	if  not self.myPageViews[bigPart] or not self.myPageViews[bigPart][smallPart] then
		if not self.myPageViews[bigPart] then
			self.myPageViews[bigPart] = {}
		end
		-- print("create pageView")
		-- local preX =self.pageViewNode:getPositionX()
		-- self.pageViewNode:setPositionX(0)
		-- self.scrollNode:setPositionX(340)
		local myPageView =  MyPageView.new()
			:pos(40, 0)
			:addTo(self.pageViewNode)
		-- self.pageViewNode:setPositionX(preX)

			-- dump(self.partData[bigPart])
		for k, v in ipairs(self.partData[bigPart][smallPart]) do
			v.id = k
			myPageView:addItemData(v)
		end
		self.myPageViews[bigPart][smallPart] = myPageView
	end
	
	self.myPageViews[bigPart][smallPart]:showPage(1)
	
	if self.pageView then
		if self.bigPart ~= bigPart then
			if self.state == "out" then
				local temp = self.pageView
				self.pageView:runAction(cc.Sequence:create(
					cc.FadeOut:create(1),
					cc.CallFunc:create(function() 
							temp:setVisible(false)
						end)
					))
				self.pageView:hide()
				self.myPageViews[bigPart][smallPart]:setOpacity(0)
				-- print("*********************")
				self.myPageViews[bigPart][smallPart]:runAction(cc.FadeIn:create(1))
			else
				self.pageView:setVisible(false)
				self.pageView:hide()
				self.myPageViews[bigPart][smallPart]:setOpacity(255)
			end
		elseif self.smallPart ~= smallPart then

			self.pageView:setVisible(false)
			self.pageView:hide()
			self.myPageViews[bigPart][smallPart]:setOpacity(255)
		end
	end
	-- print("bigPart",bigPart)
	-- print("smallPart",smallPart)
	-- print("opacity", self.myPageViews[bigPart][smallPart]:getOpacity())
	self.myPageViews[bigPart][smallPart]:setVisible(true)
	self.myPageViews[bigPart][smallPart]:show()
	self.bigPart = bigPart
	self.smallPart = smallPart
	self.pageView = self.myPageViews[bigPart][smallPart]

	for k, v in ipairs(self.topButtons) do
		if v.bigPart == bigPart then
			v:setVisible(true)
		else
			v:setVisible(false)
		end
	end

end


return MainUI