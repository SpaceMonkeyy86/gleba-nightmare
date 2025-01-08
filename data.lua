-- Override gleba's data script with our own
APS.add_planet({
    name = "gleba",
    filename = "__the-art-of-glebbing__/gleba.lua",
    technology = "planet-discovery-gleba"
})

-- Save vanilla asteroid definitions to reset them later
VanillaPlanetAsteroids = {}
for name, planet in pairs(data.raw["planet"]) do
    VanillaPlanetAsteroids[name] = table.deepcopy(planet.asteroid_spawn_definitions)
end
VanillaConnectionAsteroids = {}
for name, connection in pairs(data.raw["space-connection"]) do
    VanillaConnectionAsteroids[name] = table.deepcopy(connection.asteroid_spawn_definitions)
end

-- Add new chemistry tech for chemical plants and coal synthesis
data:extend{{
    type = "technology",
    name = "chemistry",
    icon = "__the-art-of-glebbing__/sprite/chemistry.png",
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