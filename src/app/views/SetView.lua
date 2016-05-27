--
-- Author: kwyxiong
-- Date: 2016-04-10 11:04:05
--

local SetView = class("SetView", function() 
		return cc.uiloader:load("SetView.json")
	end)

function SetView:ctor()

	self:init()
end

function SetView:init()

 
	addButtonPressedState(self.subChildren.Panel.subChildren.ButtonClose):onButtonClicked(function() 

			closeView(self)

			-- self:runAction(cc.Sequence:create(
			-- 		cc.FadeOut:create(0.2),
			-- 		cc.CallFunc:create(function() 
			-- 				closeView(self)
			-- 			end)
			-- 	))	
		
		end)

	--删除存档
	addButtonPressedState(self.subChildren.Panel.subChildren.ButtonSure):onButtonClicked(function() 
			cc.FileUtils:getInstance():removeFile(GameState.getGameStatePath())
			-- print("GameState.getGameStatePath()", GameState.getGameStatePath())
			GameData[Global_saveData] = nil
			self:runAction(cc.Sequence:create(
					cc.DelayTime:create(0.016),
					cc.CallFunc:create(function() 
							GameManager:restart()
						end)
				))
			

		end)

	local set = function()
		if GameData[Global_saveData].music == 1 then
			self.subChildren.Panel.subChildren.ButtonMusic:setButtonImage("normal", "btnonfoo0002.png")
		else
			self.subChildren.Panel.subChildren.ButtonMusic:setButtonImage("normal", "btnonfoo0001.png")
		end

		if GameData[Global_saveData].sound == 1 then
			self.subChildren.Panel.subChildren.ButtonSound:setButtonImage("normal", "btnonfoo0002.png")
		else
			self.subChildren.Panel.subChildren.ButtonSound:setButtonImage("normal", "btnonfoo0001.png")
		end
	end


	self.subChildren.Panel.subChildren.ButtonMusic:onButtonClicked(function() 
			if GameData[Global_saveData].music == 1 then
				GameData[Global_saveData].music = 0
			else
				GameData[Global_saveData].music = 1
			end
			set()
			setMusicSound()
			GameState.save(GameData)
		end)

	self.subChildren.Panel.subChildren.ButtonSound:onButtonClicked(function() 
			if GameData[Global_saveData].sound == 1 then
				GameData[Global_saveData].sound = 0
			else
				GameData[Global_saveData].sound = 1
			end		
			set()
			setMusicSound()
			GameState.save(GameData)
		end)

	set()

end



return SetView