
modifier_ch_6_22 = class({})

--------------------------------------------------------------------------------

function modifier_ch_6_22:GetTexture()
	return "item_treasure/力量护腕"
end

function modifier_ch_6_22:IsHidden()
	return true
end
--------------------------------------------------------------------------------

function modifier_ch_6_22:OnCreated( kv )
	self:OnRefresh()
end
--------------------------------------------------------------------------------

function modifier_ch_6_22:OnRefresh()
	if IsServer() then
		self.nFXIndex = ParticleManager:CreateParticle( "particles/ch/shopmall_ch_dy_1.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	--	ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "follow_head", self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControl( self.nFXIndex, 0, self:GetParent():GetOrigin() )
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["xyz"] = netTable["xyz"] + 10
		netTable["tmz"] = netTable["tmz"] + 50
		netTable["bfbtsqsx"] = netTable["bfbtsqsx"] + 20
		netTable["tmz3"] = netTable["tmz3"] + 50
		netTable["jnmjts"] = netTable["jnmjts"] + 0.15
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end
function modifier_ch_6_22:OnDestroy()
	if IsServer() then
		if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex, true)
		end
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["xyz"] = netTable["xyz"] - 10
		netTable["tmz"] = netTable["tmz"] - 50
		netTable["bfbtsqsx"] = netTable["bfbtsqsx"] - 20
		netTable["tmz3"] = netTable["tmz3"] - 50
		netTable["jnmjts"] = netTable["jnmjts"] - 0.15
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end

function modifier_ch_6_22:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------------------------

