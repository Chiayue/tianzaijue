
modifier_boss_two_pureattack_lua = class({})


function modifier_boss_two_pureattack_lua:DeclareFunctions()
    local funcs = {
       MODIFIER_EVENT_ON_ATTACK_LANDED,
    
    }
    return funcs
end

function modifier_boss_two_pureattack_lua:OnAttackLanded(params)
    if IsServer() then
        if self:GetCaster()==params.attacker and self:GetAbility():IsCooldownReady()  and self:GetParent():GetHealthPercent()<50 then
            local damageInfo = 
                    {
                        victim = params.unit,
                        attacker = self:GetCaster(),
                        damage = self:GetParent():GetAttackDamage(),
                        damage_type = self:GetAbility():GetAbilityDamageType(),
                        ability = self,
                    }
                    ApplyDamage( damageInfo )
            self:GetAbility():StartCooldown(-1)
        end
    end

end
--------------------------------------------------------------------------------

function modifier_boss_two_pureattack_lua:IsDebuff()
	return false
end

function modifier_boss_two_pureattack_lua:GetTexture( params )
    return "modifier_boss_two_pureattack_lua"
end
function modifier_boss_two_pureattack_lua:IsHidden()
	return true
	-- body
end
function modifier_boss_two_pureattack_lua:OnCreated( kv )
 	

end

function modifier_boss_two_pureattack_lua:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end
