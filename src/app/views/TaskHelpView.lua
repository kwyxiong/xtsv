--
-- Author: kwyxiong
-- Date: 2016-04-06 15:51:47
--

local TaskHelpView = class("TaskHelpView", function() 
		return cc.uiloader:load("TaskHelpView.json")
	end)

function TaskHelpView:ctor(arg)
	self.taskData = arg.taskData


	self:init()
end

function TaskHelpView:init()

 
	addButtonPressedState(self.subChildren.Panel.subChildren.ButtonClose):onButtonClicked(function() 

			closeView(self)

			-- self:runAction(cc.Sequence:create(
			-- 		cc.FadeOut:create(0.2),
			-- 		cc.CallFunc:create(function() 
			-- 				closeView(self)
			-- 			end)
			-- 	))	
			
		end)
	local str = ""
	local keyWords = getTaskKeyWords(self.taskData)
	for k, v in pairs(keyWords) do
		str = str .. k .. " "
	end

	self.subChildren.Panel.subChildren.Des:setString(str)
end



return TaskHelpView