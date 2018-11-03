[[
原则:哪个命令打开的,哪个命令必须将它复原
例如:A命令打开了任务面板,那么A命令必须将其关闭

cmd_1001 打开大地图 并确认大地图打开之后返回
cmd_1002 关闭所有的地图 等待完全关闭后返回
cmd_1003打开小地图 会检测当前是否已经有打开的小地图,如果有则关闭

cmd_1007 打开任务栏界面
cmd_1008 关闭任务栏界面


cmd_1101 与指定NPC对话 小红点查找的方式
cmd_1102 通过大地图打开小地图并 点击指定坐标
cmd_1103 打开小地图并 点击指定坐标
cmd_1104 查找黄色提示文字并点击
cmd_1105 自动寻路=>移动到指定场景的指定坐标
cmd_1106 目標點附近才能使用這個方法,用來查找對話標誌
cmd_1107 进入战斗
cmd_1108 获取指定题目的答案


cmd_1201 领取职业任务
cmd_1202 执行职业任务
cmd_1203 勾魂马面任务
cmd_1204 鬼族使者任务
cmd_1205 人族使者任务
cmd_1206 袁天罡任务
cmd_1207 道士任务
cmd_1208 李世民任务
cmd_1209 信使任务
cmd_1210 孙悟空任务
cmd_1211 大大王任务
]]




cmd_0001 不断检测是否移动停止,如果移动停止则返回
errorType = [ESCAPE,FIGHT,CATCH]
示例
game.cmdcenter:Execute("0001","FIGHT")
返回值:要么报错，要么返回true


cmd_0002 战斗处理
ESCAPE = 逃跑
FIGHT = 战斗
CATCH = 捕捉 (捕捉暂时硬编码到了代码中,只提供了幽灵和野鬼的捕捉选项)
示例
game.cmdcenter:TestExecute("0002", "ESCAPE")

返回值:如果没有检测到战斗则返回false,
如果检测到则进行战斗处理,战斗处理是个死循环,只有在检测到战斗结束时返回true


cmd_0003    查找黄色提示文字并点击
game.cmdcenter:TestExecute("0003")


cmd_0004    打开大地图 并确认大地图打开之后返回
game.cmdcenter:TestExecute("0004")


cmd_0005    关闭所有打开的地图，并打开当前场景的小地图
game.cmdcenter:Execute("0005")


cmd_0006    关闭所有的地图 等待完全关闭后返回
game.cmdcenter:Execute("0006")


cmd_0007    打开任务栏界面
game.cmdcenter:Execute("0007")

cmd_0008    关闭任务栏界面
game.cmdcenter:Execute("0008")


cmd_0009    通过大地图打开小地图并 点击指定坐标
name 场景名称
coordPos 坐标点
click  是否点击(默认是点击)
game.cmdcenter:Execute("0009","长安",_p(50,50))


cmd_0010    
与指定NPC对话 小红点查找的方式
不负责移动过程的检测,留给调用者负责检测
npcName NPC的名称
game.cmdcenter:TestExecute("0010","超级管家")



cmd_0011
打开小地图并 点击指定坐标
name 小地图场景名称
要点击的坐标点 coordPos
game.cmdcenter:Execute("0011","长安",_p(50,50))


cmd_0012
自动寻路  不支持有飞行棋的情况
sceneName 寻路的场景名称
coordPos 寻路的场景坐标点
stopArea 是否到达场景之后就退出
game.cmdcenter:Execute("0012","长安",_p(50,50),true)


cmd_0013
查找对话标志,旁边才能使用
coordPos 目标点的坐标
type  对话的类型
game.cmdcenter:Execute("0013",_p(50,50),"finger")


cmd_0014
获取指定题目的答案
game.cmdcenter:Execute("0014","但愿人长久")

cmd_0015
去洛阳购买指定的药品
name  药品名称
num    数量
game.cmdcenter:Execute("0015","风水混元丹",1)