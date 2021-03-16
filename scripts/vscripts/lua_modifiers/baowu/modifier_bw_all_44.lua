
modifier_bw_all_44 = class({})
--------------------------------------------------------------------------------

function modifier_bw_all_44:GetTexture()
	return "item_treasure/林野长弓"
end
--------------------------------------------------------------------------------
function modifier_bw_all_44:IsHidden()
	return true
end
function modifier_bw_all_44:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_all_44:OnRefresh()
	
end


function modifier_bw_all_44:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end


function modifier_bw_all_44:OnAttackLanded( params )
	if IsServer() then
		if self:GetParent() == params.attacker then
			local caster = self:GetParent()
			local level = caster:GetLevel()
			local gold = level *(1+caster.cas_table.jqjc/100)
			SendOverheadEventMessage( nil, 0, caster, gold, nil )--加这个会很吵
			PlayerUtil.ModifyGold(caster,gold)
		end
	end
end

function modifier_bw_all_44:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end