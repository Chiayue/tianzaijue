ab_bw_3_11 = class( {} )

LinkLuaModifier( "modifier_bw_3_11", "lua_modifiers/baowu/modifier_bw_3_11", LUA_MODIFIER_MOTION_NONE )


function ab_bw_3_11:GetIntrinsicModifierName()
	return "modifier_bw_3_11"
end

function ab_bw_3_11:OnProjectileHit_ExtraData(target, vLocation, extraData)
	EmitSoundOn( "Item.Maelstrom.Chain_Lightning", target )
	local nFXIndex = ParticleManager:CreateParticle( "particles/econ/events/ti7/maelstorm_ti7.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControlEnt( nFXIndex, 0, EntIndexToHScript(extraData.up), PATTACH_POINT_FOLLOW, "attach_hitloc", EntIndexToHScript(extraData.up):GetOrigin(), true )
	ParticleManager:SetParticleControlEnt( nFXIndex, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
    ApplyDamage({victim = target, attacker = self:GetCaster(), damage = extraData.damage, 
                 ability = self, damage_type = DAMAGE_TYPE_MAGICAL})
    extraData.bounces_left = extraData.bounces_left - 1
    extraData.up=target:GetEntityIndex()
    -- If there are bounces remaining, reduce damage and find a new target
    if extraData.bounces_left > 0 then
        extraData[tostring(target:GetEntityIndex())] = 1
        self:CreateMoonGlaive(target, extraData)
    end
end
function ab_bw_3_11:CreateMoonGlaive(originalTarget, extraData)
	
    local caster = self:GetCaster()
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), originalTarget:GetAbsOrigin(), nil, 300,
                    DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
                    DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
    local target
    for _,enemy in pairs(enemies) do
        if extraData[tostring(enemy:GetEntityIndex())] ~= 1 and not enemy:IsAttackImmune() then
            target = enemy
            break
        end
    end
    
    if target then
    	
        local projectile = {
            Target = target,
            Source = originalTarget,
            Ability = self,
            EffectName = "",
            bDodgable = true,
            bProvidesVision = false,
            iMoveSpeed =900,
            iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
            ExtraData = extraData
        }
        ProjectileManager:CreateTrackingProjectile(projectile)
        
    end
end
--------------------------------------------------------------------------------
