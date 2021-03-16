

modifier_boss_wood_bot_passive_lua_thinker = class({})

-----------------------------------------------------------------------------

function modifier_boss_wood_bot_passive_lua_thinker:OnCreated( kv )
	if IsServer() then

		local hCaster=self:GetCaster()
		EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "Hero_Techies.LandMine.Priming", self:GetParent() )
		
		ParticleMgr.CreateWarnRing(self:GetParent(),nil,300,1.5)
			
	end
end


-----------------------------------------------------------------------------

function modifier_boss_wood_bot_passive_lua_thinker:OnDestroy()
	if IsServer() then
		
		local hCaster=self:GetParent()
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_techies/techies_blast_off.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0,hCaster:GetOrigin() )
		ParticleManager:ReleaseParticleIndex(nFXIndex)
		EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "Hero_Techies.Suicide.Arcana", self:GetParent() )
			 local enemies = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetOrigin(), nil, 300,
                    DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
                    DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
    
		    for _,enemy in pairs(enemies) do
		    	
		    	enemy:AddNewModifier( hCaster, self:GetAbility(), "stun_nothing", {duration=1} )
		    	local damage = {
					victim = enemy,
					attacker = self:GetCaster(),
					damage = self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster())*2.5,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = self:GetAbility(),
				}
				ApplyDamage( damage )		
		    end
		end
	
end

-----------------------------------------------------------------------------

