--
-- Author: kwyxiong
-- Date: 2016-04-02 00:08:08
--

local ShopViewBox = class("ShopViewBox", function() 
		return display.newNode()
	end)

function ShopViewBox:ctor(arg)
	self.data = arg.data
	self.clothes = {}
	self:init()
end

function ShopViewBox:getData()
	return self.data
end

function ShopViewBox:init()
	local bg = display.newSprite("image344.png")
		:addTo(self)



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

	local sp = display.newFilteredSprite("image475.png", "GRAY")
		:pos(0, -71)
     	:addTo(self)

	local buyButton = cc.ui.UIPushButton.new({normal = "image475.png"})
		:pos(0, -71)
		:addTo(self)
	-- drug(buyButton)
	addButtonPressedState(buyButton)
		:onButtonClicked(function() 
				-- if Global_touchEventEnable  then
					-- Global_touchEventEnable = false
					-- broadCastMsg("touchShopViewBox", {data = self.data})
				-- end
				local sureCallback = function() 
					if GameData[Global_saveData].jb < self.data.money then
						return
					end
					audio.playSound("cash.mp3")
					GameData[Global_saveData].jb = GameData[Global_saveData].jb - self.data.money

					GameData[Global_saveData].clothes[self.data.id .. ""] = os.time()
					broadCastMsg("buyUpdate")
				end
				showView("TipsView", {type = "shop", money = self.data.money, name = self.data.name , sureCallback = sureCallback}, true, true)
			end)

	if GameData[Global_saveData].jb < self.data.money then
		buyButton:setVisible(false)
	end

	local name = cc.ui.UILabel.new({text = self.data.money, size = 15})
		:setTextColor(Global_label_color4)
		name:pos(-10, -71)
		:addTo(self)
	name:setAnchorPoint(cc.p(0.5, 0.5))
	name:enableOutline(cc.c4b(255,255,255,255), 1)	

end

function ShopViewBox:wear(data)
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

function ShopViewBox:setPosScale()
	-- print(self.layer)
	local area = Global_setting_layer[self.layer].area
	-- dump(area, "area")
	local posScale = Global_posScales[area] or {-147, -323, 0.7}
	self.bodyNode:setPosition(posScale[1], posScale[2])

	self.bodyNode:setScale(posScale[3])
end

function ShopViewBox:initStar()
	local star = getRQStar(self.data.rq)
	if star < 10 then
		star = "0" .. star
	end
	local starSp = display.newSprite("rqstar00" .. star .. ".png")
		:pos(0, -43)
		:addTo(self, 2)



end



function ShopViewBox:initName()
	local name = cc.ui.UILabel.new({text = self.data.name, size = 14})
		:setTextColor(Global_label_color4)
		name:pos(0, -23)
		:addTo(self, 1)
	name:setAnchorPoint(cc.p(0.5, 0.5))
	name:enableOutline(cc.c4b(255,255,255,255), 2)
end


return ShopViewBox