
modifier_bw_3_8 = class({})

--------------------------------------------------------------------------------

function modifier_bw_3_8:GetTexture()
	return "item_treasure/幻术师披风"
end
--------------------------------------------------------------------------------
function modifier_bw_3_8:IsHidden()
	return true
end
function modifier_bw_3_8:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_3_8:OnRefresh()
	
end



function modifier_bw_3_8:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end
function modifier_bw_3_8:OnAttackLanded( params )
	
	if IsServer() then
		-- play sounds and stuff
		if self:GetParent() == params.attacker then
			local hTarget = params.target
			if RollPercentage(5) then
				CreateIllusions(self:GetParent(),self:GetParent(),nil,1,1,true,true)
			end
		end
	end

	return 0.0

end
function modifier_bw_3_8:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end