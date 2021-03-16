
modifier_bw_5_10 = class({})
--------------------------------------------------------------------------------

function modifier_bw_5_10:GetTexture()
	return "item_treasure/林野长弓"
end
--------------------------------------------------------------------------------
function modifier_bw_5_10:IsHidden()
	return true
end
function modifier_bw_5_10:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_5_10:OnRefresh()
	
end


function modifier_bw_5_10:DeclareFunctions()
	local funcs = 
	{

		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end

function modifier_bw_5_10:GetModifierPreAttack_BonusDamage( params )
	return  99999
end
function modifier_bw_5_10:OnAttackLanded( params )
	if IsServer() then
		-- play sounds and stuff
		if self:GetParent() == params.attacker then
			local caster = self:GetParent()
			local hTarget = params.target
			if hTarget ~= nil and hTarget:IsAlive()  then
				hTarget:AddNewModifier( hTarget, nil, "modifier_bw_5_10_buff", {duration=5} )
				if RollPercent(1) then
					local hp = hTarget:GetMaxHealth()*0.95
					hTarget:SetMaxHealth(hp)
				end	
			end
		end
	end
end
function modifier_bw_5_10:GetModifierPhysicalArmorBonus( params )
	return  -150
end
function modifier_bw_5_10:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end