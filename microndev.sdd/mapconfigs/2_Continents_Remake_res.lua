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

SpawnResourceField (6813 , 7340, 50 , 300)
SpawnResourceField (9686 , 4221, 50 , 300)   -- middle
SpawnResourceField (3797 , 1024, 50 , 300)
SpawnResourceField (4358 , 7475, 50 , 300)
SpawnResourceField (702 , 8180, 50 , 300)
SpawnResourceField (4463 , 11027, 50 , 300)
---coordinates go in between here---


return {lolfactor=95, res=res, featurehandling="remove"}