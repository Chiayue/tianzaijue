modifier_throw_attack = class({})
--------------------------------------------------------------------------------

function modifier_throw_attack:IsDebuff()
	return false
end
function modifier_throw_attack:IsHidden()
	return false
end

function modifier_throw_attack:GetTexture( params )
    return "sword/stun_modifier"
end
function modifier_throw_attack:OnCreated( kv )
    if IsServer() then
        self:StartIntervalThink(1)
        self:OnIntervalThink()
       
    end
    
end
function modifier_throw_attack:OnDestroy()
	if IsServer() then
		
	end
end
function modifier_throw_attack:OnIntervalThink()
	if IsServer() then
		local hCaster=self:GetCaster()
        if self:GetAbility():IsCooldownReady() and hCaster:IsAlive() then
            local enemies = FindUnitsInRadius( hCaster:GetTeamNumber(), hCaster:GetOrigin(), hCaster, hCaster:Script_GetAttackRange()+440, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
			local num=1
			for i=1,num do
				if enemies[i] then
					local sxxx=CreateUnitByName("npc_dota_dummy_target", enemies[i]:GetOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS )
					
					local nFXIndex = ParticleManager:CreateParticle( "particles/add_custom/boss_warning/aoe_warning.vpcf", PATTACH_CUSTOMORIGIN, nil )
					ParticleManager:SetParticleControl( nFXIndex, 0, sxxx:GetOrigin() )
					ParticleManager:SetParticleControl( nFXIndex, 1, Vector(200,0,0) )
					ParticleManager:ReleaseParticleIndex(nFXIndex)
					local projectile =
					{
						Target = sxxx,
						Source = self:GetCaster(),
						Ability = self:GetAbility(),
						EffectName = hCaster:GetRangedProjectileName(),
						iMoveSpeed = 500,
						vSourceLoc = self:GetCaster():GetOrigin(),
						bDodgeable = false,
						bProvidesVision = false,
						bIgnoreObstructions = true,
						iSourceAttachment = 1,
					}

					ProjectileManager:CreateTrackingProjectile( projectile )
					EmitSoundOn( "Hero_ObsidianDestroyer.ArcaneOrb.Impact", hCaster )
					
				end
			end
            self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(1))
        end
        
	end
end
function modifier_throw_attack:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
	}
	return funcs
end

function modifier_throw_attack:GetModifierExtraHealthPercentage( params )
    return 100
end
function modifier_throw_attack:CheckState()
	local state = {
	[MODIFIER_STATE_DISARMED] = true,
	}

	return state
end