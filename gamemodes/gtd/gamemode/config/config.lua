--[[
    DONT TOUCH THESE LINES
]]--

GM.Config = {}
local config = GM.Config

--[[
    Actual config starts here
]]--

-- General

config.Deviation = 0.10 -- How much certain values like time between enemy spawns and others deviate by in %, set this to 0 to disable deviation

-- Waves

config.Difficulty = "NORMAL" -- Can be: EASY, NORMAL, HARD or INSANE (unless you define your own)
config.StartTokens = 100

-- Perks

config.PerkSlots = 3
config.PerkSlotRequirements = { -- perk slots have no requirement by default
    [2] = 30,
    [3] = 60,
}