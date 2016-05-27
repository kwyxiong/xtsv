require("config")
require("cocos.init")
require("framework.init")

require("app.utils.init")
require("app.nano.init")

require("app.managers.init")
GameState=require(cc.PACKAGE_NAME .. ".cc.utils.GameState") 
if display.width > 800 then
    -- Game_800_600 = 1
end
GameData={}

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()


 
    --wjnezka2


    -- dump(GameData[Global_saveData])
    MyApp.super.ctor(self)

    self:addEventListener("APP_ENTER_BACKGROUND_EVENT", function() broadCastMsg("APP_ENTER_BACKGROUND_EVENT") end)
    self:addEventListener("APP_ENTER_FOREGROUND_EVENT", function() broadCastMsg("APP_ENTER_FOREGROUND_EVENT") end)

    GameState.init(function (param)
        local returnValue = nil
        -- dump(param)
        if param.errorCode then
            print("GameState Error")
        else
            print("GameState Right")
       
            if param.name == "save" then
                local str = json.encode(param.values)
                str = crypto.encryptXXTEA(str, "abcd")

                returnValue = {data = str}
            elseif param.name == "load" then
                local str = crypto.decryptXXTEA(param.values.data, "abcd")
                -- print(str)
                returnValue = json.decode(str)
            end
        end
        return returnValue
    end,"data.txt","4590545")

    -- print("aaaaaaaaa",GameState.getGameStatePath())
    if io.exists(GameState.getGameStatePath()) then
        -- print("dddddddd",GameState.getGameStatePath())
        GameData = GameState.load()
        -- dump(GameData)
    end


    
end

function MyApp:run()
    cc.FileUtils:getInstance():addSearchPath("res/")
    cc.FileUtils:getInstance():addSearchPath("res/icon")
    cc.FileUtils:getInstance():addSearchPath("res/images")
    cc.FileUtils:getInstance():addSearchPath("res/bg")
    cc.FileUtils:getInstance():addSearchPath("res/bird")

    cc.FileUtils:getInstance():addSearchPath("res/chara/jingling")
    cc.FileUtils:getInstance():addSearchPath("res/chara/NPC")
    cc.FileUtils:getInstance():addSearchPath("res/chara/nvzhu")
    cc.FileUtils:getInstance():addSearchPath("res/chara/nvzhu/gongshi")
    cc.FileUtils:getInstance():addSearchPath("res/chara/suzixuan")
    cc.FileUtils:getInstance():addSearchPath("res/chara/yifeng")
    cc.FileUtils:getInstance():addSearchPath("res/snd/bgm")
	cc.FileUtils:getInstance():addSearchPath("res/cg/CG")
    cc.FileUtils:getInstance():addSearchPath("res/camera")

    cc.FileUtils:getInstance():addSearchPath("res/data/card")
    cc.FileUtils:getInstance():addSearchPath("res/data/table")
    cc.FileUtils:getInstance():addSearchPath("res/data/bgm")
    cc.FileUtils:getInstance():addSearchPath("res/data/sound")
    cc.FileUtils:getInstance():addSearchPath("res/data/fashions")

  
    package.loaded["app.data.init"] = nil
    package.loaded["app.data.saveData"] = nil
    require("app.data.init")
    
    
    self:enterScene("StartScene")


--wjnezka2
    -- self:enterScene("LoadingScene")

end

return MyApp
