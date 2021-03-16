
item_set_11_01_lua_modifier = class({})

function item_set_11_01_lua_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end
function item_set_11_01_lua_modifier:GetModifierHealthBonus( params )	--智力
	return self:GetAbility():GetSpecialValueFor("bonus_health")
end
function item_set_11_01_lua_modifier:GetModifierBonusStats_Intellect( params )	--智力
	
	
	return self:GetAbility():GetSpecialValueFor("bonus_intellect")
end
function item_set_11_01_lua_modifier:GetModifierPhysicalArmorBonus( params )	--智力
	
	
	return self:GetAbility():GetSpecialValueFor("bonus_armor")
end
--------------------------------------------------------------------------------

function item_set_11_01_lua_modifier:IsDebuff()
	return false
end

function item_set_11_01_lua_modifier:GetTexture( params )
    return "item_set_11_01_lua_modifier"
end
function item_set_11_01_lua_modifier:IsHidden()
	return true
	-- body
end
function item_set_11_01_lua_modifier:OnCreated( kv )
	if IsServer() then
		local event={}
		event.caster=self:GetCaster()
		event.ability=self:GetAbility()
		suit_equip(event)
	end
 	
end
function item_set_11_01_lua_modifier:OnDestroy( kv )
	if IsServer() then
		local event={}
		event.caster=self:GetCaster()
		event.ability=self:GetAbility()
		suit_unequip(event)
	end
 	
end

function item_set_11_01_lua_modifier:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end

function item_set_11_01_lua_modifier:OnTakeDamage( params )
   local caster=self:GetCaster()
    if params.attacker==caster and params.unit:IsAlive()==false and RollPercentage(5) then
    	local buff=caster:FindModifierByName("item_set_11_01_lua_modifier_buff")
    	if buff then
    		if buff:GetStackCount()<50 then
    			buff:SetStackCount(buff:GetStackCount()+1)
    		end
    	else
    		caster:AddNewModifier(caster, self:GetAbility(), "item_set_11_01_lua_modifier_buff", {} )	
    	end
	end
end


