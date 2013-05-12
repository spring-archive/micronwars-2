function gadget:GetInfo()
  return {
    name = "AutoCapture",
    desc = "Idle constructors capture nearby special buildings",
    author = "camo",
    date = "2011-04",
    license = "CC-BY-SA",
    layer = 0,
    enabled = true,
  }
end

RANGE=1200 -- Adjust the searchrange here.

if (gadgetHandler:IsSyncedCode()) then
local teams
local UnitsByDefs=Spring.GetTeamUnitsByDefs
local GetHealth=Spring.GetUnitHealth
local GetCommands=Spring.GetUnitCommands
local GetPosition=Spring.GetUnitPosition
local GetNearbyUnits=Spring.GetUnitsInCylinder
local GetTeamList=Spring.GetTeamList
local GetUnitAllyTeam =Spring.GetUnitAllyTeam 
local GetTeamInfo=Spring.GetTeamInfo


function gadget:Initialize()
  teams=#GetTeamList()
end

function gadget:GameFrame(n)
  local teamID=GetTeamList()[n%teams+1]
  local _,_,_,_,_,ally,_,_=GetTeamInfo(teamID)
  local units=UnitsByDefs(teamID, UnitDefNames["nwdcontruck"].id)
  for _,unitID in ipairs(units) do
    local _,_,_,_,bp=GetHealth(unitID)
    if bp==1 and GetCommands(unitID,1)[1]==nil then
      local px, py, pz = GetPosition(unitID)
      local nearbyunits=GetNearbyUnits(px,pz,RANGE)
      for _,v in ipairs(nearbyunits) do
        if GetUnitAllyTeam(v)~=ally then
          if Spring.GetUnitDefID(v)==UnitDefNames["outpost"].id or Spring.GetUnitDefID(v)==UnitDefNames["bunker"].id or Spring.GetUnitDefID(v)==UnitDefNames["ioncannon"].id then
            Spring.GiveOrderToUnit(unitID,130,{v},{})
          end
        end
      end
    end
  end
end

end