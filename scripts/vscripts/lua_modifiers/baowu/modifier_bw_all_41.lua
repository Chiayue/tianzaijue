
modifier_bw_all_41 = class({})

-----------------------------------------------------------------------------------------
function modifier_bw_all_41:GetTexture()
	return "item_treasure/地狱火"
end

function modifier_bw_all_41:IsHidden()
	return true
end
----------------------------------------

function modifier_bw_all_41:OnCreated( kv )
	
		self:OnRefresh()
	
end

----------------------------------------
function modifier_bw_all_41:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_BONUS_DAY_VISION,
	}
	return funcs
end
function modifier_bw_all_41:GetBonusDayVision( params )
	return self:GetStackCount()
end
function modifier_bw_all_41:OnRefresh()
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+1)
		
		local caster = self:GetParent()
		local attributes2 = {}

		attributes2["dyh_max"] = 1
		AttributesSet2(caster,attributes2)
	end
end
function modifier_bw_all_41:OnDestroy()
	if IsServer() then
		local caster = self:GetParent()
		local attributes2 = {}
		attributes2["dyh_max"] = -1 * self:GetStackCount()
		AttributesSet2(caster,attributes2)
	end
end


function modifier_bw_all_41:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end