


modifiy_shopmall_tszc_6 = class({})
LinkLuaModifier( "modifiy_shopmall_tszc_6_buff", "lua_modifiers/mall/modifiy_shopmall_tszc_6_buff", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function modifiy_shopmall_tszc_6:GetTexture()
	return "rune/shopmall_tszc_6"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_tszc_6:IsHidden()
	return true
end
function modifiy_shopmall_tszc_6:OnCreated( kv )
	
end

function modifiy_shopmall_tszc_6:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end


function modifiy_shopmall_tszc_6:OnDeath( params )
	if IsServer() then
		if self:GetParent() ~= params.unit and params.attacker:GetPlayerOwnerID() == self:GetParent():GetPlayerOwnerID() then
			local wave = math.ceil(Stage.wave/6)
			local hero = self:GetParent()
			local baseStr = hero:GetBaseStrength()  + wave
			local baseAgi = hero:GetBaseAgility()	+ wave
			local baseInt = hero:GetBaseIntellect()	+ wave	
			hero:SetBaseStrength(baseStr)
			hero:SetBaseAgility(baseAgi)
			hero:SetBaseIntellect(baseInt)
			hero:CalculateStatBonus(true)
			if hero:HasModifier("modifiy_shopmall_tszc_6_buff") then	
				hero:SetModifierStackCount( "modifiy_shopmall_tszc_6_buff",hero, hero:GetModifierStackCount("modifiy_shopmall_tszc_6_buff",hero)+wave )
			else
				hero:AddNewModifier( hero, hero, "modifiy_shopmall_tszc_6_buff", {} )
				hero:SetModifierStackCount( "modifiy_shopmall_tszc_6_buff",hero, wave )
			end

		end
	end
end



function modifiy_shopmall_tszc_6:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end