
modifier_boss_invoker_unit_passive_lua = class({})


function modifier_boss_invoker_unit_passive_lua:DeclareFunctions()
    local funcs = {
       MODIFIER_EVENT_ON_ATTACK_LANDED,
    
    }
    return funcs
end

function modifier_boss_invoker_unit_passive_lua:OnAttackLanded(params)
    if IsServer() then
        if self:GetCaster()==params.attacker then
            if params.target:IsAlive() then

                if self:GetCaster():GetUnitName()=="npc_invoker_fire" then
                    params.target:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_boss_invoker_unit_passive_lua_fire", {duration=5} )
                end
                if self:GetCaster():GetUnitName()=="npc_invoker_dust" then
                    if RollPercentage(50) then
                        params.target:AddNewModifier( self:GetCaster(), self:GetAbility(), "stun_nothing", {duration=0.1} )
                    end
                end
                if self:GetCaster():GetUnitName()=="npc_invoker_water" then
                    params.target:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_boss_invoker_unit_passive_lua_water", {duration=5} )
                    local buff=params.target:AddNewModifier( self:GetCaster(), self:GetAbility(), "lower_attackspeed", {duration=5} )
                    buff:SetStackCount(math.ceil(self:GetCaster():GetDisplayAttackSpeed())*20/100)
                end
                if self:GetCaster():GetUnitName()=="npc_invoker_thender" then
                 params.target:SetMana(params.target:GetMana()-200+120*GameRules:GetCustomGameDifficulty())
                    local damageInfo = 
                        {
                            victim = params.target,
                            attacker = self:GetCaster(),
                            damage = self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster())*1.25,
                            damage_type = DAMAGE_TYPE_MAGICAL,
                            ability = self,
                        }

                        ApplyDamage( damageInfo )

                end
            end
        end
    end

end
--------------------------------------------------------------------------------

function modifier_boss_invoker_unit_passive_lua:IsDebuff()
	return false
end

function modifier_boss_invoker_unit_passive_lua:GetTexture( params )
    return "modifier_boss_invoker_unit_passive_lua"
end
function modifier_boss_invoker_unit_passive_lua:IsHidden()
	return false
	-- body
end
function modifier_boss_invoker_unit_passive_lua:OnCreated( kv )
 	

end

function modifier_boss_invoker_unit_passive_lua:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end
