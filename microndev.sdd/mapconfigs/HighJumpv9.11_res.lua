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

SpawnResourceField (1970 , 2909, 8 , 500)   -- middle
SpawnResourceField (4203 , 2909, 8 , 500)
SpawnResourceField (3120 , 3764, 8 , 500)
SpawnResourceField (3033 , 6558, 8 , 500)
SpawnResourceField (1970 , 7401, 8 , 500)
SpawnResourceField (4203 , 7401, 8 , 500)



---coordinates go in between here---


return {lolfactor=95, res=res, featurehandling="remove"}