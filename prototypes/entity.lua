local function void_activity_led_sprite()
    return {
        filename = "__PavementDriveAssistContinued__/graphics/sound/dummy.png",
        width = 1,
        height = 1,
        frame_count = 1,
        shift = {0, 0},
    }
end

local function void_circuit_wire_connection_point()
    return {
        shadow = {
            red = {0, 0},
            green = {0, 0},
        },
        wire = {
            red = {0, 0},
            green = {0, 0},
        }
    }
end

local function void_circuit_wire_connection_point(direction)
    return {
        shadow = {
            red = {-0.5, -0.05},
            green = {-0.5, 0.05},
        },
        wire = {
            red = {-0.5, -0.05},
            green = {-0.5, 0.05},
        }
    }
end

data:extend({
{
    type = "constant-combinator",
    name = "pda-road-sign-speed-limit",
    icon = "__PavementDriveAssistContinued__/graphics/icons/icon_speed_limit.png",
    icon_size = 32,
    flags = {"placeable-neutral", "player-creation", "not-on-map", "placeable-off-grid"},
    minable = {hardness = 0.2, mining_time = 1.0, result = "pda-road-sign-speed-limit"},
    max_health = 75,
    render_layer = "floor",
    corpse = "small-remnants",
    collision_box = {{-0.85, -0.85}, {0.85, 0.85}},
    selection_box = {{-0.8, -0.8}, {0.8, 0.8}},
    collision_mask = { "floor-layer", "water-tile" },
    item_slot_count = 1,
    resistances =
    {
        {
            type = "fire",
            percent = 95
        },
        {
            type = "explosion",
            percent = 90
        },
        {
            type = "physical",
            percent = 90
        },
    },
    sprites =
    {
      north =
      {
        filename = "__PavementDriveAssistContinued__/graphics/entity/road-sign-speed-limit-n.png",
        width = 64,
        height = 64,
        frame_count = 1,
        shift = {0, 0},
      },
      east =
      {
        filename = "__PavementDriveAssistContinued__/graphics/entity/road-sign-speed-limit-e.png",
        width = 64,
        height = 64,
        frame_count = 1,
        shift = {0, 0},
      },
      south =
      {
        filename = "__PavementDriveAssistContinued__/graphics/entity/road-sign-speed-limit-s.png",
        width = 64,
        height = 64,
        frame_count = 1,
        shift = {0, 0},
      },
      west =
      {
        filename = "__PavementDriveAssistContinued__/graphics/entity/road-sign-speed-limit-w.png",
        width = 64,
        height = 64,
        frame_count = 1,
        shift = {0, 0},
      },
    },

    activity_led_sprites =
    {
        north = void_activity_led_sprite(),
        east = void_activity_led_sprite(),
        south = void_activity_led_sprite(),
        west = void_activity_led_sprite()
    },

    activity_led_light =
    {
        intensity = 0.8,
        size = 1,
        --color = {r = 1.0, g = 1.0, b = 1.0}
    },

    activity_led_light_offsets =
    {
        {0, 0},
        {0, 0},
        {0, 0},
        {0, 0}
    },
    circuit_wire_connection_points =
    {
        {
            shadow = { red = {-0.15, -0.75}, green = {0.15, -0.75}, },
            wire = { red = {-0.15, -0.75},  green = {0.15, -0.75}, },
        },
        {
            shadow = { red = {0.95, -0.12}, green = {0.95, 0.12}, },
            wire = { red = {0.95, -0.12},  green = {0.95, 0.12}, },
        },
        {
            shadow = { red = {0.15, 0.75}, green = {-0.15, 0.75}, },
            wire = { red = {0.15, 0.75},  green = {-0.15, 0.75}, },
        },
        {
            shadow = { red = {-0.95, 0.12}, green = {-0.95, -0.12}, },
            wire = { red = {-0.95, 0.12},  green = {-0.95, -0.12}, },
        }
    },
    circuit_wire_max_distance = 9
},
{
    type = "constant-combinator",
    name = "pda-road-sign-speed-unlimit",
    icon = "__PavementDriveAssistContinued__/graphics/icons/icon_speed_unlimit.png",
    icon_size = 32,
    flags = {"placeable-neutral", "player-creation", "not-on-map", "placeable-off-grid"},
    minable = {hardness = 0.2, mining_time = 1.0, result = "pda-road-sign-speed-limit"},
    max_health = 75,
    render_layer = "floor",
    corpse = "small-remnants",
    collision_box = {{-0.85, -0.85}, {0.85, 0.85}},
    selection_box = {{-0.8, -0.8}, {0.8, 0.8}},
    collision_mask = { "floor-layer", "water-tile" },
    item_slot_count = 1,
    resistances =
    {
        {
            type = "fire",
            percent = 95
        },
        {
            type = "explosion",
            percent = 90
        },
        {
            type = "physical",
            percent = 90
        },
    },
    sprites =
    {
      north =
      {
        filename = "__PavementDriveAssistContinued__/graphics/entity/road-sign-speed-unlimit-n.png",
        width = 64,
        height = 64,
        frame_count = 1,
        shift = {0, 0},
      },
      east =
      {
        filename = "__PavementDriveAssistContinued__/graphics/entity/road-sign-speed-unlimit-e.png",
        width = 64,
        height = 64,
        frame_count = 1,
        shift = {0, 0},
      },
      south =
      {
        filename = "__PavementDriveAssistContinued__/graphics/entity/road-sign-speed-unlimit-n.png",
        width = 64,
        height = 64,
        frame_count = 1,
        shift = {0, 0},
      },
      west =
      {
        filename = "__PavementDriveAssistContinued__/graphics/entity/road-sign-speed-unlimit-e.png",
        width = 64,
        height = 64,
        frame_count = 1,
        shift = {0, 0},
      },
    },

    activity_led_sprites =
    {
        north = void_activity_led_sprite(),
        east = void_activity_led_sprite(),
        south = void_activity_led_sprite(),
        west = void_activity_led_sprite()
    },

    activity_led_light =
    {
        intensity = 0.8,
        size = 1,
        --color = {r = 1.0, g = 1.0, b = 1.0}
    },

    activity_led_light_offsets =
    {
        {0, 0},
        {0, 0},
        {0, 0},
        {0, 0}
    },
    circuit_wire_connection_points =
    {
        void_circuit_wire_connection_point(),
        void_circuit_wire_connection_point(),
        void_circuit_wire_connection_point(),
        void_circuit_wire_connection_point()
    },
    circuit_wire_max_distance = 0

}
})
local vehicleSensor = table.deepcopy(data.raw["constant-combinator"]["pda-road-sign-speed-unlimit"])
vehicleSensor.name = "pda-road-sensor"
vehicleSensor.minable.result = "pda-road-sensor"
vehicleSensor.item_slot_count = 4
vehicleSensor.sprites = {
    north =
    {
      filename = "__PavementDriveAssistContinued__/graphics/entity/road-sensor-n.png",
      width = 96,
      height = 96,
      frame_count = 1,
      shift = {0, 0},
      hr_version =
      {
        scale = 0.5,
        filename = "__PavementDriveAssistContinued__/graphics/entity/hr-road-sensor-n.png",
        width = 192,
        height = 192,
        frame_count = 1,
        shift = {0, 0}
      }
    },
    east =
    {
      filename = "__PavementDriveAssistContinued__/graphics/entity/road-sensor-e.png",
      width = 96,
      height = 96,
      frame_count = 1,
      shift = {0, 0},
      hr_version =
      {
        scale = 0.5,
        filename = "__PavementDriveAssistContinued__/graphics/entity/hr-road-sensor-e.png",
        width = 192,
        height = 192,
        frame_count = 1,
        shift = {0, 0}
      }
    },
    west =
    {
      filename = "__PavementDriveAssistContinued__/graphics/entity/road-sensor-w.png",
      width = 96,
      height = 96,
      frame_count = 1,
      shift = {0, 0},
      hr_version =
      {
        scale = 0.5,
        filename = "__PavementDriveAssistContinued__/graphics/entity/hr-road-sensor-w.png",
        width = 192,
        height = 192,
        frame_count = 1,
        shift = {0, 0}
      }
    },
    south =
    {
      filename = "__PavementDriveAssistContinued__/graphics/entity/road-sensor-s.png",
      width = 96,
      height = 96,
      frame_count = 1,
      shift = {0, 0},
      hr_version =
      {
        scale = 0.5,
        filename = "__PavementDriveAssistContinued__/graphics/entity/hr-road-sensor-s.png",
        width = 192,
        height = 192,
        frame_count = 1,
        shift = {0, 0}
      }
    }
}
vehicleSensor.collision_box = {{-1.4, -1.4}, {1.4, 1.4}}
vehicleSensor.selection_box = {{-1.3, -1.3}, {1.3, 1.3}}
vehicleSensor.circuit_wire_max_distance = 9
vehicleSensor.circuit_wire_connection_points = {
        {
            shadow = { red = {-0.15, -1.2}, green = {0.15, -1.2}, },
            wire = { red = {-0.15, -1.2},  green = {0.15, -1.2}, },
        },
        {
            shadow = { red = {1.4, -0.12}, green = {1.4, 0.12}, },
            wire = { red = {1.4, -0.12},  green = {1.4, 0.12}, },
        },
        {
            shadow = { red = {0.15, 1.2}, green = {-0.15, 1.2}, },
            wire = { red = {0.15, 1.2},  green = {-0.15, 1.2}, },
        },
        {
            shadow = { red = {-1.4, 0.12}, green = {-1.4, -0.12}, },
            wire = { red = {-1.4, 0.12},  green = {-1.4, -0.12}, },
        }
    }


local road_sign_stop = table.deepcopy(data.raw["constant-combinator"]["pda-road-sign-speed-limit"])
road_sign_stop.name = "pda-road-sign-stop"
road_sign_stop.minable.result = "pda-road-sign-stop"
road_sign_stop.sprites.north.filename = "__PavementDriveAssistContinued__/graphics/entity/road-sign-stop-n.png"
road_sign_stop.sprites.east.filename = "__PavementDriveAssistContinued__/graphics/entity/road-sign-stop-e.png"
road_sign_stop.sprites.south.filename = "__PavementDriveAssistContinued__/graphics/entity/road-sign-stop-s.png"
road_sign_stop.sprites.west.filename = "__PavementDriveAssistContinued__/graphics/entity/road-sign-stop-w.png"

data:extend({
    vehicleSensor,
    road_sign_stop
})
