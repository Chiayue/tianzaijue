-----------------------------------------------------------------
modifier_mjssz2 = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_mjssz2:IsHidden()
	return false
end

function modifier_mjssz2:GetTexture()
	return "obsidian_destroyer_essence_aura"
end
--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_mjssz2:DeclareFunctions()
	local funcs = {
	
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
	return funcs
end

function modifier_mjssz2:OnCreated( kv )
	self:OnRefresh()
end
function modifier_mjssz2:OnRefresh()
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+1)
	end
end
function modifier_mjssz2:GetModifierManaBonus( params )
	return self:GetStackCount() * 5
end
function modifier_mjssz2:GetModifierBonusStats_Intellect( params )
	return self:GetStackCount() *40
end

function modifier_mjssz2:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end

-----------