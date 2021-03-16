
modifers_item_set_02 = class({})


function modifers_item_set_02:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end
function modifers_item_set_02:GetModifierHealthBonus( params )	--智力
	
	return 2500
end
function modifers_item_set_02:GetModifierBonusStats_Agility( params )	--智力
	
	return 80
end
function modifers_item_set_02:GetModifierBonusStats_Strength( params )	--智力
	
	return 80
end
function modifers_item_set_02:GetModifierBonusStats_Intellect( params )	--智力
	
	return 80
end
function modifers_item_set_02:GetModifierPhysicalArmorBonus( params )	--智力
	
	return 15
end


function modifers_item_set_02:OnIntervalThink()
	if IsServer() then
		local hCaster=self:GetCaster()
		if hCaster ~= nil and hCaster:IsAlive() then
			local nFXIndex = ParticleManager:CreateParticle( "particles/items5_fx/essence_ring.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
			ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
			self:GetParent():Heal(self:GetParent():GetMaxHealth()*0.05+7.5*self:GetParent():GetStrength(), nil)
			TimerUtil.createTimerWithDelay(3,function ()
					ParticleManager:DestroyParticle(nFXIndex,true)      
			end)
		end
	end
end
--------------------------------------------------------------------------------

function modifers_item_set_02:IsDebuff()
	return false
end

function modifers_item_set_02:GetTexture( params )
    return "tz/枯木逢春"
end
function modifers_item_set_02:IsHidden()
	return false
	-- body
end
function modifers_item_set_02:OnCreated( kv )
	if IsServer() then
 		self:StartIntervalThink( 5)	
 	end
end

function modifers_item_set_02:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end
