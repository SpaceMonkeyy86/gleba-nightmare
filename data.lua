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