function gadget:GetInfo()
	return {
		name      = "Game Over",
		desc      = "GAME OVER!! (handles conditions thereof)",
		author    = "SirMaverick, Google Frog, KDR_11k, CarRepairer (unified by KingRaptor)",
		date      = "2009",
		license   = "GPL",
		layer     = 0,
		enabled   = true  --  loaded by default?
	}
end

--------------------------------------------------------------------------------
--	End game if only one allyteam with players AND units is left.
--	An allyteam is counted as dead if none of
--	its active players have units left.
--------------------------------------------------------------------------------

if (gadgetHandler:IsSyncedCode()) then

--if Spring.GetModOption("zkmode",false,nil) == nil then
--	Spring.Echo("<Game Over> Testing mode. Gadget removed.")
--	return
--end

--------------------------------------------------------------------------------
-- vars
--------------------------------------------------------------------------------
if not Spring.GetModOptions() then
	return
end

local function nullFunc() end

local spGetTeamInfo     = Spring.GetTeamInfo
local spGetTeamList     = Spring.GetTeamList
local spGetTeamUnits    = Spring.GetTeamUnits
local spDestroyUnit     = Spring.DestroyUnit
local spGetAllUnits     = Spring.GetAllUnits
local spGetAllyTeamList = Spring.GetAllyTeamList
local spGetPlayerInfo	= Spring.GetPlayerInfo
local spGetPlayerList	= Spring.GetPlayerList
local spAreTeamsAllied  = Spring.AreTeamsAllied
local spGetUnitTeam     = Spring.GetUnitTeam
local spGetUnitDefID    = Spring.GetUnitDefID
local spGetUnitIsStunned= Spring.GetUnitIsStunned
local spGetUnitHealth   = Spring.GetUnitHealth
local spGetUnitAllyTeam = Spring.GetUnitAllyTeam
local spTransferUnit	= Spring.TransferUnit

local spKillTeam = Spring.KillTeam or nullFunc
local spGameOver = Spring.GameOver or nullFunc

local gaiaTeamID = Spring.GetGaiaTeamID()
local gaiaAllyTeamID = select(6, Spring.GetTeamInfo(gaiaTeamID))

local aliveCount = {}
local destroyedAlliances = {}

local finishedUnits = {}	-- this stores a list of all units that have ever been completed, so it can distinguish between incomplete and partly reclaimed units

local destroy_type = 'destroy'
local commends = false

local nilUnitDef = {id=-1}
local function GetUnitDefIdByName(defName)
  return (UnitDefNames[defName] or nilUnitDef).id
end

local doesNotCountList = {
	[GetUnitDefIdByName("outpost")] = true,
	[GetUnitDefIdByName("skmine")] = true,
	[GetUnitDefIdByName("sksmokemine")] = true,
	[GetUnitDefIdByName("bunker")] = true,
}

-- auto detection of doesnotcount units
for name, ud in pairs(UnitDefs) do
	if (ud.customParams.dontcount) then
		doesNotCountList[ud.id] = true
	elseif (ud.isFeature) then
		doesNotCountList[ud.id] = true
	elseif (not ud.canAttack) and (not ud.speed) and (not ud.isFactory) then
		doesNotCountList[ud.id] = true
	end
end

local commsAlive = {}
for _,allianceID in ipairs(spGetAllyTeamList()) do
	commsAlive[allianceID] = {}
end

--------------------------------------------------------------------------------
-- local funcs
--------------------------------------------------------------------------------
local function CountAllianceUnits(allianceID)
	local teamlist = spGetTeamList(allianceID) or {}
	local count = 0
	for i=1,#teamlist do
		local teamID = teamlist[i]
		count = count + (aliveCount[teamID] or 0)
	end
	return count
end

local function HasNoComms(allianceID)
	for unitID in pairs(commsAlive[allianceID]) do
		return false
	end
	return true
end

function AddAllianceUnit(u, ud, teamID)
	local _, _, _, _, _, allianceID = spGetTeamInfo(teamID)
	aliveCount[teamID] = aliveCount[teamID] + 1
	--Spring.Echo("added alliance=" .. teamID, 'count='..aliveCount[allianceID])
	if UnitDefs[ud].isCommander then
		commsAlive[allianceID][u] = true
	end	
end

function RemoveAllianceUnit(u, ud, teamID)
	local _, _, _, _, _, allianceID = spGetTeamInfo(teamID)
	aliveCount[teamID] = aliveCount[teamID] - 1
	--Spring.Echo("removed alliance=" .. teamID, 'count='..aliveCount[allianceID]) 
	if UnitDefs[ud].isCommander then
		commsAlive[allianceID][u] = nil
	end	
	if (CountAllianceUnits(allianceID) <= 0) or (commends and HasNoComms(allianceID)) then
		DestroyAlliance(allianceID)
	end
end

-- used during initialization
local function CheckAllUnits()
	aliveCount = {}
	for _,teamID in ipairs(spGetTeamList()) do
		if teamID ~= gaiaTeam then
			aliveCount[teamID] = 0
		end
	end
	for _, unitID in ipairs(spGetAllUnits()) do
		 local teamID = spGetUnitTeam(unitID)
		 local unitDefID = spGetUnitDefID(unitID)
		 gadget:UnitFinished(unitID, unitDefID, teamID)
	end
end

-- if only one allyteam left, declare it the victor
local function CheckForVictory()
	local allylist = spGetAllyTeamList()
	local count = 0
	local lastAllyTeam
    for _,a in ipairs(allylist) do
		if not destroyedAlliances[a] and (a ~= gaiaAllyTeamID) then
			count = count + 1
			lastAllyTeam = a
		end
    end
	if count < 2 then
		spGameOver({lastAllyTeam})
	end
end

-- purge the alliance!
function DestroyAlliance(allianceID)
	if not destroyedAlliances[allianceID] then
		Spring.Echo("Game Over: Destroying alliance " .. allianceID)
		destroyedAlliances[allianceID] = true
		if destroy_type == 'debug' then
			Spring.Echo("Game Over: DEBUG")
			Spring.Echo("Game Over: Allyteam " .. allianceID .. " has met the game over conditions.")
			Spring.Echo("Game Over: If this is true, then please resign.")
			
		elseif destroy_type == 'destroy' then	-- kaboom
			local teamList = spGetTeamList(allianceID)
			if teamList then
				for i=1,#teamList do
					local t = teamList[i]
					local teamUnits = spGetTeamUnits(t) 
					for j=1,#teamUnits do
						local u = teamUnits[j]
						if GG.pwUnitsByID and GG.pwUnitsByID[u] then
							spTransferUnit(u, gaiaTeam, true)		-- don't blow up PW buildings
						else
							spDestroyUnit(u, true)
						end
					end
					spKillTeam(t)
				end
			end
			
		elseif destroy_type == 'losecontrol' then	-- no orders can be issued to team
			local teamList = spGetTeamList(allianceID)
			if teamList then
				for i=1,#teamList do
					spKillTeam(teamList[i])
				end
			end
		end
	end
	CheckForVictory()
end
GG.DestroyAlliance = DestroyAlliance

-- check for active players
local function ProcessLastAlly()	
    if Spring.IsCheatingEnabled() then
	  return
    end
    local allylist = spGetAllyTeamList()
    local activeAllies = 0
    local lastActive = nil
    for _,a in ipairs(allylist) do
		repeat
		if (a == gaiaAllyTeamID) then break end -- continue
		local teamlist = spGetTeamList(a)
		if (not teamlist) then break end -- continue
		local activeTeams = 0
		for i=1,#teamlist do
			local t = teamlist[i]
			-- any team without units is dead to us; so only teams who are active AND have units matter
			if (aliveCount[t] > 0) --[[or GG.waitingForComm[t] ]] then	
				local playerlist = spGetPlayerList(t, true) -- active players
				if playerlist then
					for _,p in ipairs(playerlist) do
						local _,_,spec = spGetPlayerInfo(p)
						if not spec then
							activeTeams = activeTeams + 1
						end
					end
				end
				-- count AI teams as active
				local _,_,_,isAiTeam = spGetTeamInfo(t)
				if isAiTeam then
					activeTeams = activeTeams + 1
				end
			end
		end
		if activeTeams > 0 then
			activeAllies = activeAllies + 1
			lastActive = a
		end
		until true
    end -- for

    if activeAllies < 2 then
      -- remove every unit except for last active alliance
      for _,a in ipairs(allylist) do
        if (a ~= lastActive)and(a ~= gaiaAllyTeamID) then
			DestroyAlliance(a)
        end
      end
    end
end

--------------------------------------------------------------------------------
-- callins
--------------------------------------------------------------------------------

function gadget:UnitFinished(u, ud, team)
	if (team ~= gaiaTeam)
	  and(not doesNotCountList[ud])
	then
		finishedUnits[u] = true
		AddAllianceUnit(u, ud, team)
	end
end

function gadget:UnitDestroyed(u, ud, team)
	if (team ~= gaiaTeam)
	  and(not doesNotCountList[ud])
	  and finishedUnits[u]
	then
		finishedUnits[u] = nil
		RemoveAllianceUnit(u, ud, team)
	end
end

function gadget:UnitGiven(u, ud, newTeam, oldTeam)
	--note the order of UnitGiven and UnitTaken in the event queue
	-- -> first we add the unit and _then_ remove it from the ally unit counter!
	if (newTeam ~= gaiaTeam)
	  and(not doesNotCountList[ud])
	  and(not select(3,spGetUnitIsStunned(u)))
	then
		AddAllianceUnit(u, ud, newTeam)
	end
end

function gadget:UnitTaken(u, ud, oldTeam, newTeam)
	if (oldTeam ~= gaiaTeam)
	  and(not doesNotCountList[ud])
	  and(select(5,spGetUnitHealth(u))>=1)
	then
		RemoveAllianceUnit(u, ud, oldTeam)	
	end
end

function gadget:Initialize()
	gaiaTeam = Spring.GetGaiaTeamID()
	_,_,_,_,_, gaiaAlliance = spGetTeamInfo(gaiaTeam)
	CheckAllUnits()
	destroy_type = Spring.GetModOptions() and Spring.GetModOptions().defeatmode or 'debug'
	commends = Spring.GetModOptions() and tobool(Spring.GetModOptions().commends)
    Spring.Echo("Game Over initialized")
end

function gadget:GameFrame(n)
  -- check for last ally:
  -- end condition: only 1 ally with human players, no AIs in other ones
  if n % 37 < 0.1 then
	ProcessLastAlly()
  end
end

function gadget:GameOver()
	Spring.Echo("GAME OVER!!")
end

else -- UNSYNCED

end
