function gadget:GetInfo()
	return {
		name = "Tier Control",
		desc = "Allows certain Units to have tiers of Units they may build.",
		author = "Argh",
		date = "January 13th, 2009",
		license = "Public Domain, or the least-restrictive rights of your country of residence.",
		layer = 1,
		enabled = true,
	}
end

local tierTable = {0}

local CMD_BUY_TIER_TWO = 32700
local CMD_BUY_TIER_THREE = 32701

BuyTierTwo = {	
		id=CMD_BUY_TIER_TWO,
		type=CMDTYPE.ICON,
		name="Upgrade your buildspeed 1.5 times",
		onlyTexture=true,	
		texture="&.9x.9&bitmaps/icons/blank.tif&bitmaps/icons/BUY_TIER_TWO.png",
		tooltip="placeholder",
		action="buy tier two",
		cursor='Guard'
		}

BuyTierThree = {	
		id=CMD_BUY_TIER_THREE,
		type=CMDTYPE.ICON,
		name="Upgrade your buildspeed 2.0 times",
		onlyTexture=true,	
		texture="&.9x.9&bitmaps/icons/blank.tif&bitmaps/icons/BUY_TIER_THREE.png",
		tooltip="placeholder",
		action="buy tier three",
		cursor='Guard'
		}


if (gadgetHandler:IsSyncedCode()) then
--------------------------------------------------------------------------------
--  SYNCED
--------------------------------------------------------------------------------
function gadget:Initialize()
	-- Set up tiers, and the Units that are in each tier.
	for ud,_ in ipairs(UnitDefs) do  -- search all UnitDef entries
		if UnitDefs[ud].customParams.build_tiers ~= nil then
			if UnitDefs[ud].customParams.build_tiers == "yes" then
				Spring.Echo("Inserted unit "..UnitDefs[ud].name.." into the build-tier system")
				table.insert(tierTable,ud,0)
			end
		end
	end
end



function gadget:UnitCreated(u, ud, team)
	if tierTable[ud] ~= nil and UnitDefs[ud].customParams.tier_cost2 ~= nil then

		Spring.InsertUnitCmdDesc(u,BuyTierTwo)
		Spring.InsertUnitCmdDesc(u,BuyTierThree)

		local cmdID = Spring.FindUnitCmdDesc(u, CMD_BUY_TIER_THREE)
		Spring.EditUnitCmdDesc(u,cmdID,{disabled = true, tooltip = "You cannot upgrade to Tier Three until you've upgraded to Tier Two.",})

		cmdID = Spring.FindUnitCmdDesc(u, CMD_BUY_TIER_TWO)
		Spring.EditUnitCmdDesc(u,cmdID,{tooltip = "Upgrade this Factory to produce second lvl units .\r\nCosts "..UnitDefs[ud].customParams.tier_cost2.." Materials.\r\nHint:  this will also boost this builder's output.",})


		for i,k in ipairs (UnitDefs) do
			CommandList = Spring.FindUnitCmdDesc(u,-i)
			if CommandList ~= nil then
				if UnitDefs[i].customParams.level == "two" then
					Spring.EditUnitCmdDesc(u,CommandList,{hidden = true,})
				end
			end
		end

		for i,k in ipairs (UnitDefs) do
			CommandList = Spring.FindUnitCmdDesc(u,-i)
			if CommandList ~= nil then
				if UnitDefs[i].customParams.level == "three" then
					Spring.EditUnitCmdDesc(u,CommandList,{hidden = true,})
				end
			end
		end
	end
end

--NOTE:  THIS USES ALLOWCOMMAND, NOT COMMANDFALLBACK, UNKNOWN WHY FALLBACK DOES NOT WORK FOR A FACTORY
function gadget:AllowCommand(u, ud, team, cmd, param, opts)
	if cmd == CMD_BUY_TIER_TWO then
	if tierTable[ud] then
			local materials = Spring.GetTeamResources(team, 'metal')
			local cost = tonumber(UnitDefs[ud].customParams.tier_cost2)
			if materials >= cost then

				Spring.UseTeamResource(team,'m',cost)
				local buildSpeed = tonumber(UnitDefs[ud].buildSpeed)
				Spring.SetUnitBuildSpeed(u,buildSpeed * 1.50)
				for i,k in ipairs (UnitDefs) do
					CommandList = Spring.FindUnitCmdDesc(u,-i)
					if CommandList ~= nil then
						if UnitDefs[i].customParams.level == "two" then
							Spring.EditUnitCmdDesc(u,CommandList,{hidden = false,})
						end
					end
				end
				--Spring.InsertUnitCmdDesc(u,BuyTierThree)
				local cmdID = Spring.FindUnitCmdDesc(u, CMD_BUY_TIER_THREE)

				Spring.EditUnitCmdDesc(u,cmdID,{disabled = false, tooltip = "Upgrades this Factory to produce third lvl units.\r\nCosts "..UnitDefs[ud].customParams.tier_cost3.." Materials.\r\nHint:  this will also boost this builder's output.",})

				cmdID = Spring.FindUnitCmdDesc(u, CMD_BUY_TIER_TWO)
				Spring.EditUnitCmdDesc(u,cmdID,{disabled = true, tooltip = "You have already upgraded to Tier Two.",})
			else
				Spring.SendMessageToTeam(team,"Not enough Resources!")
			end
	end
	return false -- if we get here, don't bother
	end


	if cmd == CMD_BUY_TIER_THREE then
	if tierTable[ud] then
			local materials = Spring.GetTeamResources(team, 'metal')
			local cost = tonumber(UnitDefs[ud].customParams.tier_cost3)
			if materials >= cost then

				Spring.UseTeamResource(team,'m',cost)
				local buildSpeed = tonumber(UnitDefs[ud].buildSpeed)
				Spring.SetUnitBuildSpeed(u,buildSpeed * 2.00)
				for i,k in ipairs (UnitDefs) do
					CommandList = Spring.FindUnitCmdDesc(u,-i)
					if CommandList ~= nil then
						if UnitDefs[i].customParams.level == "three" then
							Spring.EditUnitCmdDesc(u,CommandList,{hidden = false,})
						end
					end
				end
				local cmdID = Spring.FindUnitCmdDesc(u, CMD_BUY_TIER_THREE)
				Spring.EditUnitCmdDesc(u,cmdID,{disabled = true, tooltip = "You have already upgraded to Tier Three.",})
			else
				Spring.SendMessageToTeam(team,"Not enough Resources!")
			end
	end
	return false -- if we get here, don't bother
	end

	return true-- If all else fails.
end

--------------------------------------------------------------------------------
--  END SYNCED
--------------------------------------------------------------------------------
end