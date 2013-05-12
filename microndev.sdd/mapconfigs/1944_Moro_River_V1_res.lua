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

SpawnResourceField (7062 , 3162, 50 , 600)   -- middle
SpawnResourceField (5871 , 3564, 50 , 600)
SpawnResourceField (4440 , 6182, 50 , 600)
SpawnResourceField (3252 , 7052, 50 , 600)
SpawnResourceField (8493 , 7749, 50 , 600)
SpawnResourceField (2555 , 2936, 50 , 600)


---coordinates go in between here---


return {lolfactor=95, res=res, featurehandling="remove"}