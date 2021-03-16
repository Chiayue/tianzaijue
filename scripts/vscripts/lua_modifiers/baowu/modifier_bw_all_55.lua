
modifier_bw_all_55 = class({})

-----------------------------------------------------------------------------------------
function modifier_bw_all_55:GetTexture()
	return "item_treasure/智慧石"
end

function modifier_bw_all_55:IsHidden()
	return true
end
----------------------------------------

function modifier_bw_all_55:OnCreated( kv )
	
		self:OnRefresh()
	
end

----------------------------------------

function modifier_bw_all_55:OnRefresh()
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["jnmjts"] = netTable["jnmjts"] +0.5
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end
function modifier_bw_all_55:OnDestroy()
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["jnmjts"] = netTable["jnmjts"] -0.5
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end


function modifier_bw_all_55:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end