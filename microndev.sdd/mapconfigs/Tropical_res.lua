--map config by Razorblade

local res = {}

local function SpawnResource  (x,y)
	newrock = {}
	newrock.x = x
	newrock.y = y
	table.insert (res, newrock)
end

local function SpawnResourceField (x,z,  number, spread)
        for i = 0, number, 1 do
                local sx = x+math.random (-spread/2,spread/2)
                local sz = z+math.random (-spread/2,spread/2)
                SpawnResource (sx,sz)
        end
end


---coordinates go in between here---


SpawnResourceField (2542 , 1656, 50 , 500)
SpawnResourceField (6725 , 1442, 50 , 500)
SpawnResourceField (6600 , 8636, 50 , 500)
SpawnResourceField (2423 , 8746, 50 , 500)


---coordinates go in between here---


return {lolfactor=95, res=res, featurehandling="remove"}