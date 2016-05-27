--
-- Author: kwyxiong
-- Date: 2016-04-01 23:44:35
--

local TabButton = require("app.widgets.TabButton")
local TabButtons = class("TabButtons", function() 
		return display.newNode()
	end)

function TabButtons:ctor(arg)
	self.dress = arg.dress
	-- dump(self.dress)
	self.buttons = {}
	self.selectedButton = nil
	self.curPage = 1
	
	self:init()
end


function TabButtons:init()

	for k, v in ipairs(self.dress) do

		local TabButton = TabButton.new({text = table.getFirstKey(v)})
			:pos(10, -30 * (k-1))
			:addTo(self)
		TabButton:onButtonClicked(function() 
					if self.selectedButton then
						self.selectedButton:setHighlighted(false)
					end
					self.selectedButton = TabButton
					TabButton:setHighlighted(true)

					local showLayers = v[table.getFirstKey(v)]
					broadCastMsg("showLayers", {layers = showLayers})
				end)
		self.buttons[#self.buttons + 1] = TabButton

		if k == 1 then
			self.selectedButton = TabButton
			TabButton:setHighlighted(true)
			local showLayers = v[table.getFirstKey(v)]
			broadCastMsg("showLayers", {layers = showLayers})
		end

	end

end



return TabButtons