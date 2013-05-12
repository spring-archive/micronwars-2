-- This is a GADGET

function gadget:GetInfo()
	return {
		name = "Start game",
		desc = "Announce game start",
		author = "Razorblade",
		date = "14 june 2011",
		license = "Free",
		layer = 0,
		enabled = true
	}
end




if (gadgetHandler:IsSyncedCode()) then
	--local SpringPlaySoundFile = Spring.PlaySoundFile
	
	
	
	end

	function gadget:GameFrame(n)
	local path = "Sounds/Prepare.wav"
	Spring.PlaySoundFile(path,255)
	gadgetHandler.RemoveGadget("start game")
	end

	

		
		
	
	

