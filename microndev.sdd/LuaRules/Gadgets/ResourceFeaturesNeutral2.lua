function gadget:GetInfo()
	return {
		name = "ResourceFeaturesNeutral2",
		desc = "Neutralizes certain Units",
		author = "Argh",             --EDIT BY [MW] Razorblade
		date = "January  6th 2012",
		license = "meh",
		layer = 1,
		enabled = true,
	}
end

if (gadgetHandler:IsSyncedCode()) then
--------------------------------------------------------------------------------
--  SYNCED
--------------------------------------------------------------------------------


---------------------------------------------------------INITIALIZE NAMES HERE
---------------------------------------------------------
---------------------------------------------------------
local DrawInLosDefs = {
   
    [UnitDefNames.bunker.id] = "bunker",
	[UnitDefNames.ioncannon.id] = "ioncannon",
	
}
---------------------------------------------------------
---------------------------------------------------------
---------------------------------------------------------
local enabled = tonumber(Spring.GetModOptions().superweapons_mode) or 0

if (enabled == 0) then 
  return false
end
---------------------------------------------------------SWITCH OUT ON FRAME 11
---------------------------------------------------------AFTER WORLD BUILDER RUNS
	function gadget:GameFrame(f)
		if (f == 0) or (f > 0) and (f < 11) then end
  		if (f == 10) then

			for _,u in ipairs(Spring.GetTeamUnits(Spring.GetGaiaTeamID())) do

---------------------------------------------------------START HANDLER
				if DrawInLosDefs[Spring.GetUnitDefID(u)] then
					Spring.SetUnitNeutral(u, true)
					Spring.SetUnitNoMinimap(u,true)
					Spring.SetUnitAlwaysVisible (u,true)
					--Spring.SetUnitNoSelect(u,true)
				end
---------------------------------------------------------END HANDLER FUNCTION
			end
		end
	if (f == 34) then gadgetHandler.RemoveGadget("ResourceFeaturesNeutral2")  end
	end
end