if IsClient() then return end
if AttackSystem == nil then
	---@class AttackSystem
	AttackSystem = class({})
end
---@type AttackSystem
local public = AttackSystem

ATTACK_STATE_NOT_USECASTATTACKORB = 1 -- 不触发攻击法球
ATTACK_STATE_NOT_PROCESSPROCS = 2 -- 不触发攻击特效
ATTACK_STATE_SKIPCOOLDOWN = 8 -- 无视攻击间隔
ATTACK_STATE_IGNOREINVIS = 16 -- 不触发破影一击
ATTACK_STATE_NOT_USEPROJECTILE = 32 -- 没有攻击弹道
ATTACK_STATE_FAKEATTACK = 64 -- 假攻击
ATTACK_STATE_NEVERMISS = 128 -- 攻击不会丢失
ATTACK_STATE_NO_CLEAVE = 256 -- 没有分裂攻击
ATTACK_STATE_NO_EXTENDATTACK = 512 -- 没有触发额外攻击
ATTACK_STATE_SKIPCOUNTING = 1024 -- 不减少各种攻击计数
ATTACK_STATE_CRIT = 2048 -- 暴击，暴击技能里添加，Attack里加入无效
ATTACK_STATE_NOT_CRIT = ATTACK_STATE_CRIT * 2 -- 无暴击，暴击技能里添加，Attack里加入无效

if _G.ATTACK_SYSTEM == nil then _G.ATTACK_SYSTEM = {} end

function Attack(hAttacker, hTarget, iAttackState, ExtarData)
	local self = hAttacker
	ATTACK_SYSTEM_DUMMY_MODIFIER.iAttackState = iAttackState

	local bUseCastAttackOrb = (bit.band(iAttackState, ATTACK_STATE_NOT_USECASTATTACKORB) ~= ATTACK_STATE_NOT_USECASTATTACKORB)
	local bProcessProcs = (bit.band(iAttackState, ATTACK_STATE_NOT_PROCESSPROCS) ~= ATTACK_STATE_NOT_PROCESSPROCS)
	local bSkipCooldown = (bit.band(iAttackState, ATTACK_STATE_SKIPCOOLDOWN) == ATTACK_STATE_SKIPCOOLDOWN)
	local bIgnoreInvis = (bit.band(iAttackState, ATTACK_STATE_IGNOREINVIS) == ATTACK_STATE_IGNOREINVIS)
	local bUseProjectile = (bit.band(iAttackState, ATTACK_STATE_NOT_USEPROJECTILE) ~= ATTACK_STATE_NOT_USEPROJECTILE)
	local bFakeAttack = (bit.band(iAttackState, ATTACK_STATE_FAKEATTACK) == ATTACK_STATE_FAKEATTACK)
	local bNeverMiss = (bit.band(iAttackState, ATTACK_STATE_NEVERMISS) == ATTACK_STATE_NEVERMISS)

	if not bFakeAttack and bProcessProcs and bUseCastAttackOrb then
		local params = {
			attacker = self,
			target = hTarget,
		}
		if not ExtarData then ExtarData = {} end
		ExtarData.iAttackState = iAttackState

		if self.tSourceModifierEvents and self.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACK_START] then
			local tModifiers = self.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACK_START]
			for i = #tModifiers, 1, -1 do
				local hModifier = tModifiers[i]
				if IsValid(hModifier) and hModifier.OnAttackStart_AttackSystem then
					hModifier:OnAttackStart_AttackSystem(params, ExtarData)
				end
			end
		end
		if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_ATTACK_START] then
			local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_ATTACK_START]
			for i = #tModifiers, 1, -1 do
				local hModifier = tModifiers[i]
				if IsValid(hModifier) and hModifier.OnAttackStart_AttackSystem then
					hModifier:OnAttackStart_AttackSystem(params, ExtarData)
				end
			end
		end
	end

	self:PerformAttack(hTarget, bUseCastAttackOrb, bProcessProcs, bSkipCooldown, bIgnoreInvis, bUseProjectile, bFakeAttack, bNeverMiss)
	return ATTACK_SYSTEM_DUMMY_MODIFIER.record
end
function CDOTA_BaseNPC:Attack(hTarget, iAttackState, ExtarData)
	return Attack(self, hTarget, iAttackState, ExtarData)
end

function AttackFilter(iRecord, ...)
	iRecord = EncodeAttackRecord(iRecord)
	local bool = false
	for i, iAttackState in pairs({ ... }) do
		bool = bool or (bit.band(ATTACK_SYSTEM[iRecord] or 0, iAttackState) == iAttackState)
	end
	return bool
end
function CDOTA_BaseNPC:AttackFilter(iRecord, ...)
	return AttackFilter(iRecord, ...)
end

--- 插入攻击Falgs
function AttackFlagsAdd(iRecord, iAttackState)
	iRecord = EncodeAttackRecord(iRecord)
	if ATTACK_SYSTEM[iRecord] ~= nil then
		ATTACK_SYSTEM[iRecord] = bit.bor(ATTACK_SYSTEM[iRecord], iAttackState)
	else
		ATTACK_SYSTEM_DUMMY_MODIFIER.iAttackState = iAttackState
		ATTACK_SYSTEM[iRecord] = iAttackState
	end
end
function CDOTA_BaseNPC:AttackFlagsAdd(iRecord, iAttackState)
	return AttackFlagsAdd(iRecord, iAttackState)
end

function GetAttackFlags(iRecord)
	iRecord = EncodeAttackRecord(iRecord)
	return ATTACK_SYSTEM[iRecord] or 0
end

function public:init(bReload)
	if _G.ATTACK_SYSTEM_DUMMY then
		UTIL_Remove(_G.ATTACK_SYSTEM_DUMMY)
	end
	_G.ATTACK_SYSTEM_DUMMY = CreateModifierThinker(nil, nil, "modifier_attack_system", nil, Vector(0, 0, 0), DOTA_TEAM_NOTEAM, false)
	_G.ATTACK_SYSTEM_DUMMY_MODIFIER = _G.ATTACK_SYSTEM_DUMMY:FindModifierByName('modifier_attack_system')
end

return public