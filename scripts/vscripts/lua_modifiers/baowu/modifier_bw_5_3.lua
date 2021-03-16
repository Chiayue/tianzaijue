
modifier_bw_5_3 = class({})
LinkLuaModifier( "modifier_bw_5_3_buff", "lua_modifiers/baowu/modifier_bw_5_3_buff", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function modifier_bw_5_3:GetTexture()
	return "item_treasure/林野长弓"
end
--------------------------------------------------------------------------------
function modifier_bw_5_3:IsHidden()
	return true
end
function modifier_bw_5_3:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_5_3:OnRefresh()
	
end
function modifier_bw_5_3:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveModifierByName( "modifier_bw_5_3_buff" )
	end
end


function modifier_bw_5_3:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
	return funcs
end


function modifier_bw_5_3:OnDeath( params )
	if IsServer() then
		if self:GetParent() ~= params.unit then
			local caster = self:GetParent()
			if not params.unit.isboss then
				return nil
			end
			if caster:HasModifier("modifier_bw_5_3_buff") then	
				local cs = caster:GetModifierStackCount("modifier_bw_5_3_buff",caster) 
				if cs <100 then
					caster:SetModifierStackCount( "modifier_bw_5_3_buff",caster, cs + 1 )
				end
			else
				local modifier = caster:AddNewModifier( caster, nil, "modifier_bw_5_3_buff", {} )
				modifier:SetStackCount(1)
			end
		end
	end
end


function modifier_bw_5_3:GetModifierBonusStats_Strength( params )
	return 18000
end
function modifier_bw_5_3:GetModifierPreAttack_BonusDamage( params )
	return 66666
end

function modifier_bw_5_3:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end