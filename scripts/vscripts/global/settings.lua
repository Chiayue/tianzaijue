-- 各种设置信息，在游戏初始化的时候读取

---游戏设置时间，包括英雄选择等等

-- 游戏结束后显示计分板的时间（超时将断开连接）

--每十级的经验增数
XP_TSZ ={
	200;
	600;
	1000;
	1600;
	2000;
	3000;
	4000;
	6000;
	7000;
	10000;
	14000; --100
	25000;
	40000;  --120
	80000;
	120000;
	160000;
	200000;
	300000;
	400000;
	600000;
}
POST_GAME_TIME = 600                  
PRE_GAME_TIME = 20
-- 英雄最大等级
MAX_LEVEL = 200                          	  
-- 每一级的升级所需经验，这个经验要包括之前所有等级的经验，是一个经验总量，而不是当前等级升级还需要的经验。
XP_PER_LEVEL_TABLE = {}
XP_PER_LEVEL_TABLE2 = {}
for i=1,MAX_LEVEL do
	local xp = 200; --初始经验值为200
	--local xp2 = math.floor((i-1)/10) +1
	local xp2 = math.ceil(i/10)  --取商的整数，向上取整
	local xp3 = 200 --初始经验值为200
	if i > 1 then
		xp3 =  XP_TSZ[xp2]  + XP_PER_LEVEL_TABLE2[i - 1] 
		for ii = 2 , i do 
			xp = xp + XP_PER_LEVEL_TABLE2[ii - 1]
		end
	end
	XP_PER_LEVEL_TABLE2[i] = xp3
	XP_PER_LEVEL_TABLE[i] = xp
end

---默认所有人都选择这个虚拟的单位，在英雄选择完毕，开始游戏的时候，替换成所选的英雄
--这样做主要是为了解决部分玩家在选英雄时掉线，重连以后就没有英雄的问题
--注意：虽然在英雄定义的时候都有一个name，但是实际运用的时候都得用对应的原生dota名字。
--所以在设置默认选择单位的时候，不是kv定义的name，而是它覆盖的英雄的名字
--DUMMY_HERO = "npc_dota_hero_wisp" 

--设置各种游戏规则
local m = {};

function m.ConfigGame()
	--PRE_GAME_TIME = 30
	GameRules:SetHeroRespawnEnabled( false ) --设置是否使用默认英雄复活规则

	GameRules:SetUseUniversalShopMode( true ) --为真时，所有物品当处于任意商店范围内时都能购买到，包括神秘商店商店物品
	
	--自定义游戏设置阶段，自动跳过
	GameRules:SetCustomGameSetupTimeout(0)
	GameRules:SetCustomGameTeamMaxPlayers(TEAM_PLAYER,4)
	GameRules:SetCustomGameTeamMaxPlayers(TEAM_ENEMY,0)
	
	--英雄选择阶段，设置时间长一点，超过自定义的选择界面。 然后当所有人都选择完英雄后，会自动跳过的
	GameRules:SetHeroSelectionTime( 36000 ) --设置选择英雄的时间，因为都设置了自动选择英雄，并且
	GameRules:SetStartingGold( 0 )  --设置 初始金钱为0。
	GameRules:SetStrategyTime( 0 ) --设置英雄选择后的决策时间
	GameRules:SetShowcaseTime( 0 )  --设置 天辉vs夜魇 界面的显示时间。
	
	GameRules:SetPreGameTime( 0) --这是游戏准备时间（英雄选择后到游戏开始）
--	GameRules:SetPreGameTime(0) --这是游戏准备时间（英雄选择后到游戏开始）
	GameRules:SetPostGameTime( POST_GAME_TIME ) --设置在结束游戏后服务器与玩家断线前的时间
	
	GameRules:SetGoldTickTime(0)  --设置获得金币的时间间隔
	GameRules:SetGoldPerTick(0) --设置每个时间间隔获得的金币

	GameRules:SetHideKillMessageHeaders( true )  --设置是否隐藏击杀提示。
	
 	GameRules:SetCustomGameAllowBattleMusic( false )
	GameRules:SetCustomGameAllowHeroPickMusic( false )
	GameRules:SetCustomGameAllowMusicAtGameStart( false )
	
	 
	local mode = GameRules:GetGameModeEntity()
	mode:SetRecommendedItemsDisabled( true ) --是否禁止显示商店中的推荐购买物品
	mode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_AGILITY_ARMOR,0.02)
	mode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_AGILITY_ATTACK_SPEED,0.005)--200点敏捷增加1点攻速
	mode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_MANA,0)
	mode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_MANA_REGEN,0) --仅仅在属性面板介绍智力加成的敌方生效，没有实际生效
	
	mode:SetBuybackEnabled( false ) -- 是否允许买活
	mode:SetHudCombatEventsDisabled(true)

	mode:SetFogOfWarDisabled(true) -- 是否关闭战争迷雾（对两方都有效）
	mode:SetUnseenFogOfWarEnabled(false) --启用/禁用战争迷雾（上边为false才有用）。启用的情况下，未探测区域显示不透明的黑色，探测后变成透明的灰色；禁用的情况下，未探测区域是透明的灰色覆盖

	mode:SetUseCustomHeroLevels ( true )  -- 是否允许使用自定义英雄等级（不使用，则默认只有25级）
	mode:SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )  -- 定义英雄经验值表(table)，通过这个表来确定总共有多少级
	mode:SetCustomBackpackSwapCooldown(0)
	mode:SetGoldSoundDisabled( false ) -- 是否关闭英雄获得金币时的声音
	mode:SetRemoveIllusionsOnDeath( false )  -- 英雄死亡后是否移除其幻象
	mode:SetLoseGoldOnDeath( false ) -- 死亡是否损失金钱

	mode:SetAlwaysShowPlayerInventory( false ) -- 不论任何单位被选中，始终在界面上显示英雄的物品库存
	mode:SetAnnouncerDisabled( true ) -- 禁用播音员
	
	
	--攻击速度是一个复杂的体系。简单来说，同一攻击间隔，最大攻击速度越大，满攻速时候的攻击频率就越高
	mode:SetMaximumAttackSpeed( 600 ) -- 设置单位的最大攻击速度
	mode:SetMinimumAttackSpeed( 20 ) -- 设置单位的最小攻击速度
	
	mode:SetStashPurchasingDisabled ( false ) -- 是否关闭/开启储藏处购买功能。如果该功能被关闭，英雄必须在商店范围内购买物品
	
	mode:SetSelectionGoldPenaltyEnabled( false ) --英雄选择界面超时未选择英雄的金币减少惩罚
	
	mode:DisableHudFlip(true)
	mode:SetDaynightCycleDisabled(true)
	
	mode:SetCustomBackpackCooldownPercent(1)
	
	mode:SetCameraZRange(0,10000)
end

return m