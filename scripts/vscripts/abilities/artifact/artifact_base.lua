if artifact_base == nil then
	---@class artifact_base 神器基类
	artifact_base = class({
		art_name = "artifact_base",
		art_PlayerID = -1,
	})
end
----------------------------------------------------------------------------------------------------
-- 以下为外部接口
--- 获取神器名字
function artifact_base:GetName()
	return self.art_name
end
--- 获取神器玩家id 未装备时为-1
function artifact_base:GetPlayerID()
	return self.art_PlayerID
end
function artifact_base:IsArtifact()
	return true
end
function artifact_base:OnEquip()
end
function artifact_base:OnUnequip()
end
----------------------------------------------------------------------------------------------------
-- 以下为内部接口
function artifact_base:_OnEquip()
	self:OnEquip()
end
function artifact_base:_OnUnequip()
	self:OnUnequip()
end