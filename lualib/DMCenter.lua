local CPLUS = require("CPLUS")
local skynet = require "skynet"
local DMCenter = {}

---------------------------键盘鼠标操作--------------------------------------------

DMCenter["KEY_CODE"] ={
    ["1"]=49,
    ["2"]=50,
    ["3"]=51,
    ["4"]=52,
    ["5"]=53,
    ["6"]=54,
    ["7"]=55,
    ["8"]=56,
    ["9"]=57,
    ["0"]=48,
    ["-"]=189,
    ["="]=187,
    ["back"]=8,

    ["a"]=65,
    ["b"]=66,
    ["c"]=67,
    ["d"]=68,
    ["e"]=69,
    ["f"]=70,
    ["g"]=71,
    ["h"]=72,
    ["i"]=73,
    ["j"]=74,
    ["k"]=75,
    ["l"]=76,
    ["m"]=77,
    ["n"]=78,
    ["o"]=79,
    ["p"]=80,
    ["q"]=81,
    ["r"]=82,
    ["s"]=83,
    ["t"]=84,
    ["u"]=85,
    ["v"]=86,
    ["w"]=87,
    ["x"]=88,
    ["y"]=89,
    ["z"]=90,

    ["ctrl"]=17,
    ["alt"]=18,
    ["shift"]=16,
    ["win"]=91,
    ["space"]=32,
    ["cap"]=20,
    ["tab"]=9,
    ["~"]=192,
    ["esc"]=27,
    ["enter"]=13,

    ["up"]=38,
    ["down"]=40,
    ["left"]=37,
    ["right"]=39,

    ["option"]=93,

    ["print"]=44,
    ["delete"]=46,
    ["home"]=36,
    ["end"]=35,
    ["pgup"]=33,
    ["pgdn"]=34,

    ["f1"]=112,
    ["f2"]=113,
    ["f3"]=114,
    ["f4"]=115,
    ["f5"]=116,
    ["f6"]=117,
    ["f7"]=118,
    ["f8"]=119,
    ["f9"]=120,
    ["f10"]=121,
    ["f11"]=122,
    ["f12"]=123,

    ["["]=219,
    ["]"]=221,
    ["\\"]=220,
    [";"]=186,
    ["'"]=222,
    ["]="]=188,
    ["."]=190,
    ["/"]=191,
}

--x1,y1,x2,y2 --检查鼠标位置的影响
function DMCenter:checkMousePosEffect(...)
    -- local rect = {...}
    -- local pos = self:GetCursorPos()
    -- if _rectInPos(rect,pos) then
    --     local x = pos.x + math.random(10,50)
    --     local y = rect[4] + math.random(50,100)
    --     self:MoveTo(x,y)
    --     skynet.sleep(30)
    -- end
end

function DMCenter:GBKToUTF8(str)
    return CPLUS.DmCenter.GBKToUTF8(str)
end

function DMCenter:UTF8ToGBK(str)
    return CPLUS.DmCenter.UTF8ToGBK(str)
end

--创建并获取大漠引用ID
function DMCenter:createDM( )
    return CPLUS.DmCenter.createDM()
end

function DMCenter:Init( dm,hwnd)
    self.__dm = dm
    self.__hwnd = hwnd
end

function DMCenter:GetDm()
    return self.__dm
end

function DMCenter:GetHwnd()
    return self.__hwnd
end

--按住指定的虚拟键码
function DMCenter:KeyDownChar( key)
    return CPLUS.DmCenter.KeyDown(self.__dm,self["KEY_CODE"][key]) == 1
end
--按住指定的虚拟键码
function DMCenter:KeyDown( code)
    return CPLUS.DmCenter.KeyDown(self.__dm,code) == 1
end
--按下指定的虚拟键码
function DMCenter:KeyPress( code)
    return CPLUS.DmCenter.KeyPress(self.__dm,code) == 1
end
--按下指定的虚拟键码
function DMCenter:KeyPressChar( key)
    return CPLUS.DmCenter.KeyPress(self.__dm,self["KEY_CODE"][key]) == 1
end
--根据指定的字符串序列，依次按顺序按下其中的字符.
function DMCenter:KeyPressStr( content)
    return CPLUS.DmCenter.KeyPressStr(self.__dm,content) == 1
end

--弹起来虚拟键vk_code
function DMCenter:KeyUp( code)
    return CPLUS.DmCenter.KeyUp(self.__dm,code) == 1
end

--弹起来虚拟键key_str
function DMCenter:KeyUpChar( key)
    return CPLUS.DmCenter.KeyUp(self.__dm,self["KEY_CODE"][key]) == 1
end

--组合键
function DMCenter:KeyGroup(groupkey)
    local list = string.split(groupkey,"+")
    local result = true
    for i,key in ipairs(list) do
        result = self:KeyDown(self["KEY_CODE"][key])
        if not result then
            return false
        end
    end

    for i,key in ipairs(list) do
        result = self:KeyUp(self["KEY_CODE"][key])
        if not result then
            return false
        end
    end
    return true
end



--获取当前鼠标位置
function DMCenter:GetCursorPos( )
    return CPLUS.DmCenter.GetCursorPos(self.__dm)
end

--按下鼠标左键
function DMCenter:LeftClick( )
    return CPLUS.DmCenter.LeftClick(self.__dm) == 1
end

--双击鼠标左键
function DMCenter:LeftDoubleClick( )
    return CPLUS.DmCenter.LeftDoubleClick(self.__dm) == 1
end

--按住鼠标左键
function DMCenter:LeftDown( )
    return CPLUS.DmCenter.LeftDown(self.__dm) == 1
end

--弹起鼠标左键
function DMCenter:LeftUp( )
    return CPLUS.DmCenter.LeftUp(self.__dm) == 1
end

--按下鼠标中键
function DMCenter:MiddleClick( )
    return CPLUS.DmCenter.MiddleClick(self.__dm) == 1
end

--按住鼠标中键
function DMCenter:MiddleDown( )
    return CPLUS.DmCenter.MiddleDown(self.__dm) == 1
end

--弹起鼠标中键
function DMCenter:MiddleUp( )
    return CPLUS.DmCenter.MiddleUp(self.__dm) == 1
end

--[[
    鼠标相对于上次的位置移动rx,ry.    
    从6.1548版本开始,如果您要使鼠标移动的距离和指定的rx,ry一致,
    最好配合SetMouseSpeed和EnableMouseAccuracy函数来使用.
    rx 整形数:相对于上次的X偏移
    ry 整形数:相对于上次的Y偏移
]]
function DMCenter:MoveR( rx,ry)
    return CPLUS.DmCenter.MoveR(self.__dm,rx,ry) == 1
end

--把鼠标移动到目的点(x,y)
--[[
    x 整形数:X坐标
    y 整形数:Y坐标
]]
function DMCenter:MoveTo(x,y)
    return CPLUS.DmCenter.MoveTo(self.__dm,x,y) == 1
end

--把鼠标移动到目的范围内的任意一点
--[[
x 整形数:X坐标
y 整形数:Y坐标
w 整形数:宽度(从x计算起)
h 整形数:高度(从y计算起)
返回值:
字符串:
返回要移动到的目标点. 格式为x,y.  比如MoveToEx 100,100,10,10,返回值可能是101,102
]]
function DMCenter:MoveToEx( x,y,w,h)
    return CPLUS.DmCenter.MoveToEx(self.__dm,x,y,w,h)
end

--按下鼠标右键
function DMCenter:RightClick( )
    return CPLUS.DmCenter.RightClick(self.__dm) == 1
end

--按住鼠标右键
function DMCenter:RightDown( )
    return CPLUS.DmCenter.RightDown(self.__dm) == 1
end

--弹起鼠标右键
function DMCenter:RightUp( )
    return CPLUS.DmCenter.RightUp(self.__dm) == 1
end

--设置按键时,键盘按下和弹起的时间间隔。高级用户使用。某些窗口可能需要调整这个参数才可以正常按键。
--[[

type 字符串: 键盘类型,取值有以下

    "normal" : 对应normal键盘  默认内部延时为30ms

    "windows": 对应windows 键盘 默认内部延时为10ms

    "dx" :     对应dx 键盘 默认内部延时为50ms

delay 整形数: 延时,单位是毫秒
]]
function DMCenter:SetKeypadDelay( type,delay)
    return CPLUS.DmCenter.SetKeypadDelay(self.__dm,type,delay) == 1
end

--[[
    设置鼠标单击或者双击时,鼠标按下和弹起的时间间隔。
    高级用户使用。某些窗口可能需要调整这个参数才可以正常点击
type 字符串: 鼠标类型,取值有以下

     "normal" : 对应normal鼠标 默认内部延时为 30ms

     "windows": 对应windows 鼠标 默认内部延时为 10ms

     "dx" :     对应dx鼠标 默认内部延时为40ms

delay 整形数: 延时,单位是毫秒

]]
function DMCenter:SetMouseDelay( type,delay)
    return CPLUS.DmCenter.SetMouseDelay(self.__dm,type,delay) == 1
end


--[[
    设置系统鼠标的移动速度.一共分为11个级别. 从1开始,11结束。此接口仅仅对MoveR接口起作用.
    speed 整形数:鼠标移动速度, 最小1，最大11.  居中为6. 推荐设置为6

]]
function DMCenter:SetMouseSpeed( speed)
    return CPLUS.DmCenter.SetMouseSpeed(self.__dm,speed) == 1
end

--[[
    设置前台键鼠的模拟方式. 
    驱动功能支持的系统版本号为
    (win7/win8/win8.1/win10(10240)/win10(10586)/win10(14393)/win10(15063)/win10(16299)/win10(17134)
    不支持所有的预览版本,仅仅支持正式版本.  除了模式3,其他模式同时支持32位系统和64位系统.
mode 整形数: 
    0 正常模式(默认模式)
    1 硬件模拟
    2 硬件模拟2(ps2)（仅仅支持标准的3键鼠标，即左键，右键，中键，带滚轮的鼠标,2键和5键等扩展鼠标不支持）
    3 硬件模拟3
返回值:
    整形数:
    0  : 插件没注册
    -1 : 32位系统不支持
    -2 : 驱动释放失败.
    -3 : 驱动加载失败.可能是权限不够. 参考UAC权限设置. 或者是被安全软件拦截. 
        如果是WIN10 1607之后的系统，出现这个错误，可参考这里
    -10: 设置失败
    -7 : 系统版本不支持. 可以用winver命令查看系统内部版本号. 驱动只支持正式发布的版本，所有预览版本都不支持.
    1  : 成功
示例:

dm.SetSimMode 1
…
dm_ret = dm.BindWindow(hwnd,"normal","normal","normal",0)
...
dm.UnBindWindow


除了模式0,其他方式需要加载驱动，所以调用进程必须有管理员权限,参考如何关闭UAC.
加载驱动时，必须让安全软件放行. 否则模拟无效.

硬件模拟1,没有对键鼠的接口类型有任何限制(PS/2 USB接口)都可以模拟，甚至不插任何键鼠设备都可以模拟.
硬件模拟2(ps2),模式下的键盘基本是正常的,但鼠标兼容性很差,建议只适用此模式的键盘. 鼠标可以使用别的模式. 键盘和鼠标不要求必须插入真实的ps2设备.
硬件模拟3, 设置以后，必须手动按下需要模拟的键盘和鼠标，否则会卡住.直到按下为止. 此后，再次设置不需要重新按下键盘鼠标，直到系统重启. 这个模拟要求被指定的键盘和鼠标不可以中途插拔，会造成模拟失效.  另外,用模拟3后，最好不要调用MoveTo或者MoveToE接口,改为用MoveR自己实现MoveTo或者MoveToEx,否则可能会造成鼠标移动到屏幕左上角的问题.

此接口仅对本对象生效,实际上所有的接口都仅仅对本对象生效,除了DmGuard是全局的.

]]
local ENUMRET = {
    [0] = "插件没有注册",
    [-1] = "32位系统不支持",
    [-2] = "驱动释放失败",
    [-3] = "驱动加载失败.可能是权限不够. 参考UAC权限设置. 或者是被安全软件拦截.",
    [-10] = "设置失败",
    [-7] = "系统版本不支持. 可以用winver命令查看系统内部版本号. 驱动只支持正式发布的版本，所有预览版本都不支持."
}
function DMCenter:SetSimMode( mode)
    local ret = CPLUS.DmCenter.SetSimMode(self.__dm,mode)
    if ret == 1 then
        return true
    else
        print(ENUMRET[ret])
        return false
    end
end


--等待指定的按键按下 (前台,不是后台)
--[[
    vk_code 整形数:虚拟按键码,当此值为0，表示等待任意按键。 鼠标左键是1,鼠标右键时2,鼠标中键是4.
    time_out 整形数:等待多久,单位毫秒. 如果是0，表示一直等待
返回值:
整形数:
0:超时
1:指定的按键按下 (当vk_code不为0时)
按下的按键码:(当vk_code为0时)

]]
function DMCenter:WaitKey( code,time_out)
    return CPLUS.DmCenter.WaitKey(self.__dm,code,time_out)
end


--滚轮向下滚
function DMCenter:WheelDown( )
    return CPLUS.DmCenter.WheelDown(self.__dm) == 1
end

--滚轮向上滚
function DMCenter:WheelUp( )
    return CPLUS.DmCenter.WheelUp(self.__dm) == 1
end



----------------------------------图色操作--------------------------------------
--对指定的数据地址和长度，组合成新的参数. 
--FindPicMem FindPicMemE 以及FindPicMemEx专用
--[[
参数定义:
pic_info 字符串: 老的地址描述串
addr 整形数: 数据地址
size 整形数: 数据长度

返回值:
字符串:
新的地址描述串
示例:
pic_info = ""
pic_info = dm.AppendPicAddr(pic_info,12034,643)
pic_info = dm.AppendPicAddr(pic_info,328435,8935)
pic_info = dm.AppendPicAddr(pic_info,809234,789) 
]]
function DMCenter:AppendPicAddr( pic_info,addr,size)
    return CPLUS.DmCenter.AppendPicAddr(self.__dm,pic_info,addr,size)
end

--把BGR(按键格式)的颜色格式转换为RGB
--[[
参数定义:
bgr_color 字符串:bgr格式的颜色字符串
返回值:
字符串:
RGB格式的字符串

]]
function DMCenter:BGR2RGB( bgr_color)
    return CPLUS.DmCenter.BGR2RGB(self.__dm,bgr_color)
end


--抓取指定区域(x1, y1, x2, y2)的图像,保存为file(24位位图)
--[[
参数定义:
x1 整形数:区域的左上X坐标
y1 整形数:区域的左上Y坐标
x2 整形数:区域的右下X坐标
y2 整形数:区域的右下Y坐标
file 字符串:保存的文件名,保存的地方一般为SetPath中设置的目录
     当然这里也可以指定全路径名.
]]
function DMCenter:Capture( x1, y1, x2, y2, file)
    self:checkMousePosEffect(x1, y1, x2, y2)
    return CPLUS.DmCenter.Capture(self.__dm,x1, y1, x2, y2, file) == 1
end


--抓取指定区域(x1, y1, x2, y2)的动画，保存为gif格式
--[[
参数定义:

x1 整形数:区域的左上X坐标
y1 整形数:区域的左上Y坐标
x2 整形数:区域的右下X坐标
y2 整形数:区域的右下Y坐标
file 字符串:保存的文件名,保存的地方一般为SetPath中设置的目录
     当然这里也可以指定全路径名.
delay 整形数: 动画间隔，单位毫秒。如果为0，表示只截取静态图片
time 整形数: 总共截取多久的动画，单位毫秒。

]]
function DMCenter:CaptureGif( x1, y1, x2, y2, file,delay,time)
    self:checkMousePosEffect(x1, y1, x2, y2)
    return CPLUS.DmCenter.CaptureGif(self.__dm,x1, y1, x2, y2, file,delay,time) == 1
end


--抓取指定区域(x1, y1, x2, y2)的图像,保存为file(JPG压缩格式)
--[[

x1 整形数:区域的左上X坐标
y1 整形数:区域的左上Y坐标
x2 整形数:区域的右下X坐标
y2 整形数:区域的右下Y坐标
file 字符串:保存的文件名,保存的地方一般为SetPath中设置的目录

     当然这里也可以指定全路径名.
quality 整形数: jpg压缩比率(1-100) 越大图片质量越好
  
]]
function DMCenter:CaptureJpg( x1, y1, x2, y2, file, quality)
    self:checkMousePosEffect(x1, y1, x2, y2)
    return CPLUS.DmCenter.CaptureJpg(self.__dm,x1, y1, x2, y2, file, quality) == 1
end


--同Capture函数，只是保存的格式为PNG.
--[[
参数定义:

x1 整形数:区域的左上X坐标
y1 整形数:区域的左上Y坐标
x2 整形数:区域的右下X坐标
y2 整形数:区域的右下Y坐标
file 字符串:保存的文件名,保存的地方一般为SetPath中设置的目录
     当然这里也可以指定全路径名.
]]
function DMCenter:CapturePng( x1,y1,x2,y2,file)
    self:checkMousePosEffect(x1, y1, x2, y2)
    return CPLUS.DmCenter.CapturePng(self.__dm,x1,y1,x2,y2,file) == 1
end


--抓取上次操作的图色区域，保存为file(24位位图)
--[[
file 字符串:保存的文件名,保存的地方一般为SetPath中设置的目录
     当然这里也可以指定全路径名.
]]
function DMCenter:CapturePre( file)
    return CPLUS.DmCenter.CapturePre(self.__dm,file) == 1
end


--比较指定坐标点(x,y)的颜色
--[[
参数定义:
x 整形数: X坐标
y 整形数: Y坐标
color 字符串: 颜色字符串,可以支持偏色,多色,例如 "ffffff-202020|000000-000000" 这个表示白色偏色为202020,
和黑色偏色为000000.颜色最多支持10种颜色组合. 注意，这里只支持RGB颜色.
sim 双精度浮点数: 相似度(0.1-1.0)
返回值:
整形数:
0: 颜色匹配
1: 颜色不匹配
]]
function DMCenter:CmpColor( x,y,color,sim)
    self:checkMousePosEffect(x, y, x+50, y+50)
    return CPLUS.DmCenter.CmpColor(self.__dm,x,y,color,sim) == 1
end


--开启图色调试模式，此模式会稍许降低图色和文字识别的速度.默认不开启.
--[[
enable_debug 整形数: 0 为关闭 1 为开启
]]
function DMCenter:EnableDisplayDebug( enable_debug)
    return CPLUS.DmCenter.EnableDisplayDebug(self.__dm,enable_debug) == 1
end


--允许调用GetColor GetColorBGR GetColorHSV 以及 CmpColor时，以截图的方式来获取颜色
--[[
enable 整形数: 0 关闭 1 打开
]]
function DMCenter:EnableGetColorByCapture(enable)
    return CPLUS.DmCenter.EnableGetColorByCapture(self.__dm,enable) == 1
end


--查找指定区域内的颜色,颜色格式"RRGGBB-DRDGDB",注意,和按键的颜色格式相反
--[[
x1 整形数:区域的左上X坐标
y1 整形数:区域的左上Y坐标
x2 整形数:区域的右下X坐标
y2 整形数:区域的右下Y坐标
color 字符串:颜色 格式为"RRGGBB-DRDGDB",比如"123456-000000|aabbcc-202020".注意，这里只支持RGB颜色.
sim 双精度浮点数:相似度,取值范围0.1-1.0
dir 整形数:查找方向 0: 从左到右,从上到下 
             1: 从左到右,从下到上 
             2: 从右到左,从上到下 
             3: 从右到左,从下到上 
             4：从中心往外查找
             5: 从上到下,从左到右 
             6: 从上到下,从右到左
             7: 从下到上,从左到右
             8: 从下到上,从右到左
返回table{x=0,y=0} //如果没有找到则 x=0,y=0
x 变参指针:返回X坐标
y 变参指针:返回Y坐标  
]]
function DMCenter:FindColor( x1, y1, x2, y2, color, sim, dir)
    self:checkMousePosEffect(x1, y1, x2, y2)
    return CPLUS.DmCenter.FindColor(self.__dm,x1, y1, x2, y2, color, sim, dir)
end


--查找指定区域内的颜色块,颜色格式"RRGGBB-DRDGDB",注意,和按键的颜色格式相反
--[[
x1 整形数:区域的左上X坐标
y1 整形数:区域的左上Y坐标
x2 整形数:区域的右下X坐标
y2 整形数:区域的右下Y坐标
color 字符串:颜色 格式为"RRGGBB-DRDGDB",比如"123456-000000|aabbcc-202020".注意，这里只支持RGB颜色.
sim 双精度浮点数:相似度,取值范围0.1-1.0
count整形数:在宽度为width,高度为height的颜色块中，符合color颜色的最小数量.(注意,这个颜色数量可以在综合工具的二值化区域中看到)
width 整形数:颜色块的宽度
height 整形数:颜色块的高度

返回table{x=0,y=0} //如果没有找到则 x=0,y=0
x 变参指针:返回X坐标
y 变参指针:返回Y坐标 
]]
function DMCenter:FindColorBlock( x1, y1, x2, y2, color, sim, count,width,height)
    self:checkMousePosEffect(x1, y1, x2, y2)
    return CPLUS.DmCenter.FindColorBlock(self.__dm,x1, y1, x2, y2, color, sim, count,width,height)
end


--查找指定区域内的所有颜色块,颜色格式"RRGGBB-DRDGDB",注意,和按键的颜色格式相反
--[[
x1 整形数:区域的左上X坐标
y1 整形数:区域的左上Y坐标
x2 整形数:区域的右下X坐标
y2 整形数:区域的右下Y坐标
color 字符串:颜色 格式为"RRGGBB-DRDGDB" 比如"aabbcc-000000|123456-202020".注意，这里只支持RGB颜色.
sim 双精度浮点数:相似度,取值范围0.1-1.0
count整形数:在宽度为width,高度为height的颜色块中，符合color颜色的最小数量.(注意,这个颜色数量可以在综合工具的二值化区域中看到)
width 整形数:颜色块的宽度
height 整形数:颜色块的高度
返回值: 
字符串:
返回所有颜色块信息的坐标值,然后通过GetResultCount等接口来解析 (由于内存限制,返回的颜色数量最多为1800个左右)
示例:


s = dm.FindColorBlockEx(0,0,2000,2000,"123456-000000|abcdef-202020",1.0,350,100,200)
count = dm.GetResultCount(s)
index = 0
Do While index < count
    dm_ret = dm.GetResultPos(s,index,intX,intY)
    MessageBox intX&","&intY 
    index = index + 1 
Loop 
  
]]
function DMCenter:FindColorBlockEx( x1, y1, x2, y2, color, sim, count, width, height)
    self:checkMousePosEffect(x1, y1, x2, y2)
    return CPLUS.DmCenter.FindColorBlockEx(self.__dm,x1, y1, x2, y2, color, sim, count, width, height)
end


--查找指定区域内的颜色,颜色格式"RRGGBB-DRDGDB",注意,和按键的颜色格式相反
--[[
x1 整形数:区域的左上X坐标
y1 整形数:区域的左上Y坐标
x2 整形数:区域的右下X坐标
y2 整形数:区域的右下Y坐标
color 字符串:颜色 格式为"RRGGBB-DRDGDB",比如"123456-000000|aabbcc-202020".注意，这里只支持RGB颜色.
sim 双精度浮点数:相似度,取值范围0.1-1.0
dir 整形数:查找方向 0: 从左到右,从上到下 
             1: 从左到右,从下到上 
             2: 从右到左,从上到下 
             3: 从右到左,从下到上 
             4：从中心往外查找
             5: 从上到下,从左到右 
             6: 从上到下,从右到左
             7: 从下到上,从左到右
             8: 从下到上,从右到左
返回值: 
字符串:
返回X和Y坐标 形式如"x|y", 比如"100|200"
示例:
pos = dm.FindColorE(0,0,2000,2000,"123456-000000|aabbcc-030303|ddeeff-202020",1.0,0)
pos = split(pos,"|")
If int(pos(0)) > 0 Then
    MessageBox "找到"
End If

]]
function DMCenter:FindColorE( x1, y1, x2, y2, color, sim, dir)
    self:checkMousePosEffect(x1, y1, x2, y2)
    return CPLUS.DmCenter.FindColorE(self.__dm,x1, y1, x2, y2, color, sim, dir)
end


--查找指定区域内的所有颜色,颜色格式"RRGGBB-DRDGDB",注意,和按键的颜色格式相反
--[[
x1 整形数:区域的左上X坐标
y1 整形数:区域的左上Y坐标
x2 整形数:区域的右下X坐标
y2 整形数:区域的右下Y坐标
color 字符串:颜色 格式为"RRGGBB-DRDGDB" 比如"aabbcc-000000|123456-202020".注意，这里只支持RGB颜色.
sim 双精度浮点数:相似度,取值范围0.1-1.0
dir 整形数:查找方向 0: 从左到右,从上到下 
             1: 从左到右,从下到上 
             2: 从右到左,从上到下 
             3: 从右到左,从下到上 
             5: 从上到下,从左到右 
             6: 从上到下,从右到左
             7: 从下到上,从左到右
             8: 从下到上,从右到左



返回值: 

字符串:
返回所有颜色信息的坐标值,然后通过GetResultCount等接口来解析 (由于内存限制,返回的颜色数量最多为1800个左右)

示例:


s = dm.FindColorEx(0,0,2000,2000,"123456-000000|abcdef-202020",1.0,0)
count = dm.GetResultCount(s)
index = 0
Do While index < count
    dm_ret = dm.GetResultPos(s,index,intX,intY)
    MessageBox intX&","&intY 
    index = index + 1 
Loop
]]
function DMCenter:FindColorEx( x1, y1, x2, y2, color, sim, dir)
    self:checkMousePosEffect(x1, y1, x2, y2)
    return CPLUS.DmCenter.FindColorEx(self.__dm,x1, y1, x2, y2, color, sim, dir)
end


--查找指定区域内的所有颜色. 
--[[
x1 整形数:区域的左上X坐标
y1 整形数:区域的左上Y坐标
x2 整形数:区域的右下X坐标
y2 整形数:区域的右下Y坐标
color 字符串:颜色 格式为"RRGGBB-DRDGDB",比如"123456-000000|aabbcc-202020".注意，这里只支持RGB颜色.
sim 双精度浮点数:相似度,取值范围0.1-1.0
返回值: 
整形数:
0:没找到或者部分颜色没找到
1:所有颜色都找到

示例:
dm_ret = dm.FindMulColor(0,0,2000,2000,"123456-000000|aabbcc-030303|ddeeff-202020",1.0)
if dm_ret = 1 then
     MessageBox "找到了"
end if
]]
function DMCenter:FindMulColor( x1, y1, x2, y2, color, sim)
    self:checkMousePosEffect(x1, y1, x2, y2)
    return CPLUS.DmCenter.FindMulColor(self.__dm,x1, y1, x2, y2, color, sim) == 1
end

--根据指定的多点查找颜色坐标
--[[
x1 整形数:区域的左上X坐标
y1 整形数:区域的左上Y坐标
x2 整形数:区域的右下X坐标
y2 整形数:区域的右下Y坐标
first_color 字符串:颜色格式为"RRGGBB-DRDGDB|RRGGBB-DRDGDB|…………",比如"123456-000000"
这里的含义和按键自带Color插件的意义相同，只不过我的可以支持偏色和多种颜色组合
所有的偏移色坐标都相对于此颜色.注意，这里只支持RGB颜色.
offset_color 字符串: 偏移颜色可以支持任意多个点 格式和按键自带的Color插件意义相同, 只不过我的可以支持偏色和多种颜色组合
 格式为"x1|y1|RRGGBB-DRDGDB|RRGGBB-DRDGDB……,……xn|yn|RRGGBB-DRDGDB|RRGGBB-DRDGDB……"
比如"1|3|aabbcc|aaffaa-101010,-5|-3|123456-000000|454545-303030|565656"等任意组合都可以，支持偏色
还可以支持反色模式，比如"1|3|-aabbcc|-334455-101010,-5|-3|-123456-000000|-353535|454545-101010","-"表示除了指定颜色之外的颜色.

sim 双精度浮点数:相似度,取值范围0.1-1.0
dir 整形数:查找方向 0: 从左到右,从上到下 1: 从左到右,从下到上 2: 从右到左,从上到下 3: 从右到左, 从下到上
返回值 table{x=0,y=0}
x 变参指针:返回X坐标(坐标为first_color所在坐标)
y 变参指针:返回Y坐标(坐标为first_color所在坐标)
]]
function DMCenter:FindMultiColor( x1, y1, x2, y2,first_color,offset_color,sim, dir)
    self:checkMousePosEffect(x1, y1, x2, y2)
    return CPLUS.DmCenter.FindMultiColor(self.__dm,x1, y1, x2, y2,first_color,offset_color,sim, dir)
end


--[[
    根据指定的多点查找颜色坐标
    易语言用不了FindMultiColor可以用此接口来代替
x1 整形数:区域的左上X坐标
y1 整形数:区域的左上Y坐标
x2 整形数:区域的右下X坐标
y2 整形数:区域的右下Y坐标
first_color 字符串:颜色 格式为"RRGGBB-DRDGDB|RRGGBB-DRDGDB|…………",比如"123456-000000"
这里的含义和按键自带Color插件的意义相同，只不过我的可以支持偏色和多种颜色组合
所有的偏移色坐标都相对于此颜色.注意，这里只支持RGB颜色.
offset_color 字符串: 偏移颜色 可以支持任意多个点 格式和按键自带的Color插件意义相同, 只不过我的可以支持偏色和多种颜色组合
 格式为"x1|y1|RRGGBB-DRDGDB|RRGGBB-DRDGDB……,……xn|yn|RRGGBB-DRDGDB|RRGGBB-DRDGDB……"
比如"1|3|aabbcc|aaffaa-101010,-5|-3|123456-000000|454545-303030|565656"等任意组合都可以，支持偏色
还可以支持反色模式，比如"1|3|-aabbcc|-334455-101010,-5|-3|-123456-000000|-353535|454545-101010","-"表示除了指定颜色之外的颜色.

sim 双精度浮点数:相似度,取值范围0.1-1.0
dir 整形数:查找方向 0: 从左到右,从上到下 1: 从左到右,从下到上 2: 从右到左,从上到下 3: 从右到左, 从下到上
返回值: 
字符串:
返回X和Y坐标 形式如"x|y", 比如"100|200"

]]
function DMCenter:FindMultiColorE( x1, y1, x2, y2,first_color,offset_color,sim, dir)
    self:checkMousePosEffect(x1, y1, x2, y2)
    return CPLUS.DmCenter.FindMultiColorE(self.__dm,x1, y1, x2, y2,first_color,offset_color,sim, dir)
end


--根据指定的多点查找所有颜色坐标
--[[
x1 整形数:区域的左上X坐标
y1 整形数:区域的左上Y坐标
x2 整形数:区域的右下X坐标
y2 整形数:区域的右下Y坐标
first_color 字符串:颜色 格式为"RRGGBB-DRDGDB|RRGGBB-DRDGDB|…………",比如"123456-000000"
这里的含义和按键自带Color插件的意义相同，只不过我的可以支持偏色和多种颜色组合
所有的偏移色坐标都相对于此颜色.注意，这里只支持RGB颜色.
offset_color 字符串: 偏移颜色 可以支持任意多个点 格式和按键自带的Color插件意义相同, 只不过我的可以支持偏色和多种颜色组合
 格式为"x1|y1|RRGGBB-DRDGDB|RRGGBB-DRDGDB……,……xn|yn|RRGGBB-DRDGDB|RRGGBB-DRDGDB……"
比如"1|3|aabbcc|aaffaa-101010,-5|-3|123456-000000|454545-303030|565656"等任意组合都可以，支持偏色
还可以支持反色模式，比如"1|3|-aabbcc|-334455-101010,-5|-3|-123456-000000|-353535|454545-101010","-"表示除了指定颜色之外的颜色.
sim 双精度浮点数:相似度,取值范围0.1-1.0
dir 整形数:查找方向 0: 从左到右,从上到下 1: 从左到右,从下到上 2: 从右到左,从上到下 3: 从右到左, 从下到上
返回值: 
字符串:
返回所有颜色信息的坐标值,然后通过GetResultCount等接口来解析(由于内存限制,返回的坐标数量最多为1800个左右)
坐标是first_color所在的坐标

示例:
dm_ret = dm.FindMultiColorEx(0,0,2000,2000, "cc805b-020202|606060-010101","9|2|-00ff00|-ff0000,15|2|2dff1c-010101,6|11|a0d962|aabbcc,11|14|-ffffff",1.0,1)
count = dm.GetResultCount(dm_ret)
index = 0
Do While index < count 
   aa = dm.GetResultPos(dm_ret,index,intX,intY)
   dm.MoveTo intX,intY
   index = index + 1
   Delay  1000
Loop

]]
function DMCenter:FindMultiColorEx( x1, y1, x2, y2,first_color,offset_color,sim, dir)
    self:checkMousePosEffect(x1, y1, x2, y2)
    return CPLUS.DmCenter.FindMultiColorEx(self.__dm,x1, y1, x2, y2,first_color,offset_color,sim, dir)
end



--[[
查找指定区域内的图片,位图必须是24位色格式,支持透明色,当图像上下左右4个顶点的颜色一样时,则这个颜色将作为透明色处理.
这个函数可以查找多个图片,只返回第一个找到的X Y坐标.
x1 整形数:区域的左上X坐标
y1 整形数:区域的左上Y坐标
x2 整形数:区域的右下X坐标
y2 整形数:区域的右下Y坐标
pic_name 字符串:图片名,可以是多个图片,比如"test.bmp|test2.bmp|test3.bmp"
delta_color 字符串:颜色色偏比如"203040" 表示RGB的色偏分别是20 30 40 (这里是16进制表示)
sim 双精度浮点数:相似度,取值范围0.1-1.0
dir 整形数:查找方向 0: 从左到右,从上到下 1: 从左到右,从下到上 2: 从右到左,从上到下 3: 从右到左, 从下到上
返回值table{x=0,y=0}
intX 变参指针:返回图片左上角的X坐标
intY 变参指针:返回图片左上角的Y坐标

示例:
dm_ret = dm.FindPic(0,0,2000,2000,"1.bmp|2.bmp|3.bmp","000000",0.9,0,intX,intY)
If intX >= 0 and intY >= 0 Then
    MessageBox "找到"
End If
]]
function DMCenter:FindPic( x1, y1, x2, y2, pic_name, delta_color,sim, dir)
    self:checkMousePosEffect(x1, y1, x2, y2)
    return CPLUS.DmCenter.FindPic(self.__dm,x1, y1, x2, y2, pic_name, delta_color,sim, dir)
end


--[[
查找指定区域内的图片,位图必须是24位色格式,支持透明色,当图像上下左右4个顶点的颜色一样时,则这个颜色将作为透明色处理.
这个函数可以查找多个图片,只返回第一个找到的X Y坐标.
易语言用不了FindPic可以用此接口来代替
x1 整形数:区域的左上X坐标
y1 整形数:区域的左上Y坐标
x2 整形数:区域的右下X坐标
y2 整形数:区域的右下Y坐标
pic_name 字符串:图片名,可以是多个图片,比如"test.bmp|test2.bmp|test3.bmp"
delta_color 字符串:颜色色偏比如"203040" 表示RGB的色偏分别是20 30 40 (这里是16进制表示)
sim 双精度浮点数:相似度,取值范围0.1-1.0
dir 整形数:查找方向 0: 从左到右,从上到下 1: 从左到右,从下到上 2: 从右到左,从上到下 3: 从右到左, 从下到上

返回值:
字符串:
返回找到的图片序号(从0开始索引)以及X和Y坐标 形式如"index|x|y", 比如"3|100|200"

示例:
pos = dm.FindPicE(0,0,2000,2000,"1.bmp|2.bmp|3.bmp","000000",0.9,0)
pos = split(pos,"|")
If int(pos(1)) > 0 Then
    MessageBox "找到"
End If

]]
function DMCenter:FindPicE( x1, y1, x2, y2, pic_name, delta_color,sim, dir)
    self:checkMousePosEffect(x1, y1, x2, y2)
    return CPLUS.DmCenter.FindPicE(self.__dm,x1, y1, x2, y2, pic_name, delta_color,sim, dir)
end


--[[
查找指定区域内的图片,位图必须是24位色格式,支持透明色,当图像上下左右4个顶点的颜色一样时,则这个颜色将作为透明色处理.
这个函数可以查找多个图片,并且返回所有找到的图像的坐标.
x1 整形数:区域的左上X坐标
y1 整形数:区域的左上Y坐标
x2 整形数:区域的右下X坐标
y2 整形数:区域的右下Y坐标
pic_name 字符串:图片名,可以是多个图片,比如"test.bmp|test2.bmp|test3.bmp"
delta_color 字符串:颜色色偏比如"203040" 表示RGB的色偏分别是20 30 40 (这里是16进制表示)
sim 双精度浮点数:相似度,取值范围0.1-1.0
dir 整形数:查找方向 0: 从左到右,从上到下 1: 从左到右,从下到上 2: 从右到左,从上到下 3: 从右到左, 从下到上

返回值:
字符串:
返回的是所有找到的坐标格式如下:"id,x,y|id,x,y..|id,x,y" (图片左上角的坐标)
比如"0,100,20|2,30,40" 表示找到了两个,第一个,对应的图片是图像序号为0的图片,坐标是(100,20),第二个是序号为2的图片,坐标(30,40)
(由于内存限制,返回的图片数量最多为1500个左右)

示例:
dm_ret = dm.FindPicEx(0,0,2000,2000,"test.bmp|test2.bmp|test3.bmp|test4.bmp|test5.bmp","020202",1.0,0)
If len(dm_ret) > 0 Then
   ss = split(dm_ret,"|")
   index = 0
   count = UBound(ss) + 1
   Do While index < count
      TracePrint ss(index)
      sss = split(ss(index),",")
      id = int(sss(0))
      x = int(sss(1))
      y = int(sss(2))
      dm.MoveTo x,y
      Delay 1000
      index = index+1
   Loop
End If
]]
function DMCenter:FindPicEx( x1, y1, x2, y2, pic_name, delta_color,sim, dir)
    self:checkMousePosEffect(x1, y1, x2, y2)
    return CPLUS.DmCenter.FindPicEx(self.__dm,x1, y1, x2, y2, pic_name, delta_color,sim, dir)
end



--[[
查找指定区域内的图片,位图必须是24位色格式,支持透明色,当图像上下左右4个顶点的颜色一样时,则这个颜色将作为透明色处理.
这个函数可以查找多个图片,并且返回所有找到的图像的坐标. 此函数同FindPicEx.只是返回值不同.
x1 整形数:区域的左上X坐标
y1 整形数:区域的左上Y坐标
x2 整形数:区域的右下X坐标
y2 整形数:区域的右下Y坐标
pic_name 字符串:图片名,可以是多个图片,比如"test.bmp|test2.bmp|test3.bmp"
delta_color 字符串:颜色色偏 比如"203040" 表示RGB的色偏分别是20 30 40 (这里是16进制表示)
sim 双精度浮点数:相似度,取值范围0.1-1.0
dir 整形数:查找方向 0: 从左到右,从上到下 1: 从左到右,从下到上 2: 从右到左,从上到下 3: 从右到左, 从下到上
返回值:
字符串:
返回的是所有找到的坐标格式如下:"file,x,y| file,x,y..| file,x,y" (图片左上角的坐标)
比如"1.bmp,100,20|2.bmp,30,40" 表示找到了两个,第一个,对应的图片是1.bmp,坐标是(100,20),第二个是2.bmp,坐标(30,40)
(由于内存限制,返回的图片数量最多为1500个左右)
示例:
dm_ret = dm.FindPicExS(0,0,2000,2000,"test.bmp|test2.bmp|test3.bmp|test4.bmp|test5.bmp","020202",1.0,0)
If len(dm_ret) > 0 Then
   ss = split(dm_ret,"|")
   index = 0
   count = UBound(ss) + 1
   Do While index < count
      TracePrint ss(index)
      sss = split(ss(index),",")
      f = sss(0)
      x = int(sss(1))
      y = int(sss(2))
      dm.MoveTo x,y
      Delay 1000
      index = index+1
   Loop
End If

]]
function DMCenter:FindPicExS( x1, y1, x2, y2, pic_name, delta_color,sim, dir)
    self:checkMousePosEffect(x1, y1, x2, y2)
    return CPLUS.DmCenter.FindPicExS(self.__dm,x1, y1, x2, y2, pic_name, delta_color,sim, dir)
end


--[[
查找指定区域内的图片,位图必须是24位色格式,支持透明色,当图像上下左右4个顶点的颜色一样时,则这个颜色将作为透明色处理.
这个函数可以查找多个图片,只返回第一个找到的X Y坐标. 这个函数要求图片是数据地址
x1 整形数:区域的左上X坐标
y1 整形数:区域的左上Y坐标
x2 整形数:区域的右下X坐标
y2 整形数:区域的右下Y坐标
pic_info 字符串: 图片数据地址集合. 格式为"地址1,长度1|地址2,长度2.....|地址n,长度n". 可以用AppendPicAddr来组合. 
          地址表示24位位图资源在内存中的首地址，用十进制的数值表示
          长度表示位图资源在内存中的长度，用十进制数值表示.
delta_color 字符串:颜色色偏比如"203040" 表示RGB的色偏分别是20 30 40 (这里是16进制表示)
sim 双精度浮点数:相似度,取值范围0.1-1.0
dir 整形数:查找方向 0: 从左到右,从上到下 1: 从左到右,从下到上 2: 从右到左,从上到下 3: 从右到左, 从下到上
返回值 table{x=0,y=0}
intX 变参指针:返回图片左上角的X坐标
intY 变参指针:返回图片左上角的Y坐标
 

示例:

pic_info = ""
pic_info = dm.AppendPicAddr(pic_info,12034,643)
pic_info = dm.AppendPicAddr(pic_info,328435,8935)
pic_info = dm.AppendPicAddr(pic_info,809234,789)
dm_ret = dm.FindPicMem(0,0,2000,2000, pic_info,"000000",0.9,0,intX,intY)
If intX >= 0 and intY >= 0 Then
    MessageBox "找到"
End If

注 : 内存中的图片格式必须是24位色，并且不能加密.

]]
function DMCenter:FindPicMem( x1, y1, x2, y2, pic_info, delta_color,sim, dir,intX, intY)
    self:checkMousePosEffect(x1, y1, x2, y2)
    return CPLUS.DmCenter.FindPicMem(self.__dm,x1, y1, x2, y2, pic_info, delta_color,sim, dir,intX, intY)
end


--[[
查找指定区域内的图片,位图必须是24位色格式,支持透明色,当图像上下左右4个顶点的颜色一样时,则这个颜色将作为透明色处理.
这个函数可以查找多个图片,只返回第一个找到的X Y坐标. 这个函数要求图片是数据地址.
易语言用不了FindPicMem可以用此接口来代替
x1 整形数:区域的左上X坐标
y1 整形数:区域的左上Y坐标
x2 整形数:区域的右下X坐标
y2 整形数:区域的右下Y坐标
pic_info 字符串: 图片数据地址集合. 格式为"地址1,长度1|地址2,长度2.....|地址n,长度n". 可以用AppendPicAddr来组合. 
          地址表示24位位图资源在内存中的首地址，用十进制的数值表示
          长度表示位图资源在内存中的长度，用十进制数值表示.
delta_color 字符串:颜色色偏比如"203040" 表示RGB的色偏分别是20 30 40 (这里是16进制表示)
sim 双精度浮点数:相似度,取值范围0.1-1.0
dir 整形数:查找方向 0: 从左到右,从上到下 1: 从左到右,从下到上 2: 从右到左,从上到下 3: 从右到左, 从下到上

返回值:
字符串:
返回找到的图片序号(从0开始索引)以及X和Y坐标 形式如"index|x|y", 比如"3|100|200"
示例:
pic_info = ""
pic_info = dm.AppendPicAddr(pic_info,12034,643)
pic_info = dm.AppendPicAddr(pic_info,328435,8935)
pic_info = dm.AppendPicAddr(pic_info,809234,789)
pos = dm.FindPicMemE(0,0,2000,2000, pic_info,"000000",0.9,0)
pos = split(pos,"|")
If int(pos(1)) > 0 Then
    MessageBox "找到"
End If
注 : 内存中的图片格式必须是24位色，并且不能加密.
]]
function DMCenter:FindPicMemE( x1, y1, x2, y2, pic_info, delta_color,sim, dir)
    self:checkMousePosEffect(x1, y1, x2, y2)
    return CPLUS.DmCenter.FindPicMemE(self.__dm,x1, y1, x2, y2, pic_info, delta_color,sim, dir)
end



--[[
查找指定区域内的图片,位图必须是24位色格式,支持透明色,当图像上下左右4个顶点的颜色一样时,则这个颜色将作为透明色处理.
这个函数可以查找多个图片,并且返回所有找到的图像的坐标. 这个函数要求图片是数据地址.
x1 整形数:区域的左上X坐标
y1 整形数:区域的左上Y坐标
x2 整形数:区域的右下X坐标
y2 整形数:区域的右下Y坐标
pic_info 字符串: 图片数据地址集合. 格式为"地址1,长度1|地址2,长度2.....|地址n,长度n". 可以用AppendPicAddr来组合. 
          地址表示24位位图资源在内存中的首地址，用十进制的数值表示
          长度表示位图资源在内存中的长度，用十进制数值表示.
delta_color 字符串:颜色色偏比如"203040" 表示RGB的色偏分别是20 30 40 (这里是16进制表示)
sim 双精度浮点数:相似度,取值范围0.1-1.0
dir 整形数:查找方向 0: 从左到右,从上到下 1: 从左到右,从下到上 2: 从右到左,从上到下 3: 从右到左, 从下到上

返回值:
字符串:
返回的是所有找到的坐标格式如下:"id,x,y|id,x,y..|id,x,y" (图片左上角的坐标)
比如"0,100,20|2,30,40" 表示找到了两个,第一个,对应的图片是图像序号为0的图片,坐标是(100,20),第二个是序号为2的图片,坐标(30,40)
(由于内存限制,返回的图片数量最多为1500个左右)
示例:
pic_info = ""
pic_info = dm.AppendPicAddr(pic_info,12034,643)
pic_info = dm.AppendPicAddr(pic_info,328435,8935)
pic_info = dm.AppendPicAddr(pic_info,809234,789)
dm_ret = dm.FindPicMemEx(0,0,2000,2000, pic_info,"020202",1.0,0)
If len(dm_ret) > 0 Then
   ss = split(dm_ret,"|")
   index = 0
   count = UBound(ss) + 1
   Do While index < count
      TracePrint ss(index)
      sss = split(ss(index),",")
      id = int(sss(0))
      x = int(sss(1))
      y = int(sss(2))
      dm.MoveTo x,y
      Delay 1000
      index = index+1
   Loop
End If

注 : 内存中的图片格式必须是24位色，并且不能加密.
]]
function DMCenter:FindPicMemEx( x1, y1, x2, y2, pic_info, delta_color,sim, dir)
    self:checkMousePosEffect(x1, y1, x2, y2)
    return CPLUS.DmCenter.FindPicMemEx(self.__dm,x1, y1, x2, y2, pic_info, delta_color,sim, dir)
end



--[[
查找指定区域内的图片,位图必须是24位色格式,支持透明色,当图像上下左右4个顶点的颜色一样时,则这个颜色将作为透明色处理.
这个函数可以查找多个图片,只返回第一个找到的X Y坐标. 此函数同FindPic.只是返回值不同.
x1 整形数:区域的左上X坐标
y1 整形数:区域的左上Y坐标
x2 整形数:区域的右下X坐标
y2 整形数:区域的右下Y坐标
pic_name 字符串:图片名,可以是多个图片,比如"test.bmp|test2.bmp|test3.bmp"
delta_color 字符串:颜色色偏比如"203040" 表示RGB的色偏分别是20 30 40 (这里是16进制表示)
sim 双精度浮点数:相似度,取值范围0.1-1.0
dir 整形数:查找方向 0: 从左到右,从上到下 1: 从左到右,从下到上 2: 从右到左,从上到下 3: 从右到左, 从下到上

返回值 table{x=0,y=0,pic=""}
返回值:
intX 变参指针:返回图片左上角的X坐标
intY 变参指针:返回图片左上角的Y坐标
字符串:
返回找到的图片的文件名. 没找到返回长度为0的字符串.

示例:
dm_ret = dm.FindPicS(0,0,2000,2000,"1.bmp|2.bmp|3.bmp","000000",0.9,0,intX,intY)
If intX >= 0 and intY >= 0 Then
    MessageBox "找到"&dm_ret
End If
]]
function DMCenter:FindPicS( x1, y1, x2, y2, pic_name, delta_color,sim, dir)
    self:checkMousePosEffect(x1, y1, x2, y2)
    return CPLUS.DmCenter.FindPicS(self.__dm,x1, y1, x2, y2, pic_name, delta_color,sim, dir)
end



--[[
查找指定的形状. 形状的描述同按键的抓抓. 具体可以参考按键的抓抓. 
和按键的语法不同，需要用大漠综合工具的颜色转换.
x1 整形数:区域的左上X坐标
y1 整形数:区域的左上Y坐标
x2 整形数:区域的右下X坐标
y2 整形数:区域的右下Y坐标
offset_color 字符串: 坐标偏移描述 可以支持任意多个点 格式和按键自带的Color插件意义相同

 格式为"x1|y1|e1,……xn|yn|en"

比如"1|3|1,-5|-3|0"等任意组合都可以
sim 双精度浮点数:相似度,取值范围0.1-1.0
dir 整形数:查找方向 0: 从左到右,从上到下 1: 从左到右,从下到上 2: 从右到左,从上到下 3: 从右到左, 从下到上

返回值 table {x=0,y=0}
intX 变参指针:返回X坐标(坐标为形状(0,0)所在坐标)
intY 变参指针:返回Y坐标(坐标为形状(0,0)所在坐标)

示例:
dm_ret = dm.FindShape(0,0,2000,2000, "1|1|0,1|6|1,0|10|1,9|10|1,7|6|1,7|8|0,8|9|0,2|2|1,3|1|1",1.0,0,x,y)
dm.MoveTo x,y
]]
function DMCenter:FindShape( x1, y1, x2, y2, offset_color,sim, dir)
    self:checkMousePosEffect(x1, y1, x2, y2)
    return CPLUS.DmCenter.FindShape(self.__dm,x1, y1, x2, y2, offset_color,sim, dir)
end



--[[
查找指定的形状. 形状的描述同按键的抓抓. 具体可以参考按键的抓抓. 
和按键的语法不同，需要用大漠综合工具的颜色转换. 
易语言用不了FindShape可以用此接口来代替
x1 整形数:区域的左上X坐标
y1 整形数:区域的左上Y坐标
x2 整形数:区域的右下X坐标
y2 整形数:区域的右下Y坐标
offset_color 字符串: 坐标偏移描述 可以支持任意多个点 格式和按键自带的Color插件意义相同
 格式为"x1|y1|e1,……xn|yn|en"
比如"1|3|1,-5|-3|0"等任意组合都可以
sim 双精度浮点数:相似度,取值范围0.1-1.0
dir 整形数:查找方向 0: 从左到右,从上到下 1: 从左到右,从下到上 2: 从右到左,从上到下 3: 从右到左, 从下到上
返回值: 
字符串:
返回X和Y坐标 形式如"x|y", 比如"100|200"
示例:
pos = dm.FindShapeE(0,0,2000,2000,"1|1|0,1|6|1,0|10|1,9|10|1,7|6|1,7|8|0,8|9|0,2|2|1,3|1|1",1.0,0)
pos = split(pos,"|")
dm.MoveTo int(pos(0)),int(pos(1))
]]
function DMCenter:FindShapeE( x1, y1, x2, y2, offset_color,sim, dir)
    self:checkMousePosEffect(x1, y1, x2, y2)
    return CPLUS.DmCenter.FindShapeE(self.__dm,x1, y1, x2, y2, offset_color,sim, dir)
end




--[[
查找所有指定的形状的坐标. 形状的描述同按键的抓抓. 具体可以参考按键的抓抓. 
和按键的语法不同，需要用大漠综合工具的颜色转换.
x1 整形数:区域的左上X坐标
y1 整形数:区域的左上Y坐标
x2 整形数:区域的右下X坐标
y2 整形数:区域的右下Y坐标
offset_color 字符串: 坐标偏移描述可以支持任意多个点 格式和按键自带的Color插件意义相同

 格式为"x1|y1|e1,……xn|yn|en"

比如"1|3|1,-5|-3|0"等任意组合都可以
sim 双精度浮点数:相似度,取值范围0.1-1.0
dir 整形数:查找方向 0: 从左到右,从上到下 1: 从左到右,从下到上 2: 从右到左,从上到下 3: 从右到左, 从下到上
返回值: 
字符串:
返回所有形状的坐标值,然后通过GetResultCount等接口来解析(由于内存限制,返回的坐标数量最多为1800个左右)
示例:
dm_ret = dm.FindShapeEx(0,0,2000,2000,"1|1|0,1|6|1,0|10|1,9|10|1,7|6|1,7|8|0,8|9|0,2|2|1,3|1|1",1.0,1)
count = dm.GetResultCount(dm_ret)
index = 0
Do While index < count 
   aa = dm.GetResultPos(dm_ret,index,intX,intY)
   dm.MoveTo intX,intY
   index = index + 1
   Delay  1000
Loop
]]
function DMCenter:FindShapeEx( x1, y1, x2, y2,offset_color,sim, dir)
    self:checkMousePosEffect(x1, y1, x2, y2)
    return CPLUS.DmCenter.FindShapeEx(self.__dm,x1, y1, x2, y2,offset_color,sim, dir)
end



--[[
释放指定的图片,此函数不必要调用,除非你想节省内存.
pic_name 字符串: 
文件名比如
    "1.bmp|2.bmp|3.bmp" 等,可以使用通配符,比如
    "*.bmp" 这个对应了所有的bmp文件
    "a?c*.bmp" 这个代表了所有第一个字母是a 第三个字母是c 第二个字母任意的所有bmp文件
    "abc???.bmp|1.bmp|aa??.bmp" 可以这样任意组合.
]]
function DMCenter:FreePic( pic_name)
    return CPLUS.DmCenter.FreePic(self.__dm,pic_name) == 1
end


--获取范围(x1,y1,x2,y2)颜色的均值,返回格式"H.S.V"
--[[
x1 整形数: 左上角X
y1 整形数: 左上角Y
x2 整形数: 右下角X
y2 整形数: 右下角Y

返回值:
字符串:
颜色字符串
]]
function DMCenter:GetAveHSV( x1,y1,x2,y2)
    return CPLUS.DmCenter.GetAveHSV(self.__dm,x1,y1,x2,y2)
end


--[[
获取范围(x1,y1,x2,y2)颜色的均值,返回格式"RRGGBB"
x1 整形数: 左上角X
y1 整形数: 左上角Y
x2 整形数: 右下角X
y2 整形数: 右下角Y

返回:
字符串:
颜色字符串
]]
function DMCenter:GetAveRGB( x1,y1,x2,y2)
    return CPLUS.DmCenter.GetAveRGB(self.__dm,x1,y1,x2,y2)
end



--[[
获取(x,y)的颜色,颜色返回格式"RRGGBB",注意,和按键的颜色格式相反
x 整形数:X坐标
y 整形数:Y坐标
返回值:
字符串:
颜色字符串(注意这里都是小写字符，和工具相匹配)
color = dm.GetColor(30,30)
If color = "ffffff" Then
     MessageBox "是白色"
End If
]]
function DMCenter:GetColor( x,y)
    self:checkMousePosEffect(x, y, x+50, y+50)
    return CPLUS.DmCenter.GetColor(self.__dm,x,y)
end



--[[
    获取(x,y)的颜色,颜色返回格式"BBGGRR"
    x 整形数:X坐标
    y 整形数:Y坐标
    返回值:

    字符串:
    颜色字符串(注意这里都是小写字符，和工具相匹配)
    color = dm.GetColorBGR(30,30)
    If color = "0000ff" Then
        MessageBox "是红色"
    End If

]]
function DMCenter:GetColorBGR( x,y)
    self:checkMousePosEffect(x, y, x+50, y+50)
    return CPLUS.DmCenter.GetColorBGR(self.__dm,x,y)
end



--[[
获取(x,y)的HSV颜色,颜色返回格式"H.S.V"
x 整形数:X坐标
y 整形数:Y坐标

返回值:
字符串:
颜色字符串

color = dm.GetColorHSV(30,30)
If color = "100.20.20" Then
      MessageBox "ok"
End If
]]
function DMCenter:GetColorHSV( x,y)
    self:checkMousePosEffect(x, y, x+50, y+50)
    return CPLUS.DmCenter.GetColorHSV(self.__dm,x,y)
end



--[[
获取指定区域的颜色数量,颜色格式"RRGGBB-DRDGDB",注意,和按键的颜色格式相反
x1 整形数:区域的左上X坐标
y1 整形数:区域的左上Y坐标
x2 整形数:区域的右下X坐标
y2 整形数:区域的右下Y坐标
color 字符串:颜色 格式为"RRGGBB-DRDGDB",比如"123456-000000|aabbcc-202020".注意，这里只支持RGB颜色.
sim 双精度浮点数:相似度,取值范围0.1-1.0

返回值: 
整形数:
颜色数量
示例:
TracePrint dm.GetColorNum(0,0,2000,2000,"123456-000000|aabbcc-030303|ddeeff-202020",1.0)
]]
function DMCenter:GetColorNum( x1, y1, x2, y2, color, sim)
    self:checkMousePosEffect(x1, y1, x2, y2)
    return CPLUS.DmCenter.GetColorNum(self.__dm,x1, y1, x2, y2, color, sim)
end





--[[
获取指定图片的尺寸，如果指定的图片已经被加入缓存，则从缓存中获取信息.
此接口也会把此图片加入缓存. （当图色缓存机制打开时,具体参考EnablePicCache）
参数定义:
pic_name 字符串: 文件名 比如"1.bmp"

返回值:
字符串:
形式如 "w,h" 比如"30,20"

PutAttachment "c:\test","*.bmp"
dm_ret = dm.SetPath("c:\test")

pic_size = dm.GetPicSize("1.bmp")
pic_size = split(pic_size,",")
w = int(pic_size(0))
h = int(pic_size(1))
Trace "宽度:"&w
Trace "高度:"&h
]]
function DMCenter:GetPicSize( pic_name)
    local ret = CPLUS.DmCenter.GetPicSize(self.__dm,pic_name)
    if ret == "" then
        game.log.error("没有找到图片=>",pic_name)
        return
    end
    local list = string.split(ret,",")
    return list[1],list[2]
end




--[[
获取指定区域的图像,用二进制数据的方式返回,（不适合按键使用）方便二次开发.
x1 整形数:区域的左上X坐标
y1 整形数:区域的左上Y坐标
x2 整形数:区域的右下X坐标
y2 整形数:区域的右下Y坐标

返回值:
整形数:
返回的是指定区域的二进制颜色数据地址,每个颜色是4个字节,表示方式为(00RRGGBB)

注意,调用完此接口后，返回的数据指针在当前dm对象销毁时，或者再次调用GetScreenData时，会自动释放.
从2.1120版本之后，调用完此函数后，没必要再调用FreeScreenData了,插件会自动释放.
--FYD 麻痹的 返回的是BBGGRRFF
]]
function DMCenter:GetScreenData( x1,y1,x2,y2)
    self:checkMousePosEffect(x1, y1, x2, y2)
    local data = CPLUS.DmCenter.GetScreenData(self.__dm,x1,y1,x2,y2)
    local list = {}
    local width = x2
    local idx = 1
    while true do
        local bb = string.byte(data,(idx-1)*4 + 1)
        local gg = string.byte(data,(idx-1)*4 + 2)
        local rr = string.byte(data,(idx-1)*4 + 3)
        local rgbcolor = string.format("%02x%02x%02x",rr,gg,bb)
        local obj = {}
        obj.color = rgbcolor
        table.insert(list,obj)
        idx = idx + 1
        --因为是闭区间,所以这里要+1
        if idx > (x2+1-x1)*(y2+1-y1) then
            break
        end
    end
    local idx = 0
    for y=y1,y2 do
        for x=x1,x2 do 
            idx = idx + 1
            list[idx].x = x
            list[idx].y = y
            
        end
    end
    local result= {}
    result.list = list
    function result:get(idx)
        return list[idx]
    end
    return result
end



--[[
获取指定区域的图像,用24位位图的数据格式返回,方便二次开发.（或者可以配合SetDisplayInput的mem模式）
x1 整形数:区域的左上X坐标
y1 整形数:区域的左上Y坐标
x2 整形数:区域的右下X坐标
y2 整形数:区域的右下Y坐标
data 变参指针:返回图片的数据指针
size 变参指针:返回图片的数据长度

示例:
以下是在E语言中的示例.
.局部变量 data, 整数型
.局部变量 size, 整数型
dm.数值方法 (“GetScreenDataBmp”, 0, 0, 100, 200, data, size)
图片框1.图片 ＝ 指针到字节集 (data, size)
需要注意的是,调用此接口获取的数据指针保存在当前对象中,到下次调用此接口时,内部就会释放.
哪怕是转成字节集,这个地址也还是在此字节集中使用. 如果您要此地址一直有效，那么您需要自己拷贝字节集到自己的字节集中.

]]
function DMCenter:GetScreenDataBmp( x1,y1,x2,y2,data,size)
    self:checkMousePosEffect(x1, y1, x2, y2)
    assert(false,"涉及到字节流,暂无实现")
end



--[[
转换图片格式为24位BMP格式.
pic_name 字符串: 要转换的图片名
bmp_name 字符串: 要保存的BMP图片名 

示例:
dm.ImageToBmp "1.png","1.bmp"
dm.ImageToBmp "2.jpg","2.bmp"
dm.ImageToBmp "3.gif","3.bmp"
]]
function DMCenter:ImageToBmp( pic_name,bmp_name)
    return CPLUS.DmCenter.ImageToBmp(self.__dm,pic_name,bmp_name) == 1
end



--[[
判断指定的区域，在指定的时间内(秒),图像数据是否一直不变.(卡屏).
x1 整形数:区域的左上X坐标
y1 整形数:区域的左上Y坐标
x2 整形数:区域的右下X坐标
y2 整形数:区域的右下Y坐标
t  整形数:需要等待的时间,单位是秒 

返回值:
整形数:
0 : 没有卡屏，图像数据在变化.
1 : 卡屏. 图像数据在指定的时间内一直没有变化.
示例:
TracePrint dm.IsDisplayDead(0,0,100,100,5)
注:此函数的原理是不停的截取指定区域的图像，然后比较，如果改变就立刻返回0,否则等待直到指定的时间到达.
]]
function DMCenter:IsDisplayDead( x1,y1,x2,y2,t)
    return CPLUS.DmCenter.IsDisplayDead(self.__dm,x1,y1,x2,y2,t) == 1
end




--[[
预先加载指定的图片,这样在操作任何和图片相关的函数时,将省去了加载图片的时间。调用此函数后,没必要一定要调用FreePic,插件自己会自动释放.
另外,此函数不是必须调用的,所有和图形相关的函数只要调用过一次，图片会自动加入缓存.
如果想对一个已经加入缓存的图片进行修改，那么必须先用FreePic释放此图片在缓存中占用
的内存，然后重新调用图片相关接口，就可以重新加载此图片. （当图色缓存机制打开时,具体参考EnablePicCache）

参数定义:
pic_name 字符串: 文件名比如"1.bmp|2.bmp|3.bmp" 等,可以使用通配符,比如
          "*.bmp" 这个对应了所有的bmp文件
          "a?c*.bmp" 这个代表了所有第一个字母是a 第三个字母是c 第二个字母任意的所有bmp文件
          "abc???.bmp|1.bmp|aa??.bmp" 可以这样任意组合.

示例:
PutAttachment "c:\test","*.bmp"
dm_ret = dm.SetPath("c:\test")
all_pic = "abc???.bmp|1.bmp|aa??.bmp"
dm_ret = dm.LoadPic(all_pic)
注: 如果在LoadPic后(图片名为相对路径时)，又设置SetPath为别的目录，会导致加入缓存的图片失效，等于没加载. 
]]
function DMCenter:LoadPic( pic_name)
    return CPLUS.DmCenter.LoadPic(self.__dm,pic_name) == 1
end




--[[
预先加载指定的图片,这样在操作任何和图片相关的函数时,将省去了加载图片的时间。调用此函数后,没必要一定要调用FreePic,插件自己会自动释放.
另外,此函数不是必须调用的,所有和图形相关的函数只要调用过一次，图片会自动加入缓存.
如果想对一个已经加入缓存的图片进行修改，那么必须先用FreePic释放此图片在缓存中占用
的内存，然后重新调用图片相关接口，就可以重新加载此图片. （当图色缓存机制打开时,具体参考EnablePicCache）
此函数同LoadPic，只不过LoadPic是从文件中加载图片,而LoadPicByte从给定的内存中加载.
addr 整形数: BMP图像首地址.(完整的BMP图像，不是经过解析的. 和BMP文件里的内容一致)
size 整形数: BMP图像大小.(和BMP文件大小一致)
pic_name 字符串: 文件名,指定这个地址对应的图片名. 用于找图时使用.

示例:
dm.LoadPicByte 123456,300,"1.bmp"
dm_ret = dm.FindPic(0,0,2000,2000,"1.bmp","000000",0.9,0,x,y)
注: 如果在LoadPicByte后(图片名为相对路径时)，又设置SetPath为别的目录，会导致加入缓存的图片失效，等于没加载. 
]]
function DMCenter:LoadPicByte( addr,size,pic_name)
    assert(false,"涉及到指针操作,无实现")
end



--[[
根据通配符获取文件集合. 方便用于FindPic和FindPicEx
参数定义:

pic_name 字符串: 文件名比如"1.bmp|2.bmp|3.bmp" 等,可以使用通配符,比如
          "*.bmp" 这个对应了所有的bmp文件
          "a?c*.bmp" 这个代表了所有第一个字母是a 第三个字母是c 第二个字母任意的所有bmp文件
          "abc???.bmp|1.bmp|aa??.bmp" 可以这样任意组合.
返回值:
字符串:
返回的是通配符对应的文件集合，每个图片以|分割

示例:
PutAttachment "c:\test","*.bmp"
dm_ret = dm.SetPath("c:\test")
all_pic = "abc*.bmp"
pic_name = dm.MatchPicName(all_pic)

// 比如c:\test目录下有abc001.bmp abc002.bmp abc003.bmp
// 那么pic_name 的值为abc001.bmp|abc002.bmp|abc003.bmp
]]
function DMCenter:MatchPicName( pic_name)
    return CPLUS.DmCenter.MatchPicName(self.__dm,pic_name)
end




--[[
把RGB的颜色格式转换为BGR(按键格式)
参数定义:
rgb_color 字符串:rgb格式的颜色字符串
返回值:
字符串:
BGR格式的字符串
示例:
bgr_color = dm.RGB2BGR(rgb_color)
]]
function DMCenter:RGB2BGR( rgb_color)
    return CPLUS.DmCenter.RGB2BGR(self.__dm,rgb_color)
end




--[[
设置图色,以及文字识别时,需要排除的区域.(支持所有图色接口,以及文字相关接口,但对单点取色,或者单点颜色比较的接口不支持)
参数定义:
mode 整形数: 模式,取值如下:
           0: 添加排除区域
           1: 设置排除区域的颜色,默认颜色是FF00FF(此接口的原理是把排除区域设置成此颜色,这样就可以让这块区域实效)
           2: 请空排除区域
info 字符串: 根据mode的取值来决定
            当mode为0时,此参数指添加的区域,可以多个区域,用"|"相连. 格式为"x1,y1,x2,y2|....."
            当mode为1时,此参数为排除区域的颜色,"RRGGBB"
            当mode为2时,此参数无效
示例:
// 先清空区域
dm.SetExcludeRegion(2,"")
// 添加区域
dm.SetExcludeRegion(0,"30,30,100,300|300,400,500,600")
dm.SetExcludeRegion(0,"100,100,200,200")
至于颜色如果有需要也可以设置比如
dm.SetExcludeRegion(1,"FF11FF")
]]
function DMCenter:SetExcludeRegion( mode,info)
    return CPLUS.DmCenter.SetExcludeRegion(self.__dm,mode,info) == 1
end




--[[
设置图片密码，如果图片本身没有加密，那么此设置不影响不加密的图片，一样正常使用.
参数定义:
pwd 字符串: 图片密码
示例:
dm_ret = dm.SetPicPwd("123")
注意,此函数必须在使用图片之前调用.

]]
function DMCenter:SetPicPwd( pwd)
    return CPLUS.DmCenter.SetPicPwd(self.__dm,pwd) == 1
end



-------------------------------------文字识别--------------------------------------------------
--[[
给指定的字库中添加一条字库信息
参数定义:
index 整形数:字库的序号,取值为0-99,目前最多支持100个字库
dict_info 字符串:字库描述串，具体参考大漠综合工具中的字符定义
示例:
dm_ret = dm.AddDict(0,"081101BF8020089FD10A21443F85038$记$0.0$11")

注意: 此函数尽量在小字库中使用，大字库中使用AddDict速度比较慢
另，此函数是向指定的字库所在的内存中添加,而不是往文件中添加. 添加以后立刻就可以用于文字识别。无须再SetDict
如果要保存添加进去的字库信息，需要调用SaveDict
]]
function DMCenter:AddDict( index,dict_info)
    return CPLUS.DmCenter.AddDict(self.__dm,index,dict_info) == 1
end



--[[
清空指定的字库.
参数定义:
index 整形数:字库的序号,取值为0-99,目前最多支持100个字库
示例:
dm.ClearDict 0
注意: 此函数尽量在小字库中使用，大字库中使用AddDict速度比较慢
另外，此函数支持清空内存中的字库，而不是字库文件本身.
]]
function DMCenter:ClearDict( index)
    return CPLUS.DmCenter.ClearDict(self.__dm,index) == 1
end



--[[
允许当前调用的对象使用全局字库。  
如果你的程序中对象太多,并且每个对象都用到了同样的字库,
可以考虑用全局字库,这样可以节省大量内存.
参数定义:

enable 整形数: 0 关闭 1 打开
返回值:
示例:
dm.EnableShareDict 1
dm.SetDict 0,"xxx.txt"
注 : 一旦当前对象开启了全局字库,那么所有的和文字识别，字库相关的接口，通通都认为是对全局字库的操作.
如果所有对象都要需要全局字
]]
function DMCenter:EnableShareDict( enable)
    return CPLUS.DmCenter.EnableShareDict(self.__dm,enable) == 1
end



--[[
根据指定的范围,以及指定的颜色描述，提取点阵信息，类似于大漠工具里的单独提取.
参数定义:

x1 整形数:左上角X坐标
y1 整形数:左上角Y坐标
x2 整形数:右下角X坐标
y2 整形数:右下角Y坐标
color 字符串: 颜色格式串.注意，RGB和HSV,以及灰度格式都支持.
word 字符串: 待定义的文字,不能为空，且不能为关键符号"$"

返回值:
字符串:
识别到的点阵信息，可用于AddDict
如果失败，返回空

示例:
info = dm.FetchWord(200,200,250,220,"abcdef-101010|ffffff-101010","张三")
If len(info) > 0 Then
    dm.AddDict 3,info
End if

info = dm.FetchWord(200,200,250,220,"b@abcdef-101010|ffffff-101010","李四")
If len(info) > 0 Then
    dm.AddDict 2,info
End if

info = dm.FetchWord(200,200,250,220,"b@0.100.100-0.0.0","张三")
If len(info) > 0 Then
    dm.AddDict 4,info
End if

info = dm.FetchWord(200,200,250,220,"0.100.100-0.0.0|100.0.0-0.0.0","王")
If len(info) > 0 Then
    dm.AddDict 4,info
End if
]]
function DMCenter:FetchWord( x1, y1, x2, y2, color, word)
    self:checkMousePosEffect(x1, y1, x2, y2)
    return CPLUS.DmCenter.FetchWord(self.__dm,x1, y1, x2, y2, color, word)
end



--[[
   在屏幕范围(x1,y1,x2,y2)内,查找string(可以是任意个字符串的组合),
   并返回符合color_format的坐标位置,相似度sim同Ocr接口描述.
    (多色,差色查找类似于Ocr接口,不再重述) 
x1 整形数:区域的左上X坐标
y1 整形数:区域的左上Y坐标
x2 整形数:区域的右下X坐标
y2 整形数:区域的右下Y坐标
string 字符串:待查找的字符串,可以是字符串组合，比如"长安|洛阳|大雁塔",中间用"|"来分割字符串
color_format 字符串:颜色格式串, 可以包含换行分隔符,语法是","后加分割字符串. 具体可以查看下面的示例 .注意，RGB和HSV,以及灰度格式都支持.
sim 双精度浮点数:相似度,取值范围0.1-1.0
intX 变参指针:返回X坐标没找到返回-1
intY 变参指针:返回Y坐标没找到返回-1

返回值:table{x=0,y=0}

整形数:
返回字符串的索引 没找到返回-1, 比如"长安|洛阳",若找到长安，则返回0

示例:
dm_ret = dm.FindStr(0,0,2000,2000,"长安","9f2e3f-000000",1.0,intX,intY)
If intX >= 0 and intY >= 0 Then
     dm.MoveTo intX,intY
End If

dm_ret = dm.FindStr(0,0,2000,2000,"长安|洛阳","9f2e3f-000000",1.0,intX,intY)
If intX >= 0 and intY >= 0 Then
     dm.MoveTo intX,intY
End If

// 查找时,对多行文本进行换行,换行分隔符是"|". 语法是在","后增加换行字符串.任意字符串都可以.
dm_ret = dm.FindStr(0,0,2000,2000,"长安|洛阳","9f2e3f-000000,|",1.0,intX,intY)
If intX >= 0 and intY >= 0 Then
     dm.MoveTo intX,intY
End If

注: 此函数的原理是先Ocr识别，然后再查找。所以速度比FindStrFast要慢，尤其是在字库
很大，或者模糊度不为1.0时。
一般字库字符数量小于100左右，模糊度为1.0时，用FindStr要快一些,否则用FindStrFast.
]]
function DMCenter:FindStr( x1,y1,x2,y2,string,color_format,sim)
    self:checkMousePosEffect(x1, y1, x2, y2)
    return CPLUS.DmCenter.FindStr(self.__dm,x1,y1,x2,y2,string,color_format,sim)
end



--[[
在屏幕范围(x1,y1,x2,y2)内,查找string(可以是任意个字符串的组合),
并返回符合color_format的坐标位置,相似度sim同Ocr接口描述.
(多色,差色查找类似于Ocr接口,不再重述)
易语言用不了FindStr可以用此接口来代替
x1 整形数:区域的左上X坐标
y1 整形数:区域的左上Y坐标
x2 整形数:区域的右下X坐标
y2 整形数:区域的右下Y坐标
string 字符串:待查找的字符串, 可以是字符串组合，比如"长安|洛阳|大雁塔",中间用"|"来分割字符串
color_format 字符串:颜色格式串, 可以包含换行分隔符,语法是","后加分割字符串. 具体可以查看下面的示例.注意，RGB和HSV,以及灰度格式都支持.
sim 双精度浮点数:相似度,取值范围0.1-1.0

返回值:

字符串:
返回字符串序号以及X和Y坐标,形式如"id|x|y", 比如"0|100|200",没找到时，id和X以及Y均为-1，"-1|-1|-1"

示例:
pos = dm.FindStrE(0,0,2000,2000,"长安","9f2e3f-000000",1.0)
pos = split(pos,"|")
If int(pos(0)) >= 0 Then
     dm.MoveTo int(pos(1)),int(pos(2))
End If

pos = dm.FindStrE(0,0,2000,2000,"长安|洛阳","9f2e3f-000000",1.0)
pos = split(pos,"|")
If int(pos(0)) >= 0 Then
     dm.MoveTo int(pos(1)),int(pos(2))
End If

// 查找时,对多行文本进行换行,换行分隔符是"|". 语法是在","后增加换行字符串.任意字符串都可以.
pos = dm.FindStrE(0,0,2000,2000,"长安|洛阳","9f2e3f-000000,|",1.0)
pos = split(pos,"|")
If int(pos(0)) >= 0 Then
     dm.MoveTo int(pos(1)),int(pos(2))
End If
注: 此函数的原理是先Ocr识别，然后再查找。所以速度比FindStrFastE要慢，尤其是在字库
很大，或者模糊度不为1.0时。
一般字库字符数量小于100左右，模糊度为1.0时，用FindStrE要快一些,否则用FindStrFastE.
]]
function DMCenter:FindStrE( x1,y1,x2,y2,string,color_format,sim)
    self:checkMousePosEffect(x1, y1, x2, y2)
    return CPLUS.DmCenter.FindStrE(self.__dm,x1,y1,x2,y2,string,color_format,sim)
end




--[[
在屏幕范围(x1,y1,x2,y2)内,查找string(可以是任意字符串的组合),
并返回符合color_format的所有坐标位置,相似度sim同Ocr接口描述.
(多色,差色查找类似于Ocr接口,不再重述)
x1 整形数:区域的左上X坐标
y1 整形数:区域的左上Y坐标
x2 整形数:区域的右下X坐标
y2 整形数:区域的右下Y坐标
string 字符串:待查找的字符串, 可以是字符串组合，比如"长安|洛阳|大雁塔",中间用"|"来分割字符串
color_format 字符串:颜色格式串, 可以包含换行分隔符,语法是","后加分割字符串. 具体可以查看下面的示例.注意，RGB和HSV,以及灰度格式都支持.
sim 双精度浮点数:相似度,取值范围0.1-1.0

返回值:
字符串:
返回所有找到的坐标集合,格式如下:
"id,x0,y0|id,x1,y1|......|id,xn,yn"
比如"0,100,20|2,30,40" 表示找到了两个,第一个,对应的是序号为0的字符串,坐标是(100,20),第二个是序号为2的字符串,坐标(30,40)

示例:
dm_ret = dm.FindStrEx(0,0,2000,2000,"长安|洛阳","9f2e3f-000000",1.0)
If len(dm_ret) > 0 Then
   ss = split(dm_ret,"|")
   index = 0
   count = UBound(ss) + 1
   Do While index < count
      TracePrint ss(index)
      sss = split(ss(index),",")
      id = int(sss(0))
      x = int(sss(1))
      y = int(sss(2))
      dm.MoveTo x,y
      Delay 1000
      index = index+1
   Loop
End If

注: 此函数的原理是先Ocr识别，然后再查找。所以速度比FindStrExFast要慢，尤其是在字库
很大，或者模糊度不为1.0时。
一般字库字符数量小于100左右，模糊度为1.0时，用FindStrEx要快一些,否则用FindStrFastEx.
]]
function DMCenter:FindStrEx( x1,y1,x2,y2,string,color_format,sim)
    self:checkMousePosEffect(x1, y1, x2, y2)
    return CPLUS.DmCenter.FindStrEx(self.__dm,x1,y1,x2,y2,string,color_format,sim)
end





--[[
在屏幕范围(x1,y1,x2,y2)内,查找string(可以是任意字符串的组合),并返回符合color_format的所有坐标位置,相似度sim同Ocr接口描述.
(多色,差色查找类似于Ocr接口,不再重述). 此函数同FindStrEx,只是返回值不同. 
x1 整形数:区域的左上X坐标
y1 整形数:区域的左上Y坐标
x2 整形数:区域的右下X坐标
y2 整形数:区域的右下Y坐标
string 字符串:待查找的字符串, 可以是字符串组合，比如"长安|洛阳|大雁塔",中间用"|"来分割字符串
color_format 字符串:颜色格式串, 可以包含换行分隔符,语法是","后加分割字符串. 具体可以查看下面的示例.注意，RGB和HSV,以及灰度格式都支持.
sim 双精度浮点数:相似度,取值范围0.1-1.0

返回值:
字符串:
返回所有找到的坐标集合,格式如下:
"str,x0,y0| str,x1,y1|......| str,xn,yn"
比如"长安,100,20|大雁塔,30,40" 表示找到了两个,第一个是长安 ,坐标是(100,20),第二个是大雁塔,坐标(30,40)

示例:
dm_ret = dm.FindStrExS(0,0,2000,2000,"长安|洛阳","9f2e3f-000000",1.0)
If len(dm_ret) > 0 Then
   ss = split(dm_ret,"|")
   index = 0
   count = UBound(ss) + 1
   Do While index < count
      TracePrint ss(index)
      sss = split(ss(index),",")
      str = sss(0)
      x = int(sss(1))
      y = int(sss(2))
      dm.MoveTo x,y
      Delay 1000
      index = index+1
   Loop
End If

注: 此函数的原理是先Ocr识别，然后再查找。所以速度比FindStrExFastS要慢，尤其是在字库
很大，或者模糊度不为1.0时。
一般字库字符数量小于100左右，模糊度为1.0时，用FindStrExS要快一些,否则用FindStrFastExS
]]
function DMCenter:FindStrExS( x1,y1,x2,y2,string,color_format,sim)
    self:checkMousePosEffect(x1, y1, x2, y2)
    return CPLUS.DmCenter.FindStrExS(self.__dm,x1,y1,x2,y2,string,color_format,sim)
end




--[[
同FindStr
x1 整形数:区域的左上X坐标
y1 整形数:区域的左上Y坐标
x2 整形数:区域的右下X坐标
y2 整形数:区域的右下Y坐标
string 字符串:待查找的字符串,可以是字符串组合，比如"长安|洛阳|大雁塔",中间用"|"来分割字符串
color_format 字符串:颜色格式串, 可以包含换行分隔符,语法是","后加分割字符串. 具体可以查看下面的示例.注意，RGB和HSV,以及灰度格式都支持.
sim 双精度浮点数:相似度,取值范围0.1-1.0
intX 变参指针:返回X坐标 没找到返回-1
intY 变参指针:返回Y坐标 没找到返回-1

返回值:table{x=0,y=0}

整形数:
返回字符串的索引 没找到返回-1, 比如"长安|洛阳",若找到长安，则返回0

示例:
dm_ret = dm.FindStrFast(0,0,2000,2000,"长安","9f2e3f-000000",1.0,intX,intY)
If intX >= 0 and intY >= 0 Then
     dm.MoveTo intX,intY
End If

dm_ret = dm.FindStrFast(0,0,2000,2000,"长安|洛阳","9f2e3f-000000",0.9,intX,intY)
If intX >= 0 and intY >= 0 Then
     dm.MoveTo intX,intY
End If

// 查找时,对多行文本进行换行,换行分隔符是"|". 语法是在","后增加换行字符串.任意字符串都可以.
dm_ret = dm.FindStrFast(0,0,2000,2000,"长安|洛阳","9f2e3f-000000,|",0.9,intX,intY)
If intX >= 0 and intY >= 0 Then
     dm.MoveTo intX,intY
End If

注: 此函数比FindStr要快很多，尤其是在字库很大时，或者模糊识别时，效果非常明显。
推荐使用此函数。
另外由于此函数是只识别待查找的字符，所以可能会有如下情况出现问题。
比如 字库中有"张和三" 一共3个字符数据，然后待识别区域里是"张和三",如果用FindStr查找
"张三"肯定是找不到的，但是用FindStrFast却可以找到，因为"和"这个字符没有列入查找计划中
所以，在使用此函数时，也要特别注意这一点。
]]
function DMCenter:FindStrFast( x1,y1,x2,y2,string,color_format,sim)
    self:checkMousePosEffect(x1, y1, x2, y2)
    return CPLUS.DmCenter.FindStrFast(self.__dm,x1,y1,x2,y2,string,color_format,sim)
end




--[[
同FindStrE
易语言用不了FindStrFast可以用此接口来代替
x1 整形数:区域的左上X坐标
y1 整形数:区域的左上Y坐标
x2 整形数:区域的右下X坐标
y2 整形数:区域的右下Y坐标
string 字符串:待查找的字符串, 可以是字符串组合，比如"长安|洛阳|大雁塔",中间用"|"来分割字符串
color_format 字符串:颜色格式串, 可以包含换行分隔符,语法是","后加分割字符串. 具体可以查看下面的示例.注意，RGB和HSV,以及灰度格式都支持.
sim 双精度浮点数:相似度,取值范围0.1-1.0

返回值:
字符串:
返回字符串序号以及X和Y坐标,形式如"id|x|y", 比如"0|100|200",没找到时，id和X以及Y均为-1，"-1|-1|-1"

示例:
pos = dm.FindStrFastE(0,0,2000,2000,"长安","9f2e3f-000000",1.0)
pos = split(pos,"|")
If int(pos(0)) >= 0 Then
     dm.MoveTo int(pos(1)),int(pos(2))
End If

pos = dm.FindStrFastE(0,0,2000,2000,"长安|洛阳","9f2e3f-000000",0.9)
pos = split(pos,"|")
If int(pos(0)) >= 0 Then
     dm.MoveTo int(pos(1)),int(pos(2))
End If

// 查找时,对多行文本进行换行,换行分隔符是"|". 语法是在","后增加换行字符串.任意字符串都可以.
pos = dm.FindStrFastE(0,0,2000,2000,"长安|洛阳","9f2e3f-000000,|",0.9)
pos = split(pos,"|")
If int(pos(0)) >= 0 Then
     dm.MoveTo int(pos(1)),int(pos(2))
End If

注: 此函数比FindStrE要快很多，尤其是在字库很大时，或者模糊识别时，效果非常明显。
推荐使用此函数。
另外由于此函数是只识别待查找的字符，所以可能会有如下情况出现问题。
比如 字库中有"张和三" 一共3个字符数据，然后待识别区域里是"张和三",如果用FindStrE查找
"张三"肯定是找不到的，但是用FindStrFastE却可以找到，因为"和"这个字符没有列入查找计划中
所以，在使用此函数时，也要特别注意这一点。
]]
function DMCenter:FindStrFastE( x1,y1,x2,y2,string,color_format,sim)
    self:checkMousePosEffect(x1, y1, x2, y2)
    return CPLUS.DmCenter.FindStrFastE(self.__dm,x1,y1,x2,y2,string,color_format,sim)
end




--[[
同FindStrEx
x1 整形数:区域的左上X坐标
y1 整形数:区域的左上Y坐标
x2 整形数:区域的右下X坐标
y2 整形数:区域的右下Y坐标
string 字符串:待查找的字符串, 可以是字符串组合，比如"长安|洛阳|大雁塔",中间用"|"来分割字符串
color_format 字符串:颜色格式串, 可以包含换行分隔符,语法是","后加分割字符串. 具体可以查看下面的示例.注意，RGB和HSV,以及灰度格式都支持.
sim 双精度浮点数:相似度,取值范围0.1-1.0

返回值:
字符串:
返回所有找到的坐标集合,格式如下:
"id,x0,y0|id,x1,y1|......|id,xn,yn"
比如"0,100,20|2,30,40" 表示找到了两个,第一个,对应的是序号为0的字符串,坐标是(100,20),第二个是序号为2的字符串,坐标(30,40)

示例:
dm_ret = dm.FindStrFastEx(0,0,2000,2000,"长安|洛阳","9f2e3f-000000",0.9)
If len(dm_ret) > 0 Then
   ss = split(dm_ret,"|")
   index = 0
   count = UBound(ss) + 1
   Do While index < count
      TracePrint ss(index)
      sss = split(ss(index),",")
      id = int(sss(0))
      x = int(sss(1))
      y = int(sss(2))
      dm.MoveTo x,y
      Delay 1000
      index = index+1
   Loop
End If

注: 此函数比FindStrEx要快很多，尤其是在字库很大时，或者模糊识别时，效果非常明显。
推荐使用此函数。
另外由于此函数是只识别待查找的字符，所以可能会有如下情况出现问题。
比如 字库中有"张和三" 一共3个字符数据，然后待识别区域里是"张和三",如果用FindStrEx查找
"张三"肯定是找不到的，但是用FindStrFastEx却可以找到，因为"和"这个字符没有列入查找计划中
所以，在使用此函数时，也要特别注意这一点。
]]
function DMCenter:FindStrFastEx( x1,y1,x2,y2,string,color_format,sim)
    self:checkMousePosEffect(x1, y1, x2, y2)
    return CPLUS.DmCenter.FindStrFastEx(self.__dm,x1,y1,x2,y2,string,color_format,sim)
end





--[[
同FindStrExS. 
x1 整形数:区域的左上X坐标
y1 整形数:区域的左上Y坐标
x2 整形数:区域的右下X坐标
y2 整形数:区域的右下Y坐标
string 字符串:待查找的字符串, 可以是字符串组合，比如"长安|洛阳|大雁塔",中间用"|"来分割字符串
color_format 字符串:颜色格式串, 可以包含换行分隔符,语法是","后加分割字符串. 具体可以查看下面的示例 .注意，RGB和HSV,以及灰度格式都支持.
sim 双精度浮点数:相似度,取值范围0.1-1.0

返回值:
字符串:
返回所有找到的坐标集合,格式如下:
"str,x0,y0| str,x1,y1|......| str,xn,yn"
比如"长安,100,20|大雁塔,30,40" 表示找到了两个,第一个是长安 ,坐标是(100,20),第二个是大雁塔,坐标(30,40)
示例:
dm_ret = dm.FindStrFastExS(0,0,2000,2000,"长安|洛阳","9f2e3f-000000",0.9)
If len(dm_ret) > 0 Then
   ss = split(dm_ret,"|")
   index = 0
   count = UBound(ss) + 1
   Do While index < count
      TracePrint ss(index)
      sss = split(ss(index),",")
      str = sss(0)
      x = int(sss(1))
      y = int(sss(2))
      dm.MoveTo x,y
      Delay 1000
      index = index+1
   Loop
End If
注: 此函数比FindStrExS要快很多，尤其是在字库很大时，或者模糊识别时，效果非常明显。
推荐使用此函数。
另外由于此函数是只识别待查找的字符，所以可能会有如下情况出现问题。
比如 字库中有"张和三" 一共3个字符数据，然后待识别区域里是"张和三",如果用FindStrExS查找
"张三"肯定是找不到的，但是用FindStrFastExS却可以找到，因为"和"这个字符没有列入查找计划中
所以，在使用此函数时，也要特别注意这一点。
]]
function DMCenter:FindStrFastExS( x1,y1,x2,y2,string,color_format,sim)
    self:checkMousePosEffect(x1, y1, x2, y2)
    return CPLUS.DmCenter.FindStrFastExS(self.__dm,x1,y1,x2,y2,string,color_format,sim)
end




--[[
同FindStrS. 
x1 整形数:区域的左上X坐标
y1 整形数:区域的左上Y坐标
x2 整形数:区域的右下X坐标
y2 整形数:区域的右下Y坐标
string 字符串:待查找的字符串,可以是字符串组合，比如"长安|洛阳|大雁塔",中间用"|"来分割字符串
color_format 字符串:颜色格式串, 可以包含换行分隔符,语法是","后加分割字符串. 具体可以查看下面的示例 .注意，RGB和HSV,以及灰度格式都支持.
sim 双精度浮点数:相似度,取值范围0.1-1.0
intX 变参指针:返回X坐标 没找到返回-1
intY 变参指针:返回Y坐标 没找到返回-1

返回值: table{x=0,y=0,str=""}

字符串:
返回找到的字符串. 没找到的话返回长度为0的字符串.

示例:
dm_ret = dm.FindStrFastS(0,0,2000,2000,"长安","9f2e3f-000000",1.0,intX,intY)
If intX >= 0 and intY >= 0 Then
     dm.MoveTo intX,intY
End If

dm_ret = dm.FindStrFastS(0,0,2000,2000,"长安|洛阳","9f2e3f-000000",0.9,intX,intY)
If intX >= 0 and intY >= 0 Then
     dm.MoveTo intX,intY
End If

// 查找时,对多行文本进行换行,换行分隔符是"|". 语法是在","后增加换行字符串.任意字符串都可以.
dm_ret = dm.FindStrFastS(0,0,2000,2000,"长安|洛阳","9f2e3f-000000,|",0.9,intX,intY)
If intX >= 0 and intY >= 0 Then
     dm.MoveTo intX,intY
End If

注: 此函数比FindStrS要快很多，尤其是在字库很大时，或者模糊识别时，效果非常明显。
推荐使用此函数。
另外由于此函数是只识别待查找的字符，所以可能会有如下情况出现问题。
比如 字库中有"张和三" 一共3个字符数据，然后待识别区域里是"张和三",如果用FindStrS查找
"张三"肯定是找不到的，但是用FindStrFastS却可以找到，因为"和"这个字符没有列入查找计划中
所以，在使用此函数时，也要特别注意这一点。
]]
function DMCenter:FindStrFastS( x1,y1,x2,y2,string,color_format,sim)
    self:checkMousePosEffect(x1, y1, x2, y2)
    return CPLUS.DmCenter.FindStrFastS(self.__dm,x1,y1,x2,y2,string,color_format,sim)
end



--[[
在屏幕范围(x1,y1,x2,y2)内,查找string(可以是任意个字符串的组合),
并返回符合color_format的坐标位置,相似度sim同Ocr接口描述.
(多色,差色查找类似于Ocr接口,不再重述).此函数同FindStr,只是返回值不同.
x1 整形数:区域的左上X坐标
y1 整形数:区域的左上Y坐标
x2 整形数:区域的右下X坐标
y2 整形数:区域的右下Y坐标
string 字符串:待查找的字符串,可以是字符串组合，比如"长安|洛阳|大雁塔",中间用"|"来分割字符串
color_format 字符串:颜色格式串, 可以包含换行分隔符,语法是","后加分割字符串. 具体可以查看下面的示例 .注意，RGB和HSV,以及灰度格式都支持.
sim 双精度浮点数:相似度,取值范围0.1-1.0
intX 变参指针:返回X坐标 没找到返回-1
intY 变参指针:返回Y坐标 没找到返回-1

返回值: table{x=0,y=0,str=""}
字符串:
返回找到的字符串. 没找到的话返回长度为0的字符串.

示例:
dm_ret = dm.FindStrS(0,0,2000,2000,"长安","9f2e3f-000000",1.0,intX,intY)
If intX >= 0 and intY >= 0 Then
     dm.MoveTo intX,intY
End If

dm_ret = dm.FindStrS(0,0,2000,2000,"长安|洛阳","9f2e3f-000000",1.0,intX,intY)
If intX >= 0 and intY >= 0 Then
     dm.MoveTo intX,intY
End If

// 查找时,对多行文本进行换行,换行分隔符是"|". 语法是在","后增加换行字符串.任意字符串都可以.
dm_ret = dm.FindStrS(0,0,2000,2000,"长安|洛阳","9f2e3f-000000,|",1.0,intX,intY)
If intX >= 0 and intY >= 0 Then
     dm.MoveTo intX,intY
End If
注: 此函数的原理是先Ocr识别，然后再查找。所以速度比FindStrFastS要慢，尤其是在字库
很大，或者模糊度不为1.0时。
一般字库字符数量小于100左右，模糊度为1.0时，用FindStrS要快一些,否则用FindStrFastS.
]]
function DMCenter:FindStrS( x1,y1,x2,y2,string,color_format,sim)
    self:checkMousePosEffect(x1, y1, x2, y2)
    return CPLUS.DmCenter.FindStrS(self.__dm,x1,y1,x2,y2,string,color_format,sim)
end




--[[
同FindStr，但是不使用SetDict设置的字库，而利用系统自带的字库，速度比FindStr稍慢
x1 整形数:区域的左上X坐标
y1 整形数:区域的左上Y坐标
x2 整形数:区域的右下X坐标
y2 整形数:区域的右下Y坐标
string 字符串:待查找的字符串,可以是字符串组合，比如"长安|洛阳|大雁塔",中间用"|"来分割字符串
color_format 字符串:颜色格式串, 可以包含换行分隔符,语法是","后加分割字符串. 具体可以查看下面的示例 .注意，RGB和HSV,以及灰度格式都支持.
sim 双精度浮点数:相似度,取值范围0.1-1.0
font_name 字符串:系统字体名,比如"宋体"
font_size 整形数:系统字体尺寸，这个尺寸一定要以大漠综合工具获取的为准.如果获取尺寸看视频教程.
flag 整形数:字体类别 取值可以是以下值的组合,比如1+2+4+8,2+4. 0表示正常字体.
    1 : 粗体
    2 : 斜体
    4 : 下划线
    8 : 删除线
intX 变参指针:返回X坐标没找到返回-1
intY 变参指针:返回Y坐标没找到返回-1

返回值: table{x=0,y=0,str=""}
整形数:
返回字符串的索引 没找到返回-1, 比如"长安|洛阳",若找到长安，则返回0

示例:
dm_ret = dm.FindStrWithFont(0,0,2000,2000,"长安","9f2e3f-000000",1.0,"宋体",9,0,intX,intY)
If intX >= 0 and intY >= 0 Then
     dm.MoveTo intX,intY
End If

dm_ret = dm.FindStrWithFont(0,0,2000,2000,"长安|洛阳","9f2e3f-000000",1.0,"宋体",9,1+2,intX,intY)
If intX >= 0 and intY >= 0 Then
     dm.MoveTo intX,intY
End If

// 查找时,对多行文本进行换行,换行分隔符是"|". 语法是在","后增加换行字符串.任意字符串都可以.
dm_ret = dm.FindStrWithFont(0,0,2000,2000,"长安|洛阳","9f2e3f-000000,|",1.0,"宋体",9,1+2,intX,intY)
If intX >= 0 and intY >= 0 Then
     dm.MoveTo intX,intY
End If

注: 对于如何获取字体尺寸以及名字等信息，可以参考视频教程，如何使用系统字库.
]]
function DMCenter:FindStrWithFont( x1,y1,x2,y2,string,color_format,sim,font_name,font_size,flag)
    self:checkMousePosEffect(x1, y1, x2, y2)
    return CPLUS.DmCenter.FindStrWithFont(self.__dm,x1,y1,x2,y2,string,color_format,sim,font_name,font_size,flag)
end



--[[
同FindStrE，但是不使用SetDict设置的字库，而利用系统自带的字库，速度比FindStrE稍慢
x1 整形数:区域的左上X坐标
y1 整形数:区域的左上Y坐标
x2 整形数:区域的右下X坐标
y2 整形数:区域的右下Y坐标
string 字符串:待查找的字符串, 可以是字符串组合，比如"长安|洛阳|大雁塔",中间用"|"来分割字符串
color_format 字符串:颜色格式串, 可以包含换行分隔符,语法是","后加分割字符串. 具体可以查看下面的示例.注意，RGB和HSV,以及灰度格式都支持.
sim 双精度浮点数:相似度,取值范围0.1-1.0
font_name 字符串:系统字体名,比如"宋体"
font_size 整形数:系统字体尺寸，这个尺寸一定要以大漠综合工具获取的为准.如果获取尺寸看视频教程.
flag 整形数:字体类别 取值可以是以下值的组合,比如1+2+4+8,2+4. 0表示正常字体.
    1 : 粗体
    2 : 斜体
    4 : 下划线
    8 : 删除线
返回值:
字符串:
返回字符串序号以及X和Y坐标,形式如"id|x|y", 比如"0|100|200",没找到时，id和X以及Y均为-1，"-1|-1|-1"

示例:
pos = dm.FindStrWithFontE(0,0,2000,2000,"长安","9f2e3f-000000",1.0,"宋体",9,0)
pos = split(pos,"|")
If int(pos(0)) >= 0 Then
     dm.MoveTo int(pos(1)),int(pos(2))
End If

pos = dm.FindStrWithFontE(0,0,2000,2000,"长安|洛阳","9f2e3f-000000",1.0,"宋体",9,1+2)
pos = split(pos,"|")
If int(pos(0)) >= 0 Then
     dm.MoveTo int(pos(1)),int(pos(2))
End If

// 查找时,对多行文本进行换行,换行分隔符是"|". 语法是在","后增加换行字符串.任意字符串都可以.
pos = dm.FindStrWithFontE(0,0,2000,2000,"长安|洛阳","9f2e3f-000000,|",1.0,"宋体",9,1+2)
pos = split(pos,"|")
If int(pos(0)) >= 0 Then
     dm.MoveTo int(pos(1)),int(pos(2))
End If
注: 对于如何获取字体尺寸以及名字等信息，可以参考视频教程，如何使用系统字库.
]]
function DMCenter:FindStrWithFontE( x1,y1,x2,y2,string,color_format,sim,font_name,font_size,flag)
    self:checkMousePosEffect(x1, y1, x2, y2)
    return CPLUS.DmCenter.FindStrWithFontE(self.__dm,x1,y1,x2,y2,string,color_format,sim,font_name,font_size,flag)
end




--[[
同FindStrEx，但是不使用SetDict设置的字库，而利用系统自带的字库，速度比FindStrEx稍慢
x1 整形数:区域的左上X坐标
y1 整形数:区域的左上Y坐标
x2 整形数:区域的右下X坐标
y2 整形数:区域的右下Y坐标
string 字符串:待查找的字符串, 可以是字符串组合，比如"长安|洛阳|大雁塔",中间用"|"来分割字符串
color_format 字符串:颜色格式串, 可以包含换行分隔符,语法是","后加分割字符串. 具体可以查看下面的示例.注意，RGB和HSV,以及灰度格式都支持.
sim 双精度浮点数:相似度,取值范围0.1-1.0
font_name 字符串:系统字体名,比如"宋体"
font_size 整形数:系统字体尺寸，这个尺寸一定要以大漠综合工具获取的为准.如果获取尺寸看视频教程.
flag 整形数:字体类别 取值可以是以下值的组合,比如1+2+4+8,2+4. 0表示正常字体.
    1 : 粗体
    2 : 斜体
    4 : 下划线
    8 : 删除线

返回值:

字符串:
返回所有找到的坐标集合,格式如下:
"id,x0,y0|id,x1,y1|......|id,xn,yn"
比如"0,100,20|2,30,40" 表示找到了两个,第一个,对应的是序号为0的字符串,坐标是(100,20),第二个是序号为2的字符串,坐标(30,40)

示例:
dm_ret = dm.FindStrWithFontEx(0,0,2000,2000,"长安|洛阳","9f2e3f-000000",1.0,"宋体",9,1+2)
If len(dm_ret) > 0 Then
   ss = split(dm_ret,"|")
   index = 0
   count = UBound(ss) + 1
   Do While index < count
      TracePrint ss(index)
      sss = split(ss(index),",")
      id = int(sss(0))
      x = int(sss(1))
      y = int(sss(2))
      dm.MoveTo x,y
      Delay 1000
      index = index+1
   Loop
End If
注: 对于如何获取字体尺寸以及名字等信息，可以参考视频教程，如何使用系统字库.
]]
function DMCenter:FindStrWithFontEx( x1,y1,x2,y2,string,color_format,sim,font_name,font_size,flag)
    self:checkMousePosEffect(x1, y1, x2, y2)
    return CPLUS.DmCenter.FindStrWithFontEx(self.__dm,x1,y1,x2,y2,string,color_format,sim,font_name,font_size,flag)
end




--[[
获取指定字库中指定条目的字库信息.
index 整形数: 字库序号(0-99)
font_index 整形数: 字库条目序号(从0开始计数,数值不得超过指定字库的字库上限,具体参考GetDictCount)

返回值:
字符串:
返回字库条目信息. 失败返回空串.

示例:
s = dm.GetDict(0,1245)
TracePrint s
s = dm.GetDict(1,678)
TracePrint s
]]
function DMCenter:GetDict( index,font_index)
    return CPLUS.DmCenter.GetDict(self.__dm,index,font_index)
end




--[[
获取指定的字库中的字符数量.
index 整形数: 字库序号(0-99)
返回值:
整形数:
字库数量
示例:
count = dm.GetDictCount(0)
TracePrint "0号字库使用的字库数量是:"&count
]]
function DMCenter:GetDictCount( index)
    return CPLUS.DmCenter.GetDictCount(self.__dm,index)
end





--[[
根据指定的文字，以及指定的系统字库信息，获取字库描述信息.
str 字符串:需要获取的字符串
font_name 字符串:系统字体名,比如"宋体"
font_size 整形数:系统字体尺寸，这个尺寸一定要以大漠综合工具获取的为准.如何获取尺寸看视频教程.
flag 整形数:字体类别 取值可以是以下值的组合,比如1+2+4+8,2+4. 0表示正常字体.
    1 : 粗体
    2 : 斜体
    4 : 下划线
    8 : 删除线
返回值:
字符串:
返回字库信息,每个字符的字库信息用"|"来分割
示例:
// 下面的代码是获取"回收站"这3个字符的字库信息，然后加入到字库1中.
font_desc = dm.GetDictInfo("回收站","宋体",9,0)
font_desc = split(font_desc,"|")
count = ubound(font_desc)
for i = 0 to count
    TracePrint font_desc(i)
    dm.AddDict 1,font_desc(i)
next
]]
function DMCenter:GetDictInfo( str,font_name,font_size,flag)
    return CPLUS.DmCenter.GetDictInfo(self.__dm,str,font_name,font_size,flag)
end




--[[
获取当前使用的字库序号(0-99)
返回值:

整形数:
字库序号(0-99)

]]
function DMCenter:GetNowDict( )
    return CPLUS.DmCenter.GetNowDict(self.__dm)
end




--[[
对插件部分接口的返回值进行解析,并返回ret中的坐标个数
ret 字符串: 部分接口的返回串
返回值:
整形数:
返回ret中的坐标个数
]]
function DMCenter:GetResultCount( ret)
    return CPLUS.DmCenter.GetResultCount(self.__dm,ret)
end




--[[
对插件部分接口的返回值进行解析,并根据指定的第index个坐标,返回具体的值
ret 字符串:部分接口的返回串
index 整形数: 第几个坐标
intX 变参指针: 返回X坐标
intY 变参指针: 返回Y坐标

返回值:table{x=0,y=0}

整形数:
0:失败
1:成功

示例:
s = dm.FindColorEx(0,0,2000,2000,"123456-000000|abcdef-202020",1.0,0)
count = dm.GetResultCount(s)
index = 0
Do While index < count
    dm_ret = dm.GetResultPos(s,index,intX,intY)
    MessageBox intX&","&intY 
    index = index + 1 
Loop
]]
function DMCenter:GetResultPos( ret,index)
    return CPLUS.DmCenter.GetResultPos(self.__dm,ret,index)
end




--[[
在使用GetWords进行词组识别以后,可以用此接口进行识别词组数量的计算.
参数定义:
str 字符串: GetWords接口调用以后的返回值
返回值:
整形数:
返回词组数量

示例:
s = dm.GetWords(0,0,2000,2000,"000000-000000",1.0)
count = dm.GetWordResultCount(s)
MessageBox count 
]]
function DMCenter:GetWordResultCount( str)
    return CPLUS.DmCenter.GetWordResultCount(self.__dm,str)
end






--[[
在使用GetWords进行词组识别以后,可以用此接口进行识别各个词组的坐标
参数定义:

str 字符串: GetWords的返回值

index 整形数: 表示第几个词组

intX 变参指针: 返回的X坐标

intY 变参指针: 返回的Y坐标

返回值: table{x=0,y=0}
整形数:
0: 失败
1: 成功
示例:
s = dm.GetWords(0,0,2000,2000,"000000-000000",1.0)
count = dm.GetWordResultCount(s)
index = 0
Do While index < count
    dm_ret = dm.GetWordResultPos(s,index,intX,intY)
    MessageBox intX&","&intY 
    index = index + 1 
Loop 
]]
function DMCenter:GetWordResultPos( str,index)
    return CPLUS.DmCenter.GetWordResultPos(self.__dm,str,index)
end




--[[
在使用GetWords进行词组识别以后,可以用此接口进行识别各个词组的内容
str 字符串: GetWords的返回值
index 整形数: 表示第几个词组
返回值:
字符串:
返回的第index个词组内容
示例:
s = dm.GetWords(0,0,2000,2000,"000000-000000",1.0)
count = dm.GetWordResultCount(s)
index = 0
Do While index < count
    word = dm.GetWordResultStr(s,index)
    MessageBox word 
    index = index + 1 
Loop 
]]
function DMCenter:GetWordResultStr( str,index)
    return CPLUS.DmCenter.GetWordResultStr(self.__dm,str,index)
end



--[[
根据指定的范围,以及设定好的词组识别参数(一般不用更改,除非你真的理解了)
识别这个范围内所有满足条件的词组. 比较适合用在未知文字的情况下,进行不定识别.
x1 整形数:左上角X坐标
y1 整形数:左上角Y坐标
x2 整形数:右下角X坐标
y2 整形数:右下角Y坐标
color 字符串: 颜色格式串.注意，RGB和HSV,以及灰度格式都支持.
sim 双精度浮点数:相似度 0.1-1.0 

返回值:
字符串:
识别到的格式串,要用到专用函数来解析
示例:
s = dm.GetWords(0,0,2000,2000,"000000-000000",1.0)
count = dm.GetWordResultCount(s)
index = 0
Do While index < count
    dm_ret = dm.GetWordResultPos(s,index,intX,intY)
    word = dm.GetWordResultStr(s,index)
    MessageBox intX&","&intY&","&word
    index = index + 1 
Loop 
]]
function DMCenter:GetWords( x1, y1, x2, y2, color, sim)
    self:checkMousePosEffect(x1, y1, x2, y2)
    return CPLUS.DmCenter.GetWords(self.__dm,x1, y1, x2, y2, color, sim)
end

function DMCenter:GetWordsNew( x1, y1, x2, y2, color, sim)
    local s = self:GetWords(x1, y1, x2, y2, color, sim)
    local count = self:GetWordResultCount(s)
    local list = {}
    local index = 0
    while index < count do
        local data = DMCenter:GetWordResultPos(s,index)
        local word = DMCenter:GetWordResultStr(s,index)
        data.word = self:GBKToUTF8(word)
        table.insert(list,data)
        index = index + 1 
    end
    return list
end
    
--[[
根据指定的范围,以及设定好的词组识别参数(一般不用更改,除非你真的理解了)
识别这个范围内所有满足条件的词组. 这个识别函数不会用到字库。只是识别大概形状的位置 
x1 整形数:左上角X坐标
y1 整形数:左上角Y坐标
x2 整形数:右下角X坐标
y2 整形数:右下角Y坐标
color 字符串: 颜色格式串.注意，RGB和HSV,以及灰度格式都支持.
返回值:
字符串:
识别到的格式串,要用到专用函数来解析
示例:
s = dm.GetWordsNoDict(0,0,2000,2000,"000000-000000")
count = dm.GetResultCount(s)
index = 0
Do While index < count
    dm_ret = dm.GetResultPos(s,index,intX,intY)
    MessageBox intX&","&intY
    index = index + 1 
Loop 
]]
function DMCenter:GetWordsNoDict( x1, y1, x2, y2, color)
    self:checkMousePosEffect(x1, y1, x2, y2)
    return CPLUS.DmCenter.GetWordsNoDict(self.__dm,x1, y1, x2, y2, color)
end




--[[
识别屏幕范围(x1,y1,x2,y2)内符合color_format的字符串,并且相似度为sim,sim取值范围(0.1-1.0),
这个值越大越精确,越大速度越快,越小速度越慢,请斟酌使用!
x1 整形数:区域的左上X坐标
y1 整形数:区域的左上Y坐标
x2 整形数:区域的右下X坐标
y2 整形数:区域的右下Y坐标
color_format 字符串:颜色格式串. 可以包含换行分隔符,语法是","后加分割字符串. 具体可以查看下面的示例.注意，RGB和HSV,以及灰度格式都支持.
sim 双精度浮点数:相似度,取值范围0.1-1.0

返回值:
字符串:
返回识别到的字符串
示例:
//RGB单色识别
s = dm.Ocr(0,0,2000,2000,"9f2e3f-000000",1.0)
MessageBox s
//RGB单色差色识别
s = dm.Ocr(0,0,2000,2000,"9f2e3f-030303",1.0)
MessageBox s
//RGB多色识别(最多支持10种,每种颜色用"|"分割)
s = dm.Ocr(0,0,2000,2000,"9f2e3f-030303|2d3f2f-000000|3f9e4d-100000",1.0)
MessageBox s
//HSV多色识别(最多支持10种,每种颜色用"|"分割)
s = dm.Ocr(0,0,2000,2000,"20.30.40-0.0.0|30.40.50-0.0.0",1.0)
MessageBox s
//灰度多色识别(最多支持10种,每种颜色用"|"分割)
s = dm.Ocr(0,0,2000,2000,"#40-0|#70-10",1.0)
MessageBox s
//识别后,每行字符串用指定字符分割
比如用"|"字符分割
s = dm.Ocr(0,0,2000,2000,"9f2e3f-000000,|",1.0)
MessageBox s
//比如用回车换行分割
s = dm.Ocr(0,0,2000,2000,"9f2e3f-000000,"+vbcrlf,1.0)
MessageBox s
//背景色识别
//比如要识别背景色为白色,文字颜色未知的字形
s = dm.Ocr(0,0,2000,2000,"b@ffffff-000000",1.0)
MessageBox s
//注: 在color_fomat最前面加上"b@"表示后面的颜色描述是针对背景色,而非字的颜色.
]]
function DMCenter:Ocr( x1,y1,x2,y2,color_format,sim)
    self:checkMousePosEffect(x1, y1, x2, y2)
    local text = CPLUS.DmCenter.Ocr(self.__dm,x1,y1,x2,y2,color_format,sim)
    return game.dmcenter:GBKToUTF8(text)
end




--[[
识别屏幕范围(x1,y1,x2,y2)内符合color_format的字符串,并且相似度为sim,sim取值范围(0.1-1.0),
这个值越大越精确,越大速度越快,越小速度越慢,请斟酌使用!
这个函数可以返回识别到的字符串，以及每个字符的坐标.
x1 整形数:区域的左上X坐标
y1 整形数:区域的左上Y坐标
x2 整形数:区域的右下X坐标
y2 整形数:区域的右下Y坐标
color_format 字符串:颜色格式串.注意，RGB和HSV,以及灰度格式都支持.
sim 双精度浮点数:相似度,取值范围0.1-1.0

返回值:
字符串:
返回识别到的字符串 格式如  "字符0$x0$y0|…|字符n$xn$yn"
示例:
和Ocr函数相同，只是结果处理有所不同如下
dm_ret = dm.OcrEx(0,0,2000,2000,"ffffff|000000",1.0)
ss = split(dm_ret,"|")
index = 0
count = UBound(ss) + 1
Do While index < count
   TracePrint ss(index)
   sss = split(ss(index),"$")
   ocr_s = int(sss(0))
   x = int(sss(1))
   y = int(sss(2))
   TracePrint ocr_s & ","&x&","&y
   index = index+1
Loop
注: OcrEx不再像Ocr一样,支持换行分割了.
]]
function DMCenter:OcrEx( x1,y1,x2,y2,color_format,sim)
    self:checkMousePosEffect(x1, y1, x2, y2)
    return CPLUS.DmCenter.OcrEx(self.__dm,x1,y1,x2,y2,color_format,sim)
end




--[[
识别屏幕范围(x1,y1,x2,y2)内符合color_format的字符串,并且相似度为sim,sim取值范围(0.1-1.0),
这个值越大越精确,越大速度越快,越小速度越慢,请斟酌使用!
这个函数可以返回识别到的字符串，以及每个字符的坐标.这个同OcrEx,另一种返回形式.
x1 整形数:区域的左上X坐标
y1 整形数:区域的左上Y坐标
x2 整形数:区域的右下X坐标
y2 整形数:区域的右下Y坐标
color_format 字符串:颜色格式串.注意，RGB和HSV,以及灰度格式都支持.
sim 双精度浮点数:相似度,取值范围0.1-1.0

返回值:
字符串:
返回识别到的字符串 格式如  "识别到的信息|x0,y0|…|xn,yn"
示例:
和Ocr函数相同，只是结果处理有所不同如下
ss = dm.OcrExOne(0,0,2000,2000,"ffffff|000000",1.0)
ss = split(ss,"|")
MessageBox "识别到的字符串:"&ss(0)
ss_len = len(ss(0))
for i = 1 to ss_len 
    MessageBox "第("&i&")的坐标是"&ss(i)
next
]]
function DMCenter:OcrExOne( x1,y1,x2,y2,color_format,sim)
    self:checkMousePosEffect(x1, y1, x2, y2)
    return CPLUS.DmCenter.OcrExOne(self.__dm,x1,y1,x2,y2,color_format,sim)
end




--[[
识别位图中区域(x1,y1,x2,y2)的文字
x1 整形数:区域的左上X坐标
y1 整形数:区域的左上Y坐标
x2 整形数:区域的右下X坐标
y2 整形数:区域的右下Y坐标
pic_name 字符串:图片文件名
color_format 字符串:颜色格式串.注意，RGB和HSV,以及灰度格式都支持.
sim 双精度浮点数:相似度,取值范围0.1-1.0

返回值:
字符串:
返回识别到的字符串
示例:
s = dm.OcrInFile(0,0,2000,2000,"test.bmp","000000-000000",1.0)
MessageBox s
]]
function DMCenter:OcrInFile( x1, y1, x2, y2, pic_name, color_format, sim)
    self:checkMousePosEffect(x1, y1, x2, y2)
    return CPLUS.DmCenter.OcrInFile(self.__dm,x1, y1, x2, y2, pic_name, color_format, sim)
end





--[[
保存指定的字库到指定的文件中.
index 整形数:字库索引序号 取值为0-99对应100个字库
file 字符串:文件名

返回值:
整形数:
0:失败
1:成功
示例:
dm.SetPath "c:\test_game"
dm.AddDict 0,"FFF00A7D49292524A7D402805FFC$回$0.0.54$11"
dm.AddDict 0,"3F0020087FF08270B9A108268708808$收$0.0.43$11"
dm.AddDict 0,"2055C98617420807C097F222447C800$站$0.0.44$11"
dm.SaveDict 0,"test.txt"
]]
function DMCenter:SaveDict( index,file)
    return CPLUS.DmCenter.SaveDict(self.__dm,index,file) == 1
end




--[[
高级用户使用,在不使用字库进行词组识别前,可设定文字的列距,默认列距是1
col_gap 整形数:文字列距
返回值:
整形数:
0:失败
1:成功
示例:
dm_ret = dm.SetColGapNoDict(3)  
]]
function DMCenter:SetColGapNoDict( col_gap)
    return CPLUS.DmCenter.SetColGapNoDict(self.__dm,col_gap) == 1
end




--[[
设置字库文件
index 整形数:字库的序号,取值为0-99,目前最多支持100个字库
file 字符串:字库文件名
返回值:
整形数:
0:失败
1:成功
示例
dm_ret = dm.SetDict(0,"test.txt")
注: 此函数速度很慢，全局初始化时调用一次即可，切换字库用UseDict
]]
function DMCenter:SetDict( index,file)
    return CPLUS.DmCenter.SetDict(self.__dm,index,file) == 1
end





--[[
从内存中设置字库.
index 整形数:字库的序号,取值为0-99,目前最多支持100个字库
addr 整形数: 数据地址
size 整形数: 字库长度
返回值:
整形数:
0:失败
1:成功
示例:
dm_ret = dm.SetDictMem(0,234324,1000)
注: 此函数速度很慢，全局初始化时调用一次即可，切换字库用UseDict
另外，此函数不支持加密的内存字库.
]]
function DMCenter:SetDictMem( index,addr,size)
    assert(false,"涉及到指针，暂无实现")
end


--[[
设置字库的密码,在SetDict前调用,目前的设计是,所有字库通用一个密码.
pwd 字符串:字库密码
返回值:
整形数:
0:失败
1:成功
示例:
dm_ret = dm.SetDictPwd("1234")
注意:如果使用了多字库,所有字库的密码必须一样. 此函数必须在SetDict之前调用,否则会解密失败.
]]
function DMCenter:SetDictPwd( pwd)
    return CPLUS.DmCenter.SetDictPwd(self.__dm,pwd) == 1
end




--[[
高级用户使用,在使用文字识别功能前，设定是否开启精准识别
exact_ocr 整形数: 0 表示关闭精准识别
            1 开启精准识别
返回值:
整形数:
0:失败
1:成功
示例:
// 开启精准识别
dm_ret = dm.SetExactOcr(1)
注意: 精准识别开启后，行间距和列间距会对识别结果造成较大影响，可以在工具中进行测试.
]]
function DMCenter:SetExactOcr( exact_ocr)
    return CPLUS.DmCenter.SetExactOcr(self.__dm,exact_ocr) == 1
end




--[[
高级用户使用,在识别前,如果待识别区域有多行文字,可以设定列间距,默认的列间距是0,
如果根据情况设定,可以提高识别精度。一般不用设定。
min_col_gap 整形数:最小列间距
返回值:
整形数:
0:失败
1:成功
示例:
dm_ret = dm.SetMinColGap(1)
注意：此设置如果不为0,那么将不能识别连体字 慎用.
]]
function DMCenter:SetMinColGap( min_col_gap)
    return CPLUS.DmCenter.SetMinColGap(self.__dm,min_col_gap) == 1
end




--[[
高级用户使用,在识别前,如果待识别区域有多行文字,可以设定行间距,默认的行间距是1,
如果根据情况设定,可以提高识别精度。一般不用设定
min_row_gap 整形数:最小行间距

返回值:
整形数:
0:失败
1:成功
示例:
dm_ret = dm.SetMinRowGap(2)
]]
function DMCenter:SetMinRowGap( min_row_gap)
    return CPLUS.DmCenter.SetMinRowGap(self.__dm,min_row_gap) == 1
end




--[[
高级用户使用,在不使用字库进行词组识别前,可设定文字的行距,默认行距是1
row_gap 整形数:文字行距

返回值:
整形数:
0:失败
1:成功
示例:
dm_ret = dm.SetRowGapNoDict(3)
]]
function DMCenter:SetRowGapNoDict( row_gap)
    return CPLUS.DmCenter.SetRowGapNoDict(self.__dm,row_gap) == 1
end




--[[
高级用户使用,在识别词组前,可设定词组间的间隔,默认的词组间隔是5
word_gap 整形数:单词间距
返回值:
整形数:
0:失败
1:成功

示例:
dm_ret = dm.SetWordGap(5)
]]
function DMCenter:SetWordGap( word_gap)
    return CPLUS.DmCenter.SetWordGap(self.__dm,word_gap) == 1
end





--[[
高级用户使用,在不使用字库进行词组识别前,可设定词组间的间隔,默认的词组间隔是5
word_gap 整形数:单词间距

返回值:
整形数:
0:失败
1:成功
示例:
dm_ret = dm.SetWordGapNoDict(1)
]]
function DMCenter:SetWordGapNoDict( word_gap)
    return CPLUS.DmCenter.SetWordGapNoDict(self.__dm,word_gap) == 1
end






--[[
高级用户使用,在识别词组前,可设定文字的平均行高,默认的词组行高是10
line_height 整形数:行高

返回值:
整形数:
0:失败
1:成功
示例:
dm_ret = dm.SetWordLineHeight(15)
]]
function DMCenter:SetWordLineHeight( line_height)
    return CPLUS.DmCenter.SetWordLineHeight(self.__dm,line_height) == 1
end




--[[
高级用户使用,在不使用字库进行词组识别前,可设定文字的平均行高,默认的词组行高是10
line_height 整形数:行高
返回值:
整形数:
0:失败
1:成功
示例:
dm_ret = dm.SetWordLineHeightNoDict(15)
]]
function DMCenter:SetWordLineHeightNoDict( line_height)
    return CPLUS.DmCenter.SetWordLineHeightNoDict(self.__dm,line_height) == 1
end





--[[
表示使用哪个字库文件进行识别(index范围:0-99)
设置之后，永久生效，除非再次设定
index 整形数:字库编号(0-99)
返回值:
整形数:
0:失败
1:成功
示例:
dm_ret = dm.UseDict(1)
ss = dm.Ocr(0,0,2000,2000,"FFFFFF-000000",1.0)
dm_ret = dm.UseDict(0)
]]
function DMCenter:UseDict( index)
    return CPLUS.DmCenter.UseDict(self.__dm,index) == 1
end


-------------------------基本设置-----------------------------------------
--[[
设置是否开启或者关闭插件内部的图片缓存机制. (默认是打开).
enable 整形数: 0 : 关闭  1 : 打开
返回值:
整形数:
0: 失败
1: 成功
示例:
dm.EnablePicCache 0
注: 有些时候，系统内存比较吃紧，这时候再打开内部缓存，可能会导致缓存分配在虚拟内存，这样频繁换页，反而导致图色效率下降.这时候就建议关闭图色缓存.
所有图色缓存机制都是对本对象的，也就是说，调用图色缓存机制的函数仅仅对本对象生效. 每个对象都有一个图色缓存队列.
]]
function DMCenter:EnablePicCache( enable)
    return CPLUS.DmCenter.EnablePicCache(self.__dm,enable) == 1
end

--[[
获取注册在系统中的dm.dll的路径. 
返回值:
字符串:
返回dm.dll所在路径
]]
function DMCenter:GetBasePath( )
    return CPLUS.DmCenter.GetBasePath(self.__dm)
end




--[[
返回当前进程已经创建的dm对象个数.
返回值:
整形数:
个数.
]]
function DMCenter:GetDmCount( )
    return CPLUS.DmCenter.GetDmCount(self.__dm)
end



--[[
返回当前大漠对象的ID值，这个值对于每个对象是唯一存在的。可以用来判定两个大漠对象是否一致.
返回值:
整形数:
当前对象的ID值.
]]
function DMCenter:GetID( )
    return CPLUS.DmCenter.GetID(self.__dm)
end



--[[
获取插件命令的最后错误
返回值:

整形数:
返回值表示错误值。 0表示无错误.

-1 : 表示你使用了绑定里的收费功能，但是没注册，无法使用.
-2 : 使用模式0 2 时出现，因为目标窗口有保护. 常见于win7以上系统.或者有安全软件拦截插件.解决办法: 关闭所有安全软件，然后再重新尝试. 如果还不行就可以肯定是目标窗口有特殊保护. 
-3 : 使用模式0 2 时出现，可能目标窗口有保护，也可能是异常错误. 可以尝试换绑定模式或许可以解决.
-4 : 使用模式101 103时出现，这是异常错误.
-5 : 使用模式101 103时出现, 这个错误的解决办法就是关闭目标窗口，重新打开再绑定即可. 也可能是运行脚本的进程没有管理员权限. 
-6 : 被安全软件拦截。典型的是金山.360等. 如果是360关闭即可。 如果是金山，必须卸载，关闭是没用的.
-7 -9 : 使用模式101 103时出现,异常错误. 还有可能是安全软件的问题，比如360等。尝试卸载360.
-8 -10 : 使用模式101 103时出现, 目标进程可能有保护,也可能是插件版本过老，试试新的或许可以解决. -8可以尝试使用DmGuard中的np2盾配合.
-11 : 使用模式101 103时出现, 目标进程有保护. 告诉我解决。
-12 : 使用模式101 103时出现, 目标进程有保护. 告诉我解决。
-13 : 使用模式101 103时出现, 目标进程有保护. 或者是因为上次的绑定没有解绑导致。 尝试在绑定前调用ForceUnBindWindow. 
-14 : 可能系统缺少部分DLL,尝试安装d3d. 或者是鼠标或者键盘使用了dx.mouse.api或者dx.keypad.api，但实际系统没有插鼠标和键盘. 也有可能是图色中有dx.graphic.3d之类的,但相应的图色被占用,比如全屏D3D程序.
-16 : 可能使用了绑定模式 0 和 101，然后可能指定了一个子窗口.导致不支持.可以换模式2或者103来尝试. 另外也可以考虑使用父窗口或者顶级窗口.来避免这个错误。还有可能是目标窗口没有正常解绑 然后再次绑定的时候.
-17 : 模式101 103时出现. 这个是异常错误. 告诉我解决.
-18 : 句柄无效.
-19 : 使用模式0 11 101时出现,这是异常错误,告诉我解决.
-20 : 使用模式101 103 时出现,说明目标进程里没有解绑，并且子绑定达到了最大. 尝试在返回这个错误时，调用ForceUnBindWindow来强制解除绑定.
-21 : 使用模式101 103 时出现,说明目标进程里没有解绑. 尝试在返回这个错误时，调用ForceUnBindWindow来强制解除绑定.
-22 : 使用模式0 2,绑定64位进程窗口时出现,因为安全软件拦截插件释放的EXE文件导致.
-23 : 使用模式0 2,绑定64位进程窗口时出现,因为安全软件拦截插件释放的DLL文件导致.
-24 : 使用模式0 2,绑定64位进程窗口时出现,因为安全软件拦截插件运行释放的EXE.
-25 : 使用模式0 2,绑定64位进程窗口时出现,因为安全软件拦截插件运行释放的EXE.
-26 : 使用模式0 2,绑定64位进程窗口时出现, 因为目标窗口有保护. 常见于win7以上系统.或者有安全软件拦截插件.解决办法: 关闭所有安全软件，然后再重新尝试. 如果还不行就可以肯定是目标窗口有特殊保护.
-27 : 绑定64位进程窗口时出现，因为使用了不支持的模式，目前暂时只支持模式0 2 101 103
-28 : 绑定32位进程窗口时出现，因为使用了不支持的模式，目前暂时只支持模式0 2 101 103

-100 : 调用读写内存函数后，发现无效的窗口句柄
-101 : 读写内存函数失败
-200 : AsmCall失败
示例:
TracePrint dm.GetLastError()
注: 此函数必须紧跟上一句函数调用，中间任何的语句调用都会改变这个值.
]]
function DMCenter:GetLastError( )
    return CPLUS.DmCenter.GetLastError(self.__dm)
end



--[[
获取全局路径.(可用于调试)
返回值:
字符串:
以字符串的形式返回当前设置的全局路径
]]
function DMCenter:GetPath( )
    return CPLUS.DmCenter.GetPath(self.__dm) 
end


--[[
调用此函数来注册，从而使用插件的高级功能.推荐使用此函数.
参数定义:
reg_code 字符串: 注册码. (从大漠插件后台获取)
ver_info 字符串: 版本附加信息. 可以在后台详细信息查看. 可以任意填写. 可留空. 长度不能超过20. 并且只能包含数字和字母以及小数点. 这个版本信息不是插件版本.
返回值:
整形数:
-1 : 无法连接网络,(可能防火墙拦截,如果可以正常访问大漠插件网站，那就可以肯定是被防火墙拦截)
-2 : 进程没有以管理员方式运行. (出现在win7 win8 vista 2008.建议关闭uac)
0 : 失败 (未知错误)
1 : 成功
2 : 余额不足
3 : 绑定了本机器，但是账户余额不足50元.
4 : 注册码错误
5 : 你的机器或者IP在黑名单列表中或者不在白名单列表中.
6 : 非法使用插件. 
7 : 你的帐号因为非法使用被封禁. （如果是在虚拟机中使用插件，必须使用Reg或者RegEx，不能使用RegNoMac或者RegExNoMac,否则可能会造成封号，或者封禁机器）
77： 机器码或者IP因为非法使用，而被封禁. （如果是在虚拟机中使用插件，必须使用Reg或者RegEx，不能使用RegNoMac或者RegExNoMac,否则可能会造成封号，或者封禁机器）
     封禁是全局的，如果使用了别人的软件导致77，也一样会导致所有注册码均无法注册。解决办法是更换IP，更换MAC.
-8 : 版本附加信息长度超过了20
-9 : 版本附加信息里包含了非法字母.
空 : 这是不可能返回空的，如果出现空，那肯定是当前使用的版本不对,老的插件里没这个函数导致返回为空.最好参考文档中的标准写法,判断插件版本号.

示例:
dm_ret = dm.Reg("abcdefg","")
if dm_ret <> 1 then
    MessageBox "注册失败,只能使用免费功能"
end if
注: 简单游平台调用此函数，不会扣费.
注册码在大漠插件后台可以查看.
此函数每个进程调用一次即可，不需要每个DM对象都调用.
必须保证此函数在创建完对象以后立即调用，尤其必须在绑定窗口之前调用，否则可能会出现异常.
如果有多个进程操作同个窗口，必须保证每个进程要么都调用Reg,要么都不要调用Reg，以免出现异常.
]]
function DMCenter:Reg( reg_code,ver_info)
    return CPLUS.DmCenter.Reg(self.__dm,reg_code,ver_info)
end





--[[
调用此函数来注册，从而使用插件的高级功能. 可以根据指定的IP列表来注册. 新手不建议使用!
参数定义:
reg_code 字符串: 注册码. (从大漠插件后台获取)
ver_info 字符串: 版本附加信息. 可以在后台详细信息查看.可留空. 长度不能超过20. 并且只能包含数字和字母以及小数点. 这个版本信息不是插件版本.
ip 字符串: 插件注册的ip地址.可以用|来组合,依次对ip中的地址进行注册，直到成功. ip地址列表在VIP群中获取.
返回值:
整形数:
-1 : 无法连接网络,(可能防火墙拦截,如果可以正常访问大漠插件网站，那就可以肯定是被防火墙拦截)
-2 : 进程没有以管理员方式运行. (出现在win7 win8 vista 2008.建议关闭uac)
0 : 失败 (未知错误)
1 : 成功
2 : 余额不足
3 : 绑定了本机器，但是账户余额不足50元.
4 : 注册码错误
5 : 你的机器或者IP在黑名单列表中或者不在白名单列表中.
6 : 非法使用插件.
7 : 你的帐号因为非法使用被封禁. （如果是在虚拟机中使用插件，必须使用Reg或者RegEx，不能使用RegNoMac或者RegExNoMac,否则可能会造成封号，或者封禁机器）
77： 机器码或者IP因为非法使用，而被封禁. （如果是在虚拟机中使用插件，必须使用Reg或者RegEx，不能使用RegNoMac或者RegExNoMac,否则可能会造成封号，或者封禁机器）
     封禁是全局的，如果使用了别人的软件导致77，也一样会导致所有注册码均无法注册。解决办法是更换IP，更换MAC.
-8 : 版本附加信息长度超过了20
-9 : 版本附加信息里包含了非法字母.
-10 : 非法的参数ip
空 : 这是不可能返回空的，如果出现空，那肯定是当前使用的版本不对,老的插件里没这个函数导致返回为空.最好参考文档中的标准写法,判断插件版本号.
示例:
// 严重注意,这个例子的IP只是示例，实际并无效。真实IP要去VIP群里获取.
dm_ret = dm.RegEx("abcdefg","0001","123.45.4.6|78.79.26.3")
if dm_ret <> 1 then
    MessageBox "注册失败,只能使用免费功能"
end if
注: 简单游平台调用此函数，不会扣费.
注册码在大漠插件后台可以查看.
此函数每个进程调用一次即可，不需要每个DM对象都调用.
必须保证此函数在创建完对象以后立即调用，尤其必须在绑定窗口之前调用，否则可能会出现异常.
如果有多个进程操作同个窗口，必须保证每个进程要么都调用RegEx,要么都不要调用RegEx，以免出现异常.
]]
function DMCenter:RegEx( reg_code,ver_info,ip)
    return CPLUS.DmCenter.RegEx(self.__dm,reg_code,ver_info,ip)
end



--[[
调用此函数来注册，从而使用插件的高级功能. 可以根据指定的IP列表来注册.
新手不建议使用! 此函数同RegEx函数的不同在于,此函数用于注册的机器码是不带mac地址的.
reg_code 字符串: 注册码. (从大漠插件后台获取)

ver_info 字符串: 版本附加信息. 可以在后台详细信息查看.可留空. 长度不能超过20. 并且只能包含数字和字母以及小数点. 这个版本信息不是插件版本.

ip 字符串: 插件注册的ip地址.可以用|来组合,依次对ip中的地址进行注册，直到成功. ip地址列表在VIP群中获取.

返回值:

整形数:
-1 : 无法连接网络,(可能防火墙拦截,如果可以正常访问大漠插件网站，那就可以肯定是被防火墙拦截)
-2 : 进程没有以管理员方式运行. (出现在win7 win8 vista 2008.建议关闭uac)
0 : 失败 (未知错误)
1 : 成功
2 : 余额不足
3 : 绑定了本机器，但是账户余额不足50元.
4 : 注册码错误
5 : 你的机器或者IP在黑名单列表中或者不在白名单列表中.
6 : 非法使用插件.
7 : 你的帐号因为非法使用被封禁. （如果是在虚拟机中使用插件，必须使用Reg或者RegEx，不能使用RegNoMac或者RegExNoMac,否则可能会造成封号，或者封禁机器）
77： 机器码或者IP因为非法使用，而被封禁. （如果是在虚拟机中使用插件，必须使用Reg或者RegEx，不能使用RegNoMac或者RegExNoMac,否则可能会造成封号，或者封禁机器）
     封禁是全局的，如果使用了别人的软件导致77，也一样会导致所有注册码均无法注册。解决办法是更换IP，更换MAC.
-8 : 版本附加信息长度超过了20
-9 : 版本附加信息里包含了非法字母.
-10 : 非法的参数ip
空 : 这是不可能返回空的，如果出现空，那肯定是当前使用的版本不对,老的插件里没这个函数导致返回为空.最好参考文档中的标准写法,判断插件版本号.
示例:
// 严重注意,这个例子的IP只是示例，实际并无效。真实IP要去VIP群里获取.
dm_ret = dm.RegExNoMac("abcdefg","0001","123.45.4.6|78.79.26.3")
if dm_ret <> 1 then
    MessageBox "注册失败,只能使用免费功能"
end if
注: 简单游平台调用此函数，不会扣费.
注册码在大漠插件后台可以查看.
此函数每个进程调用一次即可，不需要每个DM对象都调用.
必须保证此函数在创建完对象以后立即调用，尤其必须在绑定窗口之前调用，否则可能会出现异常.
如果有多个进程操作同个窗口，必须保证每个进程要么都调用RegExNoMac,要么都不要调用RegExNoMac，以免出现异常.
]]
function DMCenter:RegExNoMac( reg_code,ver_info,ip)
    return CPLUS.DmCenter.RegExNoMac(self.__dm,reg_code,ver_info,ip)
end





--[[
调用此函数来注册，从而使用插件的高级功能.推荐使用此函数. 
新手不建议使用! 此函数同Reg函数的不同在于,此函数用于注册的机器码是不带mac地址的.
reg_code 字符串: 注册码. (从大漠插件后台获取)

ver_info 字符串: 版本附加信息. 可以在后台详细信息查看. 可以任意填写. 可留空. 长度不能超过20. 并且只能包含数字和字母以及小数点. 这个版本信息不是插件版本.

返回值:

整形数:
-1 : 无法连接网络,(可能防火墙拦截,如果可以正常访问大漠插件网站，那就可以肯定是被防火墙拦截)
-2 : 进程没有以管理员方式运行. (出现在win7 win8 vista 2008.建议关闭uac)
0 : 失败 (未知错误)
1 : 成功
2 : 余额不足
3 : 绑定了本机器，但是账户余额不足50元.
4 : 注册码错误
5 : 你的机器或者IP在黑名单列表中或者不在白名单列表中.
6 : 非法使用插件.
7 : 你的帐号因为非法使用被封禁. （如果是在虚拟机中使用插件，必须使用Reg或者RegEx，不能使用RegNoMac或者RegExNoMac,否则可能会造成封号，或者封禁机器）
77： 机器码或者IP因为非法使用，而被封禁. （如果是在虚拟机中使用插件，必须使用Reg或者RegEx，不能使用RegNoMac或者RegExNoMac,否则可能会造成封号，或者封禁机器）
     封禁是全局的，如果使用了别人的软件导致77，也一样会导致所有注册码均无法注册。解决办法是更换IP，更换MAC.
-8 : 版本附加信息长度超过了20
-9 : 版本附加信息里包含了非法字母.
空 : 这是不可能返回空的，如果出现空，那肯定是当前使用的版本不对,老的插件里没这个函数导致返回为空.最好参考文档中的标准写法,判断插件版本号.
示例:
dm_ret = dm.RegNoMac("abcdefg","")
if dm_ret <> 1 then
    MessageBox "注册失败,只能使用免费功能"
end if
注: 简单游平台调用此函数，不会扣费.
注册码在大漠插件后台可以查看.
此函数每个进程调用一次即可，不需要每个DM对象都调用.
必须保证此函数在创建完对象以后立即调用，尤其必须在绑定窗口之前调用，否则可能会出现异常.
如果有多个进程操作同个窗口，必须保证每个进程要么都调用RegNoMac,要么都不要调用RegNoMac，以免出现异常.
]]
function DMCenter:RegNoMac( reg_code,ver_info)
    return CPLUS.DmCenter.RegNoMac(self.__dm,reg_code,ver_info)
end



--[[
设定图色的获取方式，默认是显示器或者后台窗口(具体参考BindWindow)
mode 字符串: 图色输入模式取值有以下几种
1.     "screen" 这个是默认的模式，表示使用显示器或者后台窗口
2.     "pic:file" 指定输入模式为指定的图片,如果使用了这个模式，则所有和图色相关的函数
均视为对此图片进行处理，比如文字识别查找图片 颜色 等等一切图色函数.
需要注意的是，设定以后，此图片就已经加入了缓冲，如果更改了源图片内容，那么需要
释放此缓冲，重新设置.
3.     "mem:addr,size" 指定输入模式为指定的图片,此图片在内存当中. addr为图像内存地址,size为图像内存大小.
如果使用了这个模式，则所有和图色相关的函数,均视为对此图片进行处理.
比如文字识别 查找图片 颜色 等等一切图色函数.
返回值:
整形数:
0: 失败 1: 成功
示例:
// 设定为默认的模式
dm_ret = dm.SetDisplayInput("screen")
// 设定为图片模式 图片采用相对路径模式 相对于SetPath的路径
dm_ret = dm.SetDisplayInput("pic:test.bmp")
// 设为图片模式 图片采用绝对路径模式
dm_ret = dm.SetDisplayInput("pic:d:\test\test.bmp")
// 设为图片模式 但是每次设置前 先清除缓冲
dm_ret = dm.FreePic("test.bmp")
dm_ret = dm.SetDisplayInput("pic:test.bmp")
// 设置为图片模式,图片从内存中获取
dm_ret = dm.SetDisplayInput("mem:1230434,884")
]]
function DMCenter:SetDisplayInput( mode)
    return CPLUS.DmCenter.SetDisplayInput(self.__dm,mode) == 1
end





--[[
设置EnumWindow  EnumWindowByProcess  EnumWindowSuper FindWindow以及FindWindowEx的最长延时. 内部默认超时是10秒.
delay 整形数: 单位毫秒
返回值:
整形数:
0: 失败
1: 成功
示例:
dm.SetEnumWindowDelay  300000
注: 有些时候，窗口过多，并且窗口结构过于复杂，可能枚举的时间过长. 那么需要调用这个函数来延长时间。避免漏掉窗口.
]]
function DMCenter:SetEnumWindowDelay( delay)
    return CPLUS.DmCenter.SetEnumWindowDelay(self.__dm,delay) == 1
end





--[[
设置全局路径,设置了此路径后,所有接口调用中,相关的文件都相对于此路径. 比如图片,字库等.
path 字符串: 路径,可以是相对路径,也可以是绝对路径

返回值:
整形数:
0: 失败
1: 成功
示例:
// 以下代码把全局路径设置到了c盘根目录
dm_ret = dm.SetPath("c:\")
// 如下是把全局路径设置到了相对于当前exe所在的路径
dm.SetPath ".\MyData"
// 以上，如果exe在c:\test\a.exe 那么，就相当于把路径设置到了c:\test\MyData
]]
function DMCenter:SetPath( path)
    return CPLUS.DmCenter.SetPath(self.__dm,path) == 1
end




--[[
设置是否弹出错误信息,默认是打开.
show 整形数: 0表示不打开,1表示打开
返回值:
整形数:
0 : 失败
1 : 成功
示例:
dm_ret = dm.SetShowErrorMsg(0)
]]
function DMCenter:SetShowErrorMsg( show)
    return CPLUS.DmCenter.SetShowErrorMsg(self.__dm,show) == 1
end




--[[
设置是否对前台图色进行加速. (默认是关闭). (对于不绑定，或者绑定图色为normal生效)( 仅对WIN8以上系统有效)
enable 整形数: 
       0 : 关闭
       1 : 打开
返回值:
整形数:
0: 失败
1: 成功
示例:
dm.SpeedNormalGraphic 1
注: WIN8以上系统,由于AERO的开启,导致前台图色速度很慢,使用此接口可以显著提速.
WIN7系统无法使用,只能通过关闭aero来对前台图色提速.
每个进程,最多只能有一个对象开启此加速接口,如果要用开启别的对象的加速，那么要先关闭之前开启的.
并且开启此接口后,仅能对主显示器的屏幕进行截图,分屏的显示器上的内容无法截图.
另外需要注意,开启此接口后，仅对屏幕变化很频繁时有效，比如某窗口FPS很高时，越高效果越好. 如果开启此接口对静态屏幕进行图色，那效果还不如不开.
]]
function DMCenter:SpeedNormalGraphic( enable)
    return CPLUS.DmCenter.SpeedNormalGraphic(self.__dm,enable) == 1
end



--[[
返回当前插件版本号
字符串:
当前插件的版本描述字符串
示例:
// 返回版本号
ver = dm.Ver()
MessageBox ver
]]
function DMCenter:Ver( )
    return CPLUS.DmCenter.Ver(self.__dm)
end




---------------------------------后台设置---------------------------------------
--[[
绑定指定的窗口,并指定这个窗口的屏幕颜色获取方式,鼠标仿真模式,键盘仿真模式,以及模式设定,高级用户可以参考BindWindowEx更加灵活强大.
hwnd 整形数: 指定的窗口句柄
display 字符串: 屏幕颜色获取方式 取值有以下几种
"normal" : 正常模式,平常我们用的前台截屏模式
"gdi" : gdi模式,用于窗口采用GDI方式刷新时. 此模式占用CPU较大. 参考SetAero  win10以上系统使用此模式，如果截图失败，尝试把目标程序重新开启再试试。
"gdi2" : gdi2模式,此模式兼容性较强,但是速度比gdi模式要慢许多,如果gdi模式发现后台不刷新时,可以考虑用gdi2模式.
"dx2" : dx2模式,用于窗口采用dx模式刷新,如果dx方式会出现窗口所在进程崩溃的状况,可以考虑采用这种.采用这种方式要保证窗口有一部分在屏幕外.win7 win8或者vista不需要移动也可后台.此模式占用CPU较大. 参考SetAero.   win10以上系统使用此模式，如果截图失败，尝试把目标程序重新开启再试试。
"dx3" : dx3模式,同dx2模式,但是如果发现有些窗口后台不刷新时,可以考虑用dx3模式,此模式比dx2模式慢许多. 此模式占用CPU较大. 参考SetAero. win10以上系统使用此模式，如果截图失败，尝试把目标程序重新开启再试试。
"dx" : dx模式,等同于BindWindowEx中，display设置的"dx.graphic.2d|dx.graphic.3d",具体参考BindWindowEx
mouse 字符串: 鼠标仿真模式 取值有以下几种
"normal" : 正常模式,平常我们用的前台鼠标模式
"windows": Windows模式,采取模拟windows消息方式 同按键自带后台插件.
"windows2": Windows2 模式,采取模拟windows消息方式(锁定鼠标位置) 此模式等同于BindWindowEx中的mouse为以下组合
"dx.mouse.position.lock.api|dx.mouse.position.lock.message|dx.mouse.state.message"
"windows3": Windows3模式，采取模拟windows消息方式,可以支持有多个子窗口的窗口后台.
"dx": dx模式,采用模拟dx后台鼠标模式,这种方式会锁定鼠标输入.有些窗口在此模式下绑定时，需要先激活窗口再绑定(或者绑定以后激活)，否则可能会出现绑定后鼠标无效的情况.此模式等同于BindWindowEx中的mouse为以下组合
"dx.public.active.api|dx.public.active.message|dx.mouse.position.lock.api|dx.mouse.position.lock.message|dx.mouse.state.api|dx.mouse.state.message|dx.mouse.api|dx.mouse.focus.input.api|dx.mouse.focus.input.message|dx.mouse.clip.lock.api|dx.mouse.input.lock.api|dx.mouse.cursor"
"dx2"：dx2模式,这种方式类似于dx模式,但是不会锁定外部鼠标输入.
有些窗口在此模式下绑定时，需要先激活窗口再绑定(或者绑定以后手动激活)，否则可能会出现绑定后鼠标无效的情况. 此模式等同于BindWindowEx中的mouse为以下组合
"dx.public.active.api|dx.public.active.message|dx.mouse.position.lock.api|dx.mouse.state.api|dx.mouse.api|dx.mouse.focus.input.api|dx.mouse.focus.input.message|dx.mouse.clip.lock.api|dx.mouse.input.lock.api| dx.mouse.cursor"
keypad 字符串: 键盘仿真模式 取值有以下几种
"normal" : 正常模式,平常我们用的前台键盘模式
"windows": Windows模式,采取模拟windows消息方式 同按键的后台插件.
"dx": dx模式,采用模拟dx后台键盘模式。有些窗口在此模式下绑定时，需要先激活窗口再绑定(或者绑定以后激活)，否则可能会出现绑定后键盘无效的情况. 此模式等同于BindWindowEx中的keypad为以下组合
"dx.public.active.api|dx.public.active.message| dx.keypad.state.api|dx.keypad.api|dx.keypad.input.lock.api"
mode 整形数: 模式。 取值有以下几种
     0 : 推荐模式此模式比较通用，而且后台效果是最好的.
     2 : 同模式0,如果模式0有崩溃问题，可以尝试此模式. 注意0和2模式，当主绑定(第一个绑定同个窗口的对象)绑定成功后，那么调用主绑定的线程必须一致维持,否则线程一旦推出,对应的绑定也会消失.
     101 : 超级绑定模式. 可隐藏目标进程中的dm.dll.避免被恶意检测.效果要比dx.public.hide.dll好. 推荐使用.
     103 : 同模式101，如果模式101有崩溃问题，可以尝试此模式. 
     11 : 需要加载驱动,适合一些特殊的窗口,如果前面的无法绑定，可以尝试此模式. 此模式不支持32位系统
     13 : 需要加载驱动,适合一些特殊的窗口,如果前面的无法绑定，可以尝试此模式. 此模式不支持32位系统
需要注意的是: 模式101 103在大部分窗口下绑定都没问题。但也有少数特殊的窗口，比如有很多子窗口的窗口，对于这种窗口，在绑定时，一定要把
鼠标指向一个可以输入文字的窗口，比如一个文本框，最好能激活这个文本框，这样可以保证绑定的成功.
返回值:
整形数:
0: 失败
1: 成功
如果返回0，可以调用GetLastError来查看具体失败错误码,帮助分析问题.
示例:
// display: 前台 鼠标:前台键盘:前台 模式0
dm_ret = dm.BindWindow(hwnd,"normal","normal","normal",0)
// display: dx 鼠标:前台 键盘:前台模式0
dm_ret = dm.BindWindow(hwnd,"dx","normal","normal",0)
// display: dx 鼠标:dx 后台 键盘: dx后台 模式1
dm_ret = dm.BindWindow(hwnd,"dx","dx","dx",1) 
// display: dx 鼠标:windows3后台 键盘:windows后台 模式101
dm_ret = dm.BindWindow(hwnd,"dx","windows3","windows",101)
注意:
绑定之后,所有的坐标都相对于窗口的客户区坐标(不包含窗口边框)
另外,绑定窗口后,必须加以下代码,以保证所有资源正常释放
这个函数的意思是在脚本结束时,会调用这个函数。需要注意的是，目前的按键版本对于这个函数的执行不是线程级别的，也就是说，这个函数只会在主线程执行，子线程绑定的大漠对象，不保证完全释放。 
Sub OnScriptExit()
    dm_ret = dm.UnBindWindow() 
End Sub
另外 绑定dx会比较耗时间,请不要频繁调用此函数.
还有一点特别要注意的是,有些窗口绑定之后必须加一定的延时,否则后台也无效.一般1秒到2秒的延时就足够.
发现绑定失败的几种可能(一般是需要管理员权限的模式才有可能会失败)
1.     系统登录的帐号必须有Administrators权限
2.     一些防火墙会防止插件注入窗口所在进程，比如360防火墙等，必须把dm.dll设置为信任.
3.     还有一个比较弱智的可能性，那就是插件没有注册到系统中，这时CreateObject压根就是失败的. 检测对象是否创建成功很简单，如下代码
set dm = createobject("dm.dmsoft")
ver = dm.Ver()
If len(ver) = 0 Then
    MessageBox "创建对象失败,检查系统是否禁用了vbs脚本权限"
    EndScript
End If
4.     在沙盘中开的窗口进程，绑定一些需要管理员权限的模式，会失败。
解决方法是要配置沙盘参数，具体如何配置参考沙盘绑定方法.
5.     窗口所在进程有保护，这个我也无能为力.
]]
function DMCenter:BindWindow(display,mouse,keypad,mode)
    return CPLUS.DmCenter.BindWindow(self.__dm,self.__hwnd,display,mouse,keypad,mode) == 1
end


--[[
绑定指定的窗口,并指定这个窗口的屏幕颜色获取方式,鼠标仿真模式,键盘仿真模式 高级用户使用.
hwnd 整形数: 指定的窗口句柄
display 字符串: 屏幕颜色获取方式 取值有以下几种
"normal" : 正常模式,平常我们用的前台截屏模式
"gdi" : gdi模式,用于窗口采用GDI方式刷新时. 此模式占用CPU较大. 参考SetAero. win10以上系统使用此模式，如果截图失败，尝试把目标程序重新开启再试试。  
"gdi2" : gdi2模式,此模式兼容性较强,但是速度比gdi模式要慢许多,如果gdi模式发现后台不刷新时,可以考虑用gdi2模式.
"dx2" : dx2模式,用于窗口采用dx模式刷新,如果dx方式会出现窗口进程崩溃的状况,可以考虑采用这种.采用这种方式要保证窗口有一部分在屏幕外.win7 win8或者vista不需要移动也可后台. 此模式占用CPU较大. 参考SetAero. win10以上系统使用此模式，如果截图失败，尝试把目标程序重新开启再试试。 
"dx3" : dx3模式,同dx2模式,但是如果发现有些窗口后台不刷新时,可以考虑用dx3模式,此模式比dx2模式慢许多. 此模式占用CPU较大. 参考SetAero. win10以上系统使用此模式，如果截图失败，尝试把目标程序重新开启再试试。

dx模式,用于窗口采用dx模式刷新,取值可以是以下任意组合，组合采用"|"符号进行连接. 支持BindWindow中的缩写模式. 比如dx代表" dx.graphic.2d| dx.graphic.3d"
1. "dx.graphic.2d"  2d窗口的dx图色模式  
2. "dx.graphic.2d.2"  2d窗口的dx图色模式  是dx.graphic.2d的增强模式.兼容性更好.
3. "dx.graphic.3d"  3d窗口的dx图色模式, 
4. "dx.graphic.3d.8"  3d窗口的dx8图色模式,  此模式对64位进程无效.
5. "dx.graphic.opengl"  3d窗口的opengl图色模式,极少数窗口采用opengl引擎刷新. 此图色模式速度可能较慢. 
6. "dx.graphic.opengl.esv2"  3d窗口的opengl_esv2图色模式,极少数窗口采用opengl引擎刷新. 此图色模式速度可能较慢.
7. "dx.graphic.3d.10plus"  3d窗口的dx10 dx11图色模式

mouse 字符串: 鼠标仿真模式 取值有以下几种
"normal" : 正常模式,平常我们用的前台鼠标模式
"windows": Windows模式,采取模拟windows消息方式 同按键的后台插件.
"windows3": Windows3模式，采取模拟windows消息方式,可以支持有多个子窗口的窗口后台

dx模式,取值可以是以下任意组合. 组合采用"|"符号进行连接. 支持BindWindow中的缩写模式,比如windows2代表"dx.mouse.position.lock.api|dx.mouse.position.lock.message|dx.mouse.state.message"
1. "dx.mouse.position.lock.api"  此模式表示通过封锁系统API，来锁定鼠标位置.
2. "dx.mouse.position.lock.message" 此模式表示通过封锁系统消息，来锁定鼠标位置.
3. "dx.mouse.focus.input.api" 此模式表示通过封锁系统API来锁定鼠标输入焦点.
4. "dx.mouse.focus.input.message"此模式表示通过封锁系统消息来锁定鼠标输入焦点.
5. "dx.mouse.clip.lock.api" 此模式表示通过封锁系统API来锁定刷新区域。注意，使用这个模式，在绑定前，必须要让窗口完全显示出来.
6. "dx.mouse.input.lock.api" 此模式表示通过封锁系统API来锁定鼠标输入接口.
7. "dx.mouse.state.api" 此模式表示通过封锁系统API来锁定鼠标输入状态.
8. "dx.mouse.state.message" 此模式表示通过封锁系统消息来锁定鼠标输入状态.
9. "dx.mouse.api"  此模式表示通过封锁系统API来模拟dx鼠标输入.
10. "dx.mouse.cursor"  开启此模式，可以后台获取鼠标特征码. 
11. "dx.mouse.raw.input"  有些窗口需要这个才可以正常操作鼠标. 
12. "dx.mouse.input.lock.api2"  部分窗口在后台操作时，前台鼠标会移动,需要这个属性.
13. "dx.mouse.input.lock.api3"  部分窗口在后台操作时，前台鼠标会移动,需要这个属性. 

keypad 字符串: 键盘仿真模式 取值有以下几种
"normal" : 正常模式,平常我们用的前台键盘模式
"windows": Windows模式,采取模拟windows消息方式 同按键的后台插件.
dx模式,取值可以是以下任意组合. 组合采用"|"符号进行连接. 支持BindWindow中的缩写模式.比如dx代表" dx.public.active.api|dx.public.active.message| dx.keypad.state.api|dx.keypad.api|dx.keypad.input.lock.api"
1. "dx.keypad.input.lock.api" 此模式表示通过封锁系统API来锁定键盘输入接口.
2. "dx.keypad.state.api" 此模式表示通过封锁系统API来锁定键盘输入状态.
3. "dx.keypad.api" 此模式表示通过封锁系统API来模拟dx键盘输入. 
4. "dx.keypad.raw.input"  有些窗口需要这个才可以正常操作键盘.

public 字符串: 公共属性 dx模式共有 
取值可以是以下任意组合. 组合采用"|"符号进行连接 这个值可以为空
1. "dx.public.active.api" 此模式表示通过封锁系统API来锁定窗口激活状态.  注意，部分窗口在此模式下会耗费大量资源慎用. 
2. "dx.public.active.message" 此模式表示通过封锁系统消息来锁定窗口激活状态.  注意，部分窗口在此模式下会耗费大量资源慎用. 另外如果要让此模式生效，必须在绑定前，让绑定窗口处于激活状态,否则此模式将失效. 比如dm.SetWindowState hwnd,1 然后再绑定.
3.  "dx.public.disable.window.position" 此模式将锁定绑定窗口位置.不可与"dx.public.fake.window.min"共用.
4.  "dx.public.disable.window.size" 此模式将锁定绑定窗口,禁止改变大小. 不可与"dx.public.fake.window.min"共用.
5.  "dx.public.disable.window.minmax" 此模式将禁止窗口最大化和最小化,但是付出的代价是窗口同时也会被置顶. 不可与"dx.public.fake.window.min"共用.
6.  "dx.public.fake.window.min" 此模式将允许目标窗口在最小化状态时，仍然能够像非最小化一样操作.. 另注意，此模式会导致任务栏顺序重排，所以如果是多开模式下，会看起来比较混乱，建议单开使用，多开不建议使用. 同时此模式不是万能的,有些情况下最小化以后图色会不刷新或者黑屏.
7.  "dx.public.hide.dll" 此模式将会隐藏目标进程的大漠插件，避免被检测..另外使用此模式前，请仔细做过测试，此模式可能会造成目标进程不稳定，出现崩溃。
8.  "dx.public.active.api2" 此模式表示通过封锁系统API来锁定窗口激活状态. 部分窗口遮挡无法后台,需要这个属性. 
9.  "dx.public.input.ime" 此模式是配合SendStringIme使用. 具体可以查看SendStringIme接口.
10  "dx.public.graphic.protect" 此模式可以保护dx图色不被恶意检测.同时对dx.keypad.api和dx.mouse.api也有保护效果.
11  "dx.public.disable.window.show" 禁止目标窗口显示,这个一般用来配合dx.public.fake.window.min来使用. 
12  "dx.public.anti.api" 此模式可以突破部分窗口对后台的保护.
13  "dx.public.km.protect" 此模式可以保护dx键鼠不被恶意检测.最好配合dx.public.anti.api一起使用. 此属性可能会导致部分后台功能失效.
14   "dx.public.prevent.block"  绑定模式1 3 5 7 101 103下，可能会导致部分窗口卡死. 这个属性可以避免卡死.
15   "dx.public.ori.proc"  此属性只能用在模式0 1 2 3和101下. 有些窗口在不同的界面下(比如登录界面和登录进以后的界面)，键鼠的控制效果不相同. 那可以用这个属性来尝试让保持一致. 注意的是，这个属性不可以滥用，确保测试无问题才可以使用. 否则可能会导致后台失效.
16  "dx.public.down.cpu" 此模式可以配合DownCpu来降低目标进程CPU占用.  当图色方式降低CPU无效时，可以尝试此种方式.
17  "dx.public.focus.message" 当后台绑定后,后台无法正常在焦点窗口输入文字时,可以尝试加入此属性. 此属性会强制键盘消息发送到焦点窗口. 慎用此模式,此模式有可能会导致后台键盘在某些情况下失灵.
18  "dx.public.graphic.speed" 只针对图色中的dx模式有效.此模式会牺牲目标窗口的性能，来提高DX图色速度，尤其是目标窗口刷新很慢时，这个参数就很有用了.
19  "dx.public.memory" 让本对象突破目标进程防护,可以正常使用内存接口. 当用此方式使用内存接口时，内存接口的速度会取决于目标窗口的刷新率.
20  "dx.public.inject.super" 突破某些难以绑定的窗口. 此属性仅对除了模式0和2的其他模式有效.
21  "dx.public.hack.speed" 类似变速齿轮，配合接口HackSpeed使用

mode 整形数: 模式。取值有以下几种
     0 : 推荐模式此模式比较通用，而且后台效果是最好的.
     2 : 同模式0,如果模式0有崩溃问题，可以尝试此模式.  注意0和2模式，当主绑定(第一个绑定同个窗口的对象)绑定成功后，那么调用主绑定的线程必须一致维持,否则线程一旦推出,对应的绑定也会消失.
     101 : 超级绑定模式. 可隐藏目标进程中的dm.dll.避免被恶意检测.效果要比dx.public.hide.dll好. 推荐使用.
     103 : 同模式101，如果模式101有崩溃问题，可以尝试此模式. 
     11 : 需要加载驱动,适合一些特殊的窗口,如果前面的无法绑定，可以尝试此模式. 此模式不支持32位系统
     13 : 需要加载驱动,适合一些特殊的窗口,如果前面的无法绑定，可以尝试此模式. 此模式不支持32位系统
需要注意的是: 模式101 103在大部分窗口下绑定都没问题。但也有少数特殊的窗口，比如有很多子窗口的窗口，对于这种窗口，在绑定时，一定要把鼠标指向一个可以输入文字的窗口，比如一个文本框，最好能激活这个文本框，这样可以保证绑定的成功.
返回值:
整形数:
0: 失败
1: 成功
如果返回0，可以调用GetLastError来查看具体失败错误码,帮助分析问题.
示例:
比如
dm_ret = dm.BindWindowEx(hwnd,"normal","dx.mouse.position.lock.api|dx.mouse.position.lock.message","windows","dx.public.active.api",0)
dm_ret = dm.BindWindowEx(hwnd,"dx2","windows","normal","dx.public.active.api",0)
dm_ret = dm.BindWindowEx(hwnd,"dx.graphic.2d","dx.mouse.position.lock.api|dx.mouse.position.lock.message","dx.keypad.state.api|dx.keypad.api","",0)
dm_ret = dm.BindWindowEx(hwnd,"dx2","windows","windows","",0)
dm_ret = dm.BindWindowEx(hwnd,"dx2","windows","windows","dx.public.disable.window.size|dx.public.disable.window.minmax",0)
dm_ret = dm.BindWindowEx(hwnd,"dx2","windows3","windows","dx.mouse.position.lock.api",0)
等等.
注意:
绑定之后,所有的坐标都相对于窗口的客户区坐标(不包含窗口边框)
另外,绑定窗口后,必须加以下代码,以保证所有资源正常释放
这个函数的意思是在脚本结束时,会调用这个函数。需要注意的是，目前的按键版本对于这个函数的执行不是线程级别的，也就是说，这个函数只会在主线程执行，子线程绑定的大漠对象，不保证完全释放。高级语言中则需要自己控制在适当的时候解除绑定.
Sub OnScriptExit()
    dm_ret = dm.UnBindWindow() 
End Sub
另外 绑定dx会比较耗时间,请不要频繁调用此函数.
还有一点特别要注意的是,有些窗口绑定之后必须加一定的延时,否则后台也无效.一般1秒到2秒的延时就足够.
发现绑定失败的几种可能(一般是需要管理员权限的模式才有可能会失败)
1.     系统登录的帐号必须有Administrators权限
2.     一些防火墙会防止插件注入窗口所在进程，比如360防火墙等，必须把dm.dll设置为信任.
3.     还有一个比较弱智的可能性，那就是插件没有注册到系统中，这时CreateObject压根就是失败的. 检测对象是否创建成功很简单，如下代码
set dm = createobject("dm.dmsoft")
ver = dm.Ver()
If len(ver) = 0 Then
    MessageBox "创建对象失败,检查系统是否禁用了vbs脚本权限"
    EndScript
End If
4.     在沙盘中开的窗口，绑定一些需要管理员权限的模式，会失败。
解决方法是要配置沙盘参数，参考如何配置沙盘参数.
5.     窗口所在进程有保护，这个我也无能为力.
]]
function DMCenter:BindWindowEx(display,mouse,keypad,public,mode)
    return CPLUS.DmCenter.BindWindowEx(self.__dm,self.__hwnd,display,mouse,keypad,public,mode) == 1
end



--[[
降低目标窗口所在进程的CPU占用
rate 整形数: 取值范围大于等于0  取值为0 表示关闭CPU优化. 这个值越大表示降低CPU效果越好.
返回值:
整形数:
0: 失败
1: 成功
示例:
dm_ret = dm.BindWindowEx(hwnd,"dx.graphic.3d","normal","normal","",0)
dm.DownCpu 50
dm_ret = dm.BindWindowEx(hwnd,"normal","normal","normal","dx.public.down.cpu",101)
dm.DownCpu 50
注意: 此接口必须在绑定窗口成功以后调用，而且必须保证目标窗口可以支持dx.graphic.3d或者dx.graphic.3d.8或者dx.graphic.2d或者dx.graphic.2d.2或者dx.graphic.opengl或者dx.graphic.opengl.esv2方式截图，或者使用dx.public.down.cpu.否则降低CPU无效.
因为降低CPU是通过降低窗口刷新速度或者在系统消息循环增加延时来实现，所以注意，开启此功能以后会导致窗口刷新速度变慢.
]]
function DMCenter:DownCpu( rate)
    return CPLUS.DmCenter.DownCpu(self.__dm,rate) == 1
end




--[[
设置是否暂时关闭或者开启后台功能. 默认是开启.  一般用在前台切换，或者脚本暂停和恢复时，可以让用户操作窗口
enable 整形数: 0 全部关闭(图色键鼠都关闭,也就是说图色,键鼠都是前台,但是如果有指定dx.public.active.message时，在窗口前后台切换时，这个属性会失效.)
-1 只关闭图色.(也就是说图色是normal前台. 键鼠不变)
1 开启(恢复原始状态)
5 同0，也是全部关闭，但是这个模式下，就算窗口在前后台切换时，属性dx.public.active.message的效果也一样不会失效.
返回值:
整形数:
0: 失败
1: 成功
示例:
// 绑定为后台
dm_ret = dm.BindWindow(hwnd,"dx","dx","dx",101)
// 后台操作
…
// 切换到前台
dm.EnableBind 0
// 前台操作
…
// 再切换回后台
dm.EnableBind 1
注: 注意切换到前台以后,相当于dm_ret = dm.BindWindow(hwnd,"normal","normal","normal",0),图色键鼠全部是前台.
如果你经常有频繁切换后台和前台的操作，推荐使用这个函数.
同时要注意,如果有多个对象绑定了同个窗口，其中任何一个对象禁止了后台,那么其他对象后台也同样失效.
]]
function DMCenter:EnableBind( enable)
    return CPLUS.DmCenter.EnableBind(self.__dm,enable) == 1
end





--[[
设置是否开启后台假激活功能. 默认是关闭. 一般用不到. 除非有人有特殊需求. 注意看注释. 
enable 整形数: 0 关闭
               1 开启
返回值:
整形数:
0: 失败
1: 成功
示例:
// 绑定以后再调用此函数
dm.EnableFakeActive 1
// 这里做需要在窗口非激活状态下,可以操作的接口或者第三方函数
…
// 恢复
dm.EnableFakeActive 0
注: 此接口的含义并不是关闭或者开启窗口假激活功能(dx.public.active.api或者dx.public.active.message). 而是说有些时候，本来窗口没有激活并且在没有绑定的状态下，可以正常使用的功能，而在窗口绑定以后,并且窗口在非激活状态下,此时由于绑定的锁定导致无法使用. 那么，你就需要把你的部分代码用EnableFakeActive来保护起来。这样就让插件认为你的这段代码是在窗口激活状态下执行.
另外，此函数开启以后，有可能会让前台影响到后台. 所以如果不是特殊情况，最好是关闭. 
有些时候，有人会故意利用这个前台影响后台的作用，做类似同步器的软件，那这个函数就很有作用了.
]]
function DMCenter:EnableFakeActive( enable)
    return CPLUS.DmCenter.EnableFakeActive(self.__dm,enable) == 1
end




--[[
设置是否关闭绑定窗口所在进程的输入法.
enable 整形数: 1 开启
0 关闭
返回值:
整形数:
0: 失败
1: 成功
示例:
// 绑定为后台
dm_ret = dm.BindWindow(hwnd,"dx","dx","dx",101)
…
// 关闭输入法
dm.EnableIme 0 
…
// 再开启输入法
dm.EnableIme 1
注: 此函数必须在绑定后调用才有效果.
]]
function DMCenter:EnableIme( enable)
    return CPLUS.DmCenter.EnableIme(self.__dm,enable) == 1
end




--[[
是否在使用dx键盘时开启windows消息.默认开启. 
enable 整形数: 0 禁止
               1开启
返回值:
整形数:
0: 失败
1: 成功
示例:
dm_ret = dm.BindWindow(hwnd,"dx","dx2","dx",0)
dm.EnableKeypadMsg 0
注: 此接口必须在绑定之后才能调用。特殊时候使用.
]]
function DMCenter:EnableKeypadMsg( enable)
    return CPLUS.DmCenter.EnableKeypadMsg(self.__dm,enable) == 1
end




--[[
键盘消息发送补丁. 默认是关闭.
enable 整形数: 0 禁止
               1开启  
返回值:
整形数:
0: 失败
1: 成功
示例:
dm_ret = dm.BindWindow(hwnd,"dx","dx2","dx",0)
dm.EnableKeypadPatch 1
注: 此接口必须在绑定之后才能调用。
]]
function DMCenter:EnableKeypadPatch( enable)
    return CPLUS.DmCenter.EnableKeypadPatch(self.__dm,enable) == 1
end





--[[
键盘消息采用同步发送模式.默认异步.
enable 整形数: 0 禁止同步
               1开启同步
time_out 整形数: 单位是毫秒,表示同步等待的最大时间.
返回值:
整形数:
0: 失败
1: 成功
示例:
dm_ret = dm.BindWindow(hwnd,"dx","dx2","dx",0)
dm.EnableKeypadSync 1,200

注: 此接口必须在绑定之后才能调用。
有些时候，如果是异步发送，如果发送动作太快,中间没有延时,有可能下个动作会影响前面的.
而用同步就没有这个担心.
]]
function DMCenter:EnableKeypadSync( enable,time_out)
    return CPLUS.DmCenter.EnableKeypadSync(self.__dm,enable,time_out) == 1
end




--[[
是否在使用dx鼠标时开启windows消息.默认开启. 
enable 整形数: 0 禁止
               1开启
返回值:
整形数:
0: 失败
1: 成功
示例:
dm_ret = dm.BindWindow(hwnd,"dx","dx2","dx",0)
dm.EnableMouseMsg 0
注: 此接口必须在绑定之后才能调用。特殊时候使用.
]]
function DMCenter:EnableMouseMsg( enable)
    return CPLUS.DmCenter.EnableMouseMsg(self.__dm,enable) == 1
end




--[[
鼠标消息采用同步发送模式.默认异步. 
enable 整形数: 0 禁止同步
               1开启同步
time_out 整形数: 单位是毫秒,表示同步等待的最大时间.
返回值:
整形数:
0: 失败
1: 成功
示例:
dm_ret = dm.BindWindow(hwnd,"dx","dx2","dx",0)
dm.EnableMouseSync 1,200
注: 此接口必须在绑定之后才能调用。
有些时候，如果是异步发送，如果发送动作太快,中间没有延时,有可能下个动作会影响前面的.
而用同步就没有这个担心.
]]
function DMCenter:EnableMouseSync( enable,time_out)
    return CPLUS.DmCenter.EnableMouseSync(self.__dm,enable,time_out) == 1
end




--[[
键盘动作模拟真实操作,点击延时随机.
enable 整形数: 0 关闭模拟
               1 开启模拟
返回值:
整形数:
0: 失败
1: 成功
示例:
dm.EnableRealKeypad 1
dm.KeyPressChar "E"
注: 此接口对KeyPress KeyPressChar KeyPressStr起作用。具体表现是键盘按下和弹起的间隔会在
当前设定延时的基础上,上下随机浮动50%. 假如设定的键盘延时是100,那么这个延时可能就是50-150之间的一个值.
设定延时的函数是 SetKeypadDelay
]]
function DMCenter:EnableRealKeypad( enable)
    return CPLUS.DmCenter.EnableRealKeypad(self.__dm,enable) == 1
end





--[[
鼠标动作模拟真实操作,带移动轨迹,以及点击延时随机.
enable 整形数: 0 关闭模拟
               1 开启模拟(直线模拟)
               2 开启模式(随机曲线,更接近真实)
mousedelay 整形数: 单位是毫秒. 表示在模拟鼠标移动轨迹时,每移动一次的时间间隔.这个值越大,鼠标移动越慢.
Mousestep 整形数: 表示在模拟鼠标移动轨迹时,每移动一次的距离. 这个值越大，鼠标移动越快速.
返回值:
整形数:
0: 失败
1: 成功
示例:
dm.EnableRealMouse 1,20,30
dm.MoveTo 100,100
dm.MoveTo 500,500
注: 此接口同样对LeftClick RightClick MiddleClick LeftDoubleClick起作用。具体表现是鼠标按下和弹起的间隔会在
当前设定延时的基础上,上下随机浮动50%. 假如设定的鼠标延时是100,那么这个延时可能就是50-150之间的一个值.
设定延时的函数是 SetMouseDelay
]]
function DMCenter:EnableRealMouse( enable,mousedelay,mousestep)
    return CPLUS.DmCenter.EnableRealMouse(self.__dm,enable,mousedelay,mousestep) == 1
end



--[[
设置是否开启高速dx键鼠模式。 默认是关闭.
enable 整形数: 0 关闭
1 开启
返回值:
整形数:
0: 失败
1: 成功
示例:
dm.EnableSpeedDx 1
注: 此函数开启的后果就是，所有dx键鼠操作将不会等待，适用于某些特殊的场合(比如避免窗口无响应导致宿主进程也卡死的问题).
EnableMouseSync和EnableKeyboardSync开启以后，此函数就无效了.
此函数可能在部分窗口下会有副作用，谨慎使用!!
]]
function DMCenter:EnableSpeedDx( enable)
    return CPLUS.DmCenter.EnableSpeedDx(self.__dm,enable) == 1
end







--[[
强制解除绑定窗口,并释放系统资源.
hwnd 整形数: 需要强制解除绑定的窗口句柄.
返回值:
整形数:
0: 失败
1: 成功
示例:
dm_ret = dm.ForceUnBindWindow(hwnd)
注: 此接口一般用在BindWindow和BindWindowEx中，使用了模式1 3 5 7或者属性dx.public.hide.dll后，在线程或者进程结束后，没有正确调用UnBindWindow而导致下次绑定无法成功时，可以先调用这个函数强制解除绑定，并释放资源，再进行绑定.
此接口不可替代UnBindWindow. 只是用在非常时刻. 切记.
一般情况下可以无条件的在BindWindow或者BindWindowEx之前调用一次此函数。保证此刻窗口处于非绑定状态.
另外，需要注意的是,此函数只可以强制解绑在同进程绑定的窗口.  不可在不同的进程解绑别的进程绑定的窗口.(会产生异常)
]]
function DMCenter:ForceUnBindWindow( )
    return CPLUS.DmCenter.ForceUnBindWindow(self.__dm,self.__hwnd) == 1
end



--[[
获取当前对象已经绑定的窗口句柄. 无绑定返回0
整形数: 窗口句柄 
]]
function DMCenter:GetBindWindow( )
    return CPLUS.DmCenter.GetBindWindow(self.__dm)
end



--[[
获取绑定窗口的fps. (即时fps,不是平均fps). 
要想获取fps,那么图色模式必须是dx模式的其中一种.  
比如dx.graphic.3d  dx.graphic.opengl等.
返回值:
整形数: fps
示例:
fps = dm.GetFps()
]]
function DMCenter:GetFps( )
    return CPLUS.DmCenter.GetFps(self.__dm)
end


--[[
对目标窗口设置加速功能(类似变速齿轮),必须在绑定参数中有dx.public.hack.speed时才会生效.
rate 双精度浮点数: 取值范围大于0. 默认是1.0 表示不加速，也不减速. 小于1.0表示减速,大于1.0表示加速. 精度为小数点后1位. 也就是说1.5 和 1.56其实是一样的.
返回值:
整形数:
0: 失败
1: 成功
示例:
dm_ret = dm.BindWindowEx(hwnd,"normal","normal","normal","dx.public.hack.speed",0)
// 2倍加速
dm.HackSpeed 2.0
// 2.5倍
dm.HackSpeed 2.5
// 10.1倍
dm.HackSpeed 10.1
// 速度降低为原来的一半
dm.HackSpeed 0.5
// 速度降低为原来的十分之一
dm.HackSpeed 0.1
注意: 此接口必须在绑定窗口成功以后调用，而且必须有参数dx.public.hack.speed. 不一定对所有窗口有效,具体自己测试.
]]
function DMCenter:HackSpeed( rate)
    return CPLUS.DmCenter.HackSpeed(self.__dm,rate) == 1
end





--[[
判定指定窗口是否已经被后台绑定. (前台无法判定) 
hwnd 整形数: 窗口句柄 
返回值:
整形数:
0: 没绑定,或者窗口不存在.
1: 已经绑定.
示例:
dm_ret = dm.IsBind(hwnd)
]]
function DMCenter:IsBind( )
    return CPLUS.DmCenter.IsBind(self.__dm,self.__hwnd) == 1
end


--[[
锁定指定窗口的图色数据(不刷新). 
lock 整形数: 0关闭锁定
             1 开启锁定
返回值:
整形数:
0: 失败
1: 成功
示例:
dm_ret = dm.BindWindow(hwnd,"dx","dx2","dx",0)
dm.LockDisplay 1
// 这里做需要锁定做的事情
dm.LockDisplay 0

注意: 此接口只对图色为dx.graphic.3d  dx.graphic.3d.8 dx.graphic.2d  dx.graphic.2d.2有效.
]]
function DMCenter:LockDisplay( lock)
    return CPLUS.DmCenter.LockDisplay(self.__dm,lock) == 1
end




--[[
禁止外部输入到指定窗口
lock 整形数: 0关闭锁定
       1 开启锁定(键盘鼠标都锁定)
       2 只锁定鼠标
       3 只锁定键盘
       4 同1,但当您发现某些特殊按键无法锁定时,比如(回车，ESC等)，那就用这个模式吧. 但此模式会让SendString函数后台失效，或者采用和SendString类似原理发送字符串的其他3方函数失效.
       5同3,但当您发现某些特殊按键无法锁定时,比如(回车，ESC等)，那就用这个模式吧. 但此模式会让SendString函数后台失效，或者采用和SendString类似原理发送字符串的其他3方函数失效.
返回值:
整形数:
0: 失败
1: 成功
示例:
dm_ret = dm.BindWindow(hwnd,"dx","dx2","dx",0)
dm.LockInput 1
// 这里做需要锁定输入做的事情
dm.LockInput 0
注意:此接口只针对dx键鼠. 普通键鼠无效. 
有时候，绑定为dx2 鼠标模式时(或者没有锁定鼠标位置或状态时)，在脚本处理过程中，在某个时候需要临时锁定外部输入，以免外部干扰，那么这个函数就非常有用.
比如某个信息，需要鼠标移动到某个位置才可以获取，但这时，如果外部干扰，那么很可能就会获取失败，所以，这时候就很有必要锁定外部输入. 
当然，锁定完以后，记得要解除锁定，否则外部永远都无法输入了，除非解除了窗口绑定.
]]
function DMCenter:LockInput( lock)
    return CPLUS.DmCenter.LockInput(self.__dm,lock) == 1
end





--[[
设置前台鼠标在屏幕上的活动范围.
x1 整形数:区域的左上X坐标. 屏幕坐标.
y1 整形数:区域的左上Y坐标. 屏幕坐标.
x2 整形数:区域的右下X坐标. 屏幕坐标.
y2 整形数:区域的右下Y坐标. 屏幕坐标.
返回值:
整形数:
0: 失败
1: 成功
示例:
// 限制鼠标只能在10,10,800,600区域内活动.
dm.LockMouseRect 10,10,800,600
…
Sub OnScriptExit()
    // 恢复,4个参数都是0,表示恢复鼠标活动范围为整个屏幕区域.
    dm.LockMouseRect 0,0,0,0
End Sub
注: 调用此函数后，一旦有窗口切换或者窗口移动的动作，那么限制立刻失效.
如果想一直限制鼠标范围在指定的窗口客户区域，那么你需要启动一个线程，并且时刻监视当前活动窗口，然后根据情况调用此函数限制鼠标范围.
]]
function DMCenter:LockMouseRect( x1,y1,x2,y2)
    return CPLUS.DmCenter.LockMouseRect(self.__dm,x1,y1,x2,y2) == 1
end



--[[
设置开启或者关闭系统的Aero效果. (仅对WIN7及以上系统有效) 
enable 整形数: 0 关闭
1 开启
返回值:
整形数:
0: 失败
1: 成功
示例:
dm.SetAero 0
注: 如果您发现当图色后台为dx2 gdi dx3时，如果有发现目标窗口刷新速度过慢,那可以考虑关闭系统Aero. (当然这仅仅是可能的原因)
]]
function DMCenter:SetAero( enable)
    return CPLUS.DmCenter.SetAero(self.__dm,enable)== 1
end




--[[
设置dx截图最长等待时间。内部默认是3000毫秒. 一般用不到调整这个.
time  整形数: 等待时间，单位是毫秒。 注意这里不能设置的过小，否则可能会导致截图失败,从而导致图色函数和文字识别失败.

返回值:
整形数:
0: 失败
1: 成功
示例:
dm.SetDisplayDelay 500
注: 此接口仅对图色为dx.graphic.3d   dx.graphic.3d.8  dx.graphic.2d   dx.graphic.2d.2有效. 其他图色模式无效.
默认情况下，截图需要等待一个延时，超时就认为截图失败. 这个接口可以调整这个延时. 某些时候或许有用.比如当窗口图色卡死(这时获取图色一定都是超时)，并且要判断窗口卡死，那么这个设置就很有用了。
]]
function DMCenter:SetDisplayDelay( time)
    return CPLUS.DmCenter.SetDisplayDelay(self.__dm,time) == 1
end




--[[
设置opengl图色模式的强制刷新窗口等待时间. 内置为400毫秒.
time  整形数: 等待时间，单位是毫秒。 这个值越小,强制刷新的越频繁，相应的窗口可能会导致闪烁.
返回值:
整形数:
0: 失败
1: 成功
示例:
dm.SetDisplayRefreshDelay 800
注: 此接口仅对图色为dx.graphic.opengl有效. 其他图色模式无效.
默认情况下，openg截图时，如果对应的窗口处于不刷新的状态,那么我们的所有图色接口都会无法截图,从而超时导致失效。
所以特意设置这个接口，如果截图的时间超过此接口设置的时间,那么插件会对绑定的窗口强制刷新,从而让截图成功.
但是强制刷新窗口是有代价的，会造成窗口闪烁。 
如果您需要截图的窗口，刷新非常频繁，那么一般用不到强制刷新，所以可以用这个接口把等待时间设置大一些，从而避免窗口闪烁.
反之,如果您需要截图的窗口偶尔才刷新一次(比如按某个按钮，才刷新一次),那么您就需要用这个接口把等待时间设置小一些，从而提高图色函数的效率，但代价就是窗口可能会闪烁.
当这个接口设置的值超过SetDisplayDelay设置的值(默认是3000毫秒)时,那么opengl截图的方式就退化到老版本(大概是6.1540版本)的模式.(也就是不会强制刷新的版本). 
如果您发现你的程序截图会截取到以前的图片,那么建议把此值加大(建议值2000). 
如果您发现你的程序偶尔会闪烁,导致窗口出现白色区域,那么可以尝试把此值设置为大于SetDisplayDelay的值(默认是3000毫秒),这样可以彻底杜绝刷新.
]]
function DMCenter:SetDisplayRefreshDelay( time)
    return CPLUS.DmCenter.SetDisplayRefreshDelay(self.__dm,time) == 1
end



--[[
在不解绑的情况下,切换绑定窗口.(必须是同进程窗口) 
hwnd 整形数: 需要切换过去的窗口句柄
返回值:
整形数:
0: 失败
1: 成功
示例:
// 绑定为后台
dm_ret = dm.BindWindow(hwnd,"dx","dx","dx",101)
// 切换
hwnd1 = 111
dm.SwitchBindWindow(hwnd1)
注:此函数一般用在绑定以后，窗口句柄改变了的情况。如果必须不解绑，那么此函数就很有用了。
]]
function DMCenter:SwitchBindWindow( )
    return CPLUS.DmCenter.SwitchBindWindow(self.__dm,self.__hwnd) == 1
end


--[[
解除绑定窗口,并释放系统资源.一般在OnScriptExit调用
返回值:
整形数:
0: 失败
1: 成功
示例:
Sub OnScriptExit()
    dm_ret = dm.UnBindWindow() 
End Sub
]]
function DMCenter:UnBindWindow( )
    return CPLUS.DmCenter.UnBindWindow(self.__dm) == 1
end




----------------------------------窗口-----------------------------------------------
--[[
把窗口坐标转换为屏幕坐标 
hwnd 整形数: 指定的窗口句柄
x 变参指针: 窗口X坐标
y 变参指针: 窗口Y坐标
返回值: table{x=0,y=0}
整形数:
0: 失败
1: 成功
示例:
x = 0:y = 0 
dm_ret = dm.ClientToScreen(hwnd,x,y) 
]]
function DMCenter:ClientToScreen(x,y)
    return CPLUS.DmCenter.ClientToScreen(self.__dm,self.__hwnd,x,y)
end



--[[
根据指定进程名,枚举系统中符合条件的进程PID,并且按照进程打开顺序排序
name 字符串:进程名,比如qq.exe
返回值:
字符串 :
返回所有匹配的进程PID,并按打开顺序排序,格式"pid1,pid2,pid3"
示例:
pids = dm.EnumProcess("notepad.exe")
pids = split(pids,",")
转换为数组后,就可以处理了
这里注意, pids数组里的是字符串,要用于使用,还得强制类型转换,比如clng(pids(0))
]]
function DMCenter:EnumProcess( name)
    return CPLUS.DmCenter.EnumProcess(self.__dm,name)
end


--[[
根据指定条件,枚举系统中符合条件的窗口,可以枚举到按键自带的无法枚举到的窗口
parent 整形数: 获得的窗口句柄是该窗口的子窗口的窗口句柄,取0时为获得桌面句柄
title 字符串: 窗口标题. 此参数是模糊匹配.
class_name 字符串: 窗口类名. 此参数是模糊匹配.
filter整形数: 取值定义如下
1 : 匹配窗口标题,参数title有效 
2 : 匹配窗口类名,参数class_name有效.
4 : 只匹配指定父窗口的第一层孩子窗口
8 : 匹配父窗口为0的窗口,即顶级窗口
16 : 匹配可见的窗口
32 : 匹配出的窗口按照窗口打开顺序依次排列
这些值可以相加,比如4+8+16就是类似于任务管理器中的窗口列表
返回值:
字符串 :
返回所有匹配的窗口句柄字符串,格式"hwnd1,hwnd2,hwnd3"
示例:
hwnds = dm.EnumWindow(0,"QQ三国","",1+4+8+16)
这句是获取到所有标题栏中有QQ三国这个字符串的窗口句柄集合
hwnds = split(hwnds,",")
转换为数组后,就可以处理了
这里注意,hwnds数组里的是字符串,要用于使用,比如BindWindow时,还得强制类型转换,比如int(hwnds(0))
]]
function DMCenter:EnumWindow( parent,title,class_name,filter)
    return CPLUS.DmCenter.EnumWindow(self.__dm,parent,title,class_name,filter)
end




--[[
根据指定进程以及其它条件,枚举系统中符合条件的窗口,可以枚举到按键自带的无法枚举到的窗口
process_name 字符串: 进程映像名.比如(svchost.exe). 此参数是精确匹配,但不区分大小写.
title 字符串: 窗口标题. 此参数是模糊匹配.
class_name 字符串: 窗口类名. 此参数是模糊匹配.
filter 整形数: 取值定义如下
1 : 匹配窗口标题,参数title有效
2 : 匹配窗口类名,参数class_name有效
4 : 只匹配指定映像的所对应的第一个进程. 可能有很多同映像名的进程，只匹配第一个进程的.
8 : 匹配父窗口为0的窗口,即顶级窗口
16 : 匹配可见的窗口
32 : 匹配出的窗口按照窗口打开顺序依次排列
这些值可以相加,比如4+8+16
返回值:
字符串
返回所有匹配的窗口句柄字符串,格式"hwnd1,hwnd2,hwnd3"
示例:
hwnds = dm.EnumWindowByProcess("game.exe","天龙八部","",1+8+16)
这句是获取到所有标题栏中有"天龙八部"这个字符串的窗口句柄集合,并且所在进程是"game.exe"指定的进程集合.
hwnds = split(hwnds,",")
转换为数组后,就可以处理了
这里注意,hwnds数组里的是字符串,要用于使用,比如BindWindow时,还得强制类型转换,比如int(hwnds(0))
]]
function DMCenter:EnumWindowByProcess( process_name,title,class_name,filter)
    return CPLUS.DmCenter.EnumWindowByProcess(self.__dm,process_name,title,class_name,filter)
end



--[[
根据指定进程pid以及其它条件,枚举系统中符合条件的窗口,可以枚举到按键自带的无法枚举到的窗口
pid 整形数: 进程pid.
title 字符串: 窗口标题. 此参数是模糊匹配.
class_name 字符串: 窗口类名. 此参数是模糊匹配.
filter 整形数: 取值定义如下
1 : 匹配窗口标题,参数title有效
2 : 匹配窗口类名,参数class_name有效
8 : 匹配父窗口为0的窗口,即顶级窗口
16 : 匹配可见的窗口
这些值可以相加,比如2+8+16
返回值:
字符串:
返回所有匹配的窗口句柄字符串,格式"hwnd1,hwnd2,hwnd3"
示例:
hwnds = dm.EnumWindowByProcessId(1124,"天龙八部","",1+8+16)
这句是获取到所有标题栏中有"天龙八部"这个字符串的窗口句柄集合,并且所在进程是1124指定的进程.
hwnds = split(hwnds,",")
转换为数组后,就可以处理了
这里注意,hwnds数组里的是字符串,要用于使用,比如BindWindow时,还得强制类型转换,比如int(hwnds(0))
]]
function DMCenter:EnumWindowByProcessId( pid,title,class_name,filter)
    return CPLUS.DmCenter.EnumWindowByProcessId(self.__dm,pid,title,class_name,filter)
end






--[[
根据两组设定条件来枚举指定窗口.
spec1 字符串: 查找串1. (内容取决于flag1的值)
flag1整形数: 取值如下:
   0表示spec1的内容是标题
   1表示spec1的内容是程序名字. (比如notepad)
   2表示spec1的内容是类名
   3表示spec1的内容是程序路径.(不包含盘符,比如\windows\system32)
   4表示spec1的内容是父句柄.(十进制表达的串)
   5表示spec1的内容是父窗口标题
   6表示spec1的内容是父窗口类名
   7表示spec1的内容是顶级窗口句柄.(十进制表达的串)
   8表示spec1的内容是顶级窗口标题
   9表示spec1的内容是顶级窗口类名
type1 整形数: 取值如下
0精确判断
1模糊判断
spec2 字符串: 查找串2. (内容取决于flag2的值)
flag2 整形数: 取值如下:
   0表示spec2的内容是标题
   1表示spec2的内容是程序名字. (比如notepad)
   2表示spec2的内容是类名
   3表示spec2的内容是程序路径.(不包含盘符,比如\windows\system32)
   4表示spec2的内容是父句柄.(十进制表达的串)
   5表示spec2的内容是父窗口标题
   6表示spec2的内容是父窗口类名
   7表示spec2的内容是顶级窗口句柄.(十进制表达的串)
   8表示spec2的内容是顶级窗口标题
   9表示spec2的内容是顶级窗口类名
type2  整形数: 取值如下
0精确判断
1模糊判断
sort  整形数: 取值如下
0不排序.
1对枚举出的窗口进行排序,按照窗口打开顺序.
返回值:
字符串:
返回所有匹配的窗口句柄字符串,格式"hwnd1,hwnd2,hwnd3"
示例:
hwnds = dm.EnumWindowSuper("记事本",0,1,"notepad",1,0,0) 
hwnds = split(hwnds,",")
转换为数组后,就可以处理了
这里注意,hwnds数组里的是字符串,要用于使用,比如BindWindow时,还得强制类型转换,比如int(hwnds(0))
]]
function DMCenter:EnumWindowSuper( spec1,flag1,type1,spec2,flag2,type2,sort)
    return CPLUS.DmCenter.EnumWindowSuper(self.__dm,spec1,flag1,type1,spec2,flag2,type2,sort)
end


--[[
查找符合类名或者标题名的顶层可见窗口
class 字符串: 窗口类名，如果为空，则匹配所有. 这里的匹配是模糊匹配.
title 字符串: 窗口标题,如果为空，则匹配所有.这里的匹配是模糊匹配.
返回值:
整形数:
整形数表示的窗口句柄，没找到返回0
示例:
hwnd = dm.FindWindow("","记事本") 
]]
function DMCenter:FindWindow( class,title)
    return CPLUS.DmCenter.FindWindow(self.__dm,class,title)
end



--[[
根据指定的进程名字，来查找可见窗口.
process_name 字符串: 进程名. 比如(notepad.exe).这里是精确匹配,但不区分大小写.
class 字符串: 窗口类名，如果为空，则匹配所有. 这里的匹配是模糊匹配.
title 字符串: 窗口标题,如果为空，则匹配所有.这里的匹配是模糊匹配.
返回值:
整形数:
整形数表示的窗口句柄，没找到返回0
示例:
hwnd = dm.FindWindowByProcess("noteapd.exe","","记事本") 
]]
function DMCenter:FindWindowByProcess( process_name,class,title)
    return CPLUS.DmCenter.FindWindowByProcess(self.__dm,process_name,class,title)
end






--[[
根据指定的进程Id，来查找可见窗口.
process_id 整形数: 进程id. 
class 字符串: 窗口类名，如果为空，则匹配所有. 这里的匹配是模糊匹配.
title 字符串: 窗口标题,如果为空，则匹配所有.这里的匹配是模糊匹配.
返回值:
整形数:
整形数表示的窗口句柄，没找到返回0
示例:
hwnd = dm.FindWindowByProcessId(123456,"","记事本") 
]]
function DMCenter:FindWindowByProcessId( process_id,class,title)
    return CPLUS.DmCenter.FindWindowByProcessId(self.__dm,process_id,class,title)
end



--[[
查找符合类名或者标题名的顶层可见窗口,如果指定了parent,则在parent的第一层子窗口中查找.
parent 整形数: 父窗口句柄，如果为空，则匹配所有顶层窗口
class 字符串: 窗口类名，如果为空，则匹配所有. 这里的匹配是模糊匹配.
title 字符串: 窗口标题,如果为空，则匹配所有. 这里的匹配是模糊匹配.
返回值:
整形数:
整形数表示的窗口句柄，没找到返回0
示例:
hwnd = dm.FindWindowEx(0,"","记事本") 
]]
function DMCenter:FindWindowEx( parent,class,title)
    return CPLUS.DmCenter.FindWindowEx(self.__dm,parent,class,title)
end




--[[
根据两组设定条件来查找指定窗口. 
spec1 字符串: 查找串1. (内容取决于flag1的值)
flag1整形数: 取值如下:
   0表示spec1的内容是标题
   1表示spec1的内容是程序名字. (比如notepad)
   2表示spec1的内容是类名
   3表示spec1的内容是程序路径.(不包含盘符,比如\windows\system32)
   4表示spec1的内容是父句柄.(十进制表达的串)
   5表示spec1的内容是父窗口标题
   6表示spec1的内容是父窗口类名
   7表示spec1的内容是顶级窗口句柄.(十进制表达的串)
   8表示spec1的内容是顶级窗口标题
   9表示spec1的内容是顶级窗口类名
type1 整形数: 取值如下
0精确判断
1模糊判断
spec2 字符串: 查找串2. (内容取决于flag2的值)
flag2 整形数: 取值如下:
   0表示spec2的内容是标题
   1表示spec2的内容是程序名字. (比如notepad)
   2表示spec2的内容是类名
   3表示spec2的内容是程序路径.(不包含盘符,比如\windows\system32)
   4表示spec2的内容是父句柄.(十进制表达的串)
   5表示spec2的内容是父窗口标题
   6表示spec2的内容是父窗口类名
   7表示spec2的内容是顶级窗口句柄.(十进制表达的串)
   8表示spec2的内容是顶级窗口标题
   9表示spec2的内容是顶级窗口类名
type2  整形数: 取值如下
0精确判断
1模糊判断
返回值:
整形数:
整形数表示的窗口句柄，没找到返回0
示例:
hwnd = dm.FindWindowSuper("记事本",0,1,"notepad",1,0) 
]]
function DMCenter:FindWindowSuper( spec1,flag1,type1,spec2,flag2,type2)
    return CPLUS.DmCenter.FindWindowSuper(self.__dm,spec1,flag1,type1,spec2,flag2,type2)
end





--[[
获取窗口客户区域在屏幕上的位置
hwnd 整形数: 指定的窗口句柄
x1 变参指针: 返回窗口客户区左上角X坐标
y1 变参指针: 返回窗口客户区左上角Y坐标
x2 变参指针: 返回窗口客户区右下角X坐标
y2 变参指针: 返回窗口客户区右下角Y坐标
返回值: table {x1=0,x2=0,y1=0,y2=0}
整形数:
0: 失败
1: 成功
示例:
dm_ret = dm.GetClientRect(hwnd,x1,y1,x2,y2)
]]
function DMCenter:GetClientRect( )
    return CPLUS.DmCenter.GetClientRect(self.__dm,self.__hwnd)
end










--[[
获取窗口客户区域的宽度和高度
hwnd 整形数: 指定的窗口句柄
width 变参指针: 宽度
height 变参指针: 高度
返回值:  table{width=0,height=0}
整形数:
0: 失败
1: 成功
示例:
dm_ret = dm.GetClientSize(hwnd,w,h) 
TracePrint "宽度:"& w &",高度:"& h
]]
function DMCenter:GetClientSize( )
    return CPLUS.DmCenter.GetClientSize(self.__dm,self.__hwnd)
end




--[[
获取顶层活动窗口中具有输入焦点的窗口句柄 
返回值:
整形数:
返回整型表示的窗口句柄
]]
function DMCenter:GetForegroundFocus( )
    return CPLUS.DmCenter.GetForegroundFocus(self.__dm)
end






--[[
获取顶层活动窗口,可以获取到按键自带插件无法获取到的句柄
返回值:
整形数:
返回整型表示的窗口句柄
]]
function DMCenter:GetForegroundWindow( )
    return CPLUS.DmCenter.GetForegroundWindow(self.__dm)
end






--[[
获取鼠标指向的可见窗口句柄,可以获取到按键自带的插件无法获取到的句柄
返回值:
整形数:
返回整型表示的窗口句柄
]]
function DMCenter:GetMousePointWindow( )
    return CPLUS.DmCenter.GetMousePointWindow(self.__dm)
end





--[[
获取给定坐标的可见窗口句柄,可以获取到按键自带的插件无法获取到的句柄
X 整形数: 屏幕X坐标
Y 整形数: 屏幕Y坐标
返回值:
整形数:
返回整型表示的窗口句柄
]]
function DMCenter:GetPointWindow( x,y)
    return CPLUS.DmCenter.GetPointWindow(self.__dm,x,y)
end





--[[
根据指定的pid获取进程详细信息,(进程名,进程全路径,CPU占用率(百分比),内存占用量(字节))
pid 整形数: 进程pid 
返回值:
字符串:
格式"进程名|进程路径|cpu|内存"
示例:
infos = dm.GetProcessInfo(1348) 
infos = split(infos,"|")
TracePrint "进程名:"&infos(0)
TracePrint "进程路径:"&infos(1)
TracePrint "进程CPU占用率(百分比):"&infos(2)
TracePrint "进程内存占用量(字节):"&infos(3)
注: 有些时候有保护的时候，此函数返回内容会错误，那么此时可以尝试用memory保护盾来试试看.
]]
function DMCenter:GetProcessInfo( pid)
    return CPLUS.DmCenter.GetProcessInfo(self.__dm,pid)
end





--[[
获取特殊窗口
Flag 整形数: 取值定义如下
0 : 获取桌面窗口
1 : 获取任务栏窗口
返回值:
整形数:
以整型数表示的窗口句柄
示例:
desk_win = dm.GetSpecialWindow(0) 
]]
function DMCenter:GetSpecialWindow( flag)
    return CPLUS.DmCenter.GetSpecialWindow(self.__dm,flag)
end






--[[
获取给定窗口相关的窗口句柄
hwnd 整形数: 窗口句柄
flag 整形数: 取值定义如下
0 : 获取父窗口
1 : 获取第一个儿子窗口
2 : 获取First 窗口
3 : 获取Last窗口
4 : 获取下一个窗口
5 : 获取上一个窗口
6 : 获取拥有者窗口
7 : 获取顶层窗口
返回值:
整形数:
返回整型表示的窗口句柄
示例:
own_hwnd = dm.GetWindow(hwnd,6)
]]
function DMCenter:GetWindow(flag)
    return CPLUS.DmCenter.GetWindow(self.__dm,self.__hwnd,flag)
end




--[[
获取窗口的类名
hwnd 整形数: 指定的窗口句柄
返回值:
字符串:
窗口的类名
]]
function DMCenter:GetWindowClass( )
    return CPLUS.DmCenter.GetWindowClass(self.__dm,self.__hwnd)
end





--[[
获取指定窗口所在的进程ID.
hwnd 整形数: 窗口句柄
返回值:
整形数:
返回整型表示的是进程ID
]]
function DMCenter:GetWindowProcessId( )
    return CPLUS.DmCenter.GetWindowProcessId(self.__dm,self.__hwnd)
end




--[[
获取指定窗口所在的进程的exe文件全路径.
hwnd 整形数: 窗口句柄
返回值:
字符串:
返回字符串表示的是exe全路径名
]]
function DMCenter:GetWindowProcessPath( )
    return CPLUS.DmCenter.GetWindowProcessPath(self.__dm,self.__hwnd)
end




--[[
获取窗口在屏幕上的位置
hwnd 整形数: 指定的窗口句柄
x1 变参指针: 返回窗口左上角X坐标
y1 变参指针: 返回窗口左上角Y坐标
x2 变参指针: 返回窗口右下角X坐标
y2 变参指针: 返回窗口右下角Y坐标
返回值:  table{x1=0,y1=0,x2=0,y2=0}
整形数:
0: 失败
1: 成功
示例:
dm_ret = dm.GetWindowRect(hwnd,x1,y1,x2,y2)
]]
function DMCenter:GetWindowRect( )
    return CPLUS.DmCenter.GetWindowRect(self.__dm,self.__hwnd)
end




--[[
获取指定窗口的一些属性
hwnd 整形数: 指定的窗口句柄
flag 整形数: 取值定义如下
0 : 判断窗口是否存在
1 : 判断窗口是否处于激活
2 : 判断窗口是否可见
3 : 判断窗口是否最小化
4 : 判断窗口是否最大化
5 : 判断窗口是否置顶
6 : 判断窗口是否无响应
7 : 判断窗口是否可用(灰色为不可用)
8 : 另外的方式判断窗口是否无响应,如果6无效可以尝试这个
9 : 判断窗口所在进程是不是64位
返回值:
整形数:
0: 不满足条件
1: 满足条件
示例:
dm_ret = dm.GetWindowState(hwnd,3) 
If dm_ret = 1 Then
    MessageBox "窗口已经最小化了"
End If
]]
function DMCenter:GetWindowState(flag)
    return CPLUS.DmCenter.GetWindowState(self.__dm,self.__hwnd,flag)
end




--[[
获取窗口的标题
hwnd 整形数: 指定的窗口句柄
返回值:
字符串:
窗口的标题
]]
function DMCenter:GetWindowTitle( )
    return CPLUS.DmCenter.GetWindowTitle(self.__dm,self.__hwnd)
end



--[[
移动指定窗口到指定位置
hwnd 整形数: 指定的窗口句柄
x 整形数: X坐标
y 整形数: Y坐标
返回值:
整形数:
0: 失败
1: 成功
]]
function DMCenter:MoveWindow(x,y)
    return CPLUS.DmCenter.MoveWindow(self.__dm,self.__hwnd,x,y) == 1
end





--[[
把屏幕坐标转换为窗口坐标
hwnd 整形数: 指定的窗口句柄
x 变参指针: 屏幕X坐标
y 变参指针: 屏幕Y坐标
返回值: table{x=0,y=0}
整形数:
0: 失败
1: 成功
示例:
x = 100:y = 100 
dm_ret = dm.ScreenToClient(hwnd,x,y) 
]]
function DMCenter:ScreenToClient( )
    return CPLUS.DmCenter.ScreenToClient(self.__dm,self.__hwnd)
end




--[[
向指定窗口发送粘贴命令. 把剪贴板的内容发送到目标窗口.
hwnd 整形数: 指定的窗口句柄. 如果为0,则对当前激活的窗口发送.
返回值:
整形数:
0: 失败
1: 成功
示例:
dm.SetClipboard "abcd"
dm.SendPaste hwnd
注:剪贴板是公共资源，多个线程同时设置剪贴板时,会产生冲突，必须用互斥信号保护.
]]
function DMCenter:SendPaste( )
    return CPLUS.DmCenter.SendPaste(self.__dm,self.__hwnd) == 1
end




--[[
向指定窗口发送文本数据
hwnd 整形数: 指定的窗口句柄. 如果为0,则对当前激活的窗口发送.
str 字符串: 发送的文本数据
返回值:
整形数:
0: 失败
1: 成功
示例:
dm.SendString hwnd,"我是来测试的"
注： 有时候发送中文，可能会大部分机器正常，少部分会乱码。这种情况一般有两个可能
1. 系统编码没有设置为GBK
2. 目标程序里可能安装了改变当前编码的软件，比如常见的是输入法. （尝试卸载）
]]
function DMCenter:SendString(str)
    return CPLUS.DmCenter.SendString(self.__dm,self.__hwnd,str) == 1
end

function DMCenter:SendGBKString(str)
    str = DMCenter:UTF8ToGBK(str)
    return CPLUS.DmCenter.SendString(self.__dm,self.__hwnd,str) == 1
end




--[[
向指定窗口发送文本数据
hwnd 整形数: 指定的窗口句柄. 如果为0,则对当前激活的窗口发送.
str 字符串: 发送的文本数据
返回值:
整形数:
0: 失败
1: 成功
示例:
dm.SendString2 hwnd,"我是来测试的"
注: 此接口为老的SendString，如果新的SendString不能输入，可以尝试此接口.
有时候发送中文，可能会大部分机器正常，少部分会乱码。这种情况一般有两个可能
1. 系统编码没有设置为GBK
2. 目标程序里可能安装了改变当前编码的软件，比如常见的是输入法. （尝试卸载）
]]
function DMCenter:SendString2(str)
    return CPLUS.DmCenter.SendString2(self.__dm,self.__hwnd,str) == 1
end





--[[
向绑定的窗口发送文本数据.必须配合dx.public.input.ime属性.
str 字符串: 发送的文本数据
返回值:
整形数:
0: 失败
1: 成功
示例:
dm_ret = dm.BindWindowEx(hwnd,"normal","normal","normal","dx.public.input.ime",0)
dm.SendStringIme "我是来测试的"
]]
function DMCenter:SendStringIme( str)
    return CPLUS.DmCenter.SendStringIme(self.__dm,str) == 1
end






--[[
利用真实的输入法，对指定的窗口输入文字.
hwnd整形数: 窗口句柄
str 字符串: 发送的文本数据
mode整形数: 取值意义如下:
            0 : 向hwnd的窗口输入文字(前提是必须先用模式200安装了输入法)
            1 : 同模式0,如果由于保护无效，可以尝试此模式.(前提是必须先用模式200安装了输入法)
            2 : 同模式0,如果由于保护无效，可以尝试此模式. (前提是必须先用模式200安装了输入法)
            200 : 向系统中安装输入法,多次调用没问题. 全局只用安装一次.
            300 : 卸载系统中的输入法. 全局只用卸载一次. 多次调用没关系.
返回值:
整形数:
0: 失败
1: 成功
示例:
If dm.SendStringIme2(hwnd,"",200) = 1 then
      dm.SendStringIme2 hwnd,"我是来测试的",0
      dm.SendStringIme2 hwnd,"abc",0
      dm.SendStringIme2 hwnd,"123",0
      dm.SendStringIme2 hwnd,"",300
end if 
注: 如果要同时对此窗口进行绑定，并且绑定的模式是1 3 5 7 101 103，那么您必须要在绑定之前,先执行加载输入法的操作. 否则会造成绑定失败!.
卸载时，没有限制.
还有，在后台输入时，如果目标窗口有判断是否在激活状态才接受输入文字,那么可以配合绑定窗口中的假激活属性来保证文字正常输入. 诸如此类. 基本上用这个没有输入不了的文字.
比如
BindWindow hwnd,"normal","normal","normal","dx.public.active.api|dx.public.active.message",0
dm.SendStringIme2 hwnd,"哈哈",0
]]
function DMCenter:SendStringIme2(str,mode)
    return CPLUS.DmCenter.SendStringIme2(self.__dm,self.__hwnd,str,mode) == 1
end






--[[
设置窗口客户区域的宽度和高度
hwnd 整形数: 指定的窗口句柄
width 整形数: 宽度
height 整形数: 高度
返回值:
整形数:
0: 失败
1: 成功
示例:
dm_ret = dm.SetClientSize(hwnd,800,600) 
]]
function DMCenter:SetClientSize(width,height)
    return CPLUS.DmCenter.SetClientSize(self.__dm,self.__hwnd,width,height) == 1
end




--[[
设置窗口的大小
hwnd 整形数: 指定的窗口句柄
width 整形数: 宽度
height 整形数: 高度
返回值:
整形数:
0: 失败
1: 成功
]]
function DMCenter:SetWindowSize(width,height)
    return CPLUS.DmCenter.SetWindowSize(self.__dm,self.__hwnd,width,height) == 1
end





--[[
设置窗口的状态
hwnd 整形数: 指定的窗口句柄
flag 整形数: 取值定义如下
0 : 关闭指定窗口
1 : 激活指定窗口
2 : 最小化指定窗口,但不激活
3 : 最小化指定窗口,并释放内存,但同时也会激活窗口.(释放内存可以考虑用FreeProcessMemory函数)
4 : 最大化指定窗口,同时激活窗口.
5 : 恢复指定窗口 ,但不激活
6 : 隐藏指定窗口
7 : 显示指定窗口
8 : 置顶指定窗口
9 : 取消置顶指定窗口
10 : 禁止指定窗口
11 : 取消禁止指定窗口
12 : 恢复并激活指定窗口
13 : 强制结束窗口所在进程.
14 : 闪烁指定的窗口
15 : 使指定的窗口获取输入焦点
返回值:
整形数:
0: 失败
1: 成功
示例:
dm_ret = dm.SetWindowState(hwnd,0) 
]]
function DMCenter:SetWindowState(flag)
    return CPLUS.DmCenter.SetWindowState(self.__dm,self.__hwnd,flag) == 1
end




--[[
设置窗口的标题
hwnd 整形数: 指定的窗口句柄
titie 字符串: 标题
返回值:
整形数:
0: 失败
1: 成功
]]
function DMCenter:SetWindowText(title)
    return CPLUS.DmCenter.SetWindowText(self.__dm,self.__hwnd,title) == 1
end




--[[
设置窗口的透明度
hwnd 整形数: 指定的窗口句柄
trans 整形数: 透明度取值(0-255) 越小透明度越大 0为完全透明(不可见) 255为完全显示(不透明)
返回值:
整形数:
0: 失败
1: 成功
示例:
dm_ret = dm.SetWindowTransparent(hwnd,200) 
]]
function DMCenter:SetWindowTransparent(trans)
    return CPLUS.DmCenter.SetWindowTransparent(self.__dm,self.__hwnd,trans) == 1
end




------------------------------------------------------------------
function DMCenter:DoubleToData(value)
    return CPLUS.DmCenter.DoubleToData(self.__dm,value)
end
function DMCenter:FindData(addr_range, data)
    return CPLUS.DmCenter.FindData(self.__dm,self.__hwnd,addr_range, data)
end
function DMCenter:XXXXXX( )
    return CPLUS.DmCenter.XXXXX(self.__dm) == 1
end
function DMCenter:XXXXXX( )
    return CPLUS.DmCenter.XXXXX(self.__dm) == 1
end
function DMCenter:XXXXXX( )
    return CPLUS.DmCenter.XXXXX(self.__dm) == 1
end
function DMCenter:XXXXXX( )
    return CPLUS.DmCenter.XXXXX(self.__dm) == 1
end
function DMCenter:XXXXXX( )
    return CPLUS.DmCenter.XXXXX(self.__dm) == 1
end
function DMCenter:XXXXXX( )
    return CPLUS.DmCenter.XXXXX(self.__dm) == 1
end
function DMCenter:XXXXXX( )
    return CPLUS.DmCenter.XXXXX(self.__dm) == 1
end
function DMCenter:XXXXXX( )
    return CPLUS.DmCenter.XXXXX(self.__dm) == 1
end
function DMCenter:XXXXXX( )
    return CPLUS.DmCenter.XXXXX(self.__dm) == 1
end
function DMCenter:XXXXXX( )
    return CPLUS.DmCenter.XXXXX(self.__dm) == 1
end
function DMCenter:XXXXXX( )
    return CPLUS.DmCenter.XXXXX(self.__dm) == 1
end
 

return DMCenter


