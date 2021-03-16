--控制台命令注册，主要是注册一些测试用的命令
local m = {}

local boss = nil;

function m:test()
	SrvMapLevel.AddPlayerMapExp(0,100,SrvMapLevel.Reason_Game_Bonus)
end

function m:ccccc()
	local nPlayerID = Entities:GetLocalPlayer():GetPlayerID()
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
	for i=1,30 do
		local cc=CustomNetTables:GetTableValue( "tzj_storage_personal", hPlayerHero:GetPlayerOwnerID().."_"..i )
		if cc then
			PrintTable(cc)
		end
	end
	print(2222)
	for i=1,30 do
		local cc=CustomNetTables:GetTableValue( "tzj_storage_net", hPlayerHero:GetPlayerOwnerID().."_"..i )
		if cc then
			PrintTable(cc)
		end
	end
	--hPlayerHero:AddAbility("bingzhishijie"):SetLevel(1)
	--local hAbility=hPlayerHero:FindAbilityByName("ascension_crit")
	--print(hAbility:GetLevelSpecialValueFor("crit_chance",hAbility:GetLevel()))
	
	--hPlayerHero:AddNewModifier( hPlayerHero, nil, "modifier_atest", kv )
	
	--hAbility:UpgradeAbility( true )
	--print(hAbility:GetLevelSpecialValueFor("crit_chance",hAbility:GetLevel()))
		
end
function m:ddddd()
	local nPlayerID = Entities:GetLocalPlayer():GetPlayerID()
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
	local hAbility=hPlayerHero:FindAbilityByName("ascension_crit")
	if hAbility ~= nil then
			if hAbility:GetIntrinsicModifierName() ~= nil then
				local hIntrinsicModifier = hPlayerHero:FindModifierByName( hAbility:GetIntrinsicModifierName() )
				if hIntrinsicModifier then
					print( "Force Refresh intrinsic modifier after minor upgrade" )
					hIntrinsicModifier:ForceRefresh()
				end
			end
		end
	print("crit_chance==="..hAbility:GetLevelSpecialValueFor("crit_chance",hAbility:GetLevel()))
	print("crit_multiplier==="..hAbility:GetLevelSpecialValueFor("crit_multiplier",hAbility:GetLevel()))
	
end
function m:fffff()
	local nPlayerID = Entities:GetLocalPlayer():GetPlayerID()
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
	PrintTable(HERO_CUSTOM_PRO)
	
end
function m:eeeee()
	--PrintTable(BLESSING_MODIFIERS)
	local cc=Item_Pro_Weight.weapon.base_pro
	print("resutl")
	PrintTable(Weightsgetvalue_one_key(cc,3))
	print("resutl11111")
	PrintTable(Item_Pro_Weight.weapon.base_pro)
end

--注册控制台命令
Convars:RegisterCommand( "test_item",Dynamic_Wrap(m, "test") , "gc", FCVAR_CHEAT )
local eCommandFlags = FCVAR_CHEAT
Convars:RegisterCommand( "ccccc", function(...) return m:ccccc( ... ) end, "Sets whether there are new players or not", eCommandFlags )
Convars:RegisterCommand( "ddddd", function(...) return m:ddddd( ... ) end, "Sets whether there are new players or not", eCommandFlags )
Convars:RegisterCommand( "eeeee", function(...) return m:eeeee( ... ) end, "Sets whether there are new players or not", eCommandFlags )
Convars:RegisterCommand( "fffff", function(...) return m:fffff( ... ) end, "Sets whether there are new players or not", eCommandFlags )


return m
