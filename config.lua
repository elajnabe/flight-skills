Config = {}

Config.Framework = "qb"   -- esx / qb / standalone

Config.Command = "skills" -- Command to open the skills menu

Config.DefaultValues = {
    icon = "fas fa-dumbbell",
    levels = {
        [1] = 0,
        [2] = 100,
        [3] = 200,
        [4] = 300,
        [5] = 400,
        [6] = 500,
        [7] = 600,
        [8] = 700,
        [9] = 800,
        [10] = 900,
    }
}

Config.Notifications = { -- enable / disable notifications
    gainXP = true,
    loseXP = true,
    levelUp = true,
    levelDown = true,
    maxLevel = false,
}

Config.AddXPAfterMax = false  -- set to true if you want to add XP after the max level

Config.LowerXpAfterMax = true -- set to true if you want to lower the XP if a player is over the max level

Config.DeleteSkills = true    -- set to true if you want to delete the skills from the database when they are deleted from Config.Skills (recommended to keep true)

Config.Skills = {
    -- ["example"] = {
    --     label = "Example",
    --     hide = false,    -- set to true if you want to hide the skill (useful for skills that are not visible to the player)
    --     degrades = {
    --          active = true, -- set to true if you want the skill to degrade over time
    --          amount = 1,
    --          chance = 100,
    -- },
    -- },
    -- ["example-full"] = {
    --     label = "Example Full",
    --     hide = false,             -- set to true if you want to hide the skill (useful for skills that are not visible to the player)
    --     degrades = {
    --     active = true, -- set to true if you want the skill to degrade over time
    --     amount = 1,
    --     chance = 100,
    -- },
    --     icon = "fas fa-dumbbell", -- optional
    --     levels = {                -- optional
    --         [1] = {
    --             label = "Beginner",
    --             value = 0,
    --         },
    --         [2] = {
    --             label = "Intermediate",
    --             value = 78,
    --         },
    --         [3] = {
    --             label = "Advanced",
    --             value = 123,
    --         },
    --         [4] = {
    --             label = "Expert",
    --             value = 200,
    --         },
    --         [5] = {
    --             label = "Master",
    --             value = 400,
    --         },
    --     }
    -- }

    ["lockpicking"] = {
        label = "Lockpicking",
        icon = "fas fa-lock",
        hide = true,
        degrades = {
            active = true,
            amount = 1,
            chance = 100,
        }
    },

    ["hacking"] = {
        label = "Hacking",
        icon = "fas fa-laptop-code",
        hide = true,
        degrades = {
            active = true,
            amount = 1,
            chance = 100,
        },
        levels = {
            [1] = {
                label = "Novice",
                value = 0,
            },
            [2] = {
                label = "Skilled",
                value = 200,
            },
            [3] = {
                label = "Master",
                value = 500,
            },
        }
    },

    ["mechanic"] = {
        label = "Mechanic",
        icon = "fas fa-tools",
        hide = false,
        degrades = {
            active = true,
            amount = 1,
            chance = 100,
        },
        levels = {
            [1] = {
                label = "Novice",
                value = 0,
            },
            [2] = {
                label = "Skilled",
                value = 200,
            },
            [3] = {
                label = "Master",
                value = 500,
            },
        }
    },

    ["repair"] = {
        label = "Repair",
        icon = "fas fa-wrench",
        hide = false,
        degrades = {
            active = true,
            amount = 1,
            chance = 100,
        },
        levels = {
            [1] = {
                label = "Novice",
                value = 0,
            },
            [2] = {
                label = "Skilled",
                value = 200,
            },
            [3] = {
                label = "Master",
                value = 500,
            },
        }
    },

    ["crafting"] = {
        label = "Crafting",
        icon = "fas fa-hammer",
        hide = false,
        degrades = {
            active = true,
            amount = 1,
            chance = 100,
        },
        levels = {
            [1] = {
                label = "Novice",
                value = 0,
            },
            [2] = {
                label = "Skilled",
                value = 200,
            },
            [3] = {
                label = "Master",
                value = 500,
            }
        }
    },

    ["cooking"] = {
        label = "Cooking",
        icon = "fas fa-utensils",
        hide = false,
        degrades = {
            active = true,
            amount = 1,
            chance = 100,
        },
        levels = {
            [1] = {
                label = "Beginner Cook",
                value = 0,
            },
            [2] = {
                label = "Amateur Chef",
                value = 150,
            },
            [3] = {
                label = "Home Cook",
                value = 350,
            },
            [4] = {
                label = "Master Chef",
                value = 600,
            },
        }
    },

    ["fishing"] = {
        label = "Fishing",
        icon = "fas fa-fish",
        hide = false,
        degrades = {
            active = true,
            amount = 1,
            chance = 100,
        },
        levels = {
            [1] = {
                label = "Recreational Fisher",
                value = 0,
            },
            [2] = {
                label = "Angling Enthusiast",
                value = 150,
            },
            [3] = {
                label = "Master Angler",
                value = 400,
            },
        }
    },

    ["mining"] = {
        label = "Mining",
        icon = "fas fa-hard-hat",
        hide = false,
        degrades = {
            active = true,
            amount = 1,
            chance = 100,
        },
        levels = {
            [1] = {
                label = "Prospector",
                value = 0,
            },
            [2] = {
                label = "Miner",
                value = 200,
            },
            [3] = {
                label = "Master Miner",
                value = 600,
            },
        }
    },

    ["driving"] = {
        label = "Driving",
        icon = "fas fa-car",
        hide = false,
        degrades = {
            active = true,
            amount = 1,
            chance = 100,
        },
        levels = {
            [1] = {
                label = "Learner Driver",
                value = 0,
            },
            [2] = {
                label = "Skilled Driver",
                value = 200,
            },
            [3] = {
                label = "Master Driver",
                value = 500,
            },
        }
    },

    ["strength"] = {
        label = "Strength",
        icon = "fas fa-dumbbell",
        hide = false,
        degrades = {
            active = true,
            amount = 1,
            chance = 100,
        },
        levels = {
            [1] = {
                label = "Novice",
                value = 0,
            },
            [2] = {
                label = "Athlete",
                value = 200,
            },
            [3] = {
                label = "Titan",
                value = 600,
            },
        }
    },

}
