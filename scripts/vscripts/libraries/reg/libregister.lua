require("libraries.bit")
require('libraries.util')--语言级的一些工具方法

TimerUtil = require("libraries.TimerUtil")--计时器工具类

require('libraries.timers') --可以用来方便的创建定时器
require("libraries.DotaEx")
require("libraries.basic")
 --数字提示
require("libraries.PopupNumbers")
---自定义玩家数据存储系统。作用类似与NetTable。只不过可以指定玩家去更新而不用每次都更新所有人的数据
PlayerTables = require("libraries.PlayerTables")
--用来向ui发送消息
Notifications = require("libraries.notifications")
--创建投射物
require('libraries.projectiles')

require("libraries.aes.aeslua")
