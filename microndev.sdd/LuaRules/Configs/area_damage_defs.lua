local array = {}

local DAMAGE_PERIOD = 2 -- how often damage is applied

local weapons = {
	ballisticm = { radius = 2000, damage = 50, duration = 3000, rangeFall = 0.6, timeFall = 0.5},
	falloutexplo = { radius = 4000, damage = 100, duration = 4000, rangeFall = 0.2, timeFall = 0.2},
}

-- radius		- defines size of sphereical area in which damage is dealt
-- damage		- maximun damage over 1 second that can be dealt to a unit
-- duration		- how long the area damage stays around for (in frames)
-- rangeFall	- the proportion of damage not dealt increases linearly with distance from 0 to rangeFall at the radius
-- timeFall		- the proportion of damage not dealt increases linearly with elapsed time from 0 to timeFall at the duration

for i=1,#WeaponDefs do
	for weapon, data in pairs(weapons) do
		if WeaponDefs[i].name == weapon then 
			data.damage = data.damage*DAMAGE_PERIOD/30
			data.timeLoss = data.damage*data.timeFall*DAMAGE_PERIOD/data.duration
			array[i] = data 
		end
	end
end

return DAMAGE_PERIOD, array