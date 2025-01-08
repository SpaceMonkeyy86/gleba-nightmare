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

-- Agriculture requires landfill and steel
utils.remove_packs("landfill", {"logistic-science-pack"})
utils.set_prerequisites("landfill", {"automation-science-pack"})
utils.set_prerequisites("agriculture", {"automation-science-pack", "steel-processing", "landfill"})

-- Heating tower requires concrete and steel
utils.set_prerequisites("heating-tower", {"concrete", "steel-processing"})

-- Agricultural science unlocks bacteria cultivation and artificial soil
utils.set_prerequisites("agricultural-science-pack", {"bioflux"})
utils.set_prerequisites("bacteria-cultivation", {"agricultural-science-pack"})
utils.set_prerequisites("artificial-soil", {"agricultural-science-pack"})

-- Bioflux processing is removed and each recipe is moved into the respective vanilla tech
utils.remove_tech("bioflux-processing", false, true)

utils.add_recipes("plastics", {"bioplastic"})
utils.set_prerequisites("plastics", {"chemistry", "agricultural-science-pack"})
utils.add_packs("plastics", {"agricultural-science-pack"})

utils.add_recipes("rocket-fuel", {"rocket-fuel-from-jelly"})
utils.add_packs("rocket-fuel", {"agricultural-science-pack"})

utils.add_recipes("sulfur-processing", {"biosulfur", "coal-synthesis"})
utils.set_prerequisites("sulfur-processing", {"chemistry", "agricultural-science-pack"})
utils.add_packs("sulfur-processing", {"agricultural-science-pack"})

utils.add_recipes("lubricant", {"biolubricant"})
utils.add_packs("lubricant", {"agricultural-science-pack"})

-- Carbon fiber and its successors no longer require space science
utils.remove_packs("carbon-fiber", {"chemical-science-pack", "space-science-pack"})
utils.remove_packs("rocket-turret", {"space-science-pack"})
utils.remove_packs("spidertron", {"space-science-pack"})
utils.remove_packs("stack-inserter", {"space-science-pack"})
utils.remove_packs("transport-belt-capacity-1", {"space-science-pack"})
utils.remove_packs("transport-belt-capacity-2", {"space-science-pack"})
utils.remove_packs("toolbelt-equipment", {"space-science-pack"})

-- Oil processing is moved to space science so that it is available before heading to another planet
utils.add_prerequisites("oil-gathering", {"space-science-pack"})
utils.add_packs("oil-gathering", {"space-science-pack"})
utils.remove_recipes("oil-processing", {"chemical-plant"})
utils.set_unit("oil-processing", {
    time = 30,
    count = 50,
    ingredients = {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
        {"space-science-pack", 1}
    }
})
utils.set_prerequisites("advanced-oil-processing", {"oil-processing"})
utils.add_packs("advanced-oil-processing", {"space-science-pack"})

-- Coal synthesis is available earlier and chemical products don't require oil
utils.remove_recipes("rocket-turret", {"coal-synthesis"})
utils.add_prerequisites("military-2", {"sulfur-processing"})
utils.set_prerequisites("rocket-fuel", {"chemical-science-pack"})
utils.set_prerequisites("lubricant", {"chemical-science-pack"})
utils.set_prerequisites("flammables", {"chemistry"})

-- Rocket silo buffs (cry about it)
utils.add_packs("rocket-silo", {"production-science-pack", "utility-science-pack"})
utils.add_packs("logistic-system", {"production-science-pack", "utility-science-pack"})
utils.add_packs("space-platform-thruster", {"production-science-pack", "utility-science-pack"})
utils.add_packs("planet-discovery-vulcanus", {"production-science-pack", "utility-science-pack"})
utils.add_packs("planet-discovery-fulgora", {"production-science-pack", "utility-science-pack"})
utils.add_packs("planet-discovery-nauvis", {"production-science-pack", "utility-science-pack"})
utils.set_prerequisites("rocket-silo", {
    "concrete",
    "advanced-material-processing-2",
    "rocket-fuel",
    "logistic-robotics",
    "rocketry",
    "automation-3",
    "logistics-3",
    "effect-transmission",
    "military-4",
    "advanced-combinators",
    "electric-energy-distribution-2",
    "stack-inserter"
})

-- Some techs require utility science, making it more useful
utils.add_packs("advanced-combinators", {"utility-science-pack"})
utils.set_prerequisites("advanced-combinators", {"circuit-network", "utility-science-pack"})
utils.add_packs("electric-energy-distribution-2", {"utility-science-pack"})
utils.set_prerequisites("electric-energy-distribution-2", {"electric-energy-distribution-1", "utility-science-pack"})

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
utils.add_packs("quality-module", {"agricultural-science-pack"})
utils.add_packs("productivity-module-2", {"agricultural-science-pack"})
utils.add_packs("speed-module-2", {"agricultural-science-pack"})
utils.add_packs("efficiency-module-2", {"agricultural-science-pack"})
utils.add_packs("quality-module-2", {"agricultural-science-pack"})
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
utils.add_packs("elevated-rail", {"agricultural-science-pack"})
utils.add_packs("logistics-3", {"agricultural-science-pack"})
utils.add_packs("utility-science-pack", {"agricultural-science-pack"})
utils.add_packs("rocket-silo", {"agricultural-science-pack"})
utils.add_packs("logistic-system", {"agricultural-science-pack"})
utils.add_packs("space-platform-thruster", {"agricultural-science-pack"})
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

-- Missing prerequisites that are normally required to reach other planets
utils.add_prerequisites("rocket-turret", {"processing-unit"})
utils.set_prerequisites("advanced-asteroid-processing", {"space-science-pack"})
utils.add_prerequisites("calcite-processing", {"advanced-oil-processing"})
utils.add_prerequisites("flamethrower", {"oil-gathering"})

-- Trigger techs are replaced with science pack requirements so the early game isn't trivial
utils.set_unit("agriculture", {
    time = 30,
    count = 100,
    ingredients = {
        {"automation-science-pack", 1}
    }
})
utils.set_unit("heating-tower", {
    time = 30,
    count = 500,
    ingredients = {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1}
    }
})
utils.set_unit("biochamber", {
    time = 30,
    count = 150,
    ingredients = {
        {"automation-science-pack", 1}
    }
})
utils.set_unit("bioflux", {
    time = 30,
    count = 150,
    ingredients = {
        {"automation-science-pack", 1}
    }
})
utils.set_unit("agricultural-science-pack", {
    time = 30,
    count = 100,
    ingredients = {
        {"automation-science-pack", 1}
    }
})
utils.set_unit("bacteria-cultivation", {
    time = 30,
    count = 500,
    ingredients = {
        {"automation-science-pack", 1},
        {"agricultural-science-pack", 1}
    }
})
utils.set_unit("artificial-soil", {
    time = 30,
    count = 300,
    ingredients = {
        {"automation-science-pack", 1},
        {"agricultural-science-pack", 1}
    }
})

-- Adjust nauvis techs to be more like the other planetary techs
utils.remove_tech("uranium-mining", false, true)
utils.add_effects("planet-discovery-nauvis", {
    {
        type = "mining-with-fluid",
        modifier = true
    }
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
utils.add_packs("spidertron", {"space-science-pack"})
utils.set_trigger("tree-seeding", {
    type = "mine-entity",
    entity = "dry-tree"
})
utils.set_prerequisites("fish-breeding", {"planet-discovery-nauvis"})
utils.set_trigger("fish-breeding", {
    type = "mine-entity",
    entity = "fish"
})