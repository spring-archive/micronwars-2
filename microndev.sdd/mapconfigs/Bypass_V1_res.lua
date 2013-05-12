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

SpawnResourceField (949 , 1699, 50 , 300)
SpawnResourceField (4122 , 1699, 50 , 300)   -- middle
SpawnResourceField (7125 , 1699, 50 , 300)
SpawnResourceField (949 , 6773, 50 , 300)
SpawnResourceField (4122 , 6773, 50 , 300)
SpawnResourceField (7125 , 6773, 50 , 300)
---coordinates go in between here---


return {lolfactor=95, res=res, featurehandling="remove"}