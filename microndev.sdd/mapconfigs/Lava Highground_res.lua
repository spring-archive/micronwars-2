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

SpawnResourceField (2007 , 2036, 25 , 800)   -- middle
SpawnResourceField (2969 , 3761, 6 , 300)
SpawnResourceField (1195 , 3954, 6 , 300)
SpawnResourceField (209 , 1217, 6 , 300)
SpawnResourceField (2741 , 192, 6 , 300)



---coordinates go in between here---


return {lolfactor=95, res=res, featurehandling="remove"}