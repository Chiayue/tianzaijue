
modifier_bw_all_98 = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_98:GetTexture()
	return "item_treasure/林野长弓"
end
--------------------------------------------------------------------------------
function modifier_bw_all_98:IsHidden()
	return true
end
function modifier_bw_all_98:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_all_98:OnRefresh()
	
end


function modifier_bw_all_98:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end


function modifier_bw_all_98:OnAttackLanded( params )
	if IsServer() then
		-- play sounds and stuff
		if self:GetParent() == params.attacker then
			local hTarget = params.target
			if hTarget ~= nil  then
				local damage =  hTarget:GetHealth() * 0.2
				ApplyDamageEx(self:GetParent(),hTarget,nil,damage)
			end
		end
	end



end
function modifier_bw_all_98:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end