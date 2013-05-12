function gadget:GetInfo()
        return {
                name                    = "linked unit exploder",
                desc                    = "if the builder of a unit dies, that unit also dies",
                author          		= "knorke",
                date                    = "Feb 2010",
                license  				= "later horses dont be mean.",
                layer            		= 0,
                enabled  = true, --      loaded by default?
        }
end

local linkedUnitNames = {}
linkedUnitNames ["hawkradar"] = {} 
linkedUnitNames ["hawkradar"]["hawkmissile"]   = true
linkedUnitNames ["hawkradar"]["nwdsa2guidelinesite"] = true
linkedUnitNames ["hawkradar"]["nwdantishipturret"] = true


linkedUnitNames ["hawkradardes"] = {}
linkedUnitNames ["hawkradardes"]["hawkmissiledes"] = true


local linkedUnits = {}
local markers = false

if (gadgetHandler:IsSyncedCode()) then

function gadget:UnitCreated(unitID, unitDefID, teamID, builderID)	
	marker_on_unit (unitID, "new unit:" .. unitname (unitID) .. " built by " .. unitname (builderID))
	buildername = unitname (builderID)
	newunitname = unitname (unitID)
	if (linkedUnitNames [buildername] and linkedUnitNames [buildername][newunitname]) then addLinkedUnit (builderID, unitID) end
end

function addLinkedUnit (parentID, newLinkID)
	--Spring.Echo ("LINKING " .. newLinkID .. "  to " .. parentID)
	if (not linkedUnits [parentID]) then	--is there already a table containing linked units for this parent unit?
		linkedUnits [parentID] = {} 		--create new empty table
		end
	table.insert (linkedUnits[parentID], newLinkID)
end

--returns a table of all units linked to parentID unit
function getLinkedUnits (parentID)
	if (linkedUnits [parentID]) then
		return linkedUnits[parentID]
	end
	return nil
end

function gadget:UnitDestroyed(unitID, unitDefID, teamID, attackerID)
	if (linkedUnits[unitID]) then
		units = getLinkedUnits (unitID)
		for _,unitID in pairs(units) do			
			if (Spring.ValidUnitID (unitID)) then
				local x,y,z=Spring.GetUnitPosition (unitID)				
				Spring.SpawnCEG("smokexl", x, y-20, z)
				Spring.SpawnCEG("smokexl", x, y+20, z) 
				Spring.SpawnCEG("smokexl", x, y, z)
				Spring.DestroyUnit (unitID, true)
				end			
		end
		linkedUnits[unitID] = nil
	end
end

function unitname (unitID)--****
	if (not unitID) then return "unitname () no unitID given" end
	local unitDefID = Spring.GetUnitDefID(unitID)
	if (unitDefID) then
		local unitDef = UnitDefs[unitDefID]
		if (unitDef) then
			return unitDef.name
		end
	end
	return "unitname(): invalid unit id"
end

function marker_on_unit (_uID, _text)
	if (markers == false) then return end
	if (_uID == nil) then return end
	if (_text == nil) then return end
	local x,y,z=Spring.GetUnitPosition (_uID)
	if (x == nil or y == nil or z == nil) then return end
	Spring.MarkerAddPoint (x,y,z, _text .. "id:" .. _uID)
end

end