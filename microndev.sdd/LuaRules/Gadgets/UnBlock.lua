function gadget:GetInfo()
	return {
		name = "UnBlock",
		desc = "Deletes all Gaia Units under newly-built Units' footprints",
		author = "Argh",
		date = "March 3, 2009",
		license = "(C) 2008, Wolfe Games",
		layer = 1,
		enabled = true,
	}
end

local Gaia = Spring.GetGaiaTeamID()
local sizeX = 0
local GetUnitPosition 
local unitGroupNum = {}
local infantryTable = {}

if (gadgetHandler:IsSyncedCode()) then

function gadget:Initialize()
	for ud,_ in pairs(UnitDefs) do
		if UnitDefs[ud].customParams.unit_ui_category == 'infantry' then
			table.insert(infantryTable,ud,1)
		end
	end
end

--////////////////////////////////////////////////////////////////////  SAFE DELAYED COMMANDS
local delayedCalls = {}
function DelayedCall(fun)
	delayedCalls[#delayedCalls+1] = fun 
end

function gadget:GameFrame(f)
	for i=1,#delayedCalls do
		local fun = delayedCalls[i]
		fun()
	end
	delayedCalls = {}
end
--////////////////////////////////////////////////////////////////////

function gadget:UnitCreated(u,ud,team)
	if team ~= Gaia and infantryTable[ud] == nil then
		sizeX = UnitDefs[ud].xsize
		local x, y, z = Spring.GetUnitPosition(u)
		unitGroupNum = Spring.GetUnitsInCylinder(x, z, sizeX * 6,Gaia)
		for _,me in ipairs (unitGroupNum) do
			DelayedCall(function()
				Spring.DestroyUnit(me,false,true)
			end)
		end
	end
end

end