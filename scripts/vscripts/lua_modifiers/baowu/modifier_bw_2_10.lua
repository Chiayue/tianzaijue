
modifier_bw_2_10 = class({})

--------------------------------------------------------------------------------

function modifier_bw_2_10:GetTexture()
	return "item_treasure/莫尔迪基安的臂章"
end
--------------------------------------------------------------------------------
function modifier_bw_2_10:IsHidden()
	return true
end
function modifier_bw_2_10:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink( 1 )
	end
end


function modifier_bw_2_10:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
	return funcs
end
function modifier_bw_2_10:GetModifierPreAttack_BonusDamage( params )
	return 2000
end
function modifier_bw_2_10:GetModifierPhysicalArmorBonus( params )
	return  15
end
function modifier_bw_2_10:GetModifierBonusStats_Strength( params )
	return  1200
end
function modifier_bw_2_10:OnIntervalThink()
	if IsServer() then
		local unit = self:GetParent()
		if unit and unit:IsAlive() then
			local xl = math.ceil(unit:GetHealth()*0.96)
			if xl > 10 then
				unit:SetHealth(xl)	
			end
		end
	end
end
function modifier_bw_2_10:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end