--
-- Author: kwyxiong
-- Date: 2016-03-30 20:54:54
--

local HomeScene = class("HomeScene", function()
    return display.newScene("HomeScene")
end)

function HomeScene:ctor(arg)
	print("HomeScene:ctor(arg)")
	self.movePoses = {
	{cc.p(-290, -100),1.2},
	{cc.p(-290, -100),1.2},
	{cc.p(-290, 0),1.2},
	{cc.p(-200, 0),1},
	{cc.p(-290, 0),1.2},
	{cc.p(-200, 0),1},
	{cc.p(-290, -100),1.2}
	}



	dump(arg)
	self.arg = arg
	cc.GameObject.extend(self)
	self:addComponent("app.utils.UISceneProtocol"):exportMethods()


	self.node = display.newNode()
		:addTo(self)

	self:initBg()

	local shadow = display.newSprite("charaContainer0001.png")
		:pos(295 + 70 - 400 + display.cx, 31)
		:addTo(self.node)
	-- drug(shadow)
	self.bodyNode = display.newNode()
		:pos(88 + 70 - 400 + display.cx, -17)
		:addTo(self.node)
		-- drug(self.bodyNode)
	self.bodyNode:setCascadeOpacityEnabled(true)
	self.bodyNode:setOpacity(0)
	self.bodyNode:runAction(cc.Sequence:create(
			cc.DelayTime:create(0.2),
			cc.FadeIn:create(0.1)
		))

    self.WardrobeView = showView("WardrobeView",self.arg)
    self.handlers = {
	    regCallBack("scrollIn", handler(self, self.bgIn)),
	    regCallBack("scrollOut", handler(self, self.bgOut)),
	    regCallBack("change", handler(self, self.change)),
	    regCallBack("reset", handler(self, self.reset)),
	    regCallBack("taskSure", handler(self, self.taskSure)),
	    -- regCallBack("taskSure", handler(self, self.countScore)),
	    regCallBack("touchViewBox", handler(self, self.touchViewBox)),
	    regCallBack("switch", handler(self, self.switch)),
	    regCallBack("HomeSceneBroadCast_updateViewBox", function() 
	    		broadCastMsg("updateViewBox", {clothes = self.clothes})
	    	end),
	    regCallBack("getAllWearClothes", function() 
	    		broadCastMsg("showAllWearClothes", {clothes = self.clothes})
	    	end),	    
	}
	self.clothes = {}


	-- ["9000003","9000009","9000019","9000020","9000015","9000012"]

	-- self:wear(9000003)
	-- self:wear(9000017)
	-- self:wear(9000018)
	-- self:wear(226)
	-- self:wear(3)
	if self.arg and self.arg.id .. "" == Global_setting2.start_task then
		for k, v in ipairs(Global_setting2.special_default_dress) do
			self:wear(tonumber(v))
		end
	else
		for k, v in ipairs(Global_setting2.default_dress) do
			self:wear(tonumber(v))
		end
	end


	-- dump(self.clothes, "self.clothes")
    addBackEvent(self, function() 
    	if not self.arg then
      		app:enterScene("CityScene")
      	end
    end)  

end


function HomeScene:taskSure()
	local canOut = true
	-- dump(Global_setting_empty, "Global_setting_empty")
	-- dump(self.clothes, "self.clothes")
	for k, v in ipairs(Global_setting_empty) do
		if self.clothes[v] then
			canOut = false
		end
	end
	if canOut then
		showView("TipsView", {type = "taskSure",sureCallback = handler(self, self.countScore)}, true, true)
	else
		showView("TipsView", {type = "cantOut"}, true, true)
	end
end

function HomeScene:checkCard()

	local selfClothes_id = {}
	for k, v in pairs(self.clothes) do
		selfClothes_id[v.data.id] = true
	end
	
	for k, v in ipairs(Global_cards.cards) do
		local match = true
		for k1, v1 in ipairs(v.clothes) do
			if not selfClothes_id[v1] then
				match = false
			end
		end
		if match then
			print("卡片匹配 " .. v.name)
			if GameData[Global_saveData].cards[v.id] then
				
				return
			end
			self.cardId = v.id
			self.cardName = v.name
			
			self.touchLayer = display.newLayer()
				:addTo(self, 999999)

			self.touchLayer:runAction(cc.Sequence:create(
				cc.DelayTime:create(0.2),
				cc.CallFunc:create(function() 
						broadCastMsg("playCamera")
					end),
				cc.DelayTime:create(1.5),
				cc.CallFunc:create(function() 
						showView("CameraView", nil, true, true)
					end),
				cc.DelayTime:create(2),
				cc.CallFunc:create(function() 
						closeView("CameraView")
						self:playCamera()
					end)
				-- cc.CallFunc:create(handler(self, self.playCamera))
			))
			break
		end
	end
end

function HomeScene:playCamera()
	local CameraNode = require("app.widgets.CameraNode")
	for k, v in ipairs(self:getChildren()) do
		cascade(v)
		if v:getName() ~= "rightLayer" and v:getName() ~= "leftLayer" then
			v:runAction(cc.FadeOut:create(0.7))
		end
	end



	local cameraNode 
	local callback = function() 

		for k, v in ipairs(self:getChildren()) do
			if v ~= cameraNode then
				v:runAction(cc.FadeIn:create(0.7))
			end
		end	
		self.bodyNode:setOpacity(255)
		self.bodyNode:runAction(cc.Sequence:create(
			cc.DelayTime:create(0.7),
			cc.CallFunc:create(function() 
					if self.touchLayer then
						self.touchLayer:removeSelf()
						self.touchLayer = nil
					end
					showView("GetCardView",{cardId = self.cardId, cardName = self.cardName}, true, true)
				end)
			))
	end
	cameraNode = CameraNode.new({self.clothes, self.bodyNode:convertToWorldSpace(cc.p(0,0)), callback})
		:pos(display.cx, display.cy)
		:addTo(self, 9999)
	
	
	cameraNode:play()
				
		
end

function HomeScene:getTypeValue(typeValue)
	local tb = {}
	for k, v in pairs(typeValue) do
		local keys = string.split(k, ",")
		tb[keys[1]] = v.value
		tb[keys[2]] = 9 - v.value
	end
	-- dump(tb, "typeValue")
	return tb
end

function HomeScene:countScore()
	local needValue = self.arg.needValue
	local needColor = self.arg.needColor
	local needElement = self.arg.needElement
	local needStyle = self.arg.needStyle
	local needType = self.arg.needType
	local needWork = self.arg.needWork

	-- dump(needValue, "needValue")
	-- dump(needColor, "needColor")
	-- dump(needElement, "needElement")
	-- dump(needStyle, "needStyle")
	-- dump(needType, "needType")
	-- dump(needWork, "needWork")



	local clothNum = 0--服装件数

	local totalWeight = 0--总权值
	local allClothRQ = 0--所有服装的人气总和

	local totalValue = 0
	local totalColor = 0
	local totalElement = 0
	local totalStyle = 0
	local totalType = 0
	local totalWork = 0
	local fashionAdd = 1


	local fashionWords = {}
	for k, v in ipairs(Global_fashions.fashions) do
		fashionWords[v.keyword] = true
	end

	local function clean(tb)
		if #tb > 0 then
			for k = #tb, 1, -1 do
				if tb[k].value == "" or tb[k].name == "" then
					table.remove(tb, k)
				end
			end
		end

	end
	clean(needValue)
	clean(needColor)
	clean(needElement)
	clean(needStyle)
	clean(needType)
	clean(needWork)
	if #needValue > 0 then
		for k1, v1 in ipairs(needValue) do
			totalWeight = totalWeight + tonumber(v1.value)

		end
	end	

	if #needColor > 0 then
		for k1, v1 in ipairs(needColor) do
			totalWeight = totalWeight + tonumber(v1.value)
			if fashionWords[v1.name] then
				print("流行服饰")
				fashionAdd = Global_setting2.fashion_add
			end			
		end
	end	

	if #needElement > 0 then
		for k1, v1 in ipairs(needElement) do
			totalWeight = totalWeight + tonumber(v1.value)
			if fashionWords[v1.name] then
				print("流行服饰")
				fashionAdd = Global_setting2.fashion_add
			end		
		end
	end	

	if #needStyle > 0 then
		for k1, v1 in ipairs(needStyle) do
			totalWeight = totalWeight + tonumber(v1.value)
			if fashionWords[v1.name] then
				print("流行服饰")
				fashionAdd = Global_setting2.fashion_add
			end	
		end
	end	

	if #needType > 0 then
		for k1, v1 in ipairs(needType) do
			totalWeight = totalWeight + tonumber(v1.value)
			if fashionWords[v1.name] then
				print("流行服饰")
				fashionAdd = Global_setting2.fashion_add
			end				
		end
	end	

	if #needWork > 0 then
		for k1, v1 in ipairs(needWork) do
			totalWeight = totalWeight + tonumber(v1.value)
			if fashionWords[v1.name] then
				print("流行服饰")
				fashionAdd = Global_setting2.fashion_add
			end	
		end
	end	

	-- dump(self.clothes, "self.clothes")
	for k, v in pairs(self.clothes) do
		-- dump(v.data.type_style, "v.data.type_style")
		if Global_setting_layer[k].gradeValue > 0 then

			clothNum = clothNum + 1
			
			local rq = v.data.rq
			allClothRQ = allClothRQ + rq
			-- print(v.data.name ..  "的人气值 " .. rq)

			if #needValue > 0 then
				-- dump(v.data.type_value, "v.data.type_value")
				local typeValue = self:getTypeValue(v.data.type_value)
				-- dump(typeValue, "typeValue")
				for k1, v1 in ipairs(needValue) do
					-- print("v1.name", v1.name)
					if typeValue[v1.name] and typeValue[v1.name] >= 5 then
						if fashionWords[v1.name] and typeValue[v1.name]>=6 then
							print("流行服饰")
							fashionAdd = Global_setting2.fashion_add
						end


						totalValue = totalValue + rq * typeValue[v1.name] / 6 * tonumber(v1.value)
						-- print("要求 ".. v1.name .. " " .. v.data.name.. " " .. rq * typeValue[v1.name] / 6 * tonumber(v1.value))
					end
					
				end
			end

			if #needColor > 0 then
				local typeColor = v.data.type_color
				typeColor = table.list2Map(typeColor)
				for k1, v1 in ipairs(needColor) do
			
					if typeColor[v1.name] then
						totalColor = totalColor + rq * tonumber(v1.value)
						-- print("要求 ".. v1.name .. " " .. v.data.name .." " .. rq * tonumber(v1.value))
					end
					
				end
			end

			if #needElement > 0 then
				local typeElement = v.data.type_element
				typeElement = table.list2Map(typeElement)
				for k1, v1 in ipairs(needElement) do
					if typeElement[v1.name] then
						totalElement = totalElement + rq * tonumber(v1.value)
						-- print("要求 ".. v1.name .. " " .. v.data.name.. " " .. rq * tonumber(v1.value))
					end
					
				end
			end

			if #needStyle > 0 then
				local typeStyle = v.data.type_style
				typeStyle = table.list2Map(typeStyle)
				for k1, v1 in ipairs(needStyle) do
					if typeStyle[v1.name] then
						totalStyle = totalStyle + rq * tonumber(v1.value)

						-- print("要求 ".. v1.name .. " " .. v.data.name .." " .. rq * tonumber(v1.value))
					end
				
				end
			end

			if #needType > 0 then
				local _type = v.data.type
				for k1, v1 in ipairs(needType) do
					if _type == v1.name then
						totalType = totalType + rq * tonumber(v1.value)
						-- print("要求 ".. v1.name .. " " .. v.data.name.. " " .. rq * tonumber(v1.value))
					end
					
				end
			end		

			if #needWork > 0 then
				local typeWork = v.data.type_work
				-- dump(v.data)
				typeWork = table.list2Map(typeWork)
				for k1, v1 in ipairs(needWork) do
					if typeWork[v1.name] then
						totalWork = totalWork + rq * tonumber(v1.value)
						-- print("要求 ".. v1.name .. " " .. v.data.name .." " .. rq * tonumber(v1.value))
					end
					
				end
			end
		end
	end
	-- print("totalValue", totalValue)
	-- print("totalColor", totalColor)
	-- print("totalElement", totalElement)
	-- print("totalStyle", totalStyle)
	-- print("totalType", totalType)
	-- print("totalWork", totalWork)
	-- print("allClothRQ", allClothRQ)
	-- print("totalWeight", totalWeight)
	-- print("clothNum", clothNum)

	local max_clothes_count = Global_setting2.max_clothes_count
	local leftWeight = (1 - totalWeight)
	if leftWeight < 0 then
		leftWeight = 0
	end
	local score = totalValue + totalColor + totalElement + totalStyle + totalType + totalWork + allClothRQ * leftWeight
	if clothNum > max_clothes_count then
		score = score * max_clothes_count / clothNum
	end
	if score < 0 then
		score = 0
	end
	score = score * fashionAdd
	-- score = score * 1.2
	score = math.floor(score)
	-- print("score", score)

	local ggfs = self.arg.ggfs
	local grade = "F"
	local i = (score - ggfs) / ggfs
	if i >= 0.3 then
		grade = "S"
	elseif i>=0.2 and i <= 0.3 then
		grade = "A"
	elseif i>=0.1 and i <= 0.2 then
		grade = "B"
	elseif i>=0 and i <= 0.1 then
		grade = "C"
	elseif i>=-0.1 and i <= 0 then
		grade = "D"
	elseif i>=-0.2 and i <= -0.1 then
		grade = "E"
	elseif i <= -0.2 then
		grade = "F"
	end
	-- dump( self.arg, " self.arg")
	app:enterScene("ResultScene", {score, grade, self.arg, self.clothes})
end




function HomeScene:reset()
	for k, v in pairs(self.clothes) do
		for k1, v1 in ipairs(v.sps) do
			v1:removeSelf()
		end
	end
	self.clothes = {}
	self:emptyProtect()
	self.bodyNode:setOpacity(0)
	self.bodyNode:runAction(
			cc.FadeIn:create(0.1))

end

function HomeScene:wear(id)
	id = tonumber(id)
	-- dump(Global_clothes, "Global_clothes")
	-- print("id", id)
	local data = Global_clothes[id]
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
	-- print("wear id = " .. id )
	self.clothes[layer] = {data = data, sps = sps, switch = false}
	broadCastMsg("updateViewBox", {clothes = self.clothes})
	self:checkCard()
end

function HomeScene:bgIn()
	
	self.node:runAction(
		cc.EaseSineInOut:create(
		cc.MoveTo:create(0.5, cc.p(0, 0))
		)
		)
	self.bg1:runAction(
		cc.EaseSineInOut:create(
		cc.FadeIn:create(0.5)
		)
		)
	-- self:playPartEffect()
	self.node:runAction(
		cc.EaseSineInOut:create(
		cc.ScaleTo:create(0.5, 1)
		)
		)
end

function HomeScene:bgOut(evt)
	local index = evt.data.index
	local dis = 200
	self.node:runAction(
		cc.EaseSineInOut:create(
		cc.MoveTo:create(0.5, self.movePoses[index][1])
		)
		)
	self.bg1:runAction(
		cc.EaseSineInOut:create(
		cc.FadeOut:create(0.5)
		)
		)
	self.node:runAction(
		cc.EaseSineInOut:create(
		cc.ScaleTo:create(0.5, self.movePoses[index][2])
		)
		)
	-- self:playPartEffect()
end

function HomeScene:change(evt)
	local index = evt.data.index
	self.node:stopAllActions()
	self.bg1:stopAllActions()

	self.node:runAction(
		cc.EaseSineInOut:create(
		cc.MoveTo:create(0.5, self.movePoses[index][1])
		)
		)
	self.bg1:runAction(
		cc.EaseSineInOut:create(
		cc.FadeOut:create(0.5)
		)
		)
	self.node:runAction(
		cc.EaseSineInOut:create(
		cc.ScaleTo:create(0.5, self.movePoses[index][2])
		)
		)
	-- self:playPartEffect()
end


function HomeScene:switch(evt)
	local data = evt.data.data
	local switch = evt.data.switch
	-- broadCastMsg("playPartEffect", {data = data})

	-- local func
		
	local layer = data.parts[1].layer
	if self.clothes[layer] and self.clothes[layer].data.id == data.id then
		self.clothes[layer].switch = switch

		local spIndex  =1
		for k, v in ipairs(self.clothes[layer].data.parts) do
			if v.img ~= "" then
				local sp = self.clothes[layer].sps[spIndex]
				local layer = v.layer

				if switch then
					if Global_setting_layer[layer].switch then
						sp:zorder(tonumber(Global_setting_layer[layer].switch) * 10)
					end
				else
					sp:zorder(tonumber(v.layer) * 10)
				end

				-- print("hhhhhhhhhhhhhhhh")
				spIndex = spIndex + 1
			end
		end
	end


	-- dump(self.clothes, "self.clothes")
end

function HomeScene:touchViewBox(evt)
	local data = evt.data.data

	-- broadCastMsg("playPartEffect", {data = data})

	-- local func
		
	local layer = data.parts[1].layer

	if self.clothes[layer] then
		if self.clothes[layer].data.id == data.id then
			-- func = function()

				

				for k, v in ipairs(self.clothes[layer].sps) do
					v:removeSelf()
				end
				self.clothes[layer] = nil
				broadCastMsg("updateViewBox", {clothes = self.clothes})
				self:emptyProtect()
	        -- end
		else
			-- self:runAction(cc.Sequence:create(
	  --     		cc.DelayTime:create(0.016),
	  --     		cc.CallFunc:create(function() 
			       for k, v in ipairs(self.clothes[layer].sps) do
			          v:removeSelf()
			        end
			        self.clothes[layer] = nil
			       
	      		-- end)

	      		-- ))

	        -- func = function()
	          self:wear(data.id)
	        -- end
	        self:playPartEffect(data)
	    end
	else
		--判断冲突
		local ct = Global_setting_layer[layer].ct
		ct = string.split(ct, ",")
		for k, v in ipairs(ct) do
			if self.clothes[v .. ""] then
		      	-- self:runAction(cc.Sequence:create(
		      	-- 	cc.DelayTime:create(0.016),
		      	-- 	cc.CallFunc:create(function() 
					    for k, v in ipairs(self.clothes[v .. ""].sps) do
				        	v:removeSelf()
				        end
				        self.clothes[v .. ""] = nil
				        
		      		-- end)

		      		-- ))				
			end
		end
		--判断冲突后	
		-- func = function()
        	self:wear(data.id)
        	self:emptyProtect()
        -- end
        self:playPartEffect(data)
	end


end

function HomeScene:emptyProtect()
	-- dump(self.clothes, "self.clothes")
	for k, v in ipairs(Global_setting2["empty_dress"]) do
		local clothData = Global_clothes[tonumber(v)]
		local layer = clothData.parts[1].layer

		local hasCt = false
		local ct = Global_setting_layer[layer].ct
		ct = string.split(ct, ",")
		-- dump(ct, "ct")
		for k2, v2 in ipairs(ct) do
			if self.clothes[v2 .. ""] or self.clothes[layer] then
				hasCt = true
				break
			end 
		end

		if not hasCt then
			-- print("emptyProtect " .. v)
			self:wear(v)
		end

	end
end

-- function HomeScene:emptyProtect()

-- 	local cts = {}
-- 	for k1, v1 in pairs(self.clothes) do
-- 		local ct = Global_setting_layer[k1].ct
-- 		ct = string.split(ct, ",")
-- 		for k2, v2 in ipairs(ct) do
-- 			cts[v2 .. ""] = true
-- 		end
-- 	end	
-- 	dump(cts, "cts")
-- 	for k, v in ipairs(Global_setting2["empty_dress"]) do
-- 		local clothData = Global_clothes[tonumber(v)]
-- 		local layer = clothData.parts[1].layer
-- 		print("layer", layer)
-- 		if not cts[layer .. ""] then
-- 			print("emptyProtect " .. v)
-- 			self:wear(v)
-- 		end

-- 	end
-- end

function HomeScene:playPartEffect(data)
	local flashShow = Global_setting_layer[data.parts[1].layer].flashShow
	-- print("flashShow", flashShow)
	if flashShow == 0 then
		return
	end
	-- dump(data)
	-- local zOrders = json.decode(data["zOrders"])
	local actionNode = display.newNode()
		:addTo(self)
	local time = 0
	local sps = {}
	local sp1s = {}
	local radius = 1.0
	local light = 0.9

	local particlePos 

	-- actionNode:runAction(cc.Sequence:create(
	-- 	cc.DelayTime:create(0.016),
	-- 	cc.CallFunc:create()	)

	for k, v in ipairs(data.parts) do
		if v.img ~= "" then


	       local sprite1 = display.newSprite(v.img)
				:pos(v.fix.x, 600 - v.fix.y)
				:zorder(tonumber(v.layer) * 10)
				:addTo(self.bodyNode)
			sprite1:setAnchorPoint(cc.p(0, 1))
	        blurSprite(sprite1,radius)
	        sp1s[#sp1s + 1] = sprite1

			local sprite = display.newSprite(v.img)
				:pos(v.fix.x, 600 - v.fix.y)
				:zorder(tonumber(v.layer) * 10)
				:addTo(self.bodyNode)
			sprite:setAnchorPoint(cc.p(0, 1))
	        whiteSprite(sprite, light)
	        sps[#sps + 1] = sprite

	        if not particlePos then
	        	particlePos = cc.p(v.fix.x + sprite:getContentSize().width / 2, 600 - v.fix.y - sprite:getContentSize().height / 2)
	        end
	    end
	end
	actionNode:runAction(cc.RepeatForever:create(cc.Sequence:create(
	        cc.DelayTime:create(0.05),
	        cc.CallFunc:create(function() 
	        	time = time + 0.05
	        	if time < 0.3 then
	        		if radius < 30.0 then
			        	for k, v in ipairs(sp1s) do			     	
					        v:getGLProgramState():setUniformFloat("blurRadius", radius)				            				      
					    end
					end
	        		if light < 1.0 then
			        	for k, v in ipairs(sps) do			     	
					        v:getGLProgramState():setUniformFloat("light", light)				            				      
					    end
					end
					light = light + 0.013  
			    	radius = radius + 2.0  
			    else
		        	for k, v in ipairs(sp1s) do			     	
				        v:removeSelf()			            
				    end	
				    for k, v in ipairs(sps) do			     	
				        v:removeSelf()			            
				    end	
				    actionNode:removeSelf()	 
				    if flashShow == 2 then
						self:playParticle(particlePos)
					end
			    end
	        end)
	      )))
	-- self:playParticle()
end

function HomeScene:playParticle(particlePos)
	-- local sp = display.newSprite("image108.png")
	-- 	:pos(333,333)
	-- 	:addTo(self,9999)
	-- sp:setBlendFunc(gl.ONE_MINUS_DST_COLOR, gl.ONE)
	-- local sp = display.newSprite("image108.png")
	-- 	:pos(222,333)
	-- 	:addTo(self,9999)
	-- sp:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)	

	-- local sp = display.newSprite("image108.png")
	-- 	:pos(111,333)
	-- 	:addTo(self,9999)
	-- sp:setBlendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA)	


	local emitter1 = cc.ParticleSystemQuad:create("flower.plist")
		:pos(particlePos.x, particlePos.y)
		:addTo(self.bodyNode, 999)
	emitter1:setAutoRemoveOnFinish(true)
	-- GL_ONE , GL_ZERO
	-- sp:runAction(cc.FadeOut:create(1))
	-- sp:runAction(cc.ScaleTo:create())

	-- local emitter = cc.ParticleFlower:create()
	-- emitter:pos(333, 333)
	-- -- emitter:retain()
 --    self:addChild(emitter, 9999)
 --    emitter:setTexture(cc.Director:getInstance():getTextureCache():addImage("ball.png"))
end

function HomeScene:initBg()
	-- local bg = display.newSprite("bg1.jpg")
	-- local bg = cc.Sprite:create("bg1.jpg")
 --    bg:pos(display.cx, display.cy)
	-- 	:addTo(self)
	-- bg:setAnchorPoint(cc.p(0, 0))
	-- local path = cc.FileUtils:getInstance():fullPathForFilename("farm.jpg")
	-- print("papath",path)

	self.bg2 = display.newSprite("woshimohu.jpg")
	-- :zorder(gz("bg"))
	:pos(display.cx + 100, display.cy)
	:addTo(self.node)

	self.bg2:setScale(1270 / 1000)

	self.bg1 = display.newSprite("woshi.jpg")
		-- :zorder(gz("bg"))
    	:pos(display.cx + 100, display.cy)
		:addTo(self.node)

	self.bg1:setScale(1270 / 1000)
end

function HomeScene:onEnter()
	print("HomeScene:onEnter()")
	if Global_curMusic ~= "bgm_room.mp3" then
    	audio.playMusic("bgm_room.mp3", true)
    	Global_curMusic = "bgm_room.mp3"
    end

	GuideManager:checkGuide("HomeScene")

end

function HomeScene:onExit()
	for k, v in ipairs(self.handlers) do
		unRegCallBack({msgId = v})
	end
end



return HomeScene
