function gadget:GetInfo()
	return {
		name = "trails",
		desc = "hopes to implement trails",
		author = "KDR_11k (David Becker)",  --SMALL BUGFIX BY ARGH, PLEASE CREDIT KDR_11K.
		date = "2008-02-22",
		license = "Public Domain",
		layer = 155,
		enabled = true
	}
end

if (gadgetHandler:IsSyncedCode()) then

--SYNCED

local function AddTrail(u,ud,team,piece,width,ttl,rate)
	SendToUnsynced("Add",u,ud,team,piece,width,ttl,rate)
end

local function RemoveTrail(u, ud, team, piece)
	SendToUnsynced("Remove",u,ud,team,Spring.GetUnitScriptPiece(u,piece))
end

function gadget:UnitDestroyed(u,ud,team)
	SendToUnsynced("Destroy",u)
end

function gadget:Initialize()
	gadgetHandler:RegisterGlobal("AddTrail", AddTrail)
	gadgetHandler:RegisterGlobal("RemoveTrail", RemoveTrail)
end

function gadget:GameFrame(f)
	SendToUnsynced("Frame",f)
end

else

--UNSYNCED
local trailList = {}
local abandonedTrails = {}

local lastupdate = 0

local function AddTrail(u, ud, team, piece, width, ttl, rate)
	if Spring.GetUnitIsDead(u) then
		return
	end
	local p = Spring.GetUnitScriptPiece(u, piece)
	local t = {
		width = width,
		ttl = ttl,
		rate = rate,
		R = tonumber(UnitDefs[ud].customParams.trailr) or 1,
		G = tonumber(UnitDefs[ud].customParams.trailg) or 1,
		B = tonumber(UnitDefs[ud].customParams.trailb) or 1,
		A = tonumber(UnitDefs[ud].customParams.trailalpha) or 1,
		texture = UnitDefs[ud].customParams.trailtex or "",
		phase = 1,
		maxPhase = math.ceil(ttl/rate),
	}
	if not trailList[u] then
		trailList[u]={}
	end
	trailList[u][p] = t
end

local function RemoveTrail(u, ud, team, piece)
	if not trailList[1] then return false end
	t = trailList[u][piece]
	if t then
		t.cut = t.phase
		t.x,t.y,t.z = Spring.GetUnitPosition(u)
		abandonedTrails[#abandonedTrails+1]=t
		trailList[u][piece]=nil
	end
end


--VARIABLE DECLARATIONS
local Color = gl.Color
local Vertex = gl.Vertex
local TexCoord = gl.TexCoord
local Texture = gl.Texture
local TRIANGLE_STRIP = GL.TRIANGLE_STRIP
local BeginEnd = gl.BeginEnd
local GetUnitPiecePosDir = Spring.GetUnitPiecePosDir
local GetUnitPosition = Spring.GetUnitPosition
local GetTeamInfo = Spring.GetTeamInfo
local GetLocalTeamID = Spring.GetLocalTeamID
local GetSpectatingState = Spring.GetSpectatingState
local GetPositionLosState = Spring.GetPositionLosState

local GL_LEQUAL 		= GL.LEQUAL
local GL_ONE 		= GL.ONE
local GL_SRC_ALPHA	= GL.SRC_ALPHA
local glTranslate     		= gl.Translate
local glDepthTest     		= gl.DepthTest
local glDepthMask		= gl.DepthMask
local glBlending		= gl.Blending
local glResetState		= gl.ResetState

local frame = 0

local function GameFrame(f)
	frame = f
	if lastupdate < f then
		lastupdate = f
		for u,ts in pairs(trailList) do
			for p,t in pairs(ts) do
				if f % t.rate < .1 and t.vertices then
					local width = t.width
					local phase = t.phase
					local x,y,z,dx,dy,dz = Spring.GetUnitPiecePosDir(u,p)
					vertex0 = { x + width*dx, y + width*dy, z + width *dz }
					vertex1 = { x - width*dx, y - width*dy, z - width *dz }
					t.vertices[phase * 2 - 1] = vertex0
					t.vertices[phase * 2 - 0] = vertex1
					t.phase = phase + 1
					if phase >= t.maxPhase then
						t.phase = 1
					end
				end
			end
		end
		for i,t in pairs(abandonedTrails) do
			if f % t.rate < .1 then
				t.phase = (t.phase + 1)
				if t.phase > t.maxPhase then
					t.phase = 1
				end
				if t.phase == t.cut then
					abandonedTrails[i] = nil
				end
			end
		end
	end
	update = false
end

local function DrawTrail(vertexList, phase, maxPhase, unit, piece, width, r,g,b, alpha, offset, cut)
	local current = phase
	local n = -offset
	local alphaStep = alpha / maxPhase
	while true do
		if  (cut and current == cut and phase ~= cut) then
			return
		end
		Color(r,g,b,n*alphaStep)
		n=n+1
		TexCoord(n,0)
		Vertex(vertexList[current * 2 - 1][1],vertexList[current * 2 - 1][2],vertexList[current * 2 - 1][3])
		TexCoord(n,1)
		Vertex(vertexList[current * 2 - 0][1],vertexList[current * 2 - 0][2],vertexList[current * 2 - 0][3])
		if (phase > 1 and current == phase - 1) or (phase == 1 and current == maxPhase) then
			break
		end
		current = current + 1
		if current > maxPhase then
			current = 1
		end
	end
	if cut then
		return
	end
	local x,y,z,dx,dy,dz = GetUnitPiecePosDir(unit,piece)
	if not dx then
		return
	end
	Color(r,g,b,alpha)
	TexCoord(n,0)
	Vertex( x + width*dx, y + width*dy, z + width *dz )
	TexCoord(n,1)
	Vertex( x - width*dx, y - width*dy, z - width *dz )
end

function gadget:DrawWorld()
	local f = frame
	local _,_,_,_,_,ateam = GetTeamInfo(GetLocalTeamID())
	local _,specView = GetSpectatingState()
	glDepthTest(GL_LEQUAL)
	glDepthMask(true)
	glBlending(GL_SRC_ALPHA, GL_ONE)
	for u,ts in pairs(trailList) do
		x,y,z = GetUnitPosition(u)
		for p,t in pairs(ts) do
			if specView or GetPositionLosState(x,y,z,ateam) then
				if t.vertices then
					--gl.Color(t.R,t.G,t.B,t.A)
					Texture(t.texture)
					BeginEnd(TRIANGLE_STRIP,DrawTrail,t.vertices,t.phase,t.maxPhase,u,p,t.width,t.R,t.G,t.B,t.A, (f /t.rate)%1)
				else
					local width = t.width
					local x,y,z,dx,dy,dz = Spring.GetUnitPiecePosDir(u,p)
					vertex0 = { x + width*dx, y + width*dy, z + width *dz }
					vertex1 = { x - width*dx, y - width*dy, z - width *dz }
					local v = {}
					for i = 1 , t.maxPhase do
						v[2*i-1] = vertex0
						v[2*i-0] = vertex1
					end
					trailList[u][p].vertices = v
				end
			end
		end
	end
	for i,t in pairs(abandonedTrails) do
		x,y,z=t.x,t.y,t.z
		if specView or GetPositionLosState(x,y,z,ateam) then
			if t.vertices then
				Texture(t.texture)
				BeginEnd(GL_TRIANGLE_STRIP,DrawTrail,t.vertices,t.phase,t.maxPhase,nil,nil,t.width,t.R,t.G,t.B,t.A, (f /t.rate)%1, t.cut)
			end
		end
	end
	glResetState()
end

function gadget:RecvFromSynced(name, u, ud, team, piece, width, ttl, rate)
	if name == "Add" then
		AddTrail(u,ud,tean,piece,width,ttl,rate)
	elseif name == "Remove" then
		RemoveTrail(u, ud, team, piece)
	elseif name == "Destroy" then
		if trailList[u] then
			for t,d in pairs(trailList[u]) do
				RemoveTrail(u, ud, team, t)
			end
		end
		trailList[u] = nil
	elseif name == "Frame" then
		GameFrame(u)
	end
end

end
