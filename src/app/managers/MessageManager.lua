--
-- Author: kwyxiong
-- Date: 2016-01-23 17:20:28
--
-- 消息管理器，用于派发模块之间的消息
_MSG_DISPATCHER={}
--让它可添加组件
cc.GameObject.extend(_MSG_DISPATCHER)
--添加事件组件,让它可处理事件
_MSG_DISPATCHER:addComponent("components.behavior.EventProtocol"):exportMethods()
-- _MSG_DISPATCHER:getComponent("components.behavior.EventProtocol").debug_ = not IS_RELEASE
--事件代理(有BUG)
-- _MSG_PROXY = cc.EventProxy.new(_MSG_DISPATCHER)





-- 广播消息
function broadCastMsg(name, data)
	-- print("broadCastMsg " ..name)

	_MSG_DISPATCHER:dispatchEvent({name = name, data = data})
	-- if CUR_UI_SCENE and CUR_UI_SCENE.clothes then
	-- 	for k, v in pairs(CUR_UI_SCENE.clothes) do
	-- 		print(v.switch)
	-- 	end
	-- end
end

-- 注册消息
--返回一个ID,用于取消侦听
function regCallBack(eventName, callBack)
	assert(callBack,"CallBack function must not be nil!")
	return _MSG_DISPATCHER:addEventListener(eventName, callBack)
end

-- 取消消息的注册
function unRegCallBack( msg )
	if msg.msgId then
		_MSG_DISPATCHER:removeEventListener( msg.msgId )
	end
end

function dumpAllEventListeners()
	_MSG_DISPATCHER:getComponent("components.behavior.EventProtocol"):dumpAllEventListeners()
end
