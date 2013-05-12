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

SpawnResourceField (3283 , 3228, 100 , 300)
SpawnResourceField (6143 , 1867, 100 , 300)   -- middle
SpawnResourceField (7741 , 3886, 100 , 300)
SpawnResourceField (10433 , 5153, 100 , 300)
SpawnResourceField (5928 , 10550, 100 , 300)
SpawnResourceField (9561 , 8415, 100 , 300)
SpawnResourceField (2141 , 10612, 100 , 300)
SpawnResourceField (2851 , 7400, 100 , 300)
---coordinates go in between here---


return {lolfactor=95, res=res, featurehandling="remove"}