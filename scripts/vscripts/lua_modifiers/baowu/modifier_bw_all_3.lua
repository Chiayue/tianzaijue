
modifier_bw_all_3 = class({})
function modifier_bw_all_3:IsPurgable()
	return false
end
--------------------------------------------------------------------------------

function modifier_bw_all_3:GetTexture()
	return "item_treasure/沉默的羔羊"
end
--------------------------------------------------------------------------------
function modifier_bw_all_3:IsHidden()
	return true
end
function modifier_bw_all_3:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink( 50 )
		
		local caster = self:GetParent()
		for var=0, 4 do
			local ability = caster:GetAbilityByIndex(var)
			if ability ~= nil and not ability:IsPassive() and not BitAndTest(GetAbilityBehaviorNum(ability),DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE) then
				ability:SetActivated(false)
			end
		end
		
	end
end


function modifier_bw_all_3:OnDestroy()
	if IsServer() then
		local caster = self:GetParent()
		for var=0, 4 do
			local ability = caster:GetAbilityByIndex(var)
			if ability ~= nil and not ability:IsPassive() and not BitAndTest(GetAbilityBehaviorNum(ability),DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE) then
				ability:SetActivated(true)
			end
		end
	end
end


function modifier_bw_all_3:OnIntervalThink()
	if IsServer() then
		self:GetParent():ModifyIntellect(self:GetParent():GetBaseIntellect()*0.1)
			
		self:GetParent():ModifyStrength(self:GetParent():GetBaseStrength()*0.1)
			
		self:GetParent():ModifyAgility(self:GetParent():GetBaseAgility()*0.1)
	end
end


function modifier_bw_all_3:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
--function modifier_bw_all_3:CheckState()
--    local state = {
--        [MODIFIER_STATE_SILENCED] = true,
--        
--    }
--
--    return state
--end