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
                local sx = x+math.random (-spread/2,spread/3)
                local sz = z+math.random (-spread/3,spread/5)
                SpawnResource (sx,sz)
        end
end


---coordinates go in between here---

SpawnResourceField (908 , 3519, 150 , 500)   -- middle
SpawnResourceField (4270 , 3519, 150 , 500)
SpawnResourceField (908 , 6079, 150 , 500)
SpawnResourceField (4270 , 6079, 150 , 500)




---coordinates go in between here---


return {lolfactor=95, res=res, featurehandling="remove"}