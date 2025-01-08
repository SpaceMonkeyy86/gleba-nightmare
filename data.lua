-- Override gleba's data script with our own
APS.add_planet({
    name = "gleba",
    filename = "__roots-of-chaos__/gleba.lua",
    technology = "planet-discovery-gleba"
})

-- Add new chemistry tech for chemical plants and coal synthesis
data:extend{{
    type = "technology",
    name = "chemistry",
    icon = "__roots-of-chaos__/sprite/chemistry.png",
    icon_size = 512,
    prerequisites = {"fluid-handling"},
    effects = {
        {
            type = "unlock-recipe",
            recipe = "chemical-plant"
        },
        {
            type = "unlock-recipe",
            recipe = "coal-synthesis"
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