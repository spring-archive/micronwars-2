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

SpawnResourceField (4632 , 2123, 100 , 400)
SpawnResourceField (4632 , 3317, 100 , 400)   -- middle
SpawnResourceField (4632 , 3975, 100 , 400)
SpawnResourceField (4632 , 2733, 100 , 400)
SpawnResourceField (2408 , 3082, 50 , 400)
SpawnResourceField (6784 , 3082, 50 , 400)

---coordinates go in between here---


return {lolfactor=95, res=res, featurehandling="remove"}