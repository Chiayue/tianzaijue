if SVOperate == nil then
	SVOperate = {}
end

local public = SVOperate

public.msg = {
	-- [10001] = 'player_hard',
	-- [10002] = 'player_soft',
	-- [10003] = 'player_base_item',
	-- [10004] = 'player_item',
	-- [10005] = 'player_equip',
	[10006] = 'player_bp_level',
	[10007] = 'player_bp_receive',
	[10008] = 'player_herocards',
	[10009] = 'player_cardgroups',
	-- [10010] = 'player_default_cardgroup_id',
	[10011] = 'player_currency', -- 玩家货币
	[10012] = 'player_tokens', -- 玩家代币
	[10013] = 'player_commander', -- 玩家指挥官
	[10014] = 'player_commander_talent', -- 玩家指挥官天赋
	[10015] = 'player_commander_talent_point', -- 玩家指挥官天赋点
	[10016] = 'player_talent', -- 玩家指挥官天赋点
	[10017] = 'player_talent_point', -- 玩家指挥官天赋点
	[10018] = 'player_level', -- 玩家经验等级
	[10019] = 'player_artifact', -- 玩家神器解锁
	[10020] = 'player_spell', -- 玩家法术解锁
	[10021] = 'player_item', -- 玩家物品解锁
	[10022] = 'player_box', -- 玩家宝箱数量
	[10023] = 'player_using', -- 玩家使用物品数据
	[10024] = 'player_courier', -- 信使
	[10025] = 'player_courierfx', -- 特效
	[10026] = 'player_title', -- 称号
	[10027] = 'player_headframe', -- 头像框
	[10028] = 'player_ingameitem', -- 消耗品
	[10029] = 'player_vip', -- 月卡
	[10030] = 'player_task', -- 任务
	[10031] = 'player_limit_buy', -- 限购数据
	[10032] = 'player_battlepass_doublexp', -- BP双倍经验
	[10033] = 'player_title_task', -- 成就任务
	[10034] = 'player_adventure_progress', -- 冒险进度
	[10035] = 'player_endless_layers', -- 无尽层数
	[10036] = 'player_7play', -- 7日游玩
	[10037] = 'player_first_pay',
	[10038] = 'player_herotask', -- 英雄成长任务
	[10039] = 'player_first_pass_rewards', -- 玩家首通奖励数据
	[10040] = 'player_game_info', -- 玩家游戏内配置数据
	[10041] = 'player_endless_rank', -- 玩家无尽排行数据
	[10042] = 'player_openbox_guarantees', -- 玩家开箱保底数据
	[10043] = 'player_nian_play', -- 年兽活动奖励数据
	[10044] = 'player_laodaixin', -- 老带新次数上限

	[20001] = 'info_hero_growup',
	[20002] = 'info_hero_attribute_growup',
	[20003] = 'info_shop_product',
	[20004] = 'info_shop_item',
	[20005] = 'info_shop_special',
	[20006] = 'info_shop_tab',
	[20007] = 'info_bp',
	[20008] = 'info_bp_season',
	[20009] = 'info_bp_task_refresh_time',
	[20010] = 'info_unlock_item',
	[20011] = 'info_first_pass_reward',
	[20012] = 'info_difficulty',
	[20013] = 'info_endless_rank1', -- 无尽单人榜数据
	[20014] = 'info_endless_rank4', -- 无尽四人榜数据
	[20015] = 'info_endless_pass', -- 无尽通关奖励数据
	[20016] = 'info_endless_reset', -- 无尽重置消耗和奖励数据
	[20017] = 'info_endless_affix', -- 无尽每周词缀
	[20018] = 'info_nian_time', -- 年兽活动时间
}

function public:OnOperate(id, data, playerid)
	if nil == self.msg[id] then
		return
	end

	-- 玩家数据
	if id > 10000 and id < 20000 and playerid ~= nil then
		if id == 10008 then
			HeroCard:SetPlayerHeroCards(playerid, data)
		elseif id == 10009 then
			HeroCard:SetPlayerCardgroups(playerid, data)
		end

		NetEventData:SetTableValue("service", self.msg[id] .. '_' .. playerid, data)
		if id == 10011 then
			DeepPrintTable(data)
		end
	elseif id > 20000 and id < 30000 then
		-- info 配置表
		if id == 20001 then
			HeroCard:SetHeroGrowupInfo(data)
			return
		elseif id == 20002 then
			HeroCard:SetHeroAttributeGrowupInfo(data)
		end

		NetEventData:SetTableValue("service", self.msg[id], data)
	end
end