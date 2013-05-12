function gadget:GetInfo()
	return {
		name = "Ancient Artifacts",
		desc = "Places objects in the gameworld.",
		author = "Razorblade",
		date = "don't give a shit",
		license = "Public Domain",
		layer = 1,
		enabled = true,
	}
end

if (gadgetHandler:IsSyncedCode()) then
--------------------------------------------------------------------------------
--  SYNCED
--------------------------------------------------------------------------------
local DoNotDestroyList = {}

local DoNotSpawnNearList = {}
---------------------------------------------------------------------------------VARIABLE DECLARATIONS
local unitID
local MaxSizeX = Game.mapSizeX
local MaxSizeZ = Game.mapSizeZ

local BotY, TopY = Spring.GetGroundExtremes()
local MinX, MinZ = 0,0
local RandomNumber
local RandomFacing
local RandomHeading
local RandomX
local RandomZ
local RandomSizeX = 0
local RandomSizeZ = 0
local SizeOfUnitX = 0
local SizeOfUnitZ = 0

local CenterX
local CenterZ

local GroundHeight = 0
local GroundHeightLeftTop = 0
local GroundHeightLeftBottom = 0
local GroundHeightRightTop = 0
local GroundHeightRightBottom = 0
local MinHeight = 0
local MaxSlope = 0
local Empty
local MetalX
local MetalZ
local Type
local MetalValue
local Validation
local Validation1
local Validation2
local Validation3
local Validation4
local Validation5
local MetalCreated = 0
local PowerCreated = 0
local MaxSizeX = Game.mapSizeX
local MaxSizeZ = Game.mapSizeZ
local Type, MetalValue, MetalX, MetalZ 
local MetalTick = 0

local MetalDefs = {}
local PowerDefs = {}
local continueMe = 1

local metalID, powerID, metalUse, powerUse, RatioMetal, RatioPower = 0,0,0,0,0,0

local math_abs = math.abs
local GetGroundOrigHeight = Spring.GetGroundOrigHeight
local GetUnitsInRectangle = Spring.GetUnitsInRectangle
local GetGroundInfo = Spring.GetGroundInfo
local math_random = math.random
local CreateUnit = Spring.CreateUnit
local GetUnitDefID = Spring.GetUnitDefID
local DestroyUnit = Spring.DestroyUnit

local enabled = tonumber(Spring.GetModOptions().outposts_mode) or 0

if (enabled == 0) then 
  return false
end

function gadget:Initialize()
	for ud,_ in pairs(UnitDefs) do
		if UnitDefs[ud].customParams.do_not_destroy == 'yes' then
			table.insert(DoNotDestroyList,ud,1)
		end

		if UnitDefs[ud].customParams.do_not_spawn_near == 'yes' then
			table.insert(DoNotSpawnNearList,ud,1)
		end

		if UnitDefs[ud].customParams.ancient_metal ~= nil then
			if UnitDefs[ud].customParams.ancient_metal == 'yes' then
				table.insert(MetalDefs,ud,1)
			end
		end

		if UnitDefs[ud].customParams.ancient_power ~= nil then
			if UnitDefs[ud].customParams.ancient_power == 'yes' then
				table.insert(PowerDefs,ud,1)
			end
		end

	end
end

function gadget:GameFrame(f)
if f == 5 then
	local unitQueue = Spring.GetAllUnits()
	local unitDef

	for _,unitID in ipairs (unitQueue) do
		if MetalDefs[Spring.GetUnitDefID(unitID)] then
			continueMe = 0
			MetalCreated = MetalCreated + 1
		end
		if PowerDefs[Spring.GetUnitDefID(unitID)] then
			continueMe = 0
			PowerCreated = PowerCreated + 1
		end
	end
end

if f == 10 and continueMe == 1 then


	Spring.Echo("Map Sizes X,Y:  "..MaxSizeZ,MaxSizeX)
	MetalCreated = 0
	PowerCreated = 0
	RandomFacing = 0

	local function ValidateMe()
		
		GroundHeight = GetGroundOrigHeight(CenterX,CenterZ)
		GroundHeightLeftTop = GetGroundOrigHeight(CenterX - SizeOfUnitX,CenterZ - SizeOfUnitZ)
		GroundHeightRightTop = GetGroundOrigHeight(CenterX + SizeOfUnitX,CenterZ - SizeOfUnitZ)
		GroundHeightLeftBottom = GetGroundOrigHeight(CenterX - SizeOfUnitX,CenterZ + SizeOfUnitZ)
		GroundHeightRightBottom = GetGroundOrigHeight(CenterX + SizeOfUnitX,CenterZ + SizeOfUnitZ)

		if GroundHeight < MinHeight then Validation1 = 0 else Validation1 = 1 end

		if Validation1 == 1 then
			if
				math_abs(GroundHeightLeftTop - GroundHeight) < MaxSlope and
				math_abs(GroundHeightLeftBottom - GroundHeight) < MaxSlope and
				math_abs(GroundHeightRightTop - GroundHeight) < MaxSlope and
				math_abs(GroundHeightRightBottom - GroundHeight) < MaxSlope
			then 
				Validation2 = 1 
			else 
				Validation2 = 0 
			end
		end
		
		if Validation2 == 1 then
			Validation3 = 1
			Empty = GetUnitsInRectangle(CenterX-SizeOfUnitX*4,CenterZ-SizeOfUnitZ*4,CenterX+SizeOfUnitX*4,CenterZ+SizeOfUnitZ*4)
			if (Empty ~= nil) and (Empty[1] ~= nil) then
				for _,unitID in ipairs(Empty) do
         					if DoNotDestroyList[GetUnitDefID(unitID)] then
						Validation3 = 0
					else
						DestroyUnit(unitID,false,true)
					end
				end
			end
			if Validation3 == 1 then
				Empty = GetUnitsInRectangle(CenterX-64,CenterZ-64,CenterX+64,CenterZ+64)
				
				if (Empty ~= nil) and (Empty[1] ~= nil) then
					for _,unitID in ipairs(Empty) do
	         					if DoNotSpawnNearList[GetUnitDefID(unitID)] then
							Validation3 = 0
	         					end
					end
				end
			end
		end

		if Validation3 == 1 then
			if SizeOfUnitX + RandomSizeX >= MaxSizeX or SizeOfUnitZ + RandomSizeZ >= MaxSizeZ then 
				Validation4 = 0 
			else 
				Validation4 = 1 
			end
		end

		if Validation1 == 1 and Validation2 == 1 and Validation3 == 1 and Validation4 == 1 then 
			Validation = 1 
		else 
			Validation = 0 
		end
	end	
--------------------------------------------------------------------------------------------------------------------------END VALIDATION			
	local function FindNewSpot(MinZ,MinX)
    	RandomX = RandomX + math_random(512)
		RandomZ = RandomZ + math_random(512)
		RandomSizeX = MinX + RandomX
		RandomSizeZ = MinZ + RandomZ
		CenterX = RandomSizeX + (SizeOfUnitX / 4)
		CenterZ = RandomSizeZ + (SizeOfUnitZ / 4)
		ValidateMe()
	end	
----------------------------------------------------------------
-------------------------------------------------------------------
----------------------------------------------------------------------  START MAIN LOOPS
---------------------------------------------------------------------- Placement Solver, AncientMetal
	for MinZ = 100,MaxSizeZ,5000 do
		for MinX = 100,MaxSizeX,5000 do
			RandomFacing = math_random(0,3)

			RandomX = math_random (512)
			RandomZ = math_random (512)
			RandomSizeX = MinX + RandomX
			RandomSizeZ = MinZ + RandomZ

			MinHeight = 1
			MaxSlope = 10
			SizeOfUnitX = 5
			SizeOfUnitZ = 5
			
			CenterX = RandomSizeX + (SizeOfUnitX / 4)
			CenterZ = RandomSizeZ + (SizeOfUnitZ / 4)
			
			ValidateMe()
				
			for e = 1,6,1 do
				if Validation ~= 1 then
					FindNewSpot(MinZ,MinX)
				end
			end
				
			if Validation == 1 then
				MetalCreated = MetalCreated + 1
				CreateUnit("outpost",CenterX,0,CenterZ,RandomFacing,Spring.GetGaiaTeamID())
				
			end
		end
	end
	
	
---------------------------------------------------------------------- END Placement Solver, AncientMetal	
---------------------------------------------------------------------- Placement Solver, AncientPower	
	for MinZ = 100,MaxSizeZ,3996 do
		for MinX = 100,MaxSizeX,3996 do
			RandomFacing = math_random (0,3)
	
			RandomX = math_random (256)
			RandomZ = math_random (512)
			RandomSizeX = MinX + RandomX
			RandomSizeZ = MinZ + RandomZ

			MinHeight = 1
			MaxSlope = 5
			SizeOfUnitX = 4
			SizeOfUnitZ = 4

			CenterX = RandomSizeX + (SizeOfUnitX / 4)
			CenterZ = RandomSizeZ + (SizeOfUnitZ / 4)

			ValidateMe()
			
			for e = 1,6,1 do
				        if Validation ~= 1 then
			   		FindNewSpot(MinZ,MinX)
			   	end
			end
						
			if Validation == 1 then
				PowerCreated = PowerCreated + 1
				CreateUnit("outpost",CenterX,0,CenterZ,RandomFacing,Spring.GetGaiaTeamID())
				
			end
		end
	end
end
---------------------------------------------------------------------- END Placement Solver, AncientPower



---------------------------------------------------------------------- RATIO SET
--[[if f == 30 then
		local tempMetal = 0
		local tempHeight = 0
		for MinZ = 0,MaxSizeZ,32 do
			for MinX = 0,MaxSizeX,32 do
				tempHeight = GetGroundOrigHeight(MinX,MinZ)
				if tempHeight < 0.1 then
					tempMetal = tempMetal + 1
				end
			end
		end

	Spring.Echo("Number of water squares found:  "..tempMetal)

	if tempMetal ~= 0 then
		RatioMetal = (tempMetal * 32 * 32) / (MaxSizeX * MaxSizeZ) 
		RatioMetal = MaxSizeX * MaxSizeZ / 262144 * RatioMetal / MetalCreated

		RatioPower = (tempMetal * 32 * 32) / (MaxSizeX * MaxSizeZ) 
		RatioPower = MaxSizeX * MaxSizeZ / 262144 * RatioPower / PowerCreated
	else
		RatioMetal = ((MaxSizeX / 512) * (MaxSizeZ  / 512)) / MetalCreated
		RatioPower = ((MaxSizeX / 512) * (MaxSizeZ  / 512)) / PowerCreated
	end

	if continueMe == 1 then
		RatioMetal = RatioMetal * 5
		RatioPower = RatioPower * 5
	end
	
	for _,u in ipairs(Spring.GetTeamUnits(Spring.GetGaiaTeamID())) do
    		if MetalDefs[Spring.GetUnitDefID(u)] then
			Spring.SetUnitResourcing(u,"cum",-1)--Removed Ratio check
		end

		if PowerDefs[Spring.GetUnitDefID(u)] then
			Spring.SetUnitResourcing(u,"cue",-30)-- Removed Ratio check
		end
	end
]]--end
---------------------------------------------------------------------- END RATIO SET
---------------------------------------------------------------------- REPORTING
--[[	if f == 99 then
		Spring.Echo("Metal Created = "..MetalCreated)
		Spring.Echo("Power Created = "..PowerCreated)
		Spring.Echo("Metal Ratio Set = "..RatioMetal)
		Spring.Echo("Power Ratio Set = "..RatioPower)
]]--	end
	if f == 100 then
		
		gadgetHandler.RemoveGadget("Ancient Artifacts")
	end
---------------------------------------------------------------------- END REPORTING
end
-------------------------------------------------------------------------------------------END SYNC
end