
modifier_hero_state_pro_se = class({})

-----------------------------------------------------------------------------------------

function modifier_hero_state_pro_se:IsPurgable()
	return false
end

----------------------------------------

function modifier_hero_state_pro_se:OnCreated( kv )
	self:OnRefresh( kv )
end

----------------------------------------

function modifier_hero_state_pro_se:OnRefresh( kv )
	if self:GetAbility() == nil then
		return
	end
	
	self.jqjc = self:GetAbility():GetSpecialValueFor( "jqjc" )
	self.msmjq = self:GetAbility():GetSpecialValueFor( "msmjq" )
	self.sgzjjb = self:GetAbility():GetSpecialValueFor( "sgzjjb" )
	if IsServer() then
		self:StartIntervalThink( 10 )
	end

end

function modifier_hero_state_pro_se:OnIntervalThink()
	if IsServer() then
		if self.msmjq~=0 then
			PlayerUtil.ModifyGold(self:GetCaster(),self.msmjq)
		end
	end
end
--------------------------------------------------------------------------------

function modifier_hero_state_pro_se:DeclareFunctions()
	local funcs = 
	{
	
		MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end
function modifier_hero_state_pro_se:OnDeath( params )
	if IsServer() then
		if self:GetParent():PassivesDisabled() then
			return 1
		end

		if params.unit ~= nil and params.attacker ~= nil and params.attacker == self:GetParent() then
			PlayerUtil.ModifyGold(self:GetCaster(),self.sgzjjb)
		end
	end
end

--------------------------------------------------------------------------------
