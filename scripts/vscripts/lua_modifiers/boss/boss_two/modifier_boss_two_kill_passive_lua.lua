
modifier_boss_two_kill_passive_lua = class({})


function modifier_boss_two_kill_passive_lua:DeclareFunctions()
    local funcs = {
       
        MODIFIER_EVENT_ON_TAKEDAMAGE,
    
    }
    return funcs
end
function modifier_boss_two_kill_passive_lua:OnTakeDamage( params )
    if IsServer() then
        if params.attacker==self:GetParent() and not params.unit:IsAlive() and params.unit:IsHero() then
           
            if self:GetParent():HasModifier("modifier_boss_two_kill_passive_lua_effect_damage") then
                local buff=self:GetParent():FindModifierByName("modifier_boss_two_kill_passive_lua_effect_damage")
                    buff:SetStackCount(math.ceil(self:GetParent():GetAttackDamage()*self.percent/100)+buff:GetStackCount())
                local buff=self:GetParent():FindModifierByName("modifier_boss_two_kill_passive_lua_effect_movespeed")
                    buff:SetStackCount(1+buff:GetStackCount())
            else
                local buff=self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_boss_two_kill_passive_lua_effect_damage", {} )
                buff:SetStackCount(math.ceil(self:GetParent():GetAttackDamage()*self.percent/100))
                local buff=self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_boss_two_kill_passive_lua_effect_movespeed", {} )
                buff:SetStackCount(1)
            end

        end 
    end

    return 0
end

--------------------------------------------------------------------------------

function modifier_boss_two_kill_passive_lua:IsDebuff()
	return false
end

function modifier_boss_two_kill_passive_lua:GetTexture( params )
    return "modifier_boss_two_kill_passive_lua"
end
function modifier_boss_two_kill_passive_lua:IsHidden()
	return true
	-- body
end
function modifier_boss_two_kill_passive_lua:OnCreated( kv )
 	self.percent=self:GetAbility():GetSpecialValueFor("percent")

end

function modifier_boss_two_kill_passive_lua:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end
