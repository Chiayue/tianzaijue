
modifier_jyg_14 = class({})
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
function modifier_jyg_14:IsHidden()
	return true
end
function modifier_jyg_14:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_jyg_14:OnRefresh()
	
end


function modifier_jyg_14:DeclareFunctions()
	local funcs = 
	{

		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end


function modifier_jyg_14:OnAttackLanded( params )
	if IsServer() then
		-- play sounds and stuff
		if self:GetParent() == params.attacker then
			local caster = self:GetParent()
			local hTarget = params.target		
			if not hTarget:HasModifier("modifier_jyg_14_buff") then
				hTarget:AddNewModifier( hTarget, self:GetAbility(), "modifier_jyg_14_buff", {duration=3})	
			end		
		end
	end
end

