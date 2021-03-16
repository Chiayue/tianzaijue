
modifier_bw_all_43 = class({})

-----------------------------------------------------------------------------------------
function modifier_bw_all_43:GetTexture()
	return "item_treasure/死亡守卫"
end

function modifier_bw_all_43:IsHidden()
	return true
end
----------------------------------------

function modifier_bw_all_43:OnCreated( kv )
	
		self:OnRefresh()
	
end
function modifier_bw_all_43:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_BONUS_DAY_VISION,
	}
	return funcs
end
function modifier_bw_all_43:GetBonusDayVision( params )
	return self:GetStackCount()
end
----------------------------------------
function modifier_bw_all_43:OnRefresh()
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+1)
		
		local caster = self:GetParent()
		local attributes2 = {}

		attributes2["swsw_max"] = 1
		AttributesSet2(caster,attributes2)
	end
end
function modifier_bw_all_43:OnDestroy()
	if IsServer() then
		local caster = self:GetParent()
		local attributes2 = {}
		attributes2["swsw_max"] = -1 * self:GetStackCount()
		AttributesSet2(caster,attributes2)
	end
end


function modifier_bw_all_43:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end

