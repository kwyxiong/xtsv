--
-- Author: kwyxiong
-- Date: 2016-04-12 01:40:30
--

local InfoView = class("InfoView", function() 
		return cc.uiloader:load("InfoView.json")
	end)

function InfoView:ctor()
	self:init()
	self:addNodeEventListener(cc.NODE_EVENT, function(event)
        if event.name == "enter" then
            self:onEnter()
        elseif event.name == "exit" then
            self:onExit()
        end
    end)

end

function InfoView:onEnter()
	
end




function InfoView:onExit()
	
	CUR_UI_SCENE.particleLeaf:setVisible(true)

end

function InfoView:init()

 
	addButtonPressedState(self.subChildren.ButtonClose):onButtonClicked(function() 

			closeView(self)


		end)
-- 	self.subChildren.LabelInfo:setString("《星途少女》游戏由 TOTAL动漫社 制作，北京次元领域科技有限公司发行!\n并独家发布于4399平台！请勿转载或盗用任何本游戏的图像音乐等素材！\n\n" ..
-- "    企划：Total恺                         主题曲《星途少女》\n" ..
-- "    程序：pa、方dragon                    词/曲：luna safari\n" ..
-- "    音乐制作：luna safari、茶茶P          演唱：岚aya\n" ..
-- "    演出/数值：Muchiiu                    PV：平安夜的噩梦\n\n" ..
-- "    剧本策划：路七酱（主笔）、茶布（主编）、庭夏、秀一、以太、\n" ..
-- "             迷离的小骑士、帅气的西瓜桑、等10人\n" ..
-- "    服装设计：leno（主美）、凝竹（主美）、安基酸、M-XQQX、莎莎、  \n" ..                             
-- "             青木奈、ChildWolf、ArteCyn、果果落格格 、风铃铃、\n" ..
-- "             蠢兔、绫濑Sama、等40人\n" ..
-- "    场景制作：太空小孩、菜菜hshs、农村青年β 、安基酸、Cui工作室\n" ..
-- "    特别感谢：祈inory、蛆虫音、平安夜的噩梦、岚AYA、喵特网 ！\n\n" ..
-- "    由于参与者过多！此处仅显示部分主力成员！")

	-- self.subChildren.LabelInfo:setLineHeight( 50)

    addBackEvent(self, function() 
            closeView(self)
        end)

end

return InfoView