local list = {1,2,4,12,6}
table.sort(list,function(a,b) 
    return a > b
end)
--从大到小排列
for i,v in ipairs(list) do
    print(i,v)
end
 
print(tonumber("0x4e5143"))