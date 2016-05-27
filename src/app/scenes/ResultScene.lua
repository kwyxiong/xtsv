--
-- Author: kwyxiong
-- Date: 2016-04-03 11:26:45
--


local ResultScene = class("ResultScene", function()
    return display.newScene("ResultScene")
end)

function ResultScene:ctor(score, grade, taskData, clothes)
	cc.GameObject.extend(self)
	self:addComponent("app.utils.UISceneProtocol"):exportMethods()

	self.bg1 = display.newSprite("woshi.jpg")
		-- :zorder(gz("bg"))
    	:pos(display.cx, display.cy)
		:addTo(self)

        self.bg1:setScale(1270 / 1000)
	local bg = display.newSprite("image190.jpg")
		-- :zorder(gz("bg"))
    	:pos(0, 0)
		:addTo(self)
	bg:setAnchorPoint(cc.p(0, 0))
	bg:setScaleX(display.width / 800)
	bg:setOpacity(155)
    
    self.node = display.newNode()
        
    self.node:runAction(cc.MoveBy:create(0.2, cc.p(-200,0)))

    local shadow = display.newSprite("charaContainer0001.png")
        :pos(295 + 90 , 31)
        :addTo(self.node)
    -- drug(shadow)
    self.bodyNode = display.newNode()
        :pos(88 + 90 , -17)
        :addTo(self.node)

    for k, v in pairs(clothes) do
        self:wear(v.data.id)
    end

    -- showView("MenuView")
    local success = false
   
    local tb = {}
    tb["S"] = Global_setting2["get_ml"][1]
    tb["A"] = Global_setting2["get_ml"][2]
    tb["B"] = Global_setting2["get_ml"][3]
    tb["C"] = Global_setting2["get_ml"][4]
    tb["D"] = Global_setting2["get_ml"][5]
    tb["E"] = Global_setting2["get_ml"][6]
    tb["F"] = Global_setting2["get_ml"][7]
    local ml = math.floor(score*tb[grade])

    local money = taskData.money
    local exp = taskData.exp
    local moneyStr = taskData.money
    local expStr = taskData.exp
    local newTitle
    local newTask 

    if grade == "S" or grade == "A" or grade == "B" or grade == "C" then
    	--任务完成
    	success = true

    	local unlockId = taskData.nextTask[1]
    	local unlockTasks = GameData[Global_saveData].unlockTasks
    	local has = false
    	for k, v in ipairs(unlockTasks) do
    		if v .. "" == unlockId then
    			has = true
    			break
    		end
    	end
    	if not has and unlockId ~= "" then
            
    		GameData[Global_saveData].unlockTasks[#GameData[Global_saveData].unlockTasks + 1] = tonumber(unlockId)
            newTask = tonumber(unlockId)
    	else
            
    	end

    	GameData[Global_saveData].completeTasks[taskData.id .. ""] = true

        for k, v in ipairs(Global_titles.titles) do
            if v.getTask == unlockId .. "" and tonumber(v.level) > GameData[Global_saveData].title then
                newTitle = v
                GameData[Global_saveData].title = tonumber(v.level)

                self:updateRenWuPool()
            end
        end

        if taskData.type == 3 then
            for k, v in ipairs(GameData[Global_saveData].curRenWus) do
                if v.id == taskData.id then
                    table.remove(GameData[Global_saveData].curRenWus, k)
                    break
                end
            end
            qiatan()

        end
        -- dump(Global_cards_id, "Global_cards_id")

        local curCard = Global_cards_id[GameData[Global_saveData].curShowCard]
        -- dump(curCard)
        if curCard then
            if curCard.addType == "money" then
                
                money = math.floor(money * (1 + tonumber(curCard.addValue)))
                moneyStr = money.." +" .. tonumber(curCard.addValue) * 100 .. "%"
            elseif curCard.addType == "exp" then
               
                exp = math.floor(exp * (1 + tonumber(curCard.addValue)))
                expStr = exp.." +" .. tonumber(curCard.addValue) * 100 .. "%"
            end
        end
        -- dump(taskData.award, "taskData.award")
        if #taskData.award > 0 then
            for k = #taskData.award, 1, -1  do
                if taskData.award[k] == "" or not Global_clothes[tonumber(taskData.award[k])] then
                    table.remove(taskData.award, k)
                end
            end
            if #taskData.award > 0 then
                for k, v in ipairs(taskData.award) do
                    GameData[Global_saveData].showReward[#GameData[Global_saveData].showReward + 1] = tonumber(v)

                    GameData[Global_saveData].clothes[v] = os.time()
                end 
            end
        end
    	--金钱
    	GameData[Global_saveData].jb = GameData[Global_saveData].jb + money
    	--经验
    	GameData[Global_saveData].exp = GameData[Global_saveData].exp + exp

        -- if getLevel() > GameData[Global_saveData].showLevelUp then

        -- end

    	--魅力
    	GameData[Global_saveData].ml = GameData[Global_saveData].ml + ml
    	GameState.save(GameData)
    end
    if success then
        
        


    	local view = showView("ResultView", {score = score, grade = grade, money = moneyStr,newTitle = newTitle,newTask = newTask,
        exp = expStr , ml = ml , afterStory = taskData.afterStory, taskData = taskData })
        self.node:addTo(view.subChildren.Panel)
    else
    	local view = showView("ResultView", {score = score, grade = grade, money = 0, exp = 0, ml = 0 , taskData = taskData })
        self.node:addTo(view.subChildren.Panel)

    end
    -- autoAdjust(self.node, 1)
end

function ResultScene:updateRenWuPool()
    local curRenWus = GameData[Global_saveData].curRenWus
    local curRenWus_id = {}
    local renWuPool = GameData[Global_saveData].renWuPool
    local renWuPool_id = {}

    local completeTasks = GameData[Global_saveData].completeTasks

    local myTitle = GameData[Global_saveData].title

    for k, v in ipairs(curRenWus) do
        curRenWus_id[v.id] = true
    end

    for k, v in ipairs(renWuPool) do
        renWuPool_id[v] = true
    end
    for k, v in ipairs(Global_tasks) do
        if v.type == 3 and v.needTitle <= myTitle and not curRenWus_id[v.id] and not renWuPool_id[v.id] and not completeTasks[v.id ..""] then
            GameData[Global_saveData].renWuPool[#GameData[Global_saveData].renWuPool + 1] = v.id
        end
    end
end



function ResultScene:wear(id)
    id = tonumber(id)
    -- dump(Global_clothes, "Global_clothes")
    -- print("id", id)
    local data = Global_clothes[id]
    -- dump(data, "data")
    local sps = {}
    local layer = "0"   
    for k, v in ipairs(data.parts) do
        if v.img ~= "" then
            if k == 1 then
                layer = v.layer
            end
            local sp = display.newSprite(v.img)
                :pos(v.fix.x, 600 - v.fix.y)
                :zorder(tonumber(v.layer) * 10)
                :addTo(self.bodyNode)
            sp:setAnchorPoint(cc.p(0, 1))
            sps[#sps + 1] = sp
            -- print("hhhhhhhhhhhhhhhh")
        end
    end

end

function ResultScene:onEnter()
end

function ResultScene:onExit()
	
end

return ResultScene
