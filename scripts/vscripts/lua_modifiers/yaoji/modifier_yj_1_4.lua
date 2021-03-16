
modifier_yj_1_4 = class({})

--------------------------------------------------------------------------------

function modifier_yj_1_4:GetTexture()
	return "xhp/潜能药剂"
end
--------------------------------------------------------------------------------

function modifier_yj_1_4:IsHidden()
	return false
end

function modifier_yj_1_4:OnCreated( kv )
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["lqsj"] = netTable["lqsj"] + 20
		SetNetTableValue("UnitAttributes",unitKey,netTable)
		self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodrage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( self.nFXIndex, 0, self:GetParent():GetOrigin() )
	end
	self:OnRefresh()
end
function modifier_yj_1_4:OnDestroy( kv )
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["lqsj"] = netTable["lqsj"] - 20
		SetNetTableValue("UnitAttributes",unitKey,netTable)
		if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex, true)
		end
	end
end

function modifier_yj_1_4:OnRefresh()
	if IsServer() then
	
	end
end
function modifier_yj_1_4:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
	}
	return funcs
end
function modifier_yj_1_4:GetModifierPercentageCooldown( params )
	return 20
end

function modifier_yj_1_4:GetAttributes()
	return MODIFIER_ATTRIBUTE_NONE 
end