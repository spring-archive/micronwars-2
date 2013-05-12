local weaponName="ssm2-missile"
local weaponDef={
name="ssm2-missile",
weaponType=[[MissileLauncher]],

Accuracy=2000,

--Physic/flight path
range=3000,
reloadtime=5,
weaponVelocity=1000,
startVelocity=200,
weaponAcceleration=100,
flightTime=15,
BurnBlow=0,
FixedLauncher=false,
dance=0,
wobble=0,
tolerance=2000,
tracks=true,
Turnrate=16000,
collideFriendly=false,
noSelfDamage=true,
----APPEARANCE
model="ssm2missile.s3o",
smokeTrail=true,
explosionGenerator="custom:MittleGrosseExplosion2",
CegTag="raketenrauch5",

----TARGETING
turret=true,
CylinderTargeting=true,
avoidFeature=false,
avoidFriendly=false,
 highTrajectory=1,
trajectoryheight=2.0,
--commandfire=true,

----DAMAGE
damage={
default=1000,

},
areaOfEffect=64,
craterMult=0,

--?FIXME***
lineOfSight=true,


--sound
--soundHit=[[kanoba/SabotHitRemake.ogg]],
soundStart=[[hawklaunch.wav]],
}

return lowerkeys ({[weaponName]=weaponDef})
