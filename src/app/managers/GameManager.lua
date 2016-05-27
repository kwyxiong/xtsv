--
-- Author: kwyxiong
-- Date: 2016-04-10 11:35:59
--

local GameManager = class("GameManager")


function GameManager:ctor()

end

function GameManager:restart()
	
	-- dump(_G.Global_label_color3)
	-- dump(GameData[Global_saveData])
	require("app.MyApp").new():run()
end


return GameManager