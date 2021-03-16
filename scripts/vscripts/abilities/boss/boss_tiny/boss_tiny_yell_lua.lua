boss_tiny_yell_lua = class({})
LinkLuaModifier( "lower_movespeed","lua_modifiers/boss/lower_movespeed", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------


function boss_tiny_yell_lua:OnSpellStart()
	local hCaster = self:GetCaster()
	
	EmitSoundOn( "Hero_Ursa.Overpower", self:GetCaster() )
	local nFXIndex = ParticleManager:CreateParticle( "particles/add_custom/boss_warning/aoe_warning.vpcf", PATTACH_CUSTOMORIGIN, hCaster )
		ParticleManager:SetParticleControl( nFXIndex, 0, hCaster:GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector(2000,1,1)  )
		ParticleManager:ReleaseParticleIndex(nFXIndex)
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_ursa/ursa_loadout.vpcf", PATTACH_CUSTOMORIGIN, hCaster )
		ParticleManager:SetParticleControl( nFXIndex, 0, hCaster:GetOrigin() )
		
		ParticleManager:ReleaseParticleIndex(nFXIndex)

	 local enemies = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetOrigin(), nil, 2000,
                    DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
                    DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
    local target
    for _,enemy in pairs(enemies) do
    	
    	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_dark_willow/dark_willow_wisp_spell_fear_debuff.vpcf", PATTACH_CUSTOMORIGIN, enemy )
		ParticleManager:SetParticleControl( nFXIndex, 0, enemy:GetOrigin() )
		TimerUtil.createTimerWithDelay(3,
					function()
						ParticleManager:DestroyParticle(nFXIndex,false)

					end)
    	local buff=enemy:AddNewModifier( hCaster, self, "lower_movespeed", {duration=3} )
			buff:SetStackCount(60)
        local damage = {
			victim = enemy,
			attacker = self:GetCaster(),
			damage = self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster()),
			damage_type = DAMAGE_TYPE_PHYSICAL,
			ability = self,
		}
		ApplyDamage( damage )
    end
	
			-- body


end



function boss_tiny_yell_lua:GetCooldown( nLevel )
	return self.BaseClass.GetCooldown( self, nLevel )
end
