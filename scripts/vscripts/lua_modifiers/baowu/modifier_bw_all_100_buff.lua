
modifier_bw_all_100_buff = class({})
--------------------------------------------------------------------------------

function modifier_bw_all_100_buff:GetTexture()
	return "item_treasure/林野长弓"
end
--------------------------------------------------------------------------------
function modifier_bw_all_100_buff:IsHidden()
	return false
end
function modifier_bw_all_100_buff:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_all_100_buff:OnRefresh()
	
end


function modifier_bw_all_100_buff:DeclareFunctions()
	local funcs = 
	{

		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end


function modifier_bw_all_100_buff:OnAttackLanded( params )
	if IsServer() then
		if self:GetParent() == params.attacker then
			if RollPercentage(100) then
				local caster=self:GetParent()
				local point = caster:GetAbsOrigin()
				if caster ~= nil and caster:IsAlive() then
					local units = FindAlliesInRadiusExdd(caster,point,1200)
					if #units >= 1 then
						local attachment = caster:ScriptLookupAttachment( "attach_attack1" )
						 local info = 
							{
							Target = units[1],
							Source = caster,
							Ability = self:GetAbility(),
							EffectName = "particles/econ/items/morphling/morphling_ethereal/morphling_adaptive_strike_ethereal.vpcf",
							iMoveSpeed = 300,
							vSourceLoc = caster:GetAttachmentOrigin( attachment ),
							bDodgeable = false,
							bProvidesVision = false,
							flExpireTime = GameRules:GetGameTime() + 4,
							}

						ProjectileManager:CreateTrackingProjectile( info )
					end		
				end
			end
		end
	end
end




function modifier_bw_all_100_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end