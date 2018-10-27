local cc = {}

function cc.pos(x,y)
	return {x = x , y = y}
end

function cc.rect(x,y,width,height)
	return {x = x , y = y , width = width , height = height}
end

return cc