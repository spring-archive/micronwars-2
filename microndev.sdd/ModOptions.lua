local options={

 {
	   key    = "ba_modes",
	   name   = "Game_modes",
	   desc   = "Set specific game options on or off",
	   type   = "section",
	},
{
	   key    = "StartingResources",
	   name   = "Starting Resources",
	   desc   = "Sets storage and amount of resources that players will start with",
	   type   = "section",
	},
    {
       key="ba_modes",
       name="MicronWars - Game Modes",
       desc="MicronWars - Game Modes",
       type="section",
    },
    {
       key="ba_options",
       name="Micronwars - Options",
       desc="MicronWars - Options",
       type="section",
    },
	{
    key    = 'defeatmode',
    name   = 'Defeat Mode',
    desc   = "Method of handling defeated alliances",
    type   = 'list',
    section= 'ba_options',
    def    = 'destroy',
    items = {
      { key='debug', name="Debug", desc='Does nothing.' },
      { key='destroy', name="Destroy Alliance", desc='Destroys the alliance if they are defeated"' },
      { key='losecontrol', name="Lose Control", desc='Alliance loses control of their units if they are defeated.' },

    },
  },
      {
    key    = 'commends',
    name   = 'Team Commander Ends',
    desc   = 'Causes an allyteam to lose if they have no commanders left on their team',
    type   = 'bool',
    def    = false,
    section= 'ba_options',
  },
	
	{
		key    = "mo_coop",
		name   = "Cooperative Mode",
		desc   = "Adds an extra commander for comsharing teams",
		type   = "bool",
		def    = false,
		section= "ba_modes",
    },
	{
		key    = "mo_noowner",
		name   = "FFA Mode",
		desc   = "Units with no player control are instantly removed/destroyed",
		type   = "bool",
		def    = false,
		section= "ba_modes",
    },
	
    {
		key    = "mo_preventdraw",
		name   = "Commander Ends No Draw",
		desc   = "Last Com alive is immune to comblast, D-gunning the last enemy Com with your last Com disqualifies you",
		type   = "bool",
		def    = false,
		section= "ba_options",
    },
	{
		key    = "mo_noshare",
		name   = "No Sharing To Enemies",
		desc   = "Prevents players from giving units or resources to enemies",
		type   = "bool",
		def    = true,
		section= "ba_options",
    },
	{
		key    = "outposts_mode",
		name   = "Using outposts capture ?",
		desc   = "if set on you need to capture outposts to tech up",
		type   = "bool",
		def    = false,
		section= "ba_modes",
    },
	
	{
		key    = "superweapons_mode",
		name   = "Using Superweapons?",
		desc   = "use Superweapons to win!",
		type   = "bool",
		def    = false,
		section= "ba_modes",
    },
	
	{
		key    = "mo_comgate",
		name   = "Commander Gate Effect",
		desc   = "Commanders warp in at gamestart with a shiny teleport effect",
		type   = "bool",
		def    = false,
		section= "ba_options",
    },
    {
		key    = "mo_enemywrecks",
		name   = "Show Enemy Wrecks",
		desc   = "Gives you LOS of enemy wreckage",
		type   = "bool",
		def    = true,
		section= "ba_options",
    },
	{
		key    = "mo_nowrecks",
		name   = "No Unit Wrecks",
		desc   = "Removes all unit wrecks from the game",
		type   = "bool",
		def    = false,
		section= "ba_options",
    },
	{
		key="mo_storageowner",
		name="Team Storage Owner",
		desc="What owns the starting resource storage",
		type="list",
		def="team",
		section="ba_options",
		items={
      {key="com", name="Commander", desc="Starting resource storage belongs to commander, is lost when commander dies"},
			{key="team", name="Team", desc="Starting resource storage belongs to the team, cannot be lost"},
		}
	},
	{
      key    = "startmetal",
       name   = "Starting metal",
       desc   = "Determines amount of metal and metal storage that each player will start with",
       type   = "number",
       section= "StartingResources",
       def    = 3000,
       min    = 3000,
       max    = 15000,
       step   = 1,  -- quantization is aligned to the def value
                    -- (step <= 0) means that there is no quantization
	},
	{
       key    = "startenergy",
       name   = "Starting energy",
       desc   = "Determines amount of energy and energy storage that each player will start with",
       type   = "number",
       section= "StartingResources",
       def    = 3000,
       min    = 3000,
       max    = 15000,
       step   = 1,  -- quantization is aligned to the def value
                    -- (step <= 0) means that there is no quantization
	},
	 {
      key     = "pathfinder",
      name    = "Pathfinder",
      desc    = "Switch Pathfinding System",
      type    = "list",
      def     = "normal",
      section = "ba_options",
	  items={
		  {key="normal", name="Normal", desc="Spring vanilla pathfinder"},
		  {key="qtpfs", name="QuadTree", desc="Experimental quadtree based pathfinder"},
	  },
	  },
	
 
}
	

	

return options
