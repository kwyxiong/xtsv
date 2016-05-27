--
-- Author: kwyxiong
-- Date: 2016-03-31 11:17:55
--
local LabelButton = require("app.widgets.LabelButton")
local LabelButtons = class("LabelButtons", function() 
		return display.newNode()
	end)

function LabelButtons:ctor(arg)
	self.dress = arg.dress
	-- dump(self.dress)
	self.buttons = {}
	self.selectedButton = nil
	self.leftButton = nil
	self.rightButton = nil
	self.curPage = 1
	self.numPerPage = 4
	self.pageNum = math.ceil(#self.dress/self.numPerPage)

	self:init()
end


function LabelButtons:init()

	for k, v in ipairs(self.dress) do
		local posIndex = k%4
		if posIndex == 0 then
			posIndex = 4
		end

		local labelButton = LabelButton.new({text = table.getFirstKey(v)})
			:pos(66 * (posIndex-1) + 10, 0)
			:addTo(self)
			:zorder(50-k)
		labelButton:onButtonClicked(function() 
					if self.selectedButton then
						self.selectedButton:setHighlighted(false)
					end
					self.selectedButton = labelButton
					labelButton:setHighlighted(true)

					local showLayers = v[table.getFirstKey(v)]
					broadCastMsg("showLayers", {layers = showLayers})
				end)
		self.buttons[#self.buttons + 1] = labelButton

		if k == 1 then
			self.selectedButton = labelButton
			labelButton:setHighlighted(true)
			local showLayers = v[table.getFirstKey(v)]
			broadCastMsg("showLayers", {layers = showLayers})
		end

	end

	self.leftButton = cc.ui.UIPushButton.new({normal = "btn_left0001.png", pressed = "btn_left0004.png"})
		:addTo(self)
		:pos(-40, 3)
		:zorder(99)
		:onButtonClicked(function() 
				self.curPage = self.curPage - 1
				self:update()
			end)

	self.rightButton = cc.ui.UIPushButton.new({normal = "btn_nextimg0001.png", pressed = "btn_nextimg0002.png"})
		:addTo(self)
		:zorder(99)
		:pos(260, 4)
		:onButtonClicked(function() 
			self.curPage = self.curPage + 1
			self:update()
		end)
	self:update()
end

function LabelButtons:update()
	local minIndex = (self.curPage - 1)*self.numPerPage + 1
	local maxIndex = (self.curPage - 1)*self.numPerPage + self.numPerPage
	for k = 1, #self.buttons do
		if k >= minIndex and k <= maxIndex then
			self.buttons[k]:setVisible(true)
		else
			-- print("k", k)
			self.buttons[k]:setVisible(false)
		end
	end

	if self.curPage < self.pageNum then
		self.rightButton:setVisible(true)
	else
		self.rightButton:setVisible(false)
	end
	if self.curPage > 1 then
		self.leftButton:setVisible(true)
	else
		self.leftButton:setVisible(false)
	end
end

return LabelButtons