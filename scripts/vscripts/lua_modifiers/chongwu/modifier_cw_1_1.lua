
modifier_cw_1_1 = class({})

-----------------------------------------------------------------------------------------
function modifier_cw_1_1:GetTexture()
	return "item_treasure/杀猪刀"
end

function modifier_cw_1_1:IsHidden()
	return true
end
----------------------------------------

function modifier_cw_1_1:OnCreated( kv )
	
		self:OnRefresh()
	
end

----------------------------------------

function modifier_cw_1_1:OnRefresh()
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["sgzjjb"] = netTable["sgzjjb"] + 10
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end
function modifier_cw_1_1:OnDestroy()
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["sgzjjb"] = netTable["sgzjjb"] - 10
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end


function modifier_cw_1_1:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end