--
-- Author: kwyxiong
-- Date: 2016-04-01 11:59:21
--


local JuQingReview = class("JuQingReview", function() 
		return cc.uiloader:load("JuQingReview.json")
		-- return ccs.GUIReader:getInstance():widgetFromJsonFile("JuQingReview.json")
	end)

--15_90
--5_270
--6_230
function JuQingReview:ctor(arg)
	arg = arg or {}
 	self.story = arg.story 
 	

 
	self:init()


	local jsonFile = "script/".. self.story ..".json"
 	self:loadFile(jsonFile)

end

function JuQingReview:loadFile(jsonFile)
	local fileUtil = cc.FileUtils:getInstance()
	local fullPath = fileUtil:fullPathForFilename(jsonFile)
	local jsonStr = fileUtil:getStringFromFile(fullPath)
	local jsonVal = json.decode(jsonStr)
	self.exps = jsonVal.exps

	local str = "\n"
	for k, expOb in ipairs(self.exps) do
		local key = expOb.key
		local para = expOb.para
		if key == "text" then--输出对话
			str = str .. "【".. textSubVal(para.charaName) .."】" .. "\n".. self:parseText(para.text) .. "\n\n"
			
		end
	end

	local label = cc.ui.UILabel.new({text = str, size = 18})
				:setTextColor(Global_label_color4)
				
				label:addTo(self.sc)
			label:setAnchorPoint(cc.p(0, 1))
			label:setDimensions(630, 0)
	-- dump(label:getContentSize())


	local height = label:getContentSize().height
	label:pos(0, height - 5)
	self.sc:setInnerContainerSize(cc.size(663,height))	



	local node = self.subChildren.ImageTouch

	node:size(cc.size(27, self:getHeight(height)))


	local initPos 
	local initNodePos

	local topY = 284 + 188 - self:getHeight(height) /2
    local minY = 282 - 188 + self:getHeight(height) /2

    node:setPositionY(topY)
    -- self:showIndex(1)
  
	
	node:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event_)
		-- dump(event_)
        if event_.name == "ended" then
        
		elseif event_.name == "moved"  then
			local posY = cc.pAdd(initNodePos, cc.pSub(event_, initPos)).y
			if posY > topY then
				posY = topY
			elseif posY < minY then
				posY = minY
			end
			node:setPosition(initNodePos.x, posY)
			-- print("posY", posY)
			-- print("topY", topY)
			-- print("minY", minY)
			-- print(-height + 385 + (topY - posY) / (topY - minY) * height)
			self.inner:setPositionY(-height + 385 + (topY - posY) / (topY - minY) * (height-385))
			-- self:showIndex(getIndex(posY))
        elseif event_.name == "began"  then
        	-- isDrugging = true
        	initNodePos = cc.p(node:getPosition())
        	-- dump(initWorldPos, "initWorldPos")
        	initPos = event_
        	return true
        end
    end)
    node:setTouchEnabled(true)

end

function JuQingReview:parseText(text)
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
	local res = ""

	for k, str in ipairs(text) do
		res = res .. self:exp(str)
	end
	return res
end


function JuQingReview:exp(str)
	str = string.split(str, "=")
	local key = str[1]
	local value = str[2]
	local res = ""
	if key == "color" then--改变颜色

	elseif key == "size" then--改变大小
		
	elseif key == "sizeEnd" then
		
	elseif key == "colorEnd" then
		
	elseif key == "alignEnd" then

	elseif key == "align" then--改变对齐方式

	elseif key == "wait" then--等待

	elseif key == "l" then--点击
		
	elseif key == "cm" then--清空当前内容

	elseif key == "r" then--换行
		res = "\n"
	elseif key == "show" then--出现
	
	elseif key == "hide" then--消失

	else--文本输出
		res = key
	end
	return res
end


function JuQingReview:initScrollView()

    local sc = ccui.ScrollView:create()
    -- sc:setBackGroundColor(cc.c3b(0,255,0))
    -- sc:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
    sc:setDirection(ccui.ScrollViewDir.vertical)
    
    sc:setContentSize(cc.size(663, 385))
    sc:setPosition(cc.p(54,91))
    -- sc:scrollToPercentBothDirection(cc.p(50, 50), 1, true)
    -- local iv = ccui.ImageView:create()
    -- iv:loadTexture("chufang.jpg")
    -- iv:setPosition(cc.p(display.width/2 + 70 , display.height/2 + 53))
    -- sc:addChild(iv)
    sc:setTouchEnabled(false)
    sc:setSwallowTouches(false)
    self:addChild(sc)
    local function pageViewEvent(sender, eventType)
        if eventType == ccui.ScrollviewEventType.scrolling then
            -- local disX = sc:getInnerContainer():getPositionX() + self.sw
            -- local disY = sc:getInnerContainer():getPositionY() + self.sh
            
            -- for k = 1, 4 do
            --     local mul = self.rects[k].mul
            --     local originPos = self.rects[k].originPos
            --     self.subChildren["Image_" .. k]:setPosition(cc.pAdd(originPos, cc.p(disX*mul, disY*mul)))
            -- end
            -- local percent = (sc:getInnerContainer():getPositionX() + 140 ) / 140
            -- self.subChildren.Image_10:setOpacity(255 - percent * 105)
            -- self.subChildren.Image_10:setScale(1-percent*0.3 )
            -- dump(cc.p(sc:getInnerContainer():getPosition()))
        end
    end

    self.inner = sc:getInnerContainer()
    -- iv:getParent():setPosition(-70, -53)
    -- dump(cc.p(sc:getInnerContainer():getPosition()))
    sc:addEventListener(pageViewEvent)

    self.sc = sc




end

function JuQingReview:init()



	-- local button = self:getChildByName("ButtonClose")
	-- print("button", button)
	-- button:addTouchEventListener(function(a, b) 
	-- 		dump(a)
	-- 		dump(b)
	-- 	end)
	-- addButtonPressedState(self.subChildren.PanelButtons.subChildren.ButtonFuZhuang)
	-- addButtonPressedState(self.subChildren.PanelButtons.subChildren.ButtonShiPin)
	-- addButtonPressedState(self.subChildren.PanelButtons.subChildren.ButtonMeiRong)
	

	addButtonPressedState(self.subChildren.ButtonClose):onButtonClicked(function() 
			closeView(self)
		end)




   

    self:initScrollView()
end	

function JuQingReview:showIndex(index)
	if self.curShowIndex ~= index then
		self.curShowIndex = index
		local i = 1
		for k, v in ipairs(self.tasks) do
			if k >= index and k <= index + 3 then
				self.taskItems[i]:show(v)
				i = i + 1
			end
		end

	end
end

--max 330 min 30
function JuQingReview:getHeight(height)
	local h = 115500 / height  + 30
	return h

end


return JuQingReview