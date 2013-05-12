-- NOT RELEASED!

-- King of the Hill for ModOptions -------------------------------------
-- Set up an empty box on Spring Lobby (other clients might crash) ------
-- Set up the time to control the box in ModOptions --------------------
--------------------------------------------------------------------

function gadget:GetInfo()
	return {
		name = "King of the Hill",
		desc = "obvious",
		author = "Alchemist",
		date = "April 2009",
		license = "Public domain",
		layer = 1,
		enabled = true
	}
end
---------------------------------------------------------------------------------

if(not Spring.GetModOptions()) then
	return false
end

--UNSYNCED-------------------------------------------------------------------
if(not gadgetHandler:IsSyncedCode()) then
	
	local teams = {}
	local colors = {}
	local teamTimers = {}
	local r, g, b = 255, 255, 255
	local vsx, vsy, pX, pY
	local x1, z1, x2, z2 = 0, 0, 0, 0
	
	function gadget:Initialize()
		if(Spring.GetModOptions().deathmode ~= "kingofthehill") then
			gadgetHandler:RemoveGadget()
		end
		gadgetHandler:AddSyncAction("changeColor", setBoxColor)
		gadgetHandler:AddSyncAction("changeTime", updateTimers)
		gadgetHandler:AddSyncAction("initialTime", setTeamTimers)
		x1, z1, x2, z2 = Spring.GetAllyTeamStartBox(getLastBox())
		vsx, vsy = gadgetHandler:GetViewSizes()
		posx, posy = vsx, vsy
		getTeamList()
		setColors()
	end
	
	function gadget:DrawWorldPreUnit()
		gl.DepthTest(false)
		gl.Color(r, g, b, 0.4)
		gl.DrawGroundQuad(x1, z1, x2, z2, true)
		gl.DepthTest(true)
	end
	
	function DrawScreen() -- test and fix
		vsx, vsy = gl.GetViewSizes()
		posx = vsx * 0.5
		for team, tTime in pairs(teamTimers) do
			posy = (vsy - (vsy * team * 0.15)) * 0.2
			gl.Color(255, 255, 255, 1)
			gl.Text("Team " .. team + 1 .. " - " .. math.floor(tTime/60) .. ":" .. math.floor(tTime%60), posx, posy, 24, "ocn")
		end
	end
	
	function updateTimers(cmd, team, newTime)
		teamTimers[team] = newTime
	end
	
	function setColors()
		for _, t in pairs(teams) do
			local r, g, b = Spring.GetTeamColor(t)
			colors[t] = {r, g, b}
		end
	end
	
	function setBoxColor(cmd, team, ...)
		if(team == -1) then
			r, g, b = ...
		else
			local cT = {}
			for i, c in pairs(colors[team]) do
				cT[i] = c
			end
			r, g, b = cT[1], cT[2], cT[3]
		end
	end
	
	function getTeamList()
		for i, t in ipairs(Spring.GetTeamList()) do
			teams[i] = t
		end
	end
	
	function setTeamTimers(cmd, iTime)
		for _, t in ipairs(Spring.GetAllyTeamList()) do
			teamTimers[t] = 0
		end
	end
	
	function getLastBox() -- Unsynced
		local n
		for _, t in ipairs(Spring.GetAllyTeamList()) do
			n = t
		end
		return n - 1
	end
	
end
---------------------------------------------------------------------------------

--SYNCED-----------------------------------------------------------------------
if(gadgetHandler:IsSyncedCode()) then

	local actualTeam = -1
	local control = -1
	local goalTime = 0
	local cTeamPresent = false
	local timers = {}
	local victory = false
	local x1, z1, x2, z2 = 0, 0, 0, 0
	
	function gadget:Initialize()
		if(Spring.GetModOptions().deathmode ~= "kingofthehill") then
			gadgetHandler:RemoveGadget()
		end
		goalTime = ((Spring.GetModOptions().mo_hilltime) or 15) * 30 * 60
		SendToUnsynced("initialTime", goalTime / 30 / 60)
		x1, z1, x2, z2 = Spring.GetAllyTeamStartBox(getLastBox())
		setTimers()
	end
	
	function gadget:GameStart()
		Spring.Echo("Goal time is " .. goalTime / 30 / 60 .. " minutes.")
	end
	
	function gadget:GameFrame(f)
		if(f % 15 == 1) then
			for _, u in ipairs(Spring.GetUnitsInRectangle(x1, z1, x2, z2)) do
				local uD = Spring.GetUnitDefID(u)
				if UnitDefs[uD] and UnitDefs[uD].isCommander then
					TeamControl(u)
				end
			end
			if(not controlPresent()) then
				if(cTeamPresent) then
					Spring.Echo("Team " .. control + 1 .. " lost control.")
					SendToUnsynced("changeColor", -1, 255, 255, 255)
				end
				control, cTeamPresent = -1, false
			end
		end
		if(control ~= -1 and controlPresent()) then
			timers[control] = timers[control] - 1
		end
		if(control ~= -1 and timers[control] % 30 == 1 and timers[control] > 0 - 30) then
			SendToUnsynced("changeTime", control, timers[control]/30)
		end
		if(control ~= -1 and timers[control] == 0) then
			Spring.Echo("Team " .. control + 1 .. " has won!")
			victory = true
		end
		if(victory and timers[control] == 0 - 30) then
			gameOver(actualTeam)
		end
	end
	
	function TeamControl(unit)
		if(control == -1) then	
			actualTeam, control, cTeamPresent = Spring.GetUnitTeam(unit), Spring.GetUnitAllyTeam(unit), true
			Spring.Echo("Team " .. control + 1 .. " is now in control.")
			SendToUnsynced("changeColor", Spring.GetUnitTeam(unit))
		end
	end
	
	function controlPresent()
		for _, u in ipairs(Spring.GetUnitsInRectangle(x1, z1, x2, z2)) do
			if(Spring.GetUnitAllyTeam(u) == control) then
				return true
			end
		end
		return false
	end
	
	function setTimers()
		for _, t in ipairs(Spring.GetAllyTeamList()) do
			timers[t] = goalTime
		end
	end
	
	function gameOver(team)
		if(isFFA()) then
			for _, u in ipairs(Spring.GetAllUnits()) do
				if(not Spring.AreTeamsAllied(Spring.GetUnitTeam(u), team)) then
					Spring.DestroyUnit(u, true)
				end
			end
		else
			for _, u in ipairs(Spring.GetAllUnits()) do
				if(not Spring.AreTeamsAllied(Spring.GetUnitTeam(u), team)) then
					Spring.DestroyUnit(u, true)
				end
			end
		end
	end
	
	function isFFA()
		for _, aT in ipairs(Spring.GetAllyTeamList()) do
			local count = 0
			for _, _ in ipairs(Spring.GetTeamList(aT)) do
				count = count + 1
			end
			if(count > 1) then
				return false
			end
		end
		return true
	end
	
	function getLastBox() -- Synced
		local n
		for _, t in ipairs(Spring.GetAllyTeamList()) do
			n = t
		end
		return n - 1
	end

end
