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

SpawnResourceField (350 , 6119, 40 , 400)   -- middle
SpawnResourceField (3757 , 6142, 40 , 400)
SpawnResourceField (2037 , 5011, 40 , 400)
SpawnResourceField (2029 , 2115, 40 , 400)
SpawnResourceField (358 , 1027, 40 , 400)
SpawnResourceField (3733 , 1027, 40 , 400)



---coordinates go in between here---


return {lolfactor=95, res=res, featurehandling="remove"}