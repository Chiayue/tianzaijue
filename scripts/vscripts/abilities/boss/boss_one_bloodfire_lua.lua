boss_one_bloodfire_lua = class({})
LinkLuaModifier( "modifier_boss_one_bloodfire_lua","lua_modifiers/boss/boss_one/modifier_boss_one_bloodfire_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_one_bloodfire_lua_end_buff","lua_modifiers/boss/boss_one/modifier_boss_one_bloodfire_lua_end_buff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_one_bloodfire_lua_nodead_buff","lua_modifiers/boss/boss_one/modifier_boss_one_bloodfire_lua_nodead_buff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "add_attackspeed","lua_modifiers/boss/add_attackspeed", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "add_armor","lua_modifiers/boss/add_armor", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "lower_armor","lua_modifiers/boss/lower_armor", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function boss_one_bloodfire_lua:OnAbilityPhaseStart()
	if IsServer() then
		
		local hCaster = self:GetCaster()
		EmitSoundOn( "Hero_Sven.GodsStrength", hCaster )
		local setab=hCaster:FindAbilityByName("boss_one_storm_lua") 
		if setab then
			setab:EndCooldown()
		end
		local setab=hCaster:FindAbilityByName("boss_shakeground_lua") 
		if  setab then
			setab:EndCooldown()
		end
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_loadout.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, hCaster, PATTACH_POINT_FOLLOW, "", hCaster:GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex(nFXIndex)
		hCaster:AddNewModifier( hCaster, self, "modifier_boss_one_bloodfire_lua", {duration=10} )
		
	end
	
	return true
end

function boss_one_bloodfire_lua:OnSpellStart()
	local hCaster = self:GetCaster()
	
			-- body


end

---

function boss_one_bloodfire_lua:GetCooldown( nLevel )
	return self.BaseClass.GetCooldown( self, nLevel ) 
end

