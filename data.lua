-- Override gleba's data script with our own
APS.add_planet({
    name = "gleba",
    filename = "__gleba-nightmare__/gleba.lua",
    technology = "planet-discovery-gleba"
})

-- Add new chemistry tech for chemical plants
local research_productivity = data.raw["technology"]["research-productivity"]
data:extend{{
    type = "technology",
    name = "chemistry",
    icon = research_productivity.icon,
    icon_size = research_productivity.icon_size,
    prerequisites = {"fluid-handling"},
    effects = {
        {
            type = "unlock-recipe",
            recipe = "chemical-plant"
        }
    },
    unit = {
        time = 30,
        count = 100,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1}
        }
    }
}}

-- Reorder science packs so agricultural is first
data.raw["tool"]["agricultural-science-pack"].order = "A[agricultural-science-pack]"

-- Increase mining time for stromatolites
data.raw["simple-entity"]["iron-stromatolite"].minable.mining_time = 1
data.raw["simple-entity"]["copper-stromatolite"].minable.mining_time = 1