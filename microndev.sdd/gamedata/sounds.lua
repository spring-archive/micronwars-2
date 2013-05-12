local Sounds = {
	SoundItems = {
		--- RESERVED FOR SPRING, DON'T REMOVE
		IncomingChat = {
			file = "sounds/incoming_chat.wav",
			 rolloff = 0.1, 
			
			priority = 100, --- higher numbers = less chance of cutoff
			maxconcurrent = 1, ---how many maximum can we hear?
		},
		MultiSelect = {
			file = "sounds/multiselect.wav",
			 rolloff = 0.1, 
			maxdist = 10000,
			priority = 100, --- higher numbers = less chance of cutoff
			maxconcurrent = 1, ---how many maximum can we hear?
		},
		MapPoint = {
			file = "sounds/mappoint.wav",
			rolloff = 0.1,
			
			priority = 100, --- higher numbers = less chance of cutoff
			maxconcurrent = 1, ---how many maximum can we hear?
		},
		--- END RESERVED

	alarm = {
			file = "sounds/bunker/alarm.wav",
			preload,
			gain = 6.0,
			pitch = 1.0,
			priority = 10,
			maxconcurrent = 3,
			maxdist = 20000,
			
		},
	
	
	},
}

return Sounds