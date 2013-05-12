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

SpawnResourceField (136 , 3887, 6 , 300)
SpawnResourceField (641 , 136, 6 , 300)
SpawnResourceField (246 , 2564, 4 , 400)
SpawnResourceField (246 , 1337, 4 , 400)
SpawnResourceField (3918 , 221, 6 , 300)
SpawnResourceField (3823 , 1307, 4 , 400)
SpawnResourceField (3823 , 2658, 4 , 400)
SpawnResourceField (3303 , 3730, 6 , 300)

---coordinates go in between here---


return {lolfactor=95, res=res, featurehandling="remove"}