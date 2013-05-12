function widget:GetInfo()
  return {
    name      = "Range Widget",
    desc      = "Shows your units' weapon ranges, when selected.",
    author    = "Argh",
    date      = "January 21, 2009",
    license   = "Public Domain, or the least-restrictive rights of your country of residence",
    layer     = 0,
    enabled   = true -- loaded by default?
  }
end

local RangeList = {}
local unitIDList
local id
local unitID
local Team = Spring.GetLocalTeamID()
local myRange = 0

local GetUnitDefID = Spring.GetUnitDefID
local glColor = gl.Color
local glDrawGroundCircle = gl.DrawGroundCircle
local glLineWidth = gl.LineWidth
local GetUnitPosition = Spring.GetUnitPosition
local GetUnitTeam = Spring.GetUnitTeam
local GetSelectedUnits = Spring.GetSelectedUnits
local GetUnitWeaponState = Spring.GetUnitWeaponState

function widget:Initialize()
	for ud,_ in pairs(UnitDefs) do
		if UnitDefs[ud].customParams.show_range_one == 'yes' then
			table.insert(RangeList,ud,{range_one = 0, colorR_one = tonumber(UnitDefs[ud].customParams.color_r_one), colorG_one = tonumber(UnitDefs[ud].customParams.color_g_one), colorB_one = tonumber(UnitDefs[ud].customParams.color_b_one)})
		end
		if UnitDefs[ud].customParams.show_range_two == 'yes' then
			table.insert(RangeList,ud,{range_two = 0, colorR_two = tonumber(UnitDefs[ud].customParams.color_r_two), colorG_two = tonumber(UnitDefs[ud].customParams.color_g_two), colorB_two = tonumber(UnitDefs[ud].customParams.color_b_two)})
		end
		if UnitDefs[ud].customParams.show_range_three == 'yes' then
			table.insert(RangeList,ud,{range_three = 0, colorR_three = tonumber(UnitDefs[ud].customParams.color_r_three), colorG_three = tonumber(UnitDefs[ud].customParams.color_g_three), colorB_three = tonumber(UnitDefs[ud].customParams.color_b_three)})
		end
	end
end

local stipple = (65520)
local startTime = Spring.GetTimer()
local glLineStipple = gl.LineStipple
local floor = math.floor
local DiffTimers = Spring.DiffTimers
local GetTimer = Spring.GetTimer

function widget:DrawWorldPreUnit()
	unitIDList = GetSelectedUnits()
	if unitIDList[1] ~= nil then

		local myTime = DiffTimers(GetTimer(), startTime)
		local timeShift = floor(myTime * 16 % 32)
		glLineStipple(1,stipple,-timeShift)

		for _,unitID in ipairs(unitIDList) do
			if Team == GetUnitTeam(unitID) then
				id = GetUnitDefID(unitID)
				if RangeList[id] then					
					x,y,z = GetUnitPosition(unitID)
					glLineWidth(2.5)
					if RangeList[id].range_one ~= nil then
						myRange = GetUnitWeaponState(unitID, 0, "range") 
						glColor(RangeList[id].colorR_one,RangeList[id].colorG_one,RangeList[id].colorB_one,0.35)
						glDrawGroundCircle(x,y,z,myRange,128)
					end
					if RangeList[id].range_two ~= nil then
						myRange = GetUnitWeaponState(unitID, 1, "range") 
						glColor(RangeList[id].colorR_two,RangeList[id].colorG_two,RangeList[id].colorB_two,0.35)
						glDrawGroundCircle(x,y,z,myRange,128)
					end
					if RangeList[id].range_three ~= nil then
						myRange = GetUnitWeaponState(unitID, 2, "range") 
						glColor(RangeList[id].colorR_three,RangeList[id].colorG_three,RangeList[id].colorB_three,0.35)
						glDrawGroundCircle(x,y,z,myRange,128)
					end
				end
			end
		end
		
		glLineStipple(false)
	
	end
end