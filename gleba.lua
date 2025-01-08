-- Utility functions to make tech modifications easier
local utils = require("__any-planet-start__/utils.lua")

-- Test to make sure the script is running (TODO: remove this)
require("__any-planet-start__/planets/gleba.lua")
utils.set_trigger("landfill", {type = "craft-item", item = "landfill", count = 1})