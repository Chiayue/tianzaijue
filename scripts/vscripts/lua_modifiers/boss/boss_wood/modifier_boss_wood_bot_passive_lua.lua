modifier_boss_wood_bot_passive_lua = class({})

--------------------------------------------------------------------------------

function modifier_boss_wood_bot_passive_lua:IsHidden()
	return true
end




--------------------------------------------------------------------------------

function modifier_boss_wood_bot_passive_lua:OnCreated( kv )
	
	if IsServer() then
		self.postion=self:GetParent():GetOrigin()
		self:StartIntervalThink( 0.5)	
	end
end

--------------------------------------------------------------------------------
function modifier_boss_wood_bot_passive_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_DEATH,
    }
    return funcs
end
function modifier_boss_wood_bot_passive_lua:OnIntervalThink()
	if IsServer() then
		if  self:GetParent():IsAlive() then
			self.postion=self:GetParent():GetOrigin()
		end
	end
end
function modifier_boss_wood_bot_passive_lua:OnDeath( params )
	if IsServer() then
		if self:GetParent()==params.unit then
			local hThinker = CreateModifierThinker( self:GetParent(), self:GetAbility(), "modifier_boss_wood_bot_passive_lua_thinker", { duration = 1.5 }, self.postion, self:GetParent():GetTeamNumber(), false )
		end
	end
end
function modifier_boss_wood_bot_passive_lua:OnDestroy( kv )
	
	
end
--------------------------------------------------------------------------------