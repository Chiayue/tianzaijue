
modifier_bw_all_49 = class({})
LinkLuaModifier( "modifier_bw_all_49_buff", "lua_modifiers/baowu/modifier_bw_all_49_buff", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function modifier_bw_all_49:GetTexture()
	return "item_treasure/林野长弓"
end
--------------------------------------------------------------------------------
function modifier_bw_all_49:IsHidden()
	return true
end
function modifier_bw_all_49:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_all_49:OnRefresh()
	
end


function modifier_bw_all_49:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_RESPAWN,
	}
	return funcs
end


function modifier_bw_all_49:OnRespawn( params )
	if IsServer() then
		if self:GetParent() == params.unit then
			local caster = self:GetParent()
			if caster:HasModifier("modifier_bw_all_49_buff") then	
				local level = caster:GetLevel()*3
				local cs = math.ceil(caster:GetModifierStackCount("modifier_bw_all_49_buff",caster)+level)
				caster:SetModifierStackCount( "modifier_bw_all_49_buff",caster, cs )
			else
				caster:AddNewModifier( caster, caster, "modifier_bw_all_49_buff", {} )
				local level = caster:GetLevel()*3
				caster:SetModifierStackCount( "modifier_bw_all_49_buff",caster, level )
			end
		end
	end
end
function modifier_bw_all_49:OnDestroy()
	if IsServer() then 
		
		self:GetParent():RemoveModifierByName( "modifier_bw_all_49_buff" )
		-- Removes a modifier.
	end
end
function modifier_bw_all_49:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end