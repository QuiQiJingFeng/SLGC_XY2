local Bezier = {}

function Bezier:Convert(posArray,num)
	local size = #posArray
	if size < 2 then
		return
	end
	local xarray = {}
    local yarray = {}
	local startIdx = 1
	
	local bezierPositions = {}
	num = num or 100  --默认取曲线上的100个样本点
    for t = 0, 1, 1/num do
        --当i = 2 的时候就已经把三阶bezier曲线计算出来了,所以N阶的话i最大为size-1
        for i = startIdx, size-1 do
            --因为计算公式中有j+1,,所以j的最大取值为size-1
			for j = startIdx, size - i do
				for tmp = 1,1 do  --模拟continue
					if i == startIdx then --i==startIdx+1时,第一次迭代,由已知控制点计算
						xarray[j] = posArray[j].x * (1 - t) + posArray[j + 1].x * t;
						yarray[j] = posArray[j].y * (1 - t) + posArray[j + 1].y * t;
						break
					end
					-- i != 2时,通过上一次迭代的结果计算
					xarray[j] = xarray[j] * (1 - t) + xarray[j + 1] * t;
					yarray[j] = yarray[j] * (1 - t) + yarray[j + 1] * t;
				end
            end
        end
        --经过多轮合并之后最后叠加的结果被放在第一个元素中
		--这么多轮的合并只是为了计算出一个再bezier曲线上的点...
		table.insert(bezierPositions,{x=xarray[1],y=yarray[1]})
	end
	return bezierPositions
end

-- 将所有的坐标改成整数的,并剔除重复的坐标
function Bezier:Filter(bezierPositions)
	local filters = {}
	for _, pos in ipairs(bezierPositions) do
		pos.x = math.floor(pos.x)
		pos.y = math.floor(pos.y)
		if filters[tostring(pos.x)..tostring(y)] then
			pos.remove = true
		else
			filters[tostring(pos.x)..tostring(y)] = true
		end
	end

	for i = #bezierPositions, 1,-1 do
		local pos = bezierPositions[i]
		if pos.remove then
			table.remove(bezierPositions,i)
		end
	end
	return bezierPositions
end

function Bezier:BezierTo(source,target,num)
	local controlNum = math.random(3,5)
	local dx = target.x - source.x
	local dy = target.y - source.y
	local array = {source}
    for i = 1, controlNum do
        local zf = math.random(0,1) > 0.5 and 1 or -1
		local x = source.x + dx/controlNum * i
		local y = source.y + dy/controlNum * i + zf * math.random(50,100)
		local pos = {x=x,y=y}
		table.insert(array,pos)
	end
	table.insert(array,target)

	local bezierPositions = self:Convert(array,num)
	self:Filter(bezierPositions)
	return bezierPositions
end

return Bezier

--[[
	local Bezier = require("Bezier")
	function pos(x,y)
		return {x=x,y=y}
	end
	local array = Bezier:Convert({pos(0,0),pos(200,600),pos(300,200),pos(400,400),pos(500,300),pos(400,200)})
	Bezier:Filter(array)
]]