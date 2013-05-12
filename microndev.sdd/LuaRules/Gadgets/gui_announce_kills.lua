-- This is a GADGET

function gadget:GetInfo()
	return {
		name = "Announce kills",
		desc = "Announce Leader",
		author = "Jools, zwzsg",
		date = "14 june 2011",
		license = "Free",
		layer = 0,
		enabled = true
	}
end

function friendlyName(teamID)
	if teamID == nil then return "NONE" end
	local _,_,_,notHuman,side,_,_,_ = Spring.GetTeamInfo(teamID)
	if notHuman then
		if side == "Skimmers" then return "Skimmers"
		else return side
		end
	else
		names=nil
		for _,pid in ipairs(Spring.GetPlayerList(teamID,true)) do
			names=(names and names.."," or "").."<PLAYER"..pid..">"
		end
		if names == nil then return ("Team " .. teamID) end
		return (names and names or "")
	end
end


if (gadgetHandler:IsSyncedCode()) then
-- Path to sound file and whether it should be enabled. Edit according to your wishes.
	local soundsOn = true -- change if you want to enable/disable sounds
	local snd = "sounds/takenlead.wav" --path to sound file relative to mod/map root
	
	
	local bestTeam = nil
	local bestKills = nil
	local killCounters = {}
	local function isUnitComplete(UnitID)
		local health,maxHealth,paralyzeDamage,captureProgress,buildProgress=Spring.GetUnitHealth(UnitID)
		if buildProgress and buildProgress>=1 then
			return true
		else
			return false
		end
	end

	function gadget:Initialize()
		bestKills = 0
		killCounters = {}
		for _,team in ipairs(Spring.GetTeamList()) do
			killCounters[team] = 0
		end
	end

	function gadget:UnitDestroyed(u,ud,ut,a,ad,at,TeamID)
		if ut and at and (not Spring.AreTeamsAllied(ut,at)) and isUnitComplete(u) and u and a and u~=a then
			killCounters[at]=killCounters[at]+1
			if killCounters[at]>bestKills then
				bestKills=killCounters[at]
				if at~=bestTeam then
					bestTeam=at
					if soundsOn then Spring.PlaySoundFile(snd) end
					Spring.SendMessage(friendlyName(bestTeam) .. " has taken the lead with " .. bestKills .. " kills.")
				end
			end
		end
	end

end
