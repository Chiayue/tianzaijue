
modifier_bw_all_42 = class({})

-----------------------------------------------------------------------------------------
function modifier_bw_all_42:GetTexture()
	return "item_treasure/群蛇守卫"
end

function modifier_bw_all_42:IsHidden()
	return true
end
----------------------------------------

function modifier_bw_all_42:OnCreated( kv )
	
		self:OnRefresh()
	
end

----------------------------------------
function modifier_bw_all_42:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_BONUS_DAY_VISION,
	}
	return funcs
end
function modifier_bw_all_42:GetBonusDayVision( params )
	return self:GetStackCount()*3
end
function modifier_bw_all_42:OnRefresh()
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+1)
		
		local caster = self:GetParent()
		local attributes2 = {}

		attributes2["qssw_max"] = 1
		AttributesSet2(caster,attributes2)
	end
end
function modifier_bw_all_42:OnDestroy()
	if IsServer() then
		local caster = self:GetParent()
		local attributes2 = {}
		attributes2["qssw_max"] = -1 * self:GetStackCount()
		AttributesSet2(caster,attributes2)
	end
end


function modifier_bw_all_42:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end