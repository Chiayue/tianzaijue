modifier_boss_phoenix_firetarget_lua = class({})

--------------------------------------------------------------------------------

function modifier_boss_phoenix_firetarget_lua:IsHidden()
	return false
end




--------------------------------------------------------------------------------

function modifier_boss_phoenix_firetarget_lua:OnCreated( kv )
	
	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_snapfire/hero_snapfire_ultimate_linger.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
		self:StartIntervalThink( 0.1)	
	end
end

--------------------------------------------------------------------------------

function modifier_boss_phoenix_firetarget_lua:OnIntervalThink()
	if IsServer() then
		if  EntityIsAlive(self:GetCaster()) then
			
			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_snapfire/hero_snapfire_ult_ground_outer.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			local hCaster=self:GetCaster()
			local enemies = FindUnitsInRadius(hCaster:GetTeamNumber(), self:GetParent():GetOrigin(), nil, 350,
                    DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
                    DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
    
			    for _,enemy in pairs(enemies) do
			    	
			    	local buff=enemy:AddNewModifier( hCaster, self:GetAbility(), "lower_movespeed", {duration=1} )
			    	buff:SetStackCount(30)
			    	local damage = {
						victim = enemy,
						attacker = self:GetCaster(),
						damage = self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster())*2,
						damage_type = DAMAGE_TYPE_MAGICAL,
						ability = self:GetAbility(),
					}
					ApplyDamage( damage )
			    end
		end
		self:StartIntervalThink( 1)
	end
end
--------------------------------------------------------------