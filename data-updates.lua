-- Revert asteroid changes from APS
for name, definitions in pairs(VanillaPlanetAsteroids) do
    data.raw["planet"][name].asteroid_spawn_definitions = definitions
end
for name, definitions in pairs(VanillaConnectionAsteroids) do
    data.raw["space-connection"][name].asteroid_spawn_definitions = definitions
end