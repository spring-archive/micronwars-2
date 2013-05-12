function gadget:GetInfo()
	return {
		name = "ResourceFeaturesNeutral",
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
    [UnitDefNames.outpost.id] = "outpost",
    [UnitDefNames.crystal.id] = "crystal",
	[UnitDefNames.bigcrystal.id] = "bigcrystal",
	
	
}
---------------------------------------------------------
---------------------------------------------------------
---------------------------------------------------------

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
	if (f == 34) then gadgetHandler.RemoveGadget("ResourceFeaturesNeutral")  end
	end
end