LinkLuaModifier("modifier_dark_willow_3_buff", "abilities/tower/dark_willow/dark_willow_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dark_willow_3_debuff_coin", "abilities/tower/dark_willow/dark_willow_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dark_willow_3_debuff_damage", "abilities/tower/dark_willow/dark_willow_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if dark_willow_3 == nil then
	dark_willow_3 = class({}, nil, ability_base_ai)
end
function dark_willow_3:GetAOERadius()
	return self:GetCaster():Script_GetAttackRange()
end
function dark_willow_3:OnSpellStart()
	local hCaster = self:GetCaster()
	local bRollCoin = RollPercentage(50)
	local sParticleName = bRollCoin and "particles/units/heroes/dark_willow/dark_willow_3_coin.vpcf" or "particles/units/heroes/dark_willow/dark_willow_3_coin_inverse.vpcf"
	local iParticleID = ParticleManager:CreateParticle(sParticleName, PATTACH_ABSORIGIN, hCaster)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hCaster:GameTimer(2.2, function()
		hCaster:AddNewModifier(hCaster, self, "modifier_dark_willow_3_buff", { bRollCoin = bRollCoin and 1 or 0 })
	end)
	hCaster:EmitSound("General.Sell")
	PlayerData:ModifyGold(GetPlayerID(hCaster), -1)
	local iParticleID = ParticleManager:CreateParticle("particles/msg_fx/msg_gold.vpcf", PATTACH_OVERHEAD_FOLLOW, hCaster)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(1, 1, 0))
	ParticleManager:SetParticleControl(iParticleID, 2, Vector(1, 2, 1))
	ParticleManager:SetParticleControl(iParticleID, 3, Vector(255, 204, 0))
	ParticleManager:ReleaseParticleIndex(iParticleID)
end
---------------------------------------------------------------------
--Modifiers
if modifier_dark_willow_3_buff == nil then
	modifier_dark_willow_3_buff = class({}, nil, eom_modifier)
end
function modifier_dark_willow_3_buff:OnCreated(params)
	if IsServer() then
		self.bRollCoin = params.bRollCoin == 1 and true or false
	end
end
function modifier_dark_willow_3_buff:OnRefresh(params)
	self:OnCreated(params)
end
function modifier_dark_willow_3_buff:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ATTACK_LANDED] = { self:GetParent() }
	}
end
function modifier_dark_willow_3_buff:OnAttackLanded(params)
	if params.target then
		local sModidiferName = self.bRollCoin and "modifier_dark_willow_3_debuff_coin" or "modifier_dark_willow_3_debuff_damage"
		params.target:AddNewModifier(params.attacker, self:GetAbility(), sModidiferName, nil)
		self:Destroy()
	end
end
---------------------------------------------------------------------
if modifier_dark_willow_3_debuff_coin == nil then
	modifier_dark_willow_3_debuff_coin = class({}, nil, eom_modifier)
end
function modifier_dark_willow_3_debuff_coin:OnCreated(params)
	self.damage_count = self:GetAbilitySpecialValueFor("damage_count")
	self.gold = self:GetAbilitySpecialValueFor("gold")
	if IsServer() then
		self:SetStackCount(self.damage_count)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/effigies/status_fx_effigies/status_effect_effigy_gold_lvl2.vpcf", PATTACH_INVALID, self:GetParent())
		self:AddParticle(iParticleID, false, true, -1, false, false)
	end
end
function modifier_dark_willow_3_debuff_coin:OnRefresh(params)
	self:OnCreated(params)
end
function modifier_dark_willow_3_debuff_coin:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ATTACK_LANDED] = {nil, self:GetParent() }
	}
end
function modifier_dark_willow_3_debuff_coin:OnAttackLanded(params)
	if IsServer() then
		local hCaster = self:GetCaster()
		local vDrop = params.target:GetAbsOrigin() + RandomVector(RandomFloat(100, RemapVal(0, 1, 10, 350, 600)))
		PlayerData:DropGold(GetPlayerID(hCaster), vDrop, self.gold)
		-- PlayerData:ModifyGold(GetPlayerID(hCaster), self.gold)
	end
	self:DecrementStackCount()
	if self:GetStackCount() <= 0 then
		self:Destroy()
	end
end
function modifier_dark_willow_3_debuff_coin:IsDebuff()
	return true
end
---------------------------------------------------------------------
if modifier_dark_willow_3_debuff_damage == nil then
	modifier_dark_willow_3_debuff_damage = class({}, nil, eom_modifier)
end
function modifier_dark_willow_3_debuff_damage:OnCreated(params)
	self.damage_count = self:GetAbilitySpecialValueFor("damage_count")
	self.damage_deepen = self:GetAbilitySpecialValueFor("damage_deepen")
	if IsServer() then
		self:SetStackCount(self.damage_count)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/status_fx/status_effect_dark_willow_wisp_fear.vpcf", PATTACH_INVALID, self:GetParent())
		self:AddParticle(iParticleID, false, true, -1, false, false)
	end
end
function modifier_dark_willow_3_debuff_damage:OnRefresh(params)
	self:OnCreated(params)
end
function modifier_dark_willow_3_debuff_damage:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_TAKEDAMAGE] = {nil, self:GetParent() }
	}
end
function modifier_dark_willow_3_debuff_damage:OnTakeDamage(params)
	if params.damage > 0 then
		local hCaster = self:GetCaster()
		self:DecrementStackCount()
		if self:GetStackCount() <= 0 then
			self:Destroy()
		end
	end
end
function modifier_dark_willow_3_debuff_damage:GetIncomingPercentage()
	return self.damage_deepen
end
function modifier_dark_willow_3_debuff_damage:IsDebuff()
	return true
end