-- Aircraft - Parachute Drops

-- ParaDrop Base Class
local ParaDropClass = Weapon:New{
  areaOfEffect       = 1, -- needed?
  collideFriendly    = false,
  explosionGenerator = [[custom:nothing]],
  impulseFactor      = 0,
  manualBombSettings = true,
  model              = [[Bomb_Tiny.S3O]], -- better way?
  myGravity          = 1,
  range              = 1000,
  reloadtime         = 600,
  tolerance          = 4000,
  turret             = true,
  weaponType         = [[AircraftBomb]],
  customparams = {
	no_range_adjust    = true,
    damagetype         = [[none]],
    paratrooper        = 1,
  },
  damage = {
    default            = 0,
  },
}

-- Implementations

-- US 101st Paratrooper (USA)
local US_Paratrooper = ParaDropClass:New{
  burst              = 9,
  burstrate          = 0.3,
  name               = [[Paratroops]],
}

local US_Paratrooper2 = ParaDropClass:New{
burst		= 12,
burstrate	= 0.4,
name		= [[Paratroops]],
}
-- Partisan Supply Drop (RUS)


-- Return only the full weapons
return lowerkeys({
  US_Paratrooper = US_Paratrooper,
  US_Paratrooper2 = US_Paratrooper2,
})
