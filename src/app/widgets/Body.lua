--
-- Author: Your Name
-- Date: 2016-01-16 15:33:51
--
local Body = class("Body", function() 
		return display.newNode()
	end)

function Body:ctor()

	-- self:init()
	-- self:setScale(self.BodyScale)

	-- self.handlers = {
	-- 	regCallBack("setFuse", handler(self, self.setFuse)),
	-- }
	-- self:setNodeEventEnabled(true)


	--self.clothes = { 上衣1 = { data = {}, sps = {} }}
end

function Body:onExit()
	-- for k, v in ipairs(self.handlers) do
	-- 	unRegCallBack({msgId = v})
	-- end
	
end

function Body:touchViewBox(evt)
	local data = evt.data.data

	broadCastMsg("playPartEffect", {data = data})

	if self.clothes[data.bodyPart] then 
		for k, v in ipairs(self.clothes[data.bodyPart].sps) do
			v:removeSelf()
		end
		if self.clothes[data.bodyPart].data.id == data.id then
			self.clothes[data.bodyPart] = nil
		else
			local reses = json.decode(data["reses"])
			local zOrders = json.decode(data["zOrders"])
			local sps = {}
			for k, v in ipairs(reses) do
				local sp = display.newSprite("#" .. v ..".png")
			 	    :zorder(gz(zOrders[k]))
				    :addTo(self)
				sps[#sps + 1] = sp
			end
			self.clothes[data.bodyPart] = {data = data, sps = sps}
		end
	else
		if self.nocoexist[data.bodyPart] then
			for k, v in pairs(self.nocoexist[data.bodyPart]) do
				if self.clothes[v] then
					for k1, v1 in ipairs(self.clothes[v].sps) do
						v1:removeSelf()
					end
					self.clothes[v] = nil
				end
			end
		end
		local reses = json.decode(data["reses"])
		local zOrders = json.decode(data["zOrders"])
		local sps = {}
		for k, v in ipairs(reses) do
			local sp = display.newSprite("#" .. v ..".png")
		 	    :zorder(gz(zOrders[k]))
			    :addTo(self)
			sps[#sps + 1] = sp
		end
		self.clothes[data.bodyPart] = {data = data, sps = sps}
	end
	
end



function Body:init()
	self.shenti = display.newSprite("shenti.png")
		:zorder(gz("shenti"))
		:addTo(self)
	-- shenti:setColor(cc.c3b(222,199,199))

	local neiyi = display.newSprite("neiyi_qingmu1.png")
		:zorder(gz("neiyi"))
		:addTo(self)


	
end

-- function Body:playPartEffect(evt)
-- 	local data = evt.data.data

-- 	local reses = json.decode(data["reses"])
-- 	local zOrders = json.decode(data["zOrders"])

-- 	local actionNode = display.newNode()
-- 		:addTo(self)
-- 	local sps = {}
-- 	local sp1s = {}
-- 	local radius = 1.0
-- 	local light = 1.0
-- 	for k, v in ipairs(reses) do
	    
-- 	    local sp = display.newSprite("#" .. v ..".png")
-- 	      :zorder(gz(zOrders[k]))
-- 	      :addTo(self)
-- 	    whiteSprite(sp, light)
-- 	   sps[#sps + 1] = sp
  
-- 	    local sp1 = display.newSprite("#" .. v ..".png")
-- 	      :zorder(gz(zOrders[k]))
-- 	      :addTo(self)
	   
--        blurSprite(sp1,radius)
--          sp1s[#sp1s + 1] = sp1



-- 	end



-- 	actionNode:runAction(cc.RepeatForever:create(cc.Sequence:create(
-- 	        cc.DelayTime:create(0.016),
-- 	        cc.CallFunc:create(function() 
-- 	        	if radius < 150.0 then
-- 	        		if radius < 100.0 then
-- 			        	for k, v in ipairs(sp1s) do			     	
-- 					        v:getGLProgramState():setUniformFloat("blurRadius", radius)				            				      
-- 					    end
-- 					end
-- 			    	radius = radius + 10.0  
-- 			    else
-- 		        	for k, v in ipairs(sp1s) do			     	
-- 				        v:removeSelf()			            
-- 				    end	
-- 				    for k, v in ipairs(sps) do			     	
-- 				        v:removeSelf()			            
-- 				    end	
-- 				    actionNode:removeSelf()	    	
-- 			    end
-- 	        end)
-- 	      )))
-- end


return Body