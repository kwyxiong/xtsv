--
-- Author: kwyxiong
-- Date: 2016-04-07 16:54:33
--

local ExchangeMoneyView = class("ExchangeMoneyView", function() 
		return cc.uiloader:load("ExchangeMoneyView.json")
	end)

function ExchangeMoneyView:ctor()
	self.tb = 0

	self:init()
end

function ExchangeMoneyView:init()

 	addButtonPressedState(self.subChildren.Panel.subChildren.ButtonClose):onButtonClicked(function() 

			closeView(self)
			
		end) 
    
 	addButtonPressedState(self.subChildren.Panel.subChildren.ButtonSure):onButtonClicked(function() 
 			if self.tb == 0 then
                
                if GameData[Global_saveData].tb == 0 then
                    alert("T币不足")
                else
                    alert("请输入大于0的整数")
                end
 			elseif self.tb > GameData[Global_saveData].tb then
 				alert("T币不足")
 			else
 				GameData[Global_saveData].jb = GameData[Global_saveData].jb + self.tb *tonumber(Global_setting2.money_money2)
 				GameData[Global_saveData].tb = GameData[Global_saveData].tb - self.tb
 				broadCastMsg("buyUpdate")
 				alert("获得了 " .. self.tb *tonumber(Global_setting2.money_money2) .. "金币")
 				save()
 				closeView(self)

 			end
			
			
		end) 

 	local editBox2 = cc.ui.UIInput.new({
        image = "input.png",
        size = cc.size(115, 45),
        x = 333 + 57 - 10,
        y = 333 - 52 + 10,
        listener = function(event, editbox)
            if event == "began" then
                self:onEditBoxBegan(editbox)
            elseif event == "ended" then
                self:onEditBoxEnded(editbox)
            elseif event == "return" then
                self:onEditBoxReturn(editbox)
            elseif event == "changed" then
                self:onEditBoxChanged(editbox)
            else
                printf("EditBox event %s", tostring(event))
            end
        end
    })

    editBox2:setFontColor(cc.c4b(255,51,204,255))
    editBox2:setInputMode(3)
    editBox2:setAnchorPoint(cc.p(0.5, 0.5))
    editBox2:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
    self.editBox = editBox2
    self.subChildren.Panel:addChild(editBox2)
    if GameData[Global_saveData].tb > 0 then
    	self:input(1)
    else
    	self:input(0)
    end

    self.subChildren.Panel.subChildren.LabelLeft:enableOutline(Global_label_color4, 1)
    self.subChildren.Panel.subChildren.LabelRight:enableOutline(Global_label_color4, 1)
end

function ExchangeMoneyView:input(tb)
	local myTB = GameData[Global_saveData].tb
	if tb > myTB then
		tb = myTB
	elseif tb < 0 then
		tb = 0
	end
	self.tb = tb
	self.editBox:setText(tb)
	self.subChildren.Panel.subChildren.LabelLeft:setString(tb .. "T币")
	self.subChildren.Panel.subChildren.LabelRight:setString("=".. tb *tonumber(Global_setting2.money_money2) .."金币")
end

function ExchangeMoneyView:onEditBoxBegan(editbox)
    printf("editBox1 event began : text = %s", editbox:getText())
end

function ExchangeMoneyView:onEditBoxEnded(editbox)
    printf("editBox1 event ended : %s", editbox:getText())

    if tonumber( editbox:getText()) then
    	local n = math.floor(tonumber( editbox:getText()))
    	self:input(n)
    else
    	self:input(0)
    end
end

function ExchangeMoneyView:onEditBoxReturn(editbox)
    printf("editBox1 event return : %s", editbox:getText())
    if tonumber( editbox:getText()) then
    	local n = math.floor(tonumber( editbox:getText()))
    	self:input(n)
    else
    	self:input(0)
    end
end

function ExchangeMoneyView:onEditBoxChanged(editbox)
    printf("editBox1 event changed : %s", editbox:getText())
end


return ExchangeMoneyView