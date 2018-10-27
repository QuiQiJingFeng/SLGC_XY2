local CSVLoder = require("common.CSVLoder")
local HardWareUtil = require("HardWareUtil")
local skynet = require("skynet")
local Constants = require("common/Constants")
local BIG_MAP = CSVLoder:LoadCSV("dm/res/resource/csv/big_map.csv")
local SMALL_MAP = CSVLoder:LoadCSV("dm/res/resource/csv/small_map.csv")
local NPC_MAP = CSVLoder:LoadCSV("dm/res/resource/csv/npc.csv")
local CommandCenter = require("common/CommandCenter")
local cmd_base = class("cmd_base")

FORBID_FLY_FLAG = false

function cmd_base:getBigMap()
	return BIG_MAP
end

function cmd_base:getSmallMap()
	return SMALL_MAP
end

function cmd_base:getNpcMap()
	return NPC_MAP
end

-- 小地图坐标系 左下角为0点
function cmd_base:convertToClient(name,pos,fromBigMap)
    local data = nil
    for _,conf in ipairs(SMALL_MAP) do
		if conf.name == name then
			data = conf
		end
	end
	if not data then
		skynet.error("缺少小地图区域数据 : ",name)
		return
	end

	local left = "resource/6.bmp"
	local right = "resource/7.bmp"
	local pos1 = DMCenter:FindPic(0,0,2000,2000,left,"020202",1,0)
	if not assert(pos1.x ~= 0 or pos1.y ~= 0,"FindPic SMALL_MAP.BOTTOM_LEFT FAILD") then
		return
	end

	local pos2 = DMCenter:FindPic(0,0,2000,2000,right,"020202",1,0)
	if not assert(pos2.x ~= 0 or pos2.y ~= 0,"FindPic SMALL_MAP.RIGHT_TOP FAILD") then
		return
    end
    --大地图打开像大雁塔那样的场景时需要特殊处理
    --但是小地图打开不需要特殊处理
    if fromBigMap and data.dx1 > 0 then
        local temp = clone(pos1)
        pos1.x = temp.x + data.dx1
        pos1.y = temp.y - data.dy1
        pos2.x = temp.x + data.dw + data.dx1
        pos2.y = temp.y - (data.dh + data.dy1)
    end
    
 
 	local width = math.abs(pos2.x-pos1.x)
 	local height = math.abs(pos2.y-pos1.y)
	--小地图的实际矩形大小(坐标系左下角)
    local rect = cc.rect(pos1.x,pos1.y,width,height)
	--小地图的虚拟矩形大小(坐标系左下角)
    local realRect = cc.rect(data.x,data.y,data.width,data.height)
	local xradio = rect.width/realRect.width
    local yradio = rect.height/realRect.height
    local size = DMCenter:GetClientSize()
	local x = math.ceil(pos1.x + pos.x * xradio)
    local y =  pos1.y - pos.y * yradio
	return cc.pos(x,y)
end

function cmd_base:getBigMapAreaAndPos()
	if not assert(DMCenter:UseDict(0),"UseDict ERROR index = ",0) then
		return
	end
	--长安[246,104]
	local conf = {
		x1 = 0 , y1 = 0 , x2 = 150 , y2 = 30 , corlor_format = "ffffff-000000", sim = 1
	}
	local data = DMCenter:Ocr(conf.x1,conf.y1,conf.x2,conf.y2,conf.corlor_format,conf.sim)
	local pos1 = string.find(data,"%[")
	local pos2 = string.find(data,",")
    local pos3 = string.find(data,"%]")
    local ret = {x=0,y=0}
	if pos1 and pos2 and pos3 then
		local name = string.sub(data,1,pos1-1)
        ret.name = DMCenter:GBKToUTF8(name)
        if ret.name == "大雁塔顶" then
            ret.name = "大雁塔七层"
        end
 		ret.x = string.sub(data,pos1+1,pos2-1)
 		ret.y = string.sub(data,pos2+1,pos3-1)
 		return ret
 	end
 	skynet.error("获取当前场景、坐标失败")
 	-->检测是否进入战斗界面,如果是则跳转到战斗
 	--并且在战斗之后重新调用这个方法返回数据
 	if CommandCenter:execute("1107","taopao") then
 		return self:getBigMapAreaAndPos()
 	end
 	return
end

--获取当前角色的实际屏幕坐标 --1个坐标==20 像素
function cmd_base:getCurPlayerPos()
	local size = DMCenter:GetClientSize()
	local center = cc.pos(math.ceil(size.width/2),math.ceil(size.height/2))
	local config = self:getBigMapAreaAndPos()
	
	local conf = nil
	local map = self:getSmallMap()
	for k,data in pairs(map) do
		if data.name == config.name then
			conf = data
		end
	end

	if not conf then
		skynet.error("ERROR NOT GET SMALL_MAP CONF ",config.name)
		return
	end
	
	local unit = 20
	local mapSize = cc.size(conf.width*unit,conf.height*unit)
	local x,y
	local curRealPos = cc.pos(config.x*unit,config.y*unit)
	if curRealPos.x >= size.width/2 and curRealPos.x <= mapSize.width - (size.width/2) then
	  x = center.x
	end
	if curRealPos.y >= size.height/2 and curRealPos.y <= mapSize.height -(size.height/2) then
		 y = center.y
	end

	if curRealPos.x < size.width/2 then
		x = curRealPos.x
	end
	if curRealPos.x > mapSize.width - (size.width/2) then
		x = size.width - (mapSize.width - curRealPos.x)
	end

	if curRealPos.y < size.height/2 then
		y = size.height - curRealPos.y
	end

	if curRealPos.y > mapSize.height - (size.height/2) then
		y = size.height - size.height/2 - (mapSize.height - curRealPos.y) + center.y
	end

	local cordPos = cc.pos(config.x,config.y)
	return cc.pos(x,y),cordPos
end

--禁止使用飞行棋<地府任务特殊需要>
function cmd_base:setForbidFlyFlag(flag)
	FORBID_FLY_FLAG = flag
end

function cmd_base:flyDown()
	if self:getCurFlyState() then
		HardWareUtil:KeyPad("alt+c")
		skynet.sleep(50)
	end
end

--cvtPos 目标点的屏幕位置
function cmd_base:checkFlyFlag(targetName,tarCPos,playerCpos)
	if FORBID_FLY_FLAG then
		return
	end
	HardWareUtil:MoveTo(600,200)
	skynet.sleep(30)
	local data = self:getBigMapAreaAndPos()
	if not data then
		skynet.error("获取当前场景名称、坐标失败")
		return
	end

	--如果目标位置有飞行棋
	--如果当前场景不是目标场景则直接飞过去
	--如果自己距离飞行棋的距离超过100像素,则飞过去
	local path = "resource/11.bmp|resource/12.bmp"
	local list = self:repeatFindEx(3,0,0,2000,2000,path,"020202",1.0,0)
	if #list <= 0 then
		--没有飞行棋
		return false
	end
 
	local array = {}
	for _,pos in ipairs(list) do
		pos.wight = distance(pos,tarCPos)
		table.insert(array,pos)
	end

	table.sort(array,function(a,b) 
			return a.wight < b.wight
		end)

	--飞行之前 先要 降落下来
	if self:getCurFlyState() then
		HardWareUtil:KeyPad("alt+c")
		skynet.sleep(50)
	end

	local flagPos = array[1]
	local playerDistance = distance(playerCpos,tarCPos)
	local flagDistance = distance(tarCPos,flagPos)
	local delt = 100 --如果相差在100像素之内则使用飞行棋
	if targetName ~= data.name or playerDistance - flagDistance > delt then
		HardWareUtil:MoveAndClick(array[1])
		skynet.sleep(50)
		HardWareUtil:MoveAndClick(cc.pos(176,273))
		skynet.sleep(50)
		return true
	end

	return false
end

--获取当前的飞行状态
function cmd_base:getCurFlyState()
	--打开飞行御器 界面
 	HardWareUtil:KeyPad("alt+u")
 	
    local path = "resource/13.bmp|resource/14.bmp"
    local array = self:repeatFindEx(10,100,100,800,600, path, "020202", 1, 0)
    if #array <= 0 then
        skynet.error("飞行状态查询失败")
        return
    end
 	local fly = false
   	local index = array[1].index
   	if index == 0 then
   		fly = false
   	elseif index == 1 then
   		fly = true
   	else
   		skynet.error("FLY STATE ERROR res = ",res)
   	end
	HardWareUtil:KeyPad("alt+u")

	return fly
end

function cmd_base:closeAllMap()
	local size = DMCenter:GetClientSize()
	local x = math.ceil(size.width/2)
	local y = math.ceil(size.height/2)
	HardWareUtil:MoveTo(x,y)

 
	HardWareUtil:DoubleRightClick()
	skynet.sleep(30)
 
end

--目標點附近才能使用這個方法,用來查找對話標誌
--type default is chat
--type -> "finger" is check finger
function cmd_base:chatPosition(targetPos,type)
	local playerCpos,playerPos = self:getCurPlayerPos()
	local dx = (targetPos.x - playerPos.x) * 20
	local dy = (playerPos.y - targetPos.y) * 20

	local x = playerCpos.x + dx
	local y = playerCpos.y + dy
	local targetCPos = cc.pos(x,y)

	local findChat = false
	local unit = 10
	for i=1,8 do
		HardWareUtil:MoveTo(targetCPos.x,targetCPos.y)
		skynet.sleep(10)
		if type == "finger" then
	    	local path = "resource/finger_1.bmp"
	    	local pos = DMCenter:FindPic(0,0,800,600,path,"020202",1,0.8)
	      	if pos.x ~= 0 or pos.y ~= 0 then
	      		findChat = true
	      		break
	      	end
	    else
	    	local path = "resource/chat_1.bmp|resource/chat_2.bmp|resource/chat_3.bmp|resource/chat_4.bmp"
		    local ret = DMCenter:FindPicExS(0,0,800,600, path, "020202", 1, 0)
		    if not (ret == "") then
		    	findChat = true
		    	break
		    end
	    end
		
	   	targetCPos.y = targetCPos.y - unit
	end
	if not findChat then
		return false
	end
	HardWareUtil:MoveAndClick(targetCPos)
	skynet.sleep(100)
	return true
end

function cmd_base:searchAndClickText(corlor_format,text)
	if not DMCenter:UseDict(1) then
		skynet.error("UseDict Failed")
		return
	end
	local list = DMCenter:GetWordsNew( 96, 127, 587+96, 362+127, corlor_format, 1)
	if not list or #list <= 0 then
		-- skynet.error("not search list item")
		return
	end
	local select = nil
	for _,obj in pairs(list) do
		if string.find(obj.word,text) then
			select = obj
		end
	end
	if not select then
		-- skynet.error("not select item text")
		return
	end
	HardWareUtil:MoveAndClick(select.pos)
   	return true
end

--解析当前任务栏任务，并返回其描述
function cmd_base:parseTask(taskName,corlor_format)
	if not CommandCenter:execute("1007") then
		skynet.error("打开任务面板失败")
		return
	end
	if not DMCenter:UseDict(1) then
		skynet.error("切换字库失败")
		return
	end
	local list
	local select = nil
	DMCenter:SetWordGap(10)
	for i=1,5 do
		list = DMCenter:GetWordsNew(149,160,149+149,234+160,"ffffff-101010|d2d000-303030|989413-303030",1)
		--检查当前是否有职业任务这个选项
		--如果没有,那么将所有处于打开状态的任务关闭 之后再次检查
		for i,obj in ipairs(list) do
			if string.find(obj.word,taskName) then
				select = obj
				break
			end
		end
		if select then
			break
		end
		--如果所有的都处于关闭状态了还没有找到职业任务
		local hasOpen = false
		for i=#list,1,-1 do
			local obj = list[i]
			if string.find(obj.word,"★") then
				HardWareUtil:MoveAndClick(obj.pos)
				skynet.sleep(1)
				hasOpen = true
			end
		end
		--没有职业任务
		if not hasOpen then
			if not CommandCenter:execute("1008") then
				skynet.error("关闭任务面板失败")
				return
			end
			return
		end
		HardWareUtil:MoveTo(600,300)
		skynet.sleep(10)
	end
	if not select then
		if not CommandCenter:execute("1008") then
			skynet.error("关闭任务面板失败")
			return
		end
		return
	end

	--如果处于关闭状态,那么打开它
	if string.find(select.word,"☆") then
		HardWareUtil:MoveAndClick(select.pos)
		skynet.sleep(20)
	end
	select.pos.y = select.pos.y + 20
	HardWareUtil:MoveAndClick(select.pos)
	skynet.sleep(20)
	corlor_format = corlor_format or "00ff00-101010"
	local str = DMCenter:Ocr(371,158,275+371,293+158,corlor_format,1)
	str = DMCenter:GBKToUTF8(str)

	if not CommandCenter:execute("1008") then
		skynet.error("关闭任务面板失败")
		return
	end
	return str
end

function cmd_base:repeatFind(num,x1, y1, x2, y2, pic_name, delta_color,sim,dir)
	local pos = nil
	num = num or 1
	for idx=1,num do
		pos = DMCenter:FindPic(x1, y1, x2, y2, pic_name, delta_color,sim, dir)
		if pos.x ~= 0 or pos.y ~= 0 then
			break
		end
		if num ~= idx then
			skynet.sleep(10)
		end
	end
	return (pos.x ~= 0 or pos.y ~= 0) and pos or nil
end

function cmd_base:repeatFindEx(num,x1, y1, x2, y2, pic_name, delta_color,sim,dir)
	local ret = ""
	num = num or 1
	for idx=1,num do
		ret = DMCenter:FindPicEx(x1, y1, x2, y2, pic_name, delta_color,sim, dir)
		if ret ~= "" then
	      break
	    end
		if num ~= idx then
			skynet.sleep(10)
		end
	end
	if ret == "" then
		return {}
	end
	local array = {}
	local list = string.split(ret,"|")
	for _,conf in ipairs(list) do
		local temp = string.split(conf,",")
		local data = {index=tonumber(temp[1]),x = tonumber(temp[2]),y=tonumber(temp[3])}
		table.insert(array,data)
	end
   	
	return array
end

function cmd_base:repeatFindExS(num,x1, y1, x2, y2, pic_name, delta_color,sim, dir)
	local ret = ""
	num = num or 1
	for idx=1,num do
		ret = DMCenter:FindPicExS(x1, y1, x2, y2, pic_name, delta_color,sim, dir)
		if ret ~= "" then
	      break
	    end
		if num ~= idx then
			skynet.sleep(10)
		end
	end
	if ret == "" then
		return {}
	end
	local array = {}
	local list = string.split(ret,"|")
	for _,conf in ipairs(list) do
		local temp = string.split(conf,",")
		local data = {name = temp[1],x = tonumber(temp[2]),y=tonumber(temp[3])}
		table.insert(array,data)
	end
   	
	return array
end

function cmd_base:repeatFindNotPicX(num,x1, y1, x2, y2, pic_name, delta_color,sim, dir,callback)
	local has = false
	for i=1,num do
		local list = self:repeatFindEx(1,x1, y1, x2, y2, pic_name, delta_color,sim, dir)
		if #list <= 0 then
			return true
		else
			callback()
		end
	end
end

--检测小地图是否为打开状态
--num 需要检测的次数 默认3次 耗时0-0.3s
--最坏的情况下,小地图没有打开,则耗时0.3s
function cmd_base:isSmallMapOpen(num)
	num = num or 1
	local smallOpen = self:repeatFind(num,0,0,800,600,"resource/2.bmp","020202",1,0)
	skynet.sleep(50)
	return smallOpen and true or false
end
--检测大地图是否为打开状态
--num 需要检测的次数 默认3次 耗时0-0.3s
--最坏的情况下,大地图没有打开,则耗时0.3s
function cmd_base:isBigMapOpen(num)
	num = num or 1
	local bigOpen = self:repeatFind(num,80,500,130,530,"resource/1.bmp","020202",1,0)
	return bigOpen and true or false
end

--之后可以替换成像素检测
--因为使用的是坐标检测是否停止移动,所以单位为s
function cmd_base:waitMoveEnd()
	local prePos = cc.pos(0,0)
 	while true do
 		local pos = self:getBigMapAreaAndPos()
 		local dist = distance(prePos,pos)
 		if dist == 0 then
 			break
 		end
    	prePos = pos
 		skynet.sleep(100)
 	end
end

function cmd_base:getArrayDataByKey(key,value,array)
	local data = nil
    for _,conf in ipairs(array) do
		if conf[key] == value then
			data = conf
		end
	end
	return data
end

return cmd_base