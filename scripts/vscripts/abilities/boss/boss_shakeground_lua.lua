boss_shakeground_lua = class({})
LinkLuaModifier( "modifier_boss_shakeground_lua_slow","lua_modifiers/boss/boss_one/modifier_boss_shakeground_lua_slow", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_shakeground_lua_thinker","lua_modifiers/boss/boss_one/modifier_boss_shakeground_lua_thinker", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function boss_shakeground_lua:OnAbilityPhaseStart()
	if IsServer() then
		EmitSoundOn( "Hero_Brewmaster.PrimalSplit.Spawn", self:GetCaster() )
		local hCaster = self:GetCaster()
		local difficulty = GameRules:GetCustomGameDifficulty() 
		local radius = self:GetSpecialValueFor("radius")  + difficulty * 33
		local cd = self.BaseClass.GetCastPoint( self )-difficulty*0.04
		if cd < 0.5 then
			cd = 0.5
		end
		
		ParticleMgr.CreateWarnRing(hCaster,nil,radius,cd)
		
	end
	return true
end

function boss_shakeground_lua:OnSpellStart()
	local hCaster = self:GetCaster()
	EmitSoundOn( "Hero_Brewmaster.ThunderClap", self:GetCaster() )
	local difficulty = GameRules:GetCustomGameDifficulty() 
	local radius = self:GetSpecialValueFor("radius")+ difficulty * 33
	local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/brewmaster/brewmaster_offhand_elixir/brewmaster_thunder_clap_elixir.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, hCaster, PATTACH_POINT_FOLLOW, "", hCaster:GetOrigin(), true )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector(radius,1,1)  )
		ParticleManager:ReleaseParticleIndex(nFXIndex)
	
	local enemies = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), nil, radius,
                    DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
                    DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
    
    for _,enemy in pairs(enemies) do
    	
       local buff=enemy:AddNewModifier( hCaster, self, "modifier_boss_shakeground_lua_slow", {duration=3} )
       buff:SetStackCount(60)
       local damageInfo =
			{
				victim = enemy,
				attacker = self:GetCaster(),
				damage = self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster())*self:GetSpecialValueFor("i"),
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self,
			}
		ApplyDamage( damageInfo )
    end
	local hThinker = CreateModifierThinker( self:GetCaster(), self, "modifier_boss_shakeground_lua_thinker", { duration = 3 }, hCaster:GetOrigin(), self:GetCaster():GetTeamNumber(), false )
			-- body


end


function boss_shakeground_lua:GetCooldown( nLevel )
	return self.BaseClass.GetCooldown( self, nLevel )-0.2*GameRules:GetCustomGameDifficulty()
end
function boss_shakeground_lua:GetCastPoint()
	local cd  = self.BaseClass.GetCastPoint( self )-GameRules:GetCustomGameDifficulty()*0.1
	if cd < 0.5 then
		cd = 0.5
	end
	return cd
end

