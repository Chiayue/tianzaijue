
modifier_aoshuzhuanjin = class({})

-----------------------------------------------------------------------------

function modifier_aoshuzhuanjin:OnCreated( kv )
    if self:GetAbility():GetLevel()==0 then
        self:GetParent():RemoveModifierByName(self:GetName())
        return 
    end
end

function modifier_aoshuzhuanjin:IsHidden()
    return true
end

function modifier_aoshuzhuanjin:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
	}
	return funcs
end
-----------------------------------------------------------------------------
function modifier_aoshuzhuanjin:GetModifierPercentageCooldown(params)
    return -30
end
-----------------------------------------------------------------------------
function modifier_aoshuzhuanjin:OnAttackLanded( params )
	if IsServer() then
		-- play sounds and stuff
		if self:GetParent() == params.attacker then
			local hTarget = params.target
			if hTarget ~= nil and self:GetAbility():IsCooldownReady() then
				hCaster=self:GetCaster()
                local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self:GetParent():Script_GetAttackRange()+40, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
                if enemies[1] then
                    local projectile =
                    {
                        Target = enemies[1],
                        Source = self:GetCaster(),
                        Ability = self:GetAbility(),
                        EffectName = "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_arcane_orb.vpcf",
                        iMoveSpeed = 500,
                        vSourceLoc = self:GetCaster():GetOrigin(),
                        bDodgeable = false,
                        bProvidesVision = false,
                        bIgnoreObstructions = true,
                        iSourceAttachment = 1,
                    }

                    ProjectileManager:CreateTrackingProjectile( projectile )
                    EmitSoundOn( "Hero_ObsidianDestroyer.ArcaneOrb.Impact", self:GetParent() )
                    self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(1))
                end
                
			end
		end
	end

	return 0.0
end


