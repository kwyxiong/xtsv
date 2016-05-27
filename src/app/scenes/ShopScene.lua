--
-- Author: kwyxiong
-- Date: 2016-03-24 11:59:19
--

local ShopScene = class("ShopScene", function()
    return display.newScene("ShopScene")
end)

function ShopScene:ctor()
	cc.GameObject.extend(self)
	self:addComponent("app.utils.UISceneProtocol"):exportMethods()

    showView("ShopView")
    showView("MenuView")

    addBackEvent(self, function() 
    		app:enterScene("CityScene")
    	end)	
    
end

function ShopScene:onEnter()
end

function ShopScene:onExit()
	save()
end

return ShopScene
