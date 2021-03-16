LinkLuaModifier("modifier_meepo_3", "abilities/tower/meepo/meepo_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if meepo_3 == nil then
	meepo_3 = class({})
end
function meepo_3:GetIntrinsicModifierName()
	return "modifier_meepo_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_meepo_3 == nil then
	modifier_meepo_3 = class({}, nil, eom_modifier)
end
function modifier_meepo_3:OnCreated(params)
	self.illusion_count = self:GetAbilitySpecialValueFor("illusion_count")
	self.tTable = {}
	if IsServer() then
	end
end
function modifier_meepo_3:OnRefresh(params)
	self.illusion_count = self:GetAbilitySpecialValueFor("illusion_count")
	if IsServer() then
	end
end
function modifier_meepo_3:OnDestroy()
	if IsServer() then
		if self.tTable then
			for i = #self.tTable, 1, -1 do
				local hTarget = EntIndexToHScript(self.tTable[i])
				if IsValid(hTarget) and hTarget.ForceKill then
					hTarget:ForceKill(true)
					UTIL_Remove(hTarget)
				end
			end
			self.tTable = {}
		end
	end
end
function modifier_meepo_3:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_meepo_3:OnInBattle(params)
	if self:GetParent():IsClone() then return end
	if IsServer() and self:GetParent():IsBuilding() then
		local hBuilding = self:GetParent():GetBuilding()

		for i = 1, self.illusion_count do
			local hUnit = hBuilding:Clone()
			local iIndex = hUnit:GetEntityIndex()
			table.insert(self.tTable, iIndex)
		end
	end
end
function modifier_meepo_3:OnBattleEnd()
	if IsServer() and self.tTable then
		for i = #self.tTable, 1, -1 do
			local hTarget = EntIndexToHScript(self.tTable[i])
			if IsValid(hTarget) then
				hTarget:ForceKill(true)
				UTIL_Remove(hTarget)
			end
		end
		self.tTable = {}
	end
end