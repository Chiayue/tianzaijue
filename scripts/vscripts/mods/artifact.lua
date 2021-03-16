if Artifact == nil then
	---@class Artifact 神器
	Artifact = {
		---各队伍神器实体放置池子
		tTeamArtEntPool = {}
	}
	Artifact = class({}, Artifact)
end

---@class Artifact 神器
local public = Artifact

function public:init(bReload)
	if not bReload then
		self.tData = {}
		self:InitArtifactData()
	end

	--获取神器实体槽位
	-- local tArtEndPool = Entities:FindAllByNameLike('artifact_')
	-- for _, hEnt in pairs(tArtEndPool) do
	-- 	local i = tonumber(string.sub(hEnt:GetName(), string.find(hEnt:GetName(), 'artifact_') + string.len('artifact_')))
	-- 	local iTeamID = hEnt:Attribute_GetIntValue('teamID', -1)
	-- 	if 0 < iTeamID then
	-- 		if not Artifact.tTeamArtEntPool[iTeamID] then Artifact.tTeamArtEntPool[iTeamID] = {} end
	-- 		Artifact.tTeamArtEntPool[iTeamID][i] = hEnt
	-- 		hEnt:SetModel('')
	-- 		--创建hitbox单位用于点击和触碰
	-- 		if IsValid(hEnt.hHitUnit) then
	-- 			hEnt.hHitUnit:ForceKill(false)
	-- 			UTIL_Remove(hEnt.hHitUnit)
	-- 		end
	-- 		local hHitUnit = CreateUnitByName("npc_hitbox", hEnt:GetAbsOrigin(), false, hEnt, hEnt, DOTA_TEAM_GOODGUYS)
	-- 		hHitUnit:SetModelScale(10)
	-- 		hHitUnit:AddNewModifier(hHitUnit, nil, 'modifier_artifact_hitbox', { slot = iTeamID * 100 + i })
	-- 		hEnt.hHitUnit = hHitUnit
	-- 	end
	-- end
end
function public:InitPlayerData(iPlayerID)
	---@type {}
	Artifact.tData[iPlayerID] = {
		tArtifacts = {}
	}
end
--- 初始化神器数据
function public:InitArtifactData()
	local tData = {}
	for name, v in pairs(KeyValues.ArtifactKv) do
		tData[name] = 1
	end
end
function public:UpdateNetTables()
	CustomNetTables:SetTableValue("artifact", "player_data", self.tData)
end

function public:Add(iPlayerID, sName)
	local hHero = PlayerData:GetHero(iPlayerID)
	if not IsValid(hHero)
	or not hHero:IsAlive()
	or sName == nil
	or hHero:HasAbility(sName)
	then
		return false
	end

	---@type artifact_base
	local hArtifact = hHero:AddAbility(sName)
	if IsValid(hArtifact)
	and hArtifact.IsArtifact
	and hArtifact:IsArtifact() then
		hArtifact.art_name = sName
		hArtifact.art_PlayerID = iPlayerID
		hArtifact:SetActivated(false)
		hArtifact:SetHidden(false)
		hArtifact:UpgradeAbility(false)
		hArtifact:_OnEquip()
		local hModifier = hHero:FindModifierByName(hArtifact:GetIntrinsicModifierName())
		if IsValid(hModifier) then
			hModifier:ForceRefresh()
		end

		local tPlayerData = self.tData[iPlayerID]
		table.insert(tPlayerData.tArtifacts, {
			name = sName,
			entindex = hArtifact:entindex()
		})

		self:UpdateNetTables()

		--添加模型到神器槽
		-- self:SetArtEnt(iPlayerID, sName, #tPlayerData.tArtifacts)
		--
		-- 立即使用
		local tKV = hArtifact:GetAbilityKeyValues()
		if 1 == tonumber(tKV.IsImmediate) then
			hArtifact:OnSpellStart()
		end

		Contract:OnPlayerAddItemOrArtifact(iPlayerID, sName)

		return true
	end
	return false
end
function public:Remove(iPlayerID, sName)
	local hHero = PlayerData:GetHero(iPlayerID)
	if not IsValid(hHero)
	or not hHero:IsAlive()
	or sName == nil
	or not hHero:HasAbility(sName) then
		return false
	end

	---@type artifact_base
	local hArtifact = hHero:FindAbilityByName(sName)
	if IsValid(hArtifact)
	and hArtifact.IsArtifact
	and hArtifact:IsArtifact() then
		local tPlayerData = self.tData[iPlayerID]
		remove(tPlayerData.tArtifacts, function(v)
			return v.name == sName and v.entindex == hArtifact:entindex()
		end)

		hArtifact:_OnUnequip()
		hHero:RemoveAbilityByHandle(hArtifact)

		self:UpdateNetTables()

		--神器槽移除模型
		-- self:DelArtEntByName(iPlayerID, sName)
		return true
	end
	return false
end

---移除全部神器
function public:RemoveAll(iPlayerID)
	local t = public:GetPlayerArtifacts(iPlayerID)
	for k, v in pairs(t) do
		self:Remove(iPlayerID, v)
	end
end

function public:GetPlayerArtifacts(iPlayerID)
	local t = {}
	for _, v in pairs(self.tData[iPlayerID].tArtifacts) do
		table.insert(t, v.name)
	end
	return t
end
---遍历玩家神器
---@param func function sName,iEntID=>{}
function public:EechArtifacts(iPlayerID, func)
	for i = #self.tData[iPlayerID].tArtifacts, 1, -1 do
		local t = self.tData[iPlayerID].tArtifacts[i]
		if func(t.name, t.entindex) then
			return
		end
	end
end

---设置神器实体
---@param iSlot number 指定槽位，不填则默认按顺序
function public:SetArtEnt(iPlayerID, sArtName, iSlot)
	local tAbltKV = KeyValues.AbilitiesKv[sArtName]
	local sModel = tAbltKV.Model
	if sModel then
		local hArtEnt
		if not iSlot then
			for _, hArtEnt2 in pairs(Artifact.tTeamArtEntPool[PlayerData:GetPlayerTeamID(iPlayerID)]) do
				if not IsValid(hArtEnt2.hThinker) then
					hArtEnt = hArtEnt2
				end
				break
			end
		else
			hArtEnt = Artifact.tTeamArtEntPool[PlayerData:GetPlayerTeamID(iPlayerID)][iSlot]
		end
		if hArtEnt then
			hArtEnt:SetModel(sModel)
			hArtEnt:SetModelScale(tAbltKV.ModelScale or 1)
			hArtEnt.vBasePos = hArtEnt.vBasePos or hArtEnt:GetAbsOrigin()
			hArtEnt:SetAbsOrigin(hArtEnt.vBasePos + Vector(0, 0, tAbltKV.ModelHight or 0))
			if tAbltKV.ModelForward then
				local tXYZ = string.split(tAbltKV.ModelForward, ' ')
				if 3 == #tXYZ then
					hArtEnt:SetForwardVector(Vector(tXYZ[1], tXYZ[2], tXYZ[3]))
				end
			end
			hArtEnt.hThinker = CreateModifierThinker(hArtEnt, nil, "modifier_float", nil, hArtEnt:GetAbsOrigin(), hArtEnt:GetTeamNumber(), false)
			local hBuff = hArtEnt.hThinker:FindModifierByName('modifier_float')
			if hBuff then
				local iPtclID = ParticleManager:CreateParticle("particles/artifact/artifact_activated.vpcf", PATTACH_ABSORIGIN, hArtEnt.hThinker)
				ParticleManager:SetParticleControl(iPtclID, 0, GetGroundPosition(hArtEnt.hThinker:GetAbsOrigin(), hArtEnt.hThinker))
				hBuff:AddParticle(iPtclID, false, false, -1, false, false)
			end
		end
	end
end

---删除神器实体
function public:DelArtEntBySlot(iPlayerID, iSlot)
	local hArtEnt = Artifact.tTeamArtEntPool[PlayerData:GetPlayerTeamID(iPlayerID)][iSlot]
	if hArtEnt then
		hArtEnt:SetModel('')
		if IsValid(hArtEnt.hThinker) then
			hArtEnt.hThinker:ForceKill(false)
			UTIL_Remove(hArtEnt.hThinker)
		end
	end
end
function public:DelArtEntByName(iPlayerID, sArtName)
	local sModel = KeyValues.AbilitiesKv[sArtName].Model
	if sModel then
		for _, hArtEnt in pairs(Artifact.tTeamArtEntPool[PlayerData:GetPlayerTeamID(iPlayerID)]) do
			if hArtEnt:GetModelName() == sModel then
				hArtEnt:SetModel('')
				if IsValid(hArtEnt.hThinker) then
					hArtEnt.hThinker:ForceKill(false)
					UTIL_Remove(hArtEnt.hThinker)
				end
			end
		end
	end
end

---获取物品名字用商品ID
function public:GetArtifactNameByGoodsID(sArtifactGoodsID)
	for k, v in pairs(KeyValues.ArtifactKv) do
		if 'table' == type(v) and v.UniqueID and tostring(v.UniqueID) == tostring(sArtifactGoodsID) then
			return k
		end
	end
end




---禁用全部神器效果（Debug测试使用）
function public:Disable(bDisable)
	DotaTD:EachPlayer(function(_, iPlayerID)
		local hHero = PlayerData:GetHero(iPlayerID)
		if not IsValid(hHero) or not hHero:IsAlive() then return end

		local t = public:GetPlayerArtifacts(iPlayerID)
		if bDisable then
			for k, sName in pairs(t) do
				---@type artifact_base
				local hArtifact = hHero:FindAbilityByName(sName)
				if IsValid(hArtifact)
				and hArtifact.IsArtifact
				and hArtifact:IsArtifact() then
					local tPlayerData = self.tData[iPlayerID]
					hArtifact:_OnUnequip()
					hHero:RemoveAbilityByHandle(hArtifact)
				end
			end
		else
			self:RemoveAll(iPlayerID)
			self.tData[iPlayerID].tArtifacts = {}
			for k, sName in pairs(t) do
				self:Add(iPlayerID, sName)
			end
		end
	end)
end

return public