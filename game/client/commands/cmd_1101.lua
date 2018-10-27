local skynet = require("skynet")
local HardWareUtil = require("HardWareUtil")
local CommandCenter = require("common/CommandCenter")
local super = require("commands.cmd_base")
local cmd = class("cmd_1101",super)
--与指定NPC对话 小红点查找的方式
--npcName NPC的名字
--使用限制:当前场景 必须是NPC所在场景
--不能有旗帜挡住
--[[
	可以解决那些需要进入小场景的找人任务
	例如: 需要找长安城的王秀才,该人物在长安的某栋房子里
	在长安场景的时候可以使用这个方法 直接找到该NPC 并且与之对话
	--弹出对话框之后返回
--]]
function cmd:execute(npcName,skip)
  --小地图打开的情况下,假设该小地图为本场景的小地图
	if not CommandCenter:execute("1004") then
		skynet.error("打开小地图失败")
		return
	end
	skynet.sleep(100)
	HardWareUtil:SendGBKString(npcName)
  local pos = self:repeatFind(10,100,100,800,600,"resource/3.bmp","020202",1,0)
	if not pos then
		skynet.error("没有找到该NPC选项")
		return
	end

	pos.x = pos.x - math.random(50,80)
	pos.y = pos.y + 30
	HardWareUtil:MoveAndClick(pos)
  skynet.sleep(50)
	
  local path = "resource/4.bmp|resource/5.bmp"
  local array = self:repeatFindEx(5,100,100,800,600, path, "020202",1,0)
  if #array <= 0 then
    skynet.error("小红点被挡住了")
  end

  local pos = array[1]
  HardWareUtil:MoveAndClick(pos)
  if skip then
  	return true
  end
  --检测什么时候停止移动,那个时候对话框已经弹出来了
  self:waitMoveEnd()

  return true
end

return cmd