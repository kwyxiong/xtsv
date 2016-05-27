--
-- Author: kwyxiong
-- Date: 2016-01-19 16:40:07
--
-- import(".bodyPart")
-- import(".faxing")
-- import(".fuse")
-- import(".jiyaozhuang")
-- import(".kuzi")
-- import(".lianyizhuang")
-- import(".meimao")
-- import(".qunzi")
-- import(".shangyi")
-- import(".shipin")
-- import(".waitao")
-- import(".wazi")
-- import(".xiezi")



Global_cards =  getTableByJsonFile("cards.json")
Global_cards_id = {}
for k, v in ipairs(Global_cards.cards) do
	Global_cards_id[v.id] = v
end


local temp_clothes =getTableByJsonFile("clothes.json") 
Global_clothes = {}
Global_clothes_layer = {}

for k, v in ipairs(temp_clothes.clothes) do
	Global_clothes[v.id] = v
	local layer = v.parts[1].layer
	if not Global_clothes_layer[layer] then
		Global_clothes_layer[layer] = {}
	end
	Global_clothes_layer[layer][#Global_clothes_layer[layer] + 1] = v
end

Global_fashions =  getTableByJsonFile("fashions.json")
Global_levels =  getTableByJsonFile("levels.json")
-- dump(Global_levels, "Global_levels")

Global_setting =  getTableByJsonFile("setting.json")
Global_setting_layer = {}
Global_setting_empty = {}
for k, v in ipairs(Global_setting.part) do
	Global_setting_layer[v.layer] = v
	if v.keepEmpty and v.keepEmpty == 1 then
		Global_setting_empty[#Global_setting_empty + 1] = v.layer
	end
end

Global_setting2 =  getTableByJsonFile("setting2.json")
Global_tasks =  getTableByJsonFile("tasks.json").tasks
Global_tasks_id = {}
for k, v in ipairs(Global_tasks) do
	Global_tasks_id[v.id] = v
end
-- dump(Global_tasks_id, "Global_tasks_id")
Global_titles =  getTableByJsonFile("titles.json")


Global_posScales = {
	area_8 = {-147, -323, 0.7},
	area_12 = {-196, -353, 0.9},
	area_5 = {-198, -242, 0.9},
	area_4 = {-151, -254, 0.7},
	area_666 = {-162, -67, 0.8},
	area_6 = {-165, -83, 0.8},
	area_9 = {-153, -316, 1},
	area_3 = {-188, -444, 0.9},
	area_7 = {-215, -444, 1},
	area_110 = {-298, -651, 1.4},
	area_2 = {-315, -309, 1},
	area_233 = {-295, -330, 1},
	area_10 = {-137, -333, 1},
	area_1 = {-117, -301, 1},
	area_2 = {-317, -305, 1},
	area_11 = {-322, -738, 1.5},
}


Global_label_color3 = cc.c3b(102, 45, 19)
Global_label_color4 = cc.c4b(102, 45, 19, 255)



if not GuideManager then
	GuideManager = require("app.guide.GuideManager").new()
	GuideBase = require("app.guide.GuideBase")
end

import(".saveData")




