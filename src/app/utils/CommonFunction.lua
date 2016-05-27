--
-- Author: kwyxiong
-- Date: 2016-03-21 15:59:56
--

Global_vertDefaultSource = "\n"..
"attribute vec4 a_position; \n" ..
"attribute vec2 a_texCoord; \n" ..
"attribute vec4 a_color; \n"..                                                    
"#ifdef GL_ES  \n"..
"varying lowp vec4 v_fragmentColor;\n"..
"varying mediump vec2 v_texCoord;\n"..
"#else                      \n" ..
"varying vec4 v_fragmentColor; \n" ..
"varying vec2 v_texCoord;  \n"..
"#endif    \n"..
"void main() \n"..
"{\n" ..
"gl_Position = CC_PMatrix * a_position; \n"..
"v_fragmentColor = a_color;\n"..
"v_texCoord = a_texCoord;\n"..
"}"



Global_curMusic = ""
Global_textColor = cc.c3b(102, 45, 19)

CUR_UI_SCENE = nil

--获取只有一个key value对的table的key
table.getFirstKey = function(tb)
	local key
	if type(tb) == "table" then
		for k,v in pairs(tb) do
			key = k
			break
		end
	else
		------print("table error!")
	end
	
	return key
end

cascade = function(node)
	node:setCascadeOpacityEnabled(true)
	for k, v in ipairs(node:getChildren()) do
		cascade(v)
	end
end

function alert(str)
	if CUR_UI_SCENE then
		return CUR_UI_SCENE:alert(str)
	end
end


function showView(viewName, arg, swallowTouch, fade)
	if CUR_UI_SCENE then
		return CUR_UI_SCENE:showView(viewName, arg, swallowTouch, fade)
	end
end

function closeView(viewName)
	if CUR_UI_SCENE then
		return CUR_UI_SCENE:closeView(viewName)
	end
end

function getViewByName(viewName)
	if CUR_UI_SCENE then
		return CUR_UI_SCENE:getViewByName(viewName)
	end
end

function getTableByJsonFile(jsonFile)
	local fileUtil = cc.FileUtils:getInstance()
	local fullPath = fileUtil:fullPathForFilename(jsonFile)
	local jsonStr = fileUtil:getStringFromFile(fullPath)
	local jsonVal = json.decode(jsonStr)

	return jsonVal
end

function getRQStar(rq)
	local rq_base_value = Global_setting2["rq_base_value"]
	local rq_star_value = Global_setting2["rq_star_value"]
	local maxLevel = 25
	local level = 1
	local sub = rq - rq_base_value - rq_star_value
	if rq < rq_base_value + rq_star_value then
		level = 1

	else
		level = math.floor(sub / rq_star_value) + 2
	end

	if level > maxLevel then
		level = maxLevel
	end

	return level
end

function scaleButton(button)
	button:onButtonPressed(function() 
		button:setScale(1.1)
	end)
	button:onButtonRelease(function()
		button:setScale(1)
	end)
end

function brightSprite(sprite, bright, alpha)
    -- local fileUtiles = cc.FileUtils:getInstance()
    -- local vertSource = Global_vertDefaultSource
    -- local fragSource = fileUtiles:getStringFromFile("example_white.fsh")
    -- local glProgam = cc.GLProgram:createWithByteArrays(vertSource,fragSource)
    -- local glprogramstate = cc.GLProgramState:getOrCreateWithGLProgram(glProgam)
    -- -- dump(sprite:getTextureRect())
    -- sprite:setGLProgramState(glprogramstate)
    -- sprite:getGLProgramState():setUniformFloat("bright", bright or 1.0)
   	-- sprite:getGLProgramState():setUniformFloat("alpha", alpha or 1.0)
    sprite:setGLProgramState(cc.GLProgramState:create(cc.GLProgramCache:getInstance():getGLProgram("ShaderMyBright")))
   	sprite:getGLProgramState():setUniformFloat("bright", bright or 1.0)
   	sprite:getGLProgramState():setUniformFloat("alpha", alpha or 1.0)

end

function whiteSprite(sprite, light)

    sprite:setGLProgramState(cc.GLProgramState:create(cc.GLProgramCache:getInstance():getGLProgram("ShaderMyWhite")))
   	sprite:getGLProgramState():setUniformFloat("light", light or 1.0)

end

-- function whiteSprite(sprite, light)
-- 	-- sprite:setVisible(false)
--     local fileUtiles = cc.FileUtils:getInstance()
--     local vertSource = Global_vertDefaultSource
--     local fragSource = fileUtiles:getStringFromFile("ccShader_MyWhite.frag")
--     local glProgam = cc.GLProgram:createWithByteArrays(vertSource,fragSource)
--     local glprogramstate = cc.GLProgramState:getOrCreateWithGLProgram(glProgam)
--     -- dump(sprite:getTextureRect())
--     sprite:setGLProgramState(glprogramstate)
--     -- cc.GLProgramCache:getInstance():addGLProgram(glProgam, "kShaderType_myWhite")
   
--     -- sprite:setGLProgramState(cc.GLProgramState:create(cc.GLProgramCache:getInstance():getGLProgram("ShaderMyWhite")))
--    	sprite:getGLProgramState():setUniformFloat("light", light or 1.0)

-- end

function bloomSprite(sprite,intensity )

    -- local fileUtiles = cc.FileUtils:getInstance()
    -- local vertSource = Global_vertDefaultSource
    -- local fragSource = fileUtiles:getStringFromFile("example_Bloom.fsh")
    -- local glProgam = cc.GLProgram:createWithByteArrays(vertSource,fragSource)
    -- local glprogramstate = cc.GLProgramState:create(glProgam)
    -- dump(sprite:getTextureRect())
    -- local resolution = cc.p(sprite:getTextureRect().width, sprite:getTextureRect().height)
    -- dump(resolution)
    -- sprite:setGLProgramState(glprogramstate)
    -- cc.GLProgramCache:getInstance():addGLProgram(glProgam, "kShaderType_myBlur")

    sprite:setGLProgramState(cc.GLProgramState:create(cc.GLProgramCache:getInstance():getGLProgram("ShaderMyBloom")))
    -- sprite:getGLProgramState():setUniformVec2("resolution", resolution)	
    sprite:getGLProgramState():setUniformFloat("intensity", intensity or 0.1)
end

function addButtonPressedState(button, bright)
    local pressedSprite = display.newSprite(button.sprite_[1]:getTexture())
        :addTo(button)
        -- :pos(333, 333)
    bloomSprite(pressedSprite, bright)
    pressedSprite:setVisible(false)
    button:onButtonPressed(function(event) 
            -- print("a")
            button.pressX = event.x
            button.pressY = event.y
            -- dump(event, "pressedEvent")
            pressedSprite:setVisible(true)
        end)
    button:onButtonRelease(function() 
            -- print("b")
            pressedSprite:setVisible(false)
        end)
    return button
end


	--ui居中偏移量
function getCenterOffSetX()
	return (display.width - 800) / 2
end

function autoAdjust(widget, adjustType)
	local offSet = cc.p(getCenterOffSetX(), 0)
	local devicesize=cc.size(display.width, display.height)
	-- dump(devicesize, "devicesize")
	local cccs=cc.size(800, 600)
	-- dump(cccs, "cccs")
	local pt = cc.p(widget:getPosition())
	local cs = widget:getContentSize()
	-- dump(cs, "cs")
	local an = cc.p(widget:getAnchorPoint())

	if adjustType == 1 then
		local dst = cc.pSub(pt,offSet)
		widget:setPosition(dst)	
	elseif adjustType == 2 then
		local ptext=cc.p(cs.width*(an.x-0.5),cs.height*an.y)
		local pt2=cc.pSub(pt,ptext)
		local ptsub=cc.pSub(pt2,cc.p(cccs.width*0.5,0))
		local dst=cc.pAdd(ptext,cc.pAdd(cc.p(devicesize.width/2.0,0),ptsub))
		dst = cc.pSub(dst, offSet)
		widget:setPosition(dst)	
	elseif adjustType == 3 then
		local ptext=cc.p(cs.width*(an.x-1.0),cs.height*an.y)
		local pt3=cc.pSub(pt,ptext)
		local ptsub=cc.pSub(pt3,cc.p(cccs.width,0))
		local dst=cc.pAdd(ptext,cc.pAdd(cc.p(devicesize.width,0),ptsub))
		dst = cc.pSub(dst, offSet)
		widget:setPosition(dst)	
	elseif adjustType == 4 then
		local ptext=cc.p(cs.width*an.x,cs.height*(an.y-0.5))
		local pt4=cc.pSub(pt,ptext)
		local ptsub=cc.pSub(pt4,cc.p(0,cccs.height*0.5))

		local dst=cc.pAdd(ptext,cc.pAdd(cc.p(0,devicesize.height*0.5),ptsub))
		dst = cc.pSub(dst, offSet)
		widget:setPosition(dst)
	elseif adjustType == 5 then

		local ptext=cc.p(cs.width*(an.x-0.5),cs.height*(an.y-0.5));
		local pt5=cc.pSub(pt,ptext);
		local ptsub=cc.pSub(pt5,cc.p(cccs.width*0.5,cccs.height*0.5));

		local dst=cc.pAdd(ptext,cc.pAdd(cc.p(devicesize.width*0.5,devicesize.height*0.5),ptsub));
		dst = cc.pSub(dst, offSet)
		widget:setPosition(dst)
	elseif adjustType == 6 then
		local ptext=cc.p(cs.width*(an.x-1.0),cs.height*(an.y-0.5));
		local pt6=cc.pSub(pt,ptext);
		local ptsub=cc.pSub(pt6,cc.p(cccs.width,cccs.height*0.5));

		local dst=cc.pAdd(ptext,cc.pAdd(cc.p(devicesize.width,devicesize.height*0.5),ptsub));
		dst = cc.pSub(dst, offSet)
		-- dump(dst, "dst")
		widget:setPosition(dst);
		
	elseif adjustType == 7 then
		local ptext=cc.p(cs.width*an.x,cs.height*(an.y-1.0))
		local pt7=cc.pSub(pt,ptext)
		local ptsub=cc.pSub(pt7,cc.p(0,cccs.height))

		local dst=cc.pAdd(ptext,cc.pAdd(cc.p(0,devicesize.height),ptsub))
		dst = cc.pSub(dst, offSet)
		widget:setPosition(dst)
	elseif adjustType == 8 then
		local ptext=cc.p(cs.width*(an.x-0.5),cs.height*(an.y-1.0));
		local pt8=cc.pSub(pt,ptext);
		local ptsub=cc.pSub(pt8,cc.p(cccs.width*0.5,cccs.height));

		local dst=cc.pAdd(ptext,cc.pAdd(cc.p(devicesize.width*0.5,devicesize.height),ptsub));
		dst = cc.pSub(dst, offSet)
		widget:setPosition(dst);
		
	elseif adjustType == 9 then
		local ptext=cc.p(cs.width*(an.x-1.0),cs.height*(an.y-1.0));
		local pt9=cc.pSub(pt,ptext);
		local ptsub=cc.pSub(pt9,cc.p(cccs.width,cccs.height));

		local dst=cc.pAdd(ptext,cc.pAdd(cc.p(devicesize.width,devicesize.height),ptsub));
		dst = cc.pSub(dst, offSet)
		widget:setPosition(dst);	
	end
end

function table.list2Map(tb)
	local res = {}
	for k, v in ipairs(tb) do
		res[v] = true
	end
	return res
end

function table.getNum(tb)
	local num = 0
	for k, v in pairs(tb) do
		num = num + 1
	end
	return num
end

function getLevel()
	local curExp = GameData[Global_saveData].exp
	local datas = Global_levels.datas
	local addExp = 0
	local resLevel = 0
	local resExp = 0
	local resMaxExp = 0
	for k = 0 , 20 do
		local curLevelNeedExp = tonumber(datas[k .. ""].exp)
		if curExp < curLevelNeedExp then
			resLevel = k
			resExp = curExp
			resMaxExp = curLevelNeedExp
			break
		else
			resLevel = resLevel + 1
			curExp = curExp - curLevelNeedExp
			resMaxExp = curLevelNeedExp
		end
	end

	if resLevel == 21 then
		resLevel = 20
		resExp = resMaxExp
	end

	return resLevel

end

--[[解析16进制颜色rgb值]]
function  GetTextColor(xStr)
    if string.len(xStr) == 6 then
        local tmp = {}
        for i = 0,5 do
            local str =  string.sub(xStr,i+1,i+1)
            if(str >= '0' and str <= '9') then
                tmp[6-i] = str - '0'
            elseif(str == 'A' or str == 'a') then
                tmp[6-i] = 10
            elseif(str == 'B' or str == 'b') then
                tmp[6-i] = 11
            elseif(str == 'C' or str == 'c') then
                tmp[6-i] = 12
            elseif(str == 'D' or str == 'd') then
                tmp[6-i] = 13
            elseif(str == 'E' or str == 'e') then
                tmp[6-i] = 14
            elseif(str == 'F' or str == 'f') then
                tmp[6-i] = 15
            else
                ------print("Wrong color value.")
                tmp[6-i] = 0
            end
        end
        local r = tmp[6] * 16 + tmp[5]
        local g = tmp[4] * 16 + tmp[3]
        local b = tmp[2] * 16 + tmp[1]
        return cc.c3b(r,g,b)
    end
    return cc.c3b(255,255,255)
end

function drug(node)
	-- local isDrugging = false
		local initPos 
	local initNodePos
	node:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event_)

        if event_.name == "ended" then
        	-- if self.arg.sellMode then
        
			-- end
			--dump(CENTER_OFFSET,"CENTER_OFFSET")
			dump(cc.p(node:getPosition()))
		elseif event_.name == "moved"  then
			node:setPosition(cc.pAdd(initNodePos, cc.pSub(event_, initPos)))
        elseif event_.name == "began"  then
        	-- isDrugging = true
        	initNodePos = cc.p(node:getPosition())
        	-- dump(initWorldPos, "initWorldPos")
        	initPos = event_
        	return true
        end
    end)
    node:setTouchEnabled(true)
    node:setTouchSwallowEnabled(false)
end



--替换用{}括起来的变量
function textSubVal(text)
	text = string.gsub(text, "}", "{")
	text = string.gsub(text, "{{", "{")
	text = string.split(text, "{")
	local newText = ""
	for k, v in ipairs(text) do
		newText = newText .. (Global_vals[v] or v)
	end
	return newText
end



function circleClippingNode(node)
	local clippingNode = cc.ClippingNode:create()
	clippingNode:addChild(node)
	local st = display.newCircle(47, {x = 0, y = 0, fillColor = cc.c4f(1, 1, 1, 1)})
	clippingNode:setStencil(st);
	clippingNode:setInverted(false)
	return clippingNode
end

function circleClippingNode1(node, radius, x, y)
	local clippingNode = cc.ClippingNode:create()
	clippingNode:addChild(node)
	local st = display.newCircle(radius, {x = x, y = y, fillColor = cc.c4f(1, 1, 1, 1)})
	clippingNode:setStencil(st);
	clippingNode:setInverted(true)
	return clippingNode
end

function blurSprite(sprite, blurRadius)
	-- sprite:setVisible(false)
    -- local fileUtiles = cc.FileUtils:getInstance()
    -- local vertSource = Global_vertDefaultSource
    -- local fragSource = fileUtiles:getStringFromFile("shaders/example_Blur.fsh")
    -- local glProgam = cc.GLProgram:createWithByteArrays(vertSource,fragSource)
    -- local glprogramstate = cc.GLProgramState:create(glProgam)
    -- dump(sprite:getTextureRect())
    local resolution = cc.p(sprite:getTextureRect().width, sprite:getTextureRect().height)

    -- cc.GLProgramCache:getInstance():addGLProgram(glProgam, "kShaderType_myBlur")

    sprite:setGLProgramState(cc.GLProgramState:create(cc.GLProgramCache:getInstance():getGLProgram("ShaderMyBlur")))
    sprite:getGLProgramState():setUniformVec2("resolution", resolution)	
    sprite:getGLProgramState():setUniformFloat("blurRadius", blurRadius or 1.0)
end

--@通过时间戳获取日期
function string.getOsTime(times)
	------print(times)
	local tab = os.date("*t",times)			
	local timeStr = string.format("%s/%s/%s %s:%s:%s",tab.year,tab.month,tab.day,tab.hour,tab.min,tab.sec)				
	return timeStr
end


function string.formatNumberToTimeString(nowtime)

	local minute=math.floor(nowtime/60)

	local second=math.floor((nowtime%3600)%60)
	
    return string.format("%02d:%02d",minute,second)
end


function getXHR()

	local xhr = cc.XMLHttpRequest:new()
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
    -- xhr:setRequestHeader("apikey", "af219d11d8885bc9579d3be4ae9fe4a0")
    -- xhr:open("GET", "http://apis.baidu.com/3023/time/time")

    -- xhr:setRequestHeader("apikey", "af219d11d8885bc9579d3be4ae9fe4a0")
    xhr:open("GET", "http://api.k780.com:88/?app=life.time&appkey=18720&sign=975b1a6260dacb22fc26530adce7e0af&format=json")
    return xhr
end

function getTaskKeyWords(taskData)
	local keyWords = {}
	local need = {}
	need[#need + 1] = taskData.needValue
	need[#need + 1] = taskData.needColor
	need[#need + 1] = taskData.needElement
	need[#need + 1] = taskData.needStyle
	need[#need + 1] = taskData.needType
	need[#need + 1] = taskData.needWork

	local function clean(tb)
		if #tb > 0 then
			for k = #tb, 1, -1 do
				if tb[k].value == "" or tb[k].name == "" then
					table.remove(tb, k)
				end
			end
		end

	end
	for k, v in ipairs(need) do
		clean(v)
	end
	for k, v in ipairs(need) do
		for k1, v1 in ipairs(v) do
			keyWords[v1.name] = true
		end
	end

	return keyWords

end

function getTaskFromPool()

    local curCard = Global_cards_id[GameData[Global_saveData].curShowCard]
    -- dump(curCard)

    local shotName
    if curCard then
        if curCard.addType ~= "money" and curCard.addType ~= "exp" then
            local addValue = tonumber(curCard.addValue)
            local rand = math.random(1 , 100)
            if rand <= addValue then--命中
            	shotName = curCard.addType
            end
        end
    end

    local findId
    if shotName then
	    for k, v in ipairs(GameData[Global_saveData].renWuPool) do
	    	local data = Global_tasks_id[v]
	    	local keyWords = getTaskKeyWords(data)
	    	if keyWords[shotName] then
			    findId = v
			    table.remove(GameData[Global_saveData].renWuPool, k)
			    break
	    	end
	    end
	end
	if findId then
		return findId
	else

	    local index =  math.random(1, #GameData[Global_saveData].renWuPool)
	    local newTaskId = GameData[Global_saveData].renWuPool [ index]
	    table.remove(GameData[Global_saveData].renWuPool, index)
	    return newTaskId
	end
end

--洽谈  return 有新的洽谈任务
function qiatan()

	local hasNew = false
    local waiting = false --是否已经有任务在洽谈
    for k, v in ipairs(GameData[Global_saveData].curRenWus) do
        if v.time then
            waiting = true
            break
        end
    end

    if #GameData[Global_saveData].curRenWus < tonumber(Global_setting2.max_work) and
        not waiting and #GameData[Global_saveData].renWuPool > 0 then
            GameData[Global_saveData].curRenWus[#GameData[Global_saveData].curRenWus + 1] = {id = getTaskFromPool(), time = -1}
        	hasNew = true
    end

    return hasNew
end



function showTips()
	local level =  getLevel()
	local needSave = false
	if level > GameData[Global_saveData].showLevelUp then
		showView("TipsView", {type = "levelUp", level = level}, true, true)
		GameData[Global_saveData].showLevelUp = level
		needSave = true
	end
	dump(GameData[Global_saveData].showReward, "GameData[Global_saveData].showReward")
	if #GameData[Global_saveData].showReward > 0 then
		for k, v in ipairs(GameData[Global_saveData].showReward) do
			showView("RewardView", {data = Global_clothes[v]}, true, true)
		end
		GameData[Global_saveData].showReward = {}
		needSave = true
	end
	if needSave then
		GameState.save(GameData)
	end
end

function setMusicSound()
	audio.setMusicVolume(GameData[Global_saveData].music)
	audio.setSoundsVolume(GameData[Global_saveData].sound)
end


function outlineSprite(sprite, radius, threshold)
    -- local fileUtiles = cc.FileUtils:getInstance()
    -- local vertSource = Global_vertDefaultSource
    -- local fragSource = fileUtiles:getStringFromFile("example_Outline.fsh")
    -- local glProgam = cc.GLProgram:createWithByteArrays(vertSource,fragSource)
    -- local glprogramstate = cc.GLProgramState:getOrCreateWithGLProgram(glProgam)
    -- -- dump(sprite:getTextureRect())
    -- sprite:setGLProgramState(glprogramstate)
    -- cc.GLProgramCache:getInstance():addGLProgram(glProgam, "kShaderType_myWhite")
   
    sprite:setGLProgramState(cc.GLProgramState:create(cc.GLProgramCache:getInstance():getGLProgram("ShaderMyOutline")))

    -- sprite:getGLProgramState():setUniformVec3(3, {122,122,122})
   	sprite:getGLProgramState():setUniformFloat("u_radius", radius or 0.01)
   	sprite:getGLProgramState():setUniformFloat("u_threshold",threshold or  0.9)

end


function getGuideHand()
	local node = display.newNode()
	-- local index = 1
	-- local dur = 0.2
	-- local imgs = {"gh1.png","gh2.png","gh1.png","gh1.png","gh1.png",}
	-- local sp = display.newSprite(imgs[index])
	-- 	:addTo(node)
	-- sp:setAnchorPoint(cc.p(0,1))
	-- local action 
	-- action= cc.RepeatForever:create(cc.Sequence:create(
	-- 		cc.DelayTime:create(dur),
	-- 		cc.CallFunc:create(function() 
	-- 				-- sp:removeSelf()
	-- 				index = index + 1
	-- 				index = CALC_3(index ==#imgs + 1, 1, index)
	-- 				sp:setTexture(imgs[index])
	-- 			end)
	-- 	))
	-- sp:runAction(action)
	return node
end




--三元运算
CALC_3 = function(exp, result1, result2) if(exp)then return result1; else return result2; end end


function addBackEvent(node, callback)

	local onKeyReleased = function ( keycode, event )
    
        if keycode == cc.KeyCode.KEY_BACK then
            if callback and not GuideManager:isGuiding() then
            	callback()
            end
        end
        return node:EventDispatcher(cc.KEYPAD_EVENT, {keycode, event, "Released"})
    end

    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED )
    local eventDispatcher = node:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, node)

end