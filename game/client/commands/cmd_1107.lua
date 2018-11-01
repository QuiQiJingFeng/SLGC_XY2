local skynet = require "skynet"
local HardWareUtil = require "HardWareUtil"
local super = require "commands.base"
local cmd = class("cmd", super)


--进入战斗
function cmd:Execute(type,...)
	local path = "in_battle.bmp"
	local pos = self:RepeatFind(30,500,200,800,600,path,"020202",1,0)
	if not pos then
		return
	end
	game.log.info("[[进入战斗中]]")
	while true do
		local pos = self:RepeatFind(1,500,200,800,600,path,"020202",1,0)
		if not pos then
			game.log.info("[[战斗结束]]")
			--加血+加蓝
			--宠物加血
			local list = {
				{630,20},
				{760,25},
				{760,40}
			}
			for i,v in ipairs(list) do
				HardWareUtil:MoveToRightClick(_p(table.unpack(v)))
				skynet.sleep(10)
			end
			return true
		end
		--回合开始
		local pos = self:RepeatFind(1,500,200,800,600,"huihekaishi.bmp","020202",1,0)
		if pos then
			game.log.info("回合开始")
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
        game.log.errorf("不支持的命令[%s]",type)
        return
	end
end

function cmd:zhandou()
	HardWareUtil:KeyPad("f1")
	skynet.sleep(50)
	--查找绿色,因为怪物的名字就是绿色的
	local pos = game.dmcenter:FindColor( 0, 0, 300, 500, "3ceb37-101010", 1, 0)
	if pos.x == 0 and pos.y == 0 then
		game.log.warning("查找怪物颜色失败")
		return
	end
	local paths = {
			"fashu/1.bmp",
			"fashu/2.bmp",
			"fashu/3.bmp",
			"fashu/4.bmp",
			"fashu/5.bmp",
			"fashu/6.bmp",
			"fashu/7.bmp",
			"fashu/8.bmp",
			"fashu/9.bmp",
			"fashu/10.bmp",
			"fashu/11.bmp",
			"fashu/12.bmp"
		}
	local path = table.concat(paths,"|")
	HardWareUtil:MoveTo(pos.x,pos.y)
	skynet.sleep(10)
	local newpos = _clone(pos)
	local list
	for i=1,20 do
		list = self:RepeatFindEx(5,0, 0, 350, 500,path,"020202",1,0)
		if #list > 0 then
			break
		end
		local y = pos.y - 10  * i
		local x = pos.x + math.random(0, 20)
		HardWareUtil:MoveTo(x,y)
		newpos = _p(x,y)
		skynet.sleep(10)
	end
	if #list <= 0 then
		game.log.warning("没有找到法术释放标记")
		return
	end
	HardWareUtil:MoveAndClick(newpos)
	skynet.sleep(30)
	HardWareUtil:KeyPad("alt+a")
	HardWareUtil:MoveTo(0,0)
end
--names = "野鬼|幽灵"
function cmd:buzhuo(names)
	local yeguipaths = {
		"master/yegui/1.bmp",
		"master/yegui/2.bmp",
		"master/yegui/3.bmp",
		"master/yegui/4.bmp",
		"master/yegui/5.bmp",
		"master/yegui/6.bmp",
		"master/yegui/7.bmp",
		"master/yegui/8.bmp",
	}
	local yeguipath = table.concat(yeguipaths,"|")
	local youlingpaths = {
		"master/youling/1.bmp",
		"master/youling/2.bmp",
		"master/youling/3.bmp",
		"master/youling/4.bmp",
		"master/youling/5.bmp",
		"master/youling/6.bmp",
		"master/youling/7.bmp",
		"master/youling/8.bmp",
		"master/youling/9.bmp",
		"master/youling/10.bmp",
		"master/youling/11.bmp",
		"master/youling/12.bmp"
	}
	local youlingpath = table.concat(youlingpaths,"|")
	local paths = string.gsub(names,"野鬼",yeguipath)
	paths = string.gsub(paths,"幽灵",youlingpath)
	local list = self:RepeatFindEx(10,0, 0, 400, 600, paths, "101010",1,0)
	if #list <= 0 then
		game.log.debug("没有找到要捕捉的怪物,进入战斗状态")
		return self:zhandou()
	end

	local master_pos = list[1]
	local path = "buzhuo.bmp"
	local pos = self:RepeatFind(5,600, 300, 800, 600, path, "020202",1,0)
	if not pos then
		game.log.debug("查找捕捉按钮失败")
		return
	end
	--点击捕捉按钮
	HardWareUtil:MoveAndClick(pos)
	skynet.sleep(50)
	--移动到怪物的头上并点击
	HardWareUtil:MoveAndClick(master_pos)
	skynet.sleep(50)
	--召唤兽进行防御
	HardWareUtil:KeyPad("alt+d")
	HardWareUtil:MoveTo(0,0)
end

function cmd:taopao()
	local path = "taopao.bmp"
	local pos = self:RepeatFind(5,600, 300, 800, 600, path, "020202",1,0)
	if not pos then
		game.log.debug("查找逃跑图片失败")
		return
	end
	--点击逃跑按钮
	HardWareUtil:MoveAndClick(pos)
	--召唤兽进行攻击
	HardWareUtil:KeyPad("alt+a")
	HardWareUtil:MoveTo(0,0)
end

return cmd