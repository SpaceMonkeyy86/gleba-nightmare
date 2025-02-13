-- Override gleba's data script with our own
APS.add_planet({
    name = "gleba",
    filename = "__overgrowth__/gleba.lua",
    technology = "planet-discovery-gleba"
})

-- Add new chemistry tech for chemical plants
data:extend{{
    type = "technology",
    name = "chemistry",
    icon = "__overgrowth__/sprite/chemistry.png",
    icon_size = 512,
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

-- Reorder science packs so agricultural is directly after space
data.raw["tool"]["agricultural-science-pack"].order = "g[space-science-pack]-a[agricultural-science-pack]"

-- Increase mining time for stromatolites by a lot
data.raw["simple-entity"]["iron-stromatolite"].minable.mining_time = 40
data.raw["simple-entity"]["copper-stromatolite"].minable.mining_time = 40