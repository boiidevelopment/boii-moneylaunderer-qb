----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

Config = {}

-- Core settings you can ignore these if you have not renamed your core
Config.CoreSettings = {
    Core = 'QBCore', -- Name of your core. Default; QBCore
    CoreFolder = 'qb-core', -- Name of your core folder. Default; qb-core
    TargetName = 'qb-target', -- Name target script. Default; qb-target
    UpdateJob = 'QBCore:Client:OnJobUpdate', -- Name of event to update job
    PlayerLoad = 'QBCore:Client:OnPlayerLoaded', -- Name of player load event
}

-- Location settings
Config.MoneyWash = {
    Range = 6, -- Range check for laundering
    RequireCops = false, -- True = cops required to use wash uses RequiredCops amount
    RequiredCops = 0, -- Amount of cops required to wash money if RequireCops = true
    Chance = 10, -- Chance to alert cops when washing
    Money = {
        Percentage = 0.5, -- Return start % this is increased based on cop count; 1-3 = 0.65, 3-5 = 0.85, 7+ = 0.95
        Time = math.random(8,15), -- Time in (s) to wait for ped to wash money
        Take = {
            Marked = { 
                Use = true, -- True = will take marked bills to wash
                Item = {name = 'markedbills', label = 'Marked Bills'}
            },
            Item = {
                Use = false, -- True = will take item to wash
                Minimum = 10000, -- Minimum amount required to wash
                Item = {name = 'dirtycash', label = 'Dirty Cash'}
            }
        },
        Return = {
            Money = {
                Use = false, -- True = will return money type below
                Type = 'cash' -- Money type; 'cash', 'bank', 'crypto'
            },
            Item = {
                Use = true, -- True = will return item below
                Item = {name = 'cash', label = 'Cash'}
            }
        }
    },
    Blacklist = {
        Job = { -- Blacklisted job list; these jobs will not see a blip for wash and cannot access
            --{name = 'police'},
            {name = 'ambulance'},
        }
    },
    Services = {
        Range = 10, -- Range check to move launderer
        Job = { -- Service job list; these jobs will not see a blip for wash, cannot access and will force ped to change location
            {name = 'police'},
            {name = 'ambulance'},
        }
    },
    Ped = { -- Ped information
        {model = 'u_m_m_jewelthief', scenario = 'WORLD_HUMAN_SMOKING', label = 'Wash Money', icon = 'fa-solid fa-money-bill-wave', distance = 5.0}
    },
    Blip = {
        Wash = { 
            Use = true,
        },
    },
    Locations = {
        -- Money wash locations to cycle through, one will be chosen randomly on new ped spawn
        [1] =  {['x'] = 55.56, ['y'] = 165.78, ['z'] = 104.79, ['h'] = 240.58},
        [2] =  {['x'] = -1808.01, ['y'] = -404.5, ['z'] = 44.61, ['h'] = 279.01},
        [3] =  {['x'] = 998.56, ['y'] = -1489.6, ['z'] = 31.4, ['h'] = 6.38},
        [4] =  {['x'] = -1156.95, ['y'] = -2033.12, ['z'] = 13.16, ['h'] = 174.09},
        [5] =  {['x'] = -1543.12, ['y'] = -590.62, ['z'] = 34.87, ['h'] = 3.41}
    }
}