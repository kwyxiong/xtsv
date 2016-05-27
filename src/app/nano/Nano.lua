--
-- Author: kwyxiong
-- Date: 2016-03-21 21:44:54
--
local TransSprite = require("app.widgets.TransSprite")
local Nano = class("Nano", function() 
		return display.newNode()
	end)

function Nano:ctor(overCallback)
	self.overCallback = function() 
		self.actionLife = false
		-- print("<------------------------")
		-- print("self.actionLife", self.actionLife)
		-- print("------------------------>")
		if overCallback then
			overCallback()
		end
	end
	

	self.actionLife = true -- 此变量用于切换场景时 action里的callfunc可能会执行的bug

	self.data = nil
	self.scriptId = 0
	self.scriptDes = ""
	self.exps = {}
	self.expsNum = 0
	self.expIndex = 0

	-- local bg = display.newSprite("woshi.jpg")
	-- 	:addTo(self)
	self.touchLayer = display.newLayer()
		:pos(-getCenterOffSetX(), 0)
		:addTo(self)
	self.touchLayer:setTouchEnabled(false)

    self.touchLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    	if event.name=='began' then
    		return true
    	elseif event.name=='ended' then
    		self:play()
			self.touchLayer:setTouchEnabled(false)
    	end
    end)

	self:addNodeEventListener(cc.NODE_EVENT, function(event)
        if event.name == "enter" then
           
        elseif event.name == "exit" then
            self:onExit()
        end
    end)


end

function Nano:onExit()
	-- print("Nano:onExit()")
end


function Nano:loadFile(jsonFile)
	local fileUtil = cc.FileUtils:getInstance()
	local fullPath = fileUtil:fullPathForFilename(jsonFile)
	local jsonStr = fileUtil:getStringFromFile(fullPath)
	local jsonVal = json.decode(jsonStr)
	self.data = jsonVal
	self.scriptId = jsonVal.script
	print(self.scriptId)
	self.des = jsonVal.des
	self.exps = jsonVal.exps
	self.expsNum = #self.exps

	self:play()

end

function Nano:play()
	-- print("-------------------Nano:play()")
	-- print("self.actionLife", self.actionLife)
	if not self.actionLife then
		return
	end
	self.expIndex = self.expIndex + 1
	-- print(self.expIndex)
	-- dump(self, "self")
	-- print("self.expIndex", self.expIndex)
	if self.expIndex > self.expsNum then--结束
		local overCallback = self.overCallback

		self:removeSelf()
		if overCallback then
			overCallback()
		end
	else
		self:exp(self.exps[self.expIndex])
	end

end


function Nano:exp(expOb)
	
	local key = expOb.key
	local para = expOb.para
	if key == "tag" then--标签，用于跳转、注释。
		-- print(para.cz)
		-- if para.tag then
		-- 	print(para.tag)
		-- end
		self:play()
	elseif key == "setLayer" then--设定层，设置层的图片、位置、大小、明暗
		if self[para.layer] then
			-- print(para.layer .. "已存在")
			self[para.layer]:setPara(para)
		else
			self[para.layer] = TransSprite.new(para)
				:addTo(self)
		end
		self:play()
	elseif key == "moveLayer" then--使层在一定时间能转换到另外一个状态

		if para.transTime == 0 then
			self[para.layer]:setPara(para)
			self:play()
		else
			self[para.layer]:trans(para.transTime / 1000, para,function() 
					self:play()
				end)			
		end
		
	elseif key == "playSound" then--指定频道播放声音
		-- dump(expOb, "expOb")
		if para.snd then
			-- dump(Global_curMusic, "Global_curMusic")
			if Global_curMusic ~= para.snd .. ".mp3" then
				audio.playMusic(para.snd .. ".mp3", para.loop)
				-- audio.setMusicVolume(para.volume)
				Global_curMusic = para.snd .. ".mp3"
			end
		end
		self:play()
	elseif key == "stopSound" then--停止目标频道的声音

	elseif key == "setSoundVolume" then--改变目标频道上的声音音量

	elseif key == "text" then--输出对话
		local talkView = getViewByName("TalkView")
		-- print("talkView", talkView)
		if not talkView then
			showView("TalkView", {text = para.text,charaName = para.charaName,
			nameSide = para.nameSide,
			overCallback = handler(self, self.play)})
		else
			talkView:setOverCallback(handler(self, self.play))
			talkView:parseText(para.text, para.charaName, para.nameSide)
		end
		
	elseif key == "top" then--提升一个层到最上层
		self:play()
	elseif key == "flash" then--使目标层闪烁一下
		self:play()
	elseif key == "option" then--选择支，选择结果保存到一个全局变量内

	elseif key == "shake" then--使目标层震动
		local disX = para.x / 2
		local disY = para.y / 2
		local dur = para.d / 2
		local actions = {}
		local shakeTimes = math.ceil(dur/0.01)
		if shakeTimes%2 == 1 then
			shakeTimes = shakeTimes + 1
		elseif shakeTimes == 0 then
			shakeTimes = 2
		end

		local subX = disX / shakeTimes/2
		local subY = disY / shakeTimes/2
		for k = 1, shakeTimes/2 do
			actions[#actions + 1] = cc.MoveBy:create(0.01, cc.p(disX, disY))
			actions[#actions + 1] = cc.MoveBy:create(0.01, cc.p(-disX, -disY))
			disX = disX - subX
			disY = disY - subY
			-- print(disX)
		end
		actions[#actions + 1] = cc.CallFunc:create(function() 
						self:play()
					end)
		self["bg"]:runAction(transition.sequence(actions))

	
	elseif key == "event" then--发出一个事件提供给程序，实现与程序的通信

	elseif key == "para" then--给目标变量赋值


	elseif key == "wait" then--等待
		if para.type == "click" then
			self.touchLayer:setTouchEnabled(true)
		else
			if para.time == 0 then 
				self:play()
			else
				self:runAction(cc.Sequence:create(
					cc.DelayTime:create(para.time / 1000),
					cc.CallFunc:create(function() 
							self:play()
						end)
					))
			end

		end
	elseif key == "end" then--剧情结束

	elseif key == "jump" then--跳转到目标tag上播放

	elseif key == "localBgm" then--控制外部程序的BGM播放器的自用语法。。。不用在意

	end

end


return Nano