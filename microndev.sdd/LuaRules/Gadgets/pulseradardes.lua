function gadget:GetInfo()
  return {
    name      = "Pulse Radar desert",
    desc      = "Lets Radars pulse",
    author    = "Camo",
    date      = "2010-08-21",
    license   = "CC-BY",
    layer     = 0,
    enabled   = true
  }
end

if (not gadgetHandler:IsSyncedCode()) then
  return false
end

local pulsers={}
local sec=0
local Spring = Spring
local susr = Spring.SetUnitSensorRadius
local radarrange=4500


function gadget:GameFrame(f)
   if f%30==0 then
      sec=sec+1
      if sec==3 then
        for i,k in pairs(pulsers) do
          susr(i,"radar",0)
        end
      end
      if sec>=10 then
        for i,k in pairs(pulsers) do
          susr(i,"radar",radarrange)
        end
        sec=0
      end
   end
end

function gadget:UnitFinished(unitID,unitDefID,teamID)
  if UnitDefNames["nwdcomdes"].id==unitDefID or UnitDefNames["hawkradardes"].id==unitDefID then
    pulsers[unitID]=true
  end
end
function gadget:UnitDestroyed(unitID,unitDefID)
  if UnitDefNames["nwdcomdes"].id==unitDefID or UnitDefNames["hawkradardes"].id==unitDefID then
    pulsers[unitID]=nil
  end
end