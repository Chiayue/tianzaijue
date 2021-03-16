
modifier_bw_all_21 = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_21:GetTexture()
	return "item_treasure/提升智力"
end
--------------------------------------------------------------------------------
function modifier_bw_all_21:IsHidden()
	return true
end
function modifier_bw_all_21:OnCreated( kv )
	self:OnRefresh()
end

function modifier_bw_all_21:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_BONUS_DAY_VISION,
	}
	return funcs
end
function modifier_bw_all_21:OnRefresh()
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+1)
		local caster = self:GetCaster()
		local unitKey = tostring(EntityHelper.getEntityIndex(caster))
		if not caster.cas_table then
			caster.cas_table = {}
		end
		local netTable = caster.cas_table --服务端存储，避免使用getNetTable方法
		netTable["bfbtszl"] = netTable["bfbtszl"] + 50
		SetNetTableValue("UnitAttributes",unitKey,netTable)	
	end
	
end
function modifier_bw_all_21:OnDestroy()
	if IsServer() then
		local caster = self:GetCaster()
		local cs = self:GetStackCount()
		local unitKey = tostring(EntityHelper.getEntityIndex(caster))
		if not caster.cas_table then
			caster.cas_table = {}
		end
		local netTable = caster.cas_table --服务端存储，避免使用getNetTable方法
		netTable["bfbtszl"] = netTable["bfbtszl"] -(cs*50)
		SetNetTableValue("UnitAttributes",unitKey,netTable)	
	end
end
function modifier_bw_all_21:GetBonusDayVision( params )
	return self:GetStackCount()*50
end

function modifier_bw_all_21:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end