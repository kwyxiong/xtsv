--
-- Author: kwyxiong
-- Date: 2016-03-21 16:06:34
--
local UISceneProtocol = class("UISceneProtocol",cc.Component)

function UISceneProtocol:ctor()
	-- --dump(cc)
	UISceneProtocol.super.ctor(self, "UISceneProtocol")

end

function UISceneProtocol:exportMethods()
	self:exportMethods_({
        "showView",
        "closeView",
        "getViewByName",
        "alert",
    })

	-- 保存打开的UI
	self.listPanel_ = { }
	--[1] = {viewName = "", view = }
	--ui居中偏移量
	self.disX = getCenterOffSetX()
end

function UISceneProtocol:onBind_(target)
	------printInfo("-----------进入" .. target.name .. "场景------------")

	CUR_UI_SCENE = target

	--给场景添加一个UI层
	local uiLayer = display.newNode():addTo(target)
	-- target.uiLayer = display.newNode():addTo(target)
	-- self.uiLayer = target.uiLayer
	uiLayer:setLocalZOrder(500)


	self.uiLayer = uiLayer

	self.alertPool = {}
	self.isAlerting = false

	if Game_800_600 then
		local rightLayer = display.newColorLayer(cc.c4b(0,0,0,255))
			:pos(getCenterOffSetX() + 800, 0)
			:addTo(target,9999999)
			:size(display.width - getCenterOffSetX() - 800, display.height)
		rightLayer:setTouchEnabled(true)
		rightLayer:setName("rightLayer")
		local leftLayer = display.newColorLayer(cc.c4b(0,0,0,255))
			:pos(0, 0)
			:addTo(target,9999999)
			:size(display.width - getCenterOffSetX() - 800, display.height)
		leftLayer:setTouchEnabled(true)
		leftLayer:setName("leftLayer")

	end
end




function UISceneProtocol:playAlert()
	-- print("playAlert")
	local str = self.alertPool[1]
	if str then 
		self.isAlerting = true
		table.remove(self.alertPool, 1)
		local node = display.newNode()
			:pos(display.cx, display.cy - 50)
			:addTo(CUR_UI_SCENE, 999)
		node:setCascadeOpacityEnabled(true)

		local bg = display.newSprite("alertBg.png")
			:addTo(node)

		local label = cc.ui.UILabel.new({text = str, size = 25})
				:setTextColor(cc.c4b(255, 255, 0, 255))
				label:addTo(node)
		label:enableOutline(cc.c4b(102, 45, 19, 255), 2)
		label:setAnchorPoint(cc.p(0.5, 0.5))
		node:runAction(cc.Sequence:create(
				cc.MoveBy:create(0.5, cc.p(0, 50)),
				cc.CallFunc:create(function() 
						if #self.alertPool == 0 then
							self.isAlerting = false
						else
							self:playAlert()
						end
					end),
				cc.MoveBy:create(0.5, cc.p(0, 50)),
				cc.DelayTime:create(1),
				cc.FadeOut:create(1),
				cc.CallFunc:create(function() 
						node:removeSelf()
						
					end)
			))	
	end
end

function UISceneProtocol:alert(str)
	self.alertPool[#self.alertPool + 1] = str
	if not self.isAlerting then
		self:playAlert()
	end

end

--居中显示view
function UISceneProtocol:showView(viewName, arg, swallowTouch, fade)

	local view = require("app.views." .. viewName).new(arg)
	if not view then
		print(viewName .. " not found")
		return
	else
		-- self.listPanel_[] =
		if self:getViewByName(viewName) and viewName ~= "RewardView"  then
			print(viewName .. " is already opened !")
			return
		end

		if fade then
			cascade(view)
		 	view:setOpacity(0)
		 	view:runAction(cc.FadeIn:create(0.2))
		end

		view:setName(viewName)
		view:pos(self.disX, 0)
		view:zorder((#self.listPanel_ + 1) * 2)
		self.uiLayer:addChild(view)






		local touchLayer
		if swallowTouch then
				--屏蔽触摸
			touchLayer = display.newLayer()
				:zorder((#self.listPanel_ + 1) * 2 - 1)
				:addTo(self.uiLayer)
		end

		self.listPanel_[#self.listPanel_ + 1] = {view = view,viewName = viewName, touchLayer = touchLayer, fade = fade}
		return view
	end
end

function UISceneProtocol:closeView(viewName)
	if type(viewName) == "string" then
		for k, v in ipairs(self.listPanel_) do
			if v.viewName == viewName then
				local removeFunc = function() 
					if v.view then
						v.view:removeSelf()
					end
					if v.touchLayer then
						v.touchLayer:removeSelf()
					end


					table.remove(self.listPanel_, k)
				end
				if v.fade then
					v.view:runAction(cc.Sequence:create(
							cc.FadeOut:create(0.15),
							cc.CallFunc:create(function() 
									removeFunc()
								end)
						))	
				else
					removeFunc()
				end

				break
			end
		end
		
	elseif type(viewName) == "userdata" then
		for k, v in ipairs(self.listPanel_) do
			if v.view == viewName then

				local removeFunc = function() 
					if v.view then
						v.view:removeSelf()
					end
					if v.touchLayer then
						v.touchLayer:removeSelf()
					end


					table.remove(self.listPanel_, k)
				end
				if v.fade then
					v.view:runAction(cc.Sequence:create(
							cc.FadeOut:create(0.15),
							cc.CallFunc:create(function() 
									removeFunc()
								end)
						))	
				else
					removeFunc()
				end
				break
			end
		end
	end
end


function UISceneProtocol:getViewByName(viewName)
	-- print("self.uiLayer:getChildByName(viewName)")
	-- print(self.uiLayer:getChildByName(viewName))
	return self.uiLayer:getChildByName(viewName)
end

return UISceneProtocol