--
-- Author: kwyxiong
-- Date: 2016-03-31 12:21:21
--
local ViewBox = class("ViewBox", function() 
		return display.newNode()
	end)

function ViewBox:ctor(arg)
	self.data = arg.data
	self.wearState = false
	self.switch = false
	self.clothes = {}
	self:init()
end

function ViewBox:getData()
	return self.data
end

function ViewBox:init()
	-- local bg = display.newSprite("image344.png")
	-- 	:addTo(self)
	local bgButton = cc.ui.UIPushButton.new({normal = "image344.png"})
		:addTo(self)
		:onButtonPressed(function() 
				self.mask:setVisible(true)
			end)
		:onButtonRelease(function() 
				self.mask:setVisible(false)
			end)
		:onButtonClicked(function() 
				-- if Global_touchEventEnable  then
					-- Global_touchEventEnable = false
					broadCastMsg("touchViewBox", {data = self.data})
				-- end
			end)
	self.bgButton = bgButton
	self.mask = display.newSprite("buton1.png")
		:addTo(self,99)
	self.mask:setVisible(false)
	local clippingNode = cc.ClippingRegionNode:create()
		:addTo(self)
	clippingNode:setClippingRegion(cc.rect(-56, -72, 112, 139))
	self.bodyNode = display.newNode()
		:addTo(clippingNode)
	-- clippingNode:setClippingEnabled(false)
	-- drug(self.bodyNode)
	-- local sp = display.newSprite("gaojijiudianyijiao.jpg")
	-- 	:addTo(clippingNode)
	self:wear(Global_clothes[9000016])
	
	self:wear(self.data)
	self:setPosScale()
	self:initStar()
	self:initName()
end

function ViewBox:wear(data)
	-- dump(Global_clothes, "Global_clothes")
	-- print("id", id)
	-- dump(data, "data")
	local sps = {}
	local layer = "0"	
	for k, v in ipairs(data.parts) do
		if v.img ~= "" then
			if k == 1 then
				layer = v.layer
			end
			local sp = display.newSprite(v.img)
				:pos(v.fix.x, 600 - v.fix.y)
				:zorder(tonumber(v.layer) * 10)
				:addTo(self.bodyNode)
			sp:setAnchorPoint(cc.p(0, 1))
			sps[#sps + 1] = sp
			-- print("hhhhhhhhhhhhhhhh")
		end
	end
	self.layer = layer
	
	-- print(data.name)
end

function ViewBox:setPosScale()
	-- print(self.layer)
	local area = Global_setting_layer[self.layer].area
	-- dump(area, "area")
	local posScale = Global_posScales[area] or {-147, -323, 0.7}
	self.bodyNode:setPosition(posScale[1], posScale[2])

	self.bodyNode:setScale(posScale[3])
end

function ViewBox:initStar()
	local star = getRQStar(self.data.rq)
	if star < 10 then
		star = "0" .. star
	end
	local starSp = display.newSprite("rqstar00" .. star .. ".png")
		:pos(0, -60)
		:addTo(self, 2)



end

function ViewBox:setWearState(wearState, switchState)
	if self.wearState ~= wearState then
		self.wearState = wearState
		if self.wearState then
			if not self.wearStateImg then
				self.wearStateImg = display.newSprite("image621.png")
				:addTo(self, 1)
			end
			self.wearStateImg:setVisible(true)
			dump(self.layer, "self.layer")
			if Global_setting_layer[self.layer].switch then

				if not self.checkBox then
					self:initCheckBox()
				end
				self.checkBox:setVisible(true)

				print("switchState", switchState)
				self.checkBox:setButtonSelected(switchState)
	
			else
				if self.checkBox then
					self.checkBox:setVisible(false)
				end
			end
		else
			if self.wearStateImg then
				self.wearStateImg:setVisible(false)
			end
			if self.checkBox then
				self.checkBox:setVisible(false)
			end
		end

	end
end


function ViewBox:initCheckBox()
	
	local images = {on = "btn_switch1.png", off = "btn_switch.png"}
    self.checkBox = cc.ui.UICheckBoxButton.new(images)
        -- :setButtonLabel(cc.ui.UILabel.new({text = labels[true], size = 24}))
        -- :setButtonLabelOffset(40, 0)
       
        :onButtonStateChanged(function(event)
        	-- dump(event)
        	-- print("??????????????????????????????????????")
        	if event.state == "on" then
        		broadCastMsg("switch", {data = self.data, switch = true})
       		else
       			broadCastMsg("switch", {data = self.data, switch = false})
        	end
            -- local button = event.target
            -- button:setButtonLabelString(labels[button:isButtonSelected()])
        end)
        :onButtonClicked(function(event)
            -- local button = event.target
            -- self.isTouchCaptureEnabled_ = button:isButtonSelected()
        end)
        :pos(0, - 40)
        :addTo(self, 1)

	
end

function ViewBox:initName()
	local name = cc.ui.UILabel.new({text = self.data.name, size = 14})
		:setTextColor(Global_label_color4)
		name:pos(0, -90)
		:addTo(self, 1)
	name:setAnchorPoint(cc.p(0.5, 0.5))
	name:enableOutline(cc.c3b(255,255,255), 2)
end


return ViewBox