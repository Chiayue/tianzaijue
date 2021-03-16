LinkLuaModifier("modifier_spell_mines", "abilities/spell/sp_mine.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sp_mine == nil then
	sp_mine = class({}, nil, sp_base)
end
function sp_mine:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function sp_mine:OnSpellStart()
	local hCaster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local count = self:GetSpecialValueFor("count")
	local vPosition = self:GetCursorPosition()
	local hCommander = Commander:GetCommander(hCaster:GetPlayerOwnerID())
	local iTeamNumber = hCaster:GetTeamNumber()

	DotaTD:EachPlayer(function(_, iPlayerID)
		if PlayerData:IsPointInPlayerRange(iPlayerID, vPosition) then
			iTeamNumber = PlayerData:GetHero(iPlayerID):GetTeamNumber()
		end
	end)

	-- 创建地雷单位
	for i = 1, count do
		CreateModifierThinker(hCommander, self, "modifier_spell_mines", nil, GetGroundPosition(vPosition + RandomVector(RandomFloat(0, radius)), hCaster), iTeamNumber, false)
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_spell_mines == nil then
	modifier_spell_mines = class({}, nil, eom_modifier)
end
function modifier_spell_mines:OnCreated(params)
	self.mine_radius = self:GetAbilitySpecialValueFor("mine_radius")
	self.damage_pct = self:GetAbilitySpecialValueFor("damage_pct")
	self.mine_delay = self:GetAbilitySpecialValueFor("mine_delay")
	self.interval = 1/30
	if IsServer() then
		self.fTime = 0
		self:StartIntervalThink(self.interval)
		self:GetParent():EmitSound("Hero_Techies.LandMine.Plant")
		self.vPosition = self:GetParent():GetAbsOrigin()
	else
		local iParticleID = ParticleManager:CreateParticle("particles/spell/sp_mine/spell_mine_mines.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_spell_mines:OnRefresh(params)
	self.mine_radius = self:GetAbilitySpecialValueFor("mine_radius")
	self.damage_pct = self:GetAbilitySpecialValueFor("damage_pct")
	self.mine_delay = self:GetAbilitySpecialValueFor("mine_delay")
end
function modifier_spell_mines:OnIntervalThink()
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if IsServer() then
		if not IsValid(hCaster) or not IsValid(hAbility) or not IsValid(hParent) then
			self:Destroy()
			return
		end
		local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), self.vPosition, nil, self.mine_radius, hAbility:GetAbilityTargetTeam(), hAbility:GetAbilityTargetType(), hAbility:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
		if #tTargets > 0 then
			if self.fTime == 0 then
				hParent:EmitSound("Hero_Techies.LandMine.Priming")
			end
			self.fTime = self.fTime + self.interval
			if self.fTime >= self.mine_delay then
				local damage_pct = self.damage_pct
				if hCaster:HasAbility("cmd_rattletrap_2") and hCaster:FindAbilityByName("cmd_rattletrap_2"):GetLevel() > 0 then
					damage_pct = hCaster:FindAbilityByName("cmd_rattletrap_2"):GetSpecialValueFor("damage_pct")
				end
				local fAttack = hCaster:GetVal(ATTRIBUTE_KIND.MagicalAttack) + hCaster:GetVal(ATTRIBUTE_KIND.PhysicalAttack)
				hCaster:DealDamage(tTargets, hAbility, fAttack * damage_pct*0.01)

				local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl(iParticleID, 0, self.vPosition)
				ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.mine_radius, self.mine_radius, self.mine_radius))
				ParticleManager:SetParticleControl(iParticleID, 2, Vector(self.mine_radius, self.mine_radius, self.mine_radius))
				ParticleManager:ReleaseParticleIndex(iParticleID)

				hParent:StopSound("Hero_Techies.LandMine.Priming")
				hParent:EmitSound("Hero_Techies.LandMine.Detonate")

				self:Destroy()
			end
		else
			hParent:StopSound("Hero_Techies.LandMine.Priming")
			self.fTime = 0
		end
	end
end
function modifier_spell_mines:OnDestroy()
	local hParent = self:GetParent()
	if IsServer() then
		hParent:RemoveAllModifiers(0, false, true, true)
		hParent:RemoveSelf()
	end
end
function modifier_spell_mines:CheckState()
	return {
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true
	}
end
function modifier_spell_mines:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_spell_mines:OnBattleEnd()
	self:Destroy()
end