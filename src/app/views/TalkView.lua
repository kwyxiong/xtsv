--
-- Author: kwyxiong
-- Date: 2016-03-22 14:19:42
--

local TalkView = class("TalkView", function() 
		return cc.uiloader:load("TalkView.json")
	end)

function TalkView:ctor(arg)
	self.text = arg.text
	self.charaName = arg.charaName
	self.nameSide = arg.nameSide


	self.overCallback = arg.overCallback
	
	self:setOpacity(0)

	self.touchLayer = display.newLayer()
		:pos(-getCenterOffSetX(), 0)
		:addTo(self)


    self.touchLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    	if event.name=='began' then
    		return true
    	elseif event.name=='ended' then
    		self:play()
			self.touchLayer:setTouchEnabled(false)
    	end
    end)

	self:hideClick()

	self.exps = {}
	self.expsNum = 0
	self.expIndex = 0

	self.speed = 0.02
	self.playIndex = 1

	

	self.entry = nil
	self.curPlayStr = ""
	self.curPlayStrLen = 0


	self.defaultColor = cc.c3b(102, 45, 19)
	self.textColor = self.defaultColor

	self.defaultSize = 22
	self.textSize = self.defaultSize

	self:initRichText()

	self:setCascadeOpacityEnabled(true)

	
	self:parseText(self.text, self.charaName, self.nameSide)

	self.maxPlayIndex = string.utf8len(self.text) 

	
	

	self:addNodeEventListener(cc.NODE_EVENT, function(event)
        if event.name == "enter" then
            self:onEnter()
        elseif event.name == "exit" then
            self:onExit()
        end
    end)
	-- self:textPlay()

end

function TalkView:initRichText()
	if self._richText then
		self._richText:removeSelf()
	end
    self._richText = ccui.RichText:create()
    self._richText:ignoreContentAdaptWithSize(false)
    self._richText:setContentSize(cc.size(640, 100))
    self._richText:setAnchorPoint(cc.p(0, 1))
   	-- self._richText:setCascadeOpacityEnabled(true)

    
  
    self._richText:setPosition(cc.p(75 ,140))
    self:addChild(self._richText, 1)	


    
end

function TalkView:parseText(text, name, side)

	self.textColor = self.defaultColor
	
	name = textSubVal(name)
	self.charaName = name
	self.nameSide = side
	self.subChildren.LabelName:setString(name)
	self.subChildren.LabelName:enableOutline(cc.c4b(102, 45, 19, 255), 2)
	if side == "left" then
		self.subChildren.Image_2:setPositionX(179)
		self.subChildren.LabelName:setPositionX(179)
		self.subChildren.Image_2:setScaleY(1)
	elseif side == "right" then
		self.subChildren.Image_2:setPositionX(629)
		self.subChildren.LabelName:setPositionX(629)
		self.subChildren.Image_2:setScaleY(-1)
	end

	text = textSubVal(text)
	text = string.gsub(text, "]", "[")
	text = string.gsub(text, "%[%[", "[")
	text = string.split(text, "[")
	
	if text[1] == "" then
		table.remove(text, 1)
	end
	if text[#text] == "" then
		table.remove(text, #text)
	end
	-- dump(text)

	self.exps = text
	self.expsNum = #self.exps
	self.expIndex = 0
	self:play()
end

function TalkView:setOverCallback(overCallback)
	self.overCallback = overCallback
end

function TalkView:play()
	self.expIndex = self.expIndex + 1
	-- print(self.expIndex)

	if self.expIndex > self.expsNum then--结束
		if self.overCallback then
			self.overCallback()
		end
	else
		self:exp(self.exps[self.expIndex])
	end
end

function TalkView:exp(str)
	str = string.split(str, "=")
	local key = str[1]
	local value = str[2]
	if key == "color" then--改变颜色
		-- dump(value, "value")
		self.textColor =  GetTextColor(value)
		-- dump(self.textColor)
		self:play()
	elseif key == "size" then--改变大小
		self.textSize = value
		self:play()
	elseif key == "sizeEnd" then
		self.textSize = self.defaultSize
		self:play()	
	elseif key == "colorEnd" then
		self.textColor = self.defaultColor
		self:play()
	elseif key == "alignEnd" then

	elseif key == "align" then--改变对齐方式

	elseif key == "wait" then--等待
		self:runAction(cc.Sequence:create(
				cc.DelayTime:create(value / 1000),
				cc.CallFunc:create(function() 
						self:play()
					end)
			))
	elseif key == "l" then--点击
		self:showClick()
	elseif key == "cm" then--清空当前内容
		self:initRichText()
		self:play()
		-- local c = self._richText:getProtectedChildByTag(1)
		-- c:setCascadeOpacityEnabled(true)
		-- c:setOpacity(40)
		-- self._richText:setCascadeOpacityEnabled(true)
		-- self._richText:updateDisplayedOpacity(0)
	elseif key == "r" then--换行
		self:runAction(cc.Sequence:create(
				cc.CallFunc:create(function() 
						local re1 = ccui.RichElementNewLine:create(1, self.textColor, 255)
						self._richText:pushBackElement(re1)
					end),
				cc.DelayTime:create(self.speed),
				cc.CallFunc:create(function() 
						
							self:play()
						
					end)
			))
	elseif key == "show" then--出现
		self:runAction(cc.Sequence:create(
				cc.FadeIn:create(0.2),
				cc.CallFunc:create(function() 
						self:play()
					end)	
			))	
	elseif key == "hide" then--消失
		self:runAction(cc.Sequence:create(
				cc.FadeOut:create(0.2),
				cc.CallFunc:create(function() 
						self:hideClick()
						self:play()
					end)
			))
	else--文本输出
		self:playString(key)

	end
end

function TalkView:showClick()
	self.subChildren.Image_3:setVisible(true)
	self.touchLayer:setTouchEnabled(true)
end

function TalkView:hideClick()
	self.subChildren.Image_3:setVisible(false)
	self.touchLayer:setTouchEnabled(false)
end

function TalkView:playString(str)
	self.curPlayStr = str
	self.curPlayStrLen = string.utf8len(str)
	self.playIndex = 1
	self:playChar()
end

function TalkView:playChar()
	-- local t1 = cc.net.SocketTCP.getTime()
	local char = string.utf8sub(self.curPlayStr, 1, self.playIndex )
	-- print(char)
	-- local t2
	-- local t3
	self:runAction(cc.Sequence:create(
			cc.CallFunc:create(function() 
					if self.curElement then
						self._richText:removeElement(self.curElement)
					end

					local re1 = ccui.RichElementText:create(1 , self.textColor, 255, char, "Arial", self.textSize, true, cc.c4b(255,255,255,255), 3)
					self._richText:pushBackElement(re1)

					self.curElement = re1
					-- t2 = cc.net.SocketTCP.getTime()
					-- print(t2-t1)

				end),
			cc.DelayTime:create(self.speed),
			cc.CallFunc:create(function() 
					-- t3 = cc.net.SocketTCP.getTime()
					-- print(t3-t2)
					-- self:stopAllActions()
	
					self.playIndex = self.playIndex + 1
					if self.playIndex > self.curPlayStrLen then
						-- print("self.curPlayStr play over")
						self.curElement = nil
						self:play()
					else
						self:playChar()
					end
				end)
		))	

end



function TalkView:onEnter()


end


function TalkView:onExit()

end




return  TalkView