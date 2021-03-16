
modifier_bw_all_19 = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_19:GetTexture()
	return "item_treasure/提升力量"
end
--------------------------------------------------------------------------------
function modifier_bw_all_19:IsHidden()
	return true
end
function modifier_bw_all_19:OnCreated( kv )
	
	self:OnRefresh()
end
function modifier_bw_all_19:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_BONUS_DAY_VISION,
	}
	return funcs
end

function modifier_bw_all_19:OnRefresh()
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+1)
		local caster = self:GetCaster()
		local unitKey = tostring(EntityHelper.getEntityIndex(caster))
		if not caster.cas_table then
			caster.cas_table = {}
		end
		local netTable = caster.cas_table --服务端存储，避免使用getNetTable方法
		netTable["bfbtsll"] = netTable["bfbtsll"] + 50
		SetNetTableValue("UnitAttributes",unitKey,netTable)	
	end
	
end
function modifier_bw_all_19:OnDestroy()
	if IsServer() then
		local caster = self:GetCaster()
		local cs = self:GetStackCount()
		local unitKey = tostring(EntityHelper.getEntityIndex(caster))
		if not caster.cas_table then
			caster.cas_table = {}
		end
		local netTable = caster.cas_table --服务端存储，避免使用getNetTable方法
		netTable["bfbtsll"] = netTable["bfbtsll"] -(cs*50)
		SetNetTableValue("UnitAttributes",unitKey,netTable)	
	end
end
function modifier_bw_all_19:GetBonusDayVision( params )
	return self:GetStackCount()*50
end

function modifier_bw_all_19:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end