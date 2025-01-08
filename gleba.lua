-- Utility functions to make tech modifications easier
local utils = require("__any-planet-start__/utils.lua")

function utils.add_packs(name, packs)
    local ingredients = data.raw["technology"][name].unit.ingredients
    for _, pack in pairs(packs) do
        ingredients[#ingredients+1] = {pack, 1}
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

utils.add_recipes("sulfur-processing", {"biosulfur"})
utils.set_prerequisites("sulfur-processing", {"chemistry", "agricultural-science-pack"})
utils.add_packs("sulfur-processing", {"agricultural-science-pack"})

utils.add_recipes("lubricant", {"biolubricant"})
utils.add_packs("lubricant", {"agricultural-science-pack"})

-- Carbon fiber and its successors no longer require space science
utils.remove_packs("carbon-fiber", {"space-science-pack"})
utils.remove_packs("rocket-turret", {"space-science-pack"})
utils.remove_packs("spidertron", {"space-science-pack"})
utils.remove_packs("stack-inserter", {"space-science-pack"})
utils.remove_packs("transport-belt-capacity-1", {"space-science-pack"})
utils.remove_packs("transport-belt-capacity-2", {"space-science-pack"})
utils.remove_packs("toolbelt-equipment", {"space-science-pack"})

-- Oil processing is moved to space science so that it is available before heading to another planet
utils.add_prerequisites("oil-gathering", {"space-science-pack"})
utils.add_packs("oil-gathering", {"space-science-pack"})
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
utils.add_prerequisites("military-science-pack", {"sulfur-processing"})
utils.set_prerequisites("rocket-fuel", {"chemical-science-pack"})
utils.set_prerequisites("lubricant", {"chemical-science-pack"})
utils.set_prerequisites("flammables", {"chemistry"})

-- Missing prerequisites that are normally required to reach gleba
utils.add_prerequisites("rocket-turret", {"processing-unit"})

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