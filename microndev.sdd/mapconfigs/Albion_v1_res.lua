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

SpawnResourceField (6338 , 6204, 5 , 300)
SpawnResourceField (8375 , 6204, 5 , 300)   -- middle
SpawnResourceField (10364 , 5725, 5 , 300)
SpawnResourceField (4399 , 6938, 5 , 300)
SpawnResourceField (2572 , 7092, 5 , 300)
SpawnResourceField (1601 , 1985, 5 , 300)
SpawnResourceField (3933 , 2621, 5 , 300)
SpawnResourceField (6175 , 1688, 5 , 300)
SpawnResourceField (9809 , 1504, 5 , 300)
SpawnResourceField (8938 , 2338, 5 , 300)
---coordinates go in between here---


return {lolfactor=95, res=res, featurehandling="remove"}