--
-- Author: kwyxiong
-- Date: 2016-04-01 16:26:24
--


function getDefaultSaveData()
	local data = {
			completeTasks = {},--已完成的主线/工作"id" = true
			
			viewTasks = {}, --已看过主线/工作 剧情 "id" = true
	
			unlockTasks = {},--已解锁的主线id
			clothes = {},--拥有的衣服 "id"  = time
			cards = {},--拥有的卡片 "id"  = time
			curShowCard = "0", --当前展示卡片
			name = "",--女主名称
			initRenWu = 0,--第一次任务模式 默认给5个任务

			showReward = {},--显示获得的服装 id
			showLevelUp = 0, -- 显示等级提升
			guides = {},	--已完成指引
			curRenWus = {},--当前任务{id = , time = } time 开始洽谈时间  -1 为获取时间
			renWuPool = {},--id,id,id 还能刷出来的工作任务
			signTime = "0",	--上次签到时间
			music = 1,
			sound = 1,
			exp = 0,
			title = 0,
			firstPlay = 1,--第一次进游戏默认播放PV
			guide = {},--已完成指引 "guide8"= true
			ml = tonumber(Global_setting2["first_ml"]),
			jb = tonumber(Global_setting2["first_money1"]),
			tb = tonumber(Global_setting2["first_money2"]),
		}
	for k = 1, 1 do
		data.unlockTasks[#data.unlockTasks + 1] = tonumber(Global_setting2.start_task)
	end
	-- for k = 1, 11 do
	-- 	data.viewTasks[100000 + k .. ""] = true
	-- end
	-- for k = 1, 8 do
	-- 	data.completeTasks[100000 + k .. ""] = true
	-- end

	for k, v in ipairs(Global_setting2.default_clothes) do
		data.clothes[v] = os.time()
		-- print(os.time())
		--这里的v如果是number GameState会报错
	end
	-- dump(data)
	return data
end

Global_saveData = "saveData_1"

-- dump(GameState)
-- Global_curMainTaskId

if not GameData[Global_saveData] then
	print("getDefaultSaveData()")
	GameData[Global_saveData] = getDefaultSaveData()
	GameState.save(GameData)
end

save = function(hide)
	GameState.save(GameData)
	if not hide then
		alert("游戏自动保存成功！")
	end
end


Global_vals = {
	nvzhuName = GameData[Global_saveData].name,
	jinglingName = Global_setting2["sprite_name"]
	
}

Global_task_type = 0 --当前在做的任务类型