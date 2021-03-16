---游戏状态。所有游戏内的操作（英雄选择，难度设置等等）都是在dota的  game in progress下完成的
--最初各个阶段的操作是根据dota的不同阶段来进行的：
--setup阶段进行英雄选择和设置StageControl = require('customsys.stage.StageControl');
--pregame阶段选择难度等
--inProgress阶段刷怪开始
--但是这样的话，如果在设置阶段没有选择英雄就掉线了，等游戏开始了再进来就会没有英雄（使用刷英雄的接口也没有用了）。
--为了解决这个问题，默认设置所有玩家可以选择同一个英雄，并给所有玩家强制选择了一个虚拟的马甲英雄。
--而且，将自定义的英雄选择放在了dota自带的英雄选择后面的阶段中。这样，一旦玩家连入游戏，立刻就会有英雄了（因为前面的设置阶段直接跳过了），
--后续需要做的只是替换这个英雄为玩家选择的即可。这样即便玩家连入以后又掉线了，再次进入已经开始的游戏也能有英雄可用了。
--但是这样强制选择处理会导致英雄选择阶段直接结束了（应该是判定所有人都选择完英雄了？），玩家连入游戏就已经是游戏准备阶段了。
--虽然界面这时候可以显示自定义选择英雄，但是实际游戏已经进展到了准备了。可能英雄没选完，就开始刷怪了。总之就是节奏完全被打乱了。
--基于以上原因，将默认的游戏设置、英雄选择、游戏准备阶段的时间都设置成0，即所有玩家加载完毕以后直接跳转到游戏进行阶段(in progress)。
--然后才通过这个自定义的游戏阶段控制去展示相应的流程
GameState = require('youxiliucheng.GameStateControl');
StageControl = require('youxiliucheng.stage.StageControl');
shuaguai = require('youxiliucheng.shuaguai')
ma = require('youxiliucheng.MonsterAttribute')
ba = require('youxiliucheng.BossAttribute')
Stage = require('youxiliucheng.stage.defines.Stage1')