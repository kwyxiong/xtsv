--
-- Author: kwyxiong
-- Date: 2016-03-23 12:03:37
--

local CityView = class("CityView", function() 
		return cc.uiloader:load("CityView.json")
	end)

function CityView:ctor(arg)

	self.sw = 70
	self.sh = 53

	self.rects = {
		{originPos = cc.p(self.subChildren.Image_1:getPosition()), mul = 0.15},
		{originPos = cc.p(self.subChildren.Image_2:getPosition()), mul = 0.4},
		{originPos = cc.p(self.subChildren.Image_3:getPosition()), mul = 0.8},
		{originPos = cc.p(self.subChildren.Image_4:getPosition()), mul = 1},

	}
    if display.width + self.sw * 2 > 1056 then
        for k = 1, 4 do

            self.subChildren["Image_" .. k]:setScale((display.width + self.sw * 2) / 1056)
        end
    end

	self:addNodeEventListener(cc.NODE_EVENT, function(event)
        if event.name == "enter" then
            self:onEnter()
        elseif event.name == "exit" then
            self:onExit()
        end
    end)	


    self.subChildren.Image_10:setBlendFunc(gl.SRC_ALPHA, gl.ONE)


    self:initScrollView()

  

  
    for k, v in pairs(self.subChildren.Image_4.subChildren) do
        if k == "ButtonHome" or k == "ButtonOffice" or k == "ButtonShop" then
            addButtonPressedState(v)
            v:onButtonClicked(function(event) 
                
                    if event.x - v.pressX > -5 and event.x - v.pressX < 5
                    and event.y - v.pressY > -5 and event.y - v.pressY < 5 then
                        if GuideManager:isGuiding() then
                            GuideManager:nextStep()
                        end
                        if k == "ButtonHome" then
                            -- print("ButtonHome")
                            app:enterScene("HomeScene")
                        elseif k == "ButtonOffice" then
                            app:enterScene("OfficeScene")
                            -- app:enterScene("OfficeScene", nil, "crossFade", 0.1)
                        elseif k == "ButtonShop" then
                            app:enterScene("ShopScene")
                        end


                    end
                end)    
        else
            if arg.moveLabel then
                
                    local image = v
                    image:setVisible(false)
                    local initPos = cc.p(image:getPosition())
                    local dis = 120
                    local delay = 1
                    if k == "ImageHome" then

                    elseif k == "ImageOffice" then
                        delay = 1.5
                    else
                        delay = 2
                    end
                    image:setPosition(cc.p(initPos.x , initPos.y + dis))
                    image:runAction(cc.Sequence:create(
                            cc.DelayTime:create(delay),
                            cc.CallFunc:create(function() 
                                    image:setVisible(true)
                                end),
                            cc.MoveBy:create(0.15, cc.p(0, -(dis + 10))),
                            cc.MoveBy:create(0.2, cc.p(0, 10))
                        ))
               

            end
        end
    end

    self.bird1 = self:getBird(1)
        :pos(-200, 400)
        :addTo(self, 2)

    self.bird2 = self:getBird(10)
        :pos(-200 + 20, 400 - 10)
        :addTo(self, 2)

    self.bird3 = self:getBird(20)
        :pos(-200 + 40, 400 + 10)
        :addTo(self, 2)
       
    self.bird1:runAction(cc.RepeatForever:create(cc.Sequence:create(
            cc.DelayTime:create(8),
            cc.MoveBy:create(4, cc.p(display.width + 200, 100)),
            cc.CallFunc:create(function() 
                    self.bird1:pos(-200, 400)
                end)
        )))

        self.bird2:runAction(cc.RepeatForever:create(cc.Sequence:create(
            cc.DelayTime:create(8),
            cc.MoveBy:create(4, cc.p(display.width + 200, 100)),
            cc.CallFunc:create(function() 
                    self.bird2:pos(-200 + 20, 400 - 10)
                end)
        )))

            self.bird3:runAction(cc.RepeatForever:create(cc.Sequence:create(
            cc.DelayTime:create(8),
            cc.MoveBy:create(4, cc.p(display.width + 200, 100)),
            cc.CallFunc:create(function() 
                    self.bird3:pos(-200 + 40, 400 + 10)
                end)
        )))

end



function CityView:initScrollView()

    local sc = ccui.ScrollView:create()
    -- sc:setBackGroundColor(cc.c3b(0,255,0))
    -- sc:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
    sc:setDirection(ccui.ScrollViewDir.both)
    sc:setInnerContainerSize(cc.size(display.width + self.sw*2, display.height + self.sh*2))
    sc:setContentSize(cc.size(display.width, display.height))
    sc:setPosition(cc.p(-getCenterOffSetX(),0))
    -- sc:scrollToPercentBothDirection(cc.p(50, 50), 1, true)
    -- local iv = ccui.ImageView:create()
    -- iv:loadTexture("chufang.jpg")
    -- iv:setPosition(cc.p(display.width/2 + 70 , display.height/2 + 53))
    -- sc:addChild(iv)
    -- sc:setTouchEnabled(false)
    sc:setSwallowTouches(false)
    self:addChild(sc)
    local function pageViewEvent(sender, eventType)
        if eventType == ccui.ScrollviewEventType.scrolling then

            local listPanel_ = CUR_UI_SCENE:getComponent("app.utils.UISceneProtocol").listPanel_
            if #listPanel_ > 2 then
                return
            end
            local disX = sc:getInnerContainer():getPositionX() + self.sw
            local disY = sc:getInnerContainer():getPositionY() + self.sh
            -- print(disX)
            for k = 1, 4 do
                local mul = self.rects[k].mul
                local originPos = self.rects[k].originPos
                self.subChildren["Image_" .. k]:setPosition(cc.pAdd(originPos, cc.p(disX*mul, disY*mul)))
            end
            local percent = (sc:getInnerContainer():getPositionX() + 140 ) / 140
            self.subChildren.Image_10:setOpacity(255 - percent * 105)
            self.subChildren.Image_10:setScale(1-percent*0.3 )
            -- dump(cc.p(sc:getInnerContainer():getPosition()))
        end
    end

    self.inner = sc:getInnerContainer()
    -- iv:getParent():setPosition(-70, -53)
    -- dump(cc.p(sc:getInnerContainer():getPosition()))
    sc:addEventListener(pageViewEvent)



    self.sc = sc
end

function CityView:onEnter()
	self.inner:setPosition(-self.sw, -self.sh)
        local percent = (self.sc:getInnerContainer():getPositionX() + 140 ) / 140
    self.subChildren.Image_10:setOpacity(255 - percent * 105)
    self.subChildren.Image_10:setScale(1-percent*0.3 )
end

function CityView:onExit()

end

function CityView:getBird(startFrameIndex)


    local sp = display.newSprite("bird0040 (".. startFrameIndex ..").png")

    local animation = cc.Animation:create()
    local number, name
    for i = 1, 40 do
    
        number = startFrameIndex + i
        if number > 40 then
            number = number - 40
        end
        
        name = "bird0040 (".. number ..").png"
        animation:addSpriteFrameWithFile(name)
    end
    -- should last 2.8 seconds. And there are 14 frames.
    animation:setDelayPerUnit(0.02)
    animation:setRestoreOriginalFrame(true)

    local action = cc.Animate:create(animation)
    sp:runAction(cc.RepeatForever:create(action))

    sp:setScale(0.8)
    return sp
end




return CityView