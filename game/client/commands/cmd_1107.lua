local skynet = require("skynet")
local HardWareUtil = require("HardWareUtil")
local super = require("commands.cmd_base")
local cmd = class("cmd_1107",super)

--进入战斗
function cmd:execute(type,...)
	local path = "resource/in_battle.bmp"
	local pos = self:repeatFind(5,500,200,800,600,path,"020202",1,0)
	if not pos then
		skynet.error("当前没有进入战斗界面")
		return
	end
	skynet.error("进入战斗中。。")
	while true do
		local pos = self:repeatFind(1,500,200,800,600,path,"020202",1,0)
		if not pos then
			skynet.error("战斗结束")
			--加血+加蓝
			--宠物加血
			HardWareUtil:MoveToRightClick(cc.pos(630,20))
			skynet.sleep(10)
			HardWareUtil:MoveToRightClick(cc.pos(780,25))
			skynet.sleep(10)
			HardWareUtil:MoveToRightClick(cc.pos(780,40))

			return true
		end
		--回合开始
		local pos = self:repeatFind(1,500,200,800,600,"resource/huihekaishi.bmp","020202",1,0)
		if pos then
			skynet.error("回合开始")
			self:update(type,...)
		end
		skynet.sleep(100)
	end
end

function cmd:update(type,...)
	if type == "zhandou" then
		self:zhandou(...)
	elseif type == "buzhuo" then
		self:buzhuo(...)
	elseif type == "taopao" then
		self:taopao(...)
	else
		skynet.error("战斗参数错误")
	end
end

function cmd:zhandou()
	HardWareUtil:KeyPad("f1")
	skynet.sleep(30)
	local pos = DMCenter:FindColor( 0, 0, 300, 500, "3ceb37-101010", 1, 0)
	if pos.x == 0 and pos.y == 0 then
		skynet.error("查找颜色失败")
		return
	end
	local paths = {
			"resource/jinzhi/1.bmp",
			"resource/jinzhi/2.bmp",
			"resource/jinzhi/3.bmp",
			"resource/jinzhi/4.bmp",
			"resource/jinzhi/5.bmp",
			"resource/jinzhi/6.bmp",
			"resource/jinzhi/7.bmp",
			"resource/jinzhi/8.bmp",
			"resource/jinzhi/9.bmp",
		}
	local path = table.concat(paths,"|")
	HardWareUtil:MoveTo(pos.x,pos.y)
	skynet.sleep(10)
	local nofind = self:repeatFindNotPicX(10,0, 0, 300, 500,path,"020202",1,0,function() 
			pos.y = pos.y - 20
			pos.x = pos.x + math.random(10,30)
			HardWareUtil:MoveTo(pos.x,pos.y)
			skynet.sleep(10)
		end)
	if not nofind then
		skynet.error("没有找到法术释放标记")
		return
	end
	HardWareUtil:LeftClick()
	skynet.sleep(30)
	HardWareUtil:KeyPad("alt+a")

	HardWareUtil:MoveTo(500,100)
end
--names = "野鬼|幽灵"
function cmd:buzhuo(names)
	local yeguipaths = {
		"resource/master/yegui/1.bmp",
		"resource/master/yegui/2.bmp",
		"resource/master/yegui/3.bmp",
		"resource/master/yegui/4.bmp",
		"resource/master/yegui/5.bmp",
		"resource/master/yegui/6.bmp",
		"resource/master/yegui/7.bmp",
		"resource/master/yegui/8.bmp",
	}
	local yeguipath = table.concat(yeguipaths,"|")
	local youlingpaths = {
		"resource/master/youling/1.bmp",
		"resource/master/youling/2.bmp",
		"resource/master/youling/3.bmp",
		"resource/master/youling/4.bmp",
		"resource/master/youling/5.bmp",
		"resource/master/youling/6.bmp",
		"resource/master/youling/7.bmp",
		"resource/master/youling/8.bmp",
		"resource/master/youling/9.bmp",
		"resource/master/youling/10.bmp",
		"resource/master/youling/11.bmp",
		"resource/master/youling/12.bmp"
	}
	local youlingpath = table.concat(youlingpaths,"|")
	local paths = string.gsub(names,"野鬼",yeguipath)
	paths = string.gsub(paths,"幽灵",youlingpath)
	local list = self:repeatFindEx(5,0, 0, 300, 500, paths, "020202",1,0)
	if #list <= 0 then
		skynet.error("没有找到怪物图片 日了狗")
		return self:zhandou()
	end

	local master_pos = list[1]
	local path = "resource/buzhuo.bmp"
	local pos = self:repeatFind(5,600, 300, 800, 600, path, "020202",1,0)
	if not pos then
		skynet.error("查找捕捉图片失败")
		return
	end
	HardWareUtil:MoveAndClick(pos)
	skynet.sleep(30)
	HardWareUtil:MoveAndClick(master_pos)
	skynet.sleep(30)
	HardWareUtil:KeyPad("alt+d")
	HardWareUtil:MoveTo(500,100)
end

function cmd:taopao()
	local path = "resource/taopao.bmp"
	local pos = self:repeatFind(5,600, 300, 800, 600, path, "020202",1,0)
	if not pos then
		skynet.error("查找逃跑图片失败")
		return
	end
	HardWareUtil:MoveAndClick(pos)
	HardWareUtil:MoveTo(500,100)
	HardWareUtil:KeyPad("alt+a")
end

return cmd