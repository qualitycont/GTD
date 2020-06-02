--[[
    DONT TOUCH THESE LINES
]]--

local config = GM.Config

--[[
    Actual config starts here
]]--

config.BaseXPNeeded = 100 -- how much XP is needed?
config.XPNeededMultipler = 1.1 -- Modifier, gets multiplied with your current level (Example: Level 34 would get 34*XPNeededMultiplier*Base excluding all other bonuses)

config.TimeBonus = 100 -- How much XP to give every x seconds
config.TimeNeededForBonus = 5 -- x seconds from ^