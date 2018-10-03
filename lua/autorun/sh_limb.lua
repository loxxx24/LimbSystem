-- # Author: STEAM_0:1:29606990
-- # Version: 10.08.2018 [1.0]

Limb = Limb or {}
Limb.config = Limb.config or {}
Limb.hitgroup = Limb.hitgroup or {}
Limb.gamemode = "sandbox"

function util.Include(name)
	local server = (string.find(name, "sv_") or string.find(name, "init.lua"))
	local client = (string.find(name, "cl_") or string.find(name, "cl_init.lua"))
	local shared = (string.find(name, "sh_") or string.find(name, "shared.lua"))
	
	if (server and !SERVER) then return end
	
	if (shared and SERVER) then
		AddCSLuaFile(name)
	elseif (client and SERVER) then
		AddCSLuaFile(name)
		return
	end
	
	include(name)
end

function Limb:GetDataHigtroup()
	return self.hitgroup
end

function Limb:AddHitGroup(hitgroup, data)
	self:GetDataHigtroup()[hitgroup] = data
end

function Limb:AddCvar(name, data)
	self.config[name] = data
end

function Limb:GetCvar(name)
	if (self.config[name]) then
		return self.config[name]
	end
	return false
end

function Limb:GetGamemode()
	return self.gamemode
end

function Limb:IsNutscript()
	if (self:GetGamemode() == "nutscript") then
		return true
	end
	
	return false
end

util.Include("config/sh_hitgroup.lua")
util.Include("config/sh_cvars.lua")

local function g(a)
	return GAMEMODE.DerivedFrom == a or GAMEMODE_NAME == a or gmod.GetGamemode().Name == a
end

hook.Add("Initialize", "Limb.Initialize", function()
	if (nut or g("nutscript")) then
		Limb.gamemode = "nutscript"
	elseif (CORPS and WEPS or g("terrortown")) then
		Limb.gamemode = "ttt"
	elseif (g("darkrp")) then
		Limb.gamemode = "darkrp"
	end

	util.Include("server/sv_limb.lua")
	util.Include("server/sv_limbhooks.lua")
	util.Include("client/cl_limb.lua")

	MsgC(Color(0, 255, 100, 255), "[LIMB] Initializing...\n")
	util.Include("plugins/sh_autoload.lua")
end)