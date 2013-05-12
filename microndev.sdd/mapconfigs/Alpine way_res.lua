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

SpawnResourceField (1128 , 5699, 15 , 400)
SpawnResourceField (4262 , 2153, 15 , 400)
SpawnResourceField (797 , 1342, 15 , 400)
SpawnResourceField (7369 , 7526, 15 , 400)

---coordinates go in between here---


return {lolfactor=95, res=res, featurehandling="remove"}