boss_wood_lower_attr_lua = class({})
LinkLuaModifier( "modifier_boss_wood_lower_attr_lua_str","lua_modifiers/boss/boss_wood/modifier_boss_wood_lower_attr_lua_str", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_wood_lower_attr_lua_agi","lua_modifiers/boss/boss_wood/modifier_boss_wood_lower_attr_lua_agi", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_wood_lower_attr_lua_int","lua_modifiers/boss/boss_wood/modifier_boss_wood_lower_attr_lua_int", LUA_MODIFIER_MOTION_NONE )



--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function boss_wood_lower_attr_lua:OnAbilityPhaseStart()
	if IsServer() then
		EmitSoundOn( "Hero_Brewmaster.PrimalSplit.Spawn", self:GetCaster() )
		local hCaster = self:GetCaster()
		local radius = self:GetSpecialValueFor("radius")
		local cd = self.BaseClass.GetCastPoint( self )
		
		ParticleMgr.CreateWarnRing(hCaster,nil,radius,cd)
	end
	return true
end

function boss_wood_lower_attr_lua:OnSpellStart()
	local hCaster = self:GetCaster()
	EmitSoundOn( "Hero_Shredder.WhirlingDeath.Cast", self:GetCaster() )
    local nFXIndex = ParticleManager:CreateParticle( "particles/boss/shredder_whirling_death.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, hCaster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hCaster:GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, hCaster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hCaster:GetOrigin(), true )
		
		ParticleManager:SetParticleControl( nFXIndex, 2, Vector(600,600,600) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
    local enemies = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetOrigin(), nil, 600,
                    DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
                    DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
    
    for _,enemy in pairs(enemies) do
   
    	
        local damage = {
			victim = enemy,
			attacker = self:GetCaster(),
			damage = self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster())*1,
			damage_type = DAMAGE_TYPE_PURE,
			ability = self,
		}
		ApplyDamage( damage )
    end
end

function boss_wood_lower_attr_lua:GetCooldown( nLevel )
	if IsServer() then
		if self:GetCaster():HasModifier("modifier_boss_wood_lower_attr_lua_bloodfier") then
			return self.BaseClass.GetCooldown( self, nLevel )/2	
		end
	end
	return self.BaseClass.GetCooldown( self, nLevel )
end

function boss_wood_lower_attr_lua:GetCastPoint()
	
	return self.BaseClass.GetCastPoint( self )
end