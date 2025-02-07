-- Revert asteroid changes from APS
for name, definitions in pairs(VanillaPlanetAsteroids) do
    data.raw["planet"][name].asteroid_spawn_definitions = definitions
end
for name, definitions in pairs(VanillaConnectionAsteroids) do
    data.raw["space-connection"][name].asteroid_spawn_definitions = definitions
end

-- Increase cost of later rocket silo prerequsities
-- Requires chemical science: +100%
-- Requires production science: +400%
-- Requires utility science: +400%
-- Spaceship prerequisites: 20x

function contains(array, val)
    for _, elem in ipairs(array) do
        if elem == val then
            return true
        end
    end
    return false
end

local whitelisted_packs = {
    "automation-science-pack",
    "logistic-science-pack",
    "agricultural-science-pack",
    "military-science-pack",
    "chemical-science-pack",
    "production-science-pack",
    "utility-science-pack"
}

local extra_expensive_techs = {
    "rocket-silo",
    "planet-discovery-vulcanus",
    "planet-discovery-fulgora",
    "planet-discovery-nauvis",
    "planet-discovery-aquilo"
}

for _, tech in pairs(data.raw["technology"]) do
    if tech.unit ~= nil and tech.unit.count ~= nil and tech.max_level ~= "infinite" then
        local multiplier = 1
        local should_modify = true

        for _, pack in ipairs(tech.unit.ingredients) do
            if not contains(whitelisted_packs, pack[1]) then
                should_modify = false
                break
            end

            if pack[1] == "chemical-science-pack" then
                multiplier = multiplier + 1
            end
            if pack[1] == "production-science-pack" or
               pack[1] == "utility-science-pack" then
                multiplier = multiplier + 4
            end
        end

        if contains(extra_expensive_techs, tech.name) then
            should_modify = true
            multiplier = 20
        end

        if should_modify and multiplier ~= 1 then
            tech.unit.count = tech.unit.count * multiplier
        end
    end
end