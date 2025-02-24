-- Revert asteroid changes from APS
for name, definitions in pairs(VanillaPlanetAsteroids) do
    data.raw["planet"][name].asteroid_spawn_definitions = definitions
end
for name, definitions in pairs(VanillaConnectionAsteroids) do
    data.raw["space-connection"][name].asteroid_spawn_definitions = definitions
end

-- Utility functions to make tech modifications easier
local utils = require("__any-planet-start__/utils.lua")

function utils.add_packs(name, packs)
    local ingredients = data.raw["technology"][name].unit.ingredients
    for _, pack in pairs(packs) do
        ingredients[#ingredients+1] = {pack, 1}
    end
end

function utils.add_effects(name, new_effects)
    local effects = data.raw["technology"][name].effects
    for _, effect in pairs(new_effects) do
        effects[#effects+1] = effect
    end
end

function utils.set_count(name, count)
    data.raw["technology"][name].unit.count = count
end

function utils.remove_prerequisites(name, prerequisites)
    local map = {}
    for _, prerequisite in pairs(prerequisites) do
        map[prerequisite] = true
    end
    local prereqs = data.raw["technology"][name].prerequisites
    for i = #prereqs, 1, -1 do
        if map[prereqs[i]] then
            table.remove(prereqs, i)
        end
    end
end

-- Jellynut and yumako are farmable straight away, and landfill is immediately unlockable
utils.set_prerequisites("jellynut", {})
utils.set_prerequisites("yumako", {})
utils.set_prerequisites("steam-power", {"jellynut"})
utils.set_prerequisites("electronics", {"yumako"})
utils.set_prerequisites("landfill", {})
utils.set_trigger("landfill", {
    type = "mine-entity",
    entity = "stone"
})

-- Biochambers are available before agriculture
utils.set_prerequisites("biochamber", {"electronics", "landfill"})
utils.set_trigger("biochamber", {
    type = "craft-item",
    item = "landfill"
})
utils.remove_recipes("agriculture", {"nutrients-from-spoilage"})
utils.insert_recipe("biochamber", "nutrients-from-spoilage", 2)
utils.add_prerequisites("bioflux", {"jellynut"})

-- Agricultural science unlocks bacteria cultivation and artificial soil
utils.set_prerequisites("agricultural-science-pack", {"bioflux"})
utils.set_trigger("agricultural-science-pack", {
    type = "craft-item",
    item = "bioflux",
    count = 1
})
utils.set_prerequisites("bacteria-cultivation", {"agricultural-science-pack"})
utils.set_unit("bacteria-cultivation", {
    time = 10,
    count = 30,
    ingredients = {
        {"agricultural-science-pack", 1}
    }
})
utils.set_prerequisites("artificial-soil", {"agricultural-science-pack"})
utils.set_unit("artificial-soil", {
    time = 10,
    count = 30,
    ingredients = {
        {"agricultural-science-pack", 1}
    }
})

-- Move each recipe in bioflux processing to the respective vanilla tech
utils.set_prerequisites("bioflux-processing", {"agricultural-science-pack"})
utils.set_unit("bioflux-processing", {
    time = 10,
    count = 30,
    ingredients = {
        {"agricultural-science-pack", 1}
    }
})
utils.remove_recipes("bioflux-processing", {"bioplastic", "biosulfur", "rocket-fuel-from-jelly", "biolubricant"})

utils.add_recipes("plastics", {"bioplastic"})
utils.set_prerequisites("plastics", {"chemistry", "bioflux-processing"})
utils.add_packs("plastics", {"agricultural-science-pack"})

utils.add_recipes("rocket-fuel", {"rocket-fuel-from-jelly"})
utils.add_packs("rocket-fuel", {"agricultural-science-pack"})

utils.add_recipes("sulfur-processing", {"biosulfur", "coal-synthesis"})
utils.set_prerequisites("sulfur-processing", {"chemistry", "bioflux-processing"})
utils.add_packs("sulfur-processing", {"agricultural-science-pack"})

utils.add_recipes("lubricant", {"biolubricant"})
utils.add_packs("lubricant", {"agricultural-science-pack"})

-- Agriculture requires agricultural science and steel
utils.set_prerequisites("agriculture", {"agricultural-science-pack", "steel-processing"})
utils.set_unit("agriculture", {
    time = 15,
    count = 100,
    ingredients = {
        {"agricultural-science-pack", 1},
        {"automation-science-pack", 1}
    }
})

-- Heating tower requires concrete
utils.set_prerequisites("heating-tower", {"concrete"})
utils.set_unit("heating-tower", {
    time = 30,
    count = 300,
    ingredients = {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1}
    }
})

-- Carbon fiber and its successors no longer require space science
utils.remove_packs("carbon-fiber", {"chemical-science-pack", "space-science-pack"})
utils.remove_packs("rocket-turret", {"space-science-pack"})
utils.remove_packs("stack-inserter", {"space-science-pack"})
utils.remove_packs("transport-belt-capacity-1", {"space-science-pack"})
utils.remove_packs("transport-belt-capacity-2", {"space-science-pack"})
utils.remove_packs("toolbelt-equipment", {"space-science-pack"})

-- Oil processing is now in space science so that it is available before heading to another planet
utils.remove_tech("oil-gathering", false, true)
utils.add_recipes("planet-discovery-nauvis", {"pumpjack"})
utils.add_recipes("planet-discovery-vulcanus", {"pumpjack"})
utils.remove_recipes("calcite-processing", {"simple-coal-liquefaction"})
utils.remove_recipes("advanced-oil-processing", {"advanced-oil-processing"})
utils.insert_recipe("advanced-oil-processing", "simple-coal-liquefaction", 1)
utils.insert_recipe("advanced-oil-processing", "oil-refinery", 1)
utils.add_recipes("advanced-oil-processing", {"solid-fuel-from-petroleum-gas"})
utils.set_prerequisites("advanced-oil-processing", {"advanced-asteroid-processing"})
utils.add_packs("advanced-oil-processing", {"agricultural-science-pack", "production-science-pack", "utility-science-pack", "space-science-pack"})
utils.set_count("advanced-oil-processing", 3000)
utils.remove_recipes("oil-processing", {"oil-refinery", "chemical-plant", "solid-fuel-from-petroleum-gas"})
utils.add_recipes("oil-processing", {"advanced-oil-processing"})
utils.set_prerequisites("oil-processing", {"planet-discovery-nauvis"})

-- Coal synthesis is available earlier and chemical products don't require oil
utils.remove_recipes("rocket-turret", {"coal-synthesis"})
utils.add_prerequisites("military-2", {"sulfur-processing"})
utils.set_prerequisites("rocket-fuel", {"chemical-science-pack"})
utils.set_prerequisites("lubricant", {"chemical-science-pack"})
utils.set_prerequisites("flammables", {"chemistry"})

-- Rocket silo buffs (cry about it)
utils.add_packs("rocket-silo", {"military-science-pack", "production-science-pack", "utility-science-pack"})
utils.set_prerequisites("rocket-silo", {
    "concrete",
    "advanced-material-processing-2",
    "rocket-fuel",
    "logistic-robotics",
    "rocketry",
    "automation-3",
    "effect-transmission",
    "stack-inserter"
})
utils.add_packs("logistic-system", {"production-science-pack", "utility-science-pack"})
utils.set_prerequisites("space-platform-thruster", {"advanced-oil-processing"})
utils.set_trigger("space-platform-thruster", {
    type = "craft-item",
    item = "petroleum-gas-barrel",
    count = 100
})
utils.add_packs("planet-discovery-vulcanus", {"production-science-pack", "utility-science-pack"})
utils.add_packs("planet-discovery-fulgora", {"production-science-pack", "utility-science-pack"})
utils.add_packs("planet-discovery-nauvis", {"production-science-pack", "utility-science-pack"})

-- Remove space science requirement from some techs because I'm feeling generous today
utils.remove_packs("logistic-system", {"space-science-pack"})
utils.set_prerequisites("logistic-system", {"logistic-robotics", "production-science-pack", "utility-science-pack"})
utils.remove_packs("productivity-module-2", {"space-science-pack"})
utils.set_prerequisites("productivity-module-2", {"productivity-module", "chemical-science-pack"})
utils.remove_packs("speed-module-2", {"space-science-pack"})
utils.set_prerequisites("speed-module-2", {"speed-module", "chemical-science-pack"})
utils.remove_packs("efficiency-module-2", {"space-science-pack"})
utils.set_prerequisites("efficiency-module-2", {"efficiency-module", "chemical-science-pack"})
utils.remove_packs("stronger-explosives-5", {"space-science-pack"})
utils.remove_packs("stronger-explosives-6", {"space-science-pack"})
utils.remove_packs("stronger-explosives-7", {"space-science-pack"})
utils.set_prerequisites("stronger-explosives-5", {"stronger-explosives-4"})
utils.remove_packs("physical-projectile-damage-7", {"space-science-pack"})
utils.set_prerequisites("physical-projectile-damage-7", {"physical-projectile-damage-6"})
utils.remove_packs("follower-robot-count-5", {"space-science-pack"})
utils.set_prerequisites("follower-robot-count-5", {"follower-robot-count-4", "production-science-pack"})
utils.remove_packs("worker-robots-speed-6", {"space-science-pack"})
utils.set_prerequisites("worker-robots-speed-6", {"worker-robots-speed-5"})
utils.remove_packs("laser-weapons-damage-7", {"space-science-pack"})
utils.set_prerequisites("laser-weapons-damage-7", {"laser-weapons-damage-6"})
utils.remove_packs("electric-weapons-damage-2", {"space-science-pack"})
utils.set_prerequisites("electric-weapons-damage-2", {"electric-weapons-damage-1"})

-- Many techs also require agricultural science
utils.add_packs("advanced-circuit", {"agricultural-science-pack"})
utils.add_packs("chemical-science-pack", {"agricultural-science-pack"})
utils.add_packs("battery", {"agricultural-science-pack"})
utils.add_packs("explosives", {"agricultural-science-pack"})
utils.add_packs("military-science-pack", {"agricultural-science-pack"})
utils.add_packs("bulk-inserter", {"agricultural-science-pack"})
utils.add_packs("modules", {"agricultural-science-pack"})
utils.add_packs("productivity-module", {"agricultural-science-pack"})
utils.add_packs("speed-module", {"agricultural-science-pack"})
utils.add_packs("efficiency-module", {"agricultural-science-pack"})
utils.add_packs("productivity-module-2", {"agricultural-science-pack"})
utils.add_packs("speed-module-2", {"agricultural-science-pack"})
utils.add_packs("efficiency-module-2", {"agricultural-science-pack"})
utils.add_packs("military-2", {"agricultural-science-pack"})
utils.add_packs("gate", {"agricultural-science-pack"})
utils.add_packs("flammables", {"agricultural-science-pack"})
utils.add_packs("rocketry", {"agricultural-science-pack"})
utils.add_packs("explosive-rocketry", {"agricultural-science-pack"})
utils.add_packs("energy-shield-equipment", {"agricultural-science-pack"})
utils.add_packs("defender", {"agricultural-science-pack"})
utils.add_packs("distractor", {"agricultural-science-pack"})
utils.add_packs("land-mine", {"agricultural-science-pack"})
utils.add_packs("military-3", {"agricultural-science-pack"})
utils.add_packs("laser-turret", {"agricultural-science-pack"})
utils.add_packs("discharge-defense-equipment", {"agricultural-science-pack"})
utils.add_packs("personal-laser-defense-equipment", {"agricultural-science-pack"})
utils.add_packs("tank", {"agricultural-science-pack"})
utils.add_packs("military-4", {"agricultural-science-pack"})
utils.add_packs("destroyer", {"agricultural-science-pack"})
utils.add_packs("modular-armor", {"agricultural-science-pack"})
utils.add_packs("power-armor", {"agricultural-science-pack"})
utils.add_packs("power-armor-mk2", {"agricultural-science-pack"})
utils.add_packs("solar-panel-equipment", {"agricultural-science-pack"})
utils.add_packs("belt-immunity-equipment", {"agricultural-science-pack"})
utils.add_packs("night-vision-equipment", {"agricultural-science-pack"})
utils.add_packs("exoskeleton-equipment", {"agricultural-science-pack"})
utils.add_packs("battery-equipment", {"agricultural-science-pack"})
utils.add_packs("battery-mk2-equipment", {"agricultural-science-pack"})
utils.add_packs("advanced-material-processing-2", {"agricultural-science-pack"})
utils.add_packs("advanced-combinators", {"agricultural-science-pack"})
utils.add_packs("laser", {"agricultural-science-pack"})
utils.add_packs("electric-energy-accumulators", {"agricultural-science-pack"})
utils.add_packs("electric-energy-distribution-2", {"agricultural-science-pack"})
utils.add_packs("low-density-structure", {"agricultural-science-pack"})
utils.add_packs("processing-unit", {"agricultural-science-pack"})
utils.add_packs("electric-engine", {"agricultural-science-pack"})
utils.add_packs("robotics", {"agricultural-science-pack"})
utils.add_packs("construction-robotics", {"agricultural-science-pack"})
utils.add_packs("logistic-robotics", {"agricultural-science-pack"})
utils.add_packs("production-science-pack", {"agricultural-science-pack"})
utils.add_packs("automation-3", {"agricultural-science-pack"})
utils.add_packs("effect-transmission", {"agricultural-science-pack"})
utils.add_packs("logistics-3", {"agricultural-science-pack"})
utils.add_packs("utility-science-pack", {"agricultural-science-pack"})
utils.add_packs("rocket-silo", {"agricultural-science-pack"})
utils.add_packs("logistic-system", {"agricultural-science-pack"})
utils.add_packs("planet-discovery-vulcanus", {"agricultural-science-pack"})
utils.add_packs("planet-discovery-fulgora", {"agricultural-science-pack"})
utils.add_packs("planet-discovery-nauvis", {"agricultural-science-pack"})

utils.add_packs("stronger-explosives-1", {"agricultural-science-pack"})
utils.add_packs("stronger-explosives-2", {"agricultural-science-pack"})
utils.add_packs("stronger-explosives-3", {"agricultural-science-pack"})
utils.add_packs("stronger-explosives-4", {"agricultural-science-pack"})
utils.add_packs("stronger-explosives-5", {"agricultural-science-pack"})
utils.add_packs("stronger-explosives-6", {"agricultural-science-pack"})
utils.add_packs("laser-shooting-speed-1", {"agricultural-science-pack"})
utils.add_packs("laser-shooting-speed-2", {"agricultural-science-pack"})
utils.add_packs("laser-shooting-speed-3", {"agricultural-science-pack"})
utils.add_packs("laser-shooting-speed-4", {"agricultural-science-pack"})
utils.add_packs("laser-shooting-speed-5", {"agricultural-science-pack"})
utils.add_packs("laser-shooting-speed-6", {"agricultural-science-pack"})
utils.add_packs("laser-shooting-speed-7", {"agricultural-science-pack"})
utils.add_packs("laser-weapons-damage-1", {"agricultural-science-pack"})
utils.add_packs("laser-weapons-damage-2", {"agricultural-science-pack"})
utils.add_packs("laser-weapons-damage-3", {"agricultural-science-pack"})
utils.add_packs("laser-weapons-damage-4", {"agricultural-science-pack"})
utils.add_packs("laser-weapons-damage-5", {"agricultural-science-pack"})
utils.add_packs("laser-weapons-damage-6", {"agricultural-science-pack"})
utils.add_packs("laser-weapons-damage-7", {"agricultural-science-pack"})
utils.add_packs("physical-projectile-damage-3", {"agricultural-science-pack"})
utils.add_packs("physical-projectile-damage-4", {"agricultural-science-pack"})
utils.add_packs("physical-projectile-damage-5", {"agricultural-science-pack"})
utils.add_packs("physical-projectile-damage-6", {"agricultural-science-pack"})
utils.add_packs("physical-projectile-damage-7", {"agricultural-science-pack"})
utils.add_packs("weapon-shooting-speed-3", {"agricultural-science-pack"})
utils.add_packs("weapon-shooting-speed-4", {"agricultural-science-pack"})
utils.add_packs("weapon-shooting-speed-5", {"agricultural-science-pack"})
utils.add_packs("weapon-shooting-speed-6", {"agricultural-science-pack"})
utils.add_packs("braking-force-1", {"agricultural-science-pack"})
utils.add_packs("braking-force-2", {"agricultural-science-pack"})
utils.add_packs("braking-force-3", {"agricultural-science-pack"})
utils.add_packs("braking-force-4", {"agricultural-science-pack"})
utils.add_packs("braking-force-5", {"agricultural-science-pack"})
utils.add_packs("braking-force-6", {"agricultural-science-pack"})
utils.add_packs("braking-force-7", {"agricultural-science-pack"})
utils.add_packs("follower-robot-count-1", {"agricultural-science-pack"})
utils.add_packs("follower-robot-count-2", {"agricultural-science-pack"})
utils.add_packs("follower-robot-count-3", {"agricultural-science-pack"})
utils.add_packs("follower-robot-count-4", {"agricultural-science-pack"})
utils.add_packs("follower-robot-count-5", {"agricultural-science-pack"})
utils.add_packs("inserter-capacity-bonus-3", {"agricultural-science-pack"})
utils.add_packs("inserter-capacity-bonus-4", {"agricultural-science-pack"})
utils.add_packs("inserter-capacity-bonus-5", {"agricultural-science-pack"})
utils.add_packs("inserter-capacity-bonus-6", {"agricultural-science-pack"})
utils.add_packs("inserter-capacity-bonus-7", {"agricultural-science-pack"})
utils.add_packs("mining-productivity-2", {"agricultural-science-pack"})
utils.add_packs("mining-productivity-3", {"agricultural-science-pack"})
utils.add_packs("research-speed-3", {"agricultural-science-pack"})
utils.add_packs("research-speed-4", {"agricultural-science-pack"})
utils.add_packs("research-speed-5", {"agricultural-science-pack"})
utils.add_packs("research-speed-6", {"agricultural-science-pack"})
utils.add_packs("worker-robots-speed-1", {"agricultural-science-pack"})
utils.add_packs("worker-robots-speed-2", {"agricultural-science-pack"})
utils.add_packs("worker-robots-speed-3", {"agricultural-science-pack"})
utils.add_packs("worker-robots-speed-4", {"agricultural-science-pack"})
utils.add_packs("worker-robots-speed-5", {"agricultural-science-pack"})
utils.add_packs("worker-robots-speed-6", {"agricultural-science-pack"})
utils.add_packs("worker-robots-speed-7", {"agricultural-science-pack"})
utils.add_packs("worker-robots-storage-1", {"agricultural-science-pack"})
utils.add_packs("worker-robots-storage-2", {"agricultural-science-pack"})
utils.add_packs("worker-robots-storage-3", {"agricultural-science-pack"})
utils.add_packs("electric-weapons-damage-1", {"agricultural-science-pack"})
utils.add_packs("electric-weapons-damage-2", {"agricultural-science-pack"})
utils.add_packs("electric-weapons-damage-3", {"agricultural-science-pack"})
utils.add_packs("electric-weapons-damage-4", {"agricultural-science-pack"})

-- Other expansion mods
if data.raw["technology"]["elevated-rail"] ~= nil then
    utils.add_packs("elevated-rail", {"agricultural-science-pack"})
end
if data.raw["technology"]["quality-module"] ~= nil then
    utils.add_packs("quality-module", {"agricultural-science-pack"})
    utils.add_packs("quality-module-2", {"agricultural-science-pack"})
    utils.remove_packs("quality-module-2", {"space-science-pack"})
    utils.set_prerequisites("quality-module-2", {"quality-module", "chemical-science-pack"})
    utils.remove_packs("epic-quality", {"space-science-pack"})
    utils.set_count("epic-quality", 1000)
end

-- Missing prerequisites that are normally required to reach other planets
utils.add_prerequisites("rocket-turret", {"processing-unit"})
utils.set_prerequisites("advanced-asteroid-processing", {"space-science-pack"})
utils.add_prerequisites("flamethrower", {"advanced-oil-processing"})
utils.add_packs("flamethrower", {"space-science-pack"})
utils.add_packs("refined-flammables-1", {"space-science-pack"})
utils.add_packs("refined-flammables-2", {"space-science-pack"})
utils.add_packs("refined-flammables-3", {"space-science-pack"})
utils.add_packs("refined-flammables-4", {"space-science-pack"})
utils.add_packs("refined-flammables-5", {"space-science-pack"})
utils.set_prerequisites("efficiency-module-3", {"efficiency-module-2", "space-science-pack"})

-- Trim unnecessary prerequisites for better mod support (discovery tree)
utils.remove_prerequisites("captivity", {"agricultural-science-pack", {"rocketry"}})
utils.remove_prerequisites("biolab", {"production-science-pack", "utility-science-pack"})
utils.remove_prerequisites("overgrowth-soil", {"production-science-pack", "utility-science-pack"})
utils.remove_prerequisites("health", {"agricultural-science-pack"})
utils.remove_prerequisites("plastic-bar-productivity", {"agricultural-science-pack"})
utils.remove_prerequisites("refined-flammables-7", {"agricultural-science-pack"})
utils.remove_prerequisites("rocket-fuel-productivity", {"agricultural-science-pack"})
utils.remove_prerequisites("stronger-explosives-7", {"agricultural-science-pack"})
utils.remove_prerequisites("tree-seeding", {"agricultural-science-pack"})

-- Adjust nauvis techs to be more like the other planetary techs
utils.set_trigger("uranium-mining", {
    type = "craft-item",
    item = "electric-mining-drill",
    count = 100
})
utils.set_trigger("nuclear-power", {
    type = "craft-item",
    item = "uranium-235",
    count = 1
})
utils.set_trigger("kovarex-enrichment-process", {
    type = "craft-item",
    item = "uranium-235",
    count = 40
})
utils.set_trigger("nuclear-fuel-reprocessing", {
    type = "craft-item",
    item = "depleted-uranium-fuel-cell",
    count = 5
})
utils.add_packs("uranium-ammo", {"space-science-pack"})
utils.add_packs("fission-reactor-equipment", {"space-science-pack"})
utils.set_trigger("tree-seeding", {
    type = "mine-entity",
    entity = "dry-tree"
})
utils.set_prerequisites("fish-breeding", {"planet-discovery-nauvis"})
utils.set_trigger("fish-breeding", {
    type = "mine-entity",
    entity = "fish"
})

-- Increase cost of later rocket silo prerequsities
-- Requires chemical science: 4x
-- Requires production science or utility science: 5x
-- Requires both production and utility science: 20x -> 30x
-- Rocket silo: flat 100x

local function contains(array, val)
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

for _, tech in pairs(data.raw["technology"]) do
    if tech.unit ~= nil then
        local multiplier = 1
        local production_utility_multiplier = 1
        local should_modify = true

        for _, pack in ipairs(tech.unit.ingredients) do
            if not contains(whitelisted_packs, pack[1]) then
                should_modify = false
                break
            end

            if pack[1] == "chemical-science-pack" then
                multiplier = multiplier * 4
            end
            if pack[1] == "production-science-pack" or
               pack[1] == "utility-science-pack" then
                production_utility_multiplier = production_utility_multiplier * 5
            end
        end

        if production_utility_multiplier == 25 then
            production_utility_multiplier = 7.5
        end

        multiplier = multiplier * production_utility_multiplier

        if tech.name == "rocket-silo" then
            multiplier = 100
        end

        if should_modify and multiplier ~= 1 then
            if tech.unit.count ~= nil then
                tech.unit.count = tech.unit.count * multiplier
            elseif tech.unit.count_formula ~= nil then
                tech.unit.count_formula = "(" .. tech.unit.count_formula .. ")*" .. multiplier
            end
        end
    end
end