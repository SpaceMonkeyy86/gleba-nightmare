-- Save vanilla asteroid definitions to reset them later
-- This script is ran just before asteroids.lua from APS so this is the ideal time
VanillaPlanetAsteroids = {}
for name, planet in pairs(data.raw["planet"]) do
    VanillaPlanetAsteroids[name] = table.deepcopy(planet.asteroid_spawn_definitions)
end
VanillaConnectionAsteroids = {}
for name, connection in pairs(data.raw["space-connection"]) do
    VanillaConnectionAsteroids[name] = table.deepcopy(connection.asteroid_spawn_definitions)
end

-- Note: actual tech modifications are in data-updates.lua and not here because
-- Factorio gets confused into thinking this code is a part of APS