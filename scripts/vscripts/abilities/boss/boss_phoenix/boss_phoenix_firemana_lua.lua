boss_phoenix_firemana_lua = class({})
LinkLuaModifier( "modifier_boss_phoenix_firemana_lua","lua_modifiers/boss/boss_phoenix/modifier_boss_phoenix_firemana_lua", LUA_MODIFIER_MOTION_NONE )



--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function boss_phoenix_firemana_lua:OnSpellStart()
	local hCaster = self:GetCaster()
	
	local enemies = FindUnitsInRadius( hCaster:GetTeamNumber(), hCaster:GetOrigin(), nil, 2500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	
	if #enemies >=1 then
		EmitSoundOn( "Hero_Phoenix.SunRay.Cast", hCaster )
		local enemynum=RandomInt(1, #enemies )
		 for i=1,RandomInt(1, #enemies ) do
		 --	if RollPercent(50) then	
		 		enemies[i]:AddNewModifier(hCaster, self, "modifier_boss_phoenix_firemana_lua", {duration=5})
		 --	end
		 end
	end
    
end

