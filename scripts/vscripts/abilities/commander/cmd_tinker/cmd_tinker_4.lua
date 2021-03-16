LinkLuaModifier("modifier_cmd_tinker_4", "abilities/commander/cmd_tinker/cmd_tinker_4.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cmd_tinker_4_missles", "abilities/commander/cmd_tinker/cmd_tinker_4.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if cmd_tinker_4 == nil then
	cmd_tinker_4 = class({})
end
function cmd_tinker_4:GetIntrinsicModifierName()
	return "modifier_cmd_tinker_4"
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_tinker_4 == nil then
	modifier_cmd_tinker_4 = class({}, nil, eom_modifier)
end
function modifier_cmd_tinker_4:IsHidden()
	return true
end
function modifier_cmd_tinker_4:OnCreated(params)
	self.missleTimes = 0
	self.number = self:GetAbilitySpecialValueFor("number")
	if IsServer() then
	end
end
function modifier_cmd_tinker_4:OnRefresh(params)
	self.number = self:GetAbilitySpecialValueFor("number")
	if IsServer() then
	end
end
function modifier_cmd_tinker_4:OnDestroy()
	if IsServer() then
	end
end
function modifier_cmd_tinker_4:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_PLAYER_USE_SPELL,
	}
end

function modifier_cmd_tinker_4:OnHeroUseSpell(params)
	if params.iPlayerID == GetPlayerID(self:GetParent()) then
		local hParent = self:GetParent()
		local hTarget = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, 2500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, 0, false)
		if #hTarget > 0 then
			for i = 1, self.number do
				local target = RandomValue(hTarget)
				self:GetParent():GameTimer(1, function()
					CreateModifierThinker(self:GetParent(), self:GetAbility(), "modifier_cmd_tinker_4_missles", { target_index = target:GetEntityIndex() }, self:GetParent():GetAbsOrigin(), target:GetTeamNumber(), false)
				end)
			end
		end
	end
end

------------------------------------------------------------------
--thinker
if modifier_cmd_tinker_4_missles == nil then
	modifier_cmd_tinker_4_missles = class({}, nil, eom_modifier)
end

function modifier_cmd_tinker_4_missles:OnCreated(params)
	self.missile_speed = 800

	if IsServer() then

		self.hTarget = EntIndexToHScript(params.target_index)
		if not IsValid(self.hTarget) then
			self:Destroy()
			return
		end

		local hParent = self:GetParent()

		local hCaster = self:GetCaster()
		self.iParticleID = ParticleManager:CreateParticle("particles/econ/items/clockwerk/clockwerk_paraflare/clockwerk_para_rocket_flare.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControl(self.iParticleID, 0, hCaster:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.iParticleID, 1, self.hTarget:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.iParticleID, 2, Vector(self.missile_speed, 0, 0))
		self:AddParticle(self.iParticleID, false, false, -1, false, false)

		self.vStartPosition = hParent:GetAbsOrigin()
		self.vTargetPosition = self.hTarget:GetAttachmentOrigin(self.hTarget:ScriptLookupAttachment("attach_hitloc"))
		local vDirection = self.vTargetPosition - self.vStartPosition
		self.vOffset = self.vStartPosition + 1 * vDirection:Length2D() * RotatePosition(Vector(0, 0, 0), QAngle(RandomFloat(-180, 0), RandomFloat(1, 0) * 180, 0), Vector(1, 0, 0))
		-- DebugDrawCi
		-- .rcle(self.vOffset, Vector(0, 255, 0), 255, 32, true, 1)
		self.fStartTime = GameRules:GetGameTime()


		self:StartIntervalThink(0)
	end
end
function modifier_cmd_tinker_4_missles:OnIntervalThink()
	if IsServer() then
		local hParent = self:GetParent()
		local fTime = GameRules:GetGameTime() - self.fStartTime

		if IsValid(self.hTarget) and self.hTarget:IsAlive() then
			self.vTargetPosition = CalcClosestPointOnEntityOBB(self.hTarget, self.vStartPosition)
			-- self.vTargetPosition.z = self.hTarget:GetAttachmentOrigin(self.hTarget:ScriptLookupAttachment("attach_hitloc")).z
		end

		local vDirection = self.vTargetPosition - self.vStartPosition
		local fProgress = Clamp((self.missile_speed * fTime) / vDirection:Length2D(), 0, 1)
		local vStart = hParent:GetAbsOrigin()
		local vEnd = Bessel(fProgress, self.vStartPosition, self.vOffset, self.vTargetPosition)

		hParent:SetAbsOrigin(vEnd)
		hParent:SetForwardVector((vEnd - vStart):Normalized())
		if fProgress >= 1 then
			self:Destroy()
		end
	end
end

function modifier_cmd_tinker_4_missles:OnDestroy()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hAbility = self:GetAbility()
		local hParent = self:GetParent()
		UTIL_Remove(self:GetParent())
		if self.iParticleID then
			ParticleManager:DestroyParticle(self.iParticleID, false)
		end
		if IsValid(self.hTarget) then
			if IsValid(hAbility) and IsValid(hCaster) then
				if UnitFilter(self.hTarget, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, hCaster:GetTeamNumber()) == UF_SUCCESS then
					ApplyDamage({
						ability = hAbility,
						victim = self.hTarget,
						attacker = hCaster,
						damage = hCaster:GetVal(ATTRIBUTE_KIND.MagicalAttack),
						damage_type = DAMAGE_TYPE_MAGICAL
					})
					-- 额外伤害
					if hCaster:FindModifierByName('modifier_cmd_tinker_0') and self.hTarget then
						local targets = FindUnitsInRadius(hCaster:GetTeamNumber(), self.hTarget:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
						local flDamage = hCaster:GetVal(ATTRIBUTE_KIND.MagicalAttack)
						for _, hTarget in ipairs(targets) do
							local tDamage = {
								ability = hAbility,
								attacker = hCaster,
								victim = hTarget,
								damage = flDamage,
								damage_type = DAMAGE_TYPE_MAGICAL
							}
							ApplyDamage(tDamage)
						end
					end
				end
			end
		end
	end
end

function modifier_cmd_tinker_4_missles:DeclareFunctions()
	return	{
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_cmd_tinker_4_missles:OnTooltip()
	return self.missleTimes
end