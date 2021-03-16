
modifers_item_set_12 = class({})


function modifers_item_set_12:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifers_item_set_12:OnAttackLanded( params )
	if IsServer() then
		
		if params.attacker == self:GetParent() then
			
			local target = params.target

			if target ~= nil and target:IsAlive() then
				if target.item_set_12_count==nil then
					target.item_set_12_count=1
					target.item_set_12_max=0
				else
					if target.item_set_12_max<=5 then
						if target.item_set_12_count==20 then
							target.item_set_12_count=1
							target.item_set_12_max=target.item_set_12_max+1
							target:SetMaxHealth(target:GetMaxHealth()*0.98)
						else
							target.item_set_12_count=target.item_set_12_count+1
						end
					end
					
				end
				
				
			end
			
		end
	end
	
	return 0
end



--------------------------------------------------------------------------------

function modifers_item_set_12:IsDebuff()
	return false
end

function modifers_item_set_12:GetTexture( params )
    return "tz/人生"
end
function modifers_item_set_12:IsHidden()
	return false
	-- body
end
function modifers_item_set_12:OnCreated( kv )
	if IsServer() then
 	end
end

function modifers_item_set_12:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifers_item_set_12:IsAura()
    return true
end

--------------------------------------------------------------------------------

function modifers_item_set_12:GetModifierAura()
    return "modifers_item_set_12_aura"
end

--------------------------------------------------------------------------------

function modifers_item_set_12:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifers_item_set_12:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO
end

--------------------------------------------------------------------------------

function modifers_item_set_12:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

--------------------------------------------------------------------------------

function modifers_item_set_12:GetAuraRadius()
    return 1200
end