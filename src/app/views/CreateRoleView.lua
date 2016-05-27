--
-- Author: kwyxiong
-- Date: 2016-04-07 18:19:24
--

local CreateRoleView = class("CreateRoleView", function() 
		return cc.uiloader:load("CreateRoleView.json")
	end)


	-- "random_firstname":["王","李","贺","吴","林","苏","萧","叶","魏"],
	-- "random_lastname":["妮可","小鸟","乃果","海未","绘里","希","真姬","空凛","花阳"],
function CreateRoleView:ctor()
	self.name = self:getRandName()

	self:init()
end

function CreateRoleView:getRandName()
	return Global_setting2.random_firstname[math.random(1, #Global_setting2.random_firstname)] .. 
	
	Global_setting2.random_lastname[math.random(1, #Global_setting2.random_lastname)]
end

function CreateRoleView:init()

 	addButtonPressedState(self.subChildren.Panel.subChildren.ButtonClose):onButtonClicked(function() 

			closeView(self)
			
		end) 

  	addButtonPressedState(self.subChildren.Panel.subChildren.ButtonRand):onButtonClicked(function() 
			self.editBox:setText(self:getRandName())
		end) 
	

 	addButtonPressedState(self.subChildren.Panel.subChildren.ButtonSure):onButtonClicked(function() 
 			if self.editBox:getText() == "" then
 				alert("请输入名称")
 			else
 				local name = self.editBox:getText()
 				GameData[Global_saveData].name = name
 				GameState.save(GameData)
 				Global_vals = {
					nvzhuName = name,
					jinglingName = Global_setting2["sprite_name"]
				}

				local taskData = Global_tasks_id[tonumber(Global_setting2.start_task)]

				app:enterScene("AVGScene", {taskData})
				-- app:enterScene("CityScene")
 			end
			
		end) 

 	local editBox2 = cc.ui.UIInput.new({
        image = "input1.png",
        size = cc.size(170, 48),
        x = 333 + 57 - 10 - 61,
        y = 333 - 52 + 10 + 24,
        -- fontSize = 14,
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
 	editBox2:setText(self.name)
    editBox2:setFontColor(cc.c4b(255,51,204,255))
    -- editBox2:setFontSize(10)
	-- editBox2:setMaxLength(14)
    editBox2:setAnchorPoint(cc.p(0.5, 0.5))
    editBox2:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND)
    self.editBox = editBox2
    self.subChildren.Panel:addChild(editBox2)
    

end




function CreateRoleView:onEditBoxBegan(editbox)
    printf("editBox1 event began : text = %s", editbox:getText())
end

function CreateRoleView:onEditBoxEnded(editbox)
    printf("editBox1 event ended : %s", editbox:getText())

    local text = editbox:getText()
    if string.len(text) > 12 then
        subText = ""
        for k = 1, 100 do
            local str = string.utf8sub(text, 1, k)
            if string.len(str) <= 12 then
                subText = str
            else
                break
            end
        end

        editbox:setText(subText)
    end

    -- editbox:setText(string.sub(editbox:getText(),1, 12))
end

function CreateRoleView:onEditBoxReturn(editbox)
    printf("editBox1 event return : %s", editbox:getText())
    -- editbox:setText(string.sub(editbox:getText(),1, 12))
        local text = editbox:getText()
    if string.len(text) > 12 then
        subText = ""
        for k = 1, 100 do
            local str = string.utf8sub(text, 1, k)
            if string.len(str) <= 12 then
                subText = str
            else
                break
            end
        end

        editbox:setText(subText)
    end
end

function CreateRoleView:onEditBoxChanged(editbox)
    printf("editBox1 event changed : %s", editbox:getText())
end


return CreateRoleView