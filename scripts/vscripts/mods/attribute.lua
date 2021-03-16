if Attributes == nil then
	Attributes = class({})
end

---@class Attributes
local public = Attributes

function public:init(bReload)
end

function public:Register(hUnit)
	local sHeroName = hUnit:GetUnitName()
	local tData = KeyValues.UnitsKv[sHeroName]

	hUnit:AddNewModifier(hUnit, nil, 'modifier_attribute_register', { duration = 0.5 })
	hUnit:AddNewModifier(hUnit, nil, 'modifier_attribute_getter', nil)


	--攻击类型
	local ATTRIBUTE_ATTACK_TYPE = {
		Physical = 1,
		Magical = 2,
		Both = 3,
		Pure = 4,
	}
	local typeAttack = tData and tData.AttackDamageTypeCustom or ''
	if typeAttack == 'Physical' then
		typeAttack = ATTRIBUTE_ATTACK_TYPE.Physical
	elseif typeAttack == 'Magical' then
		typeAttack = ATTRIBUTE_ATTACK_TYPE.Magical
	elseif typeAttack == 'Mix' then
		typeAttack = ATTRIBUTE_ATTACK_TYPE.Both
	end

	--基础攻击技能
	local hAtkAblt
	for i = 0, hUnit:GetAbilityCount() - 1, 1 do
		local hAbility = hUnit:GetAbilityByIndex(i)
		if hAbility then
			if hAbility._base_attack then
				hAtkAblt = hAbility
				break
			end
		end
	end
	--没有配置攻击技能，这里添加默认
	if not hAtkAblt then
		local sName = 'base_attack_' .. sHeroName
		if not KeyValues.AbilitiesKv[sName] then
			if typeAttack == '' then
				sName = 'base_attack'
			else
				sName = 'base_attack_' .. typeAttack
			end
		end
		if not hUnit:HasAbility(sName) then
			hAtkAblt = hUnit:AddAbility(sName)
			if hAtkAblt then
				hAtkAblt:SetLevel(1)
			end
		end
	end

	--注册升级
	hUnit.LevelUp = self.LevelUp

	-- hUnit:SetContextThink(DoUniqueString('setMana'), function()
	-- 	hUnit:GiveMana(10000)
	-- end, 0)
end

function public.LevelUp(hUnit, bPlayEffects, iLevels)
	if not IsValid(hUnit) then return end

	self = hUnit
	iLevels = iLevels or 1
	self:CreatureLevelUp(iLevels)

	hUnit:SetBaseManaRegen(0)
	hUnit:SetManaRegenGain(0)

	if bPlayEffects then
		local iParticleID = ParticleManager:CreateParticle("particles/generic_hero_status/hero_levelup.vpcf", PATTACH_ABSORIGIN_FOLLOW, self)
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
end

return public