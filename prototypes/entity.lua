local function void_activity_led_sprite()
    return {
        filename = "__PavementDriveAssist__/graphics/sound/dummy.png",
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

data:extend({  
{
    type = "constant-combinator",
    name = "pda-road-sign-speed-limit",
    icon = "__PavementDriveAssist__/graphics/icons/icon_speed_limit.png",
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
        filename = "__PavementDriveAssist__/graphics/entity/road-sign-speed-limit-n.png",
        width = 64,
        height = 64,
        frame_count = 1,
        shift = {0, 0},
      },
      east =
      {
        filename = "__PavementDriveAssist__/graphics/entity/road-sign-speed-limit-e.png",
        width = 64,
        height = 64,
        frame_count = 1,
        shift = {0, 0},
      },
      south =
      {
        filename = "__PavementDriveAssist__/graphics/entity/road-sign-speed-limit-s.png",
        width = 64,
        height = 64,
        frame_count = 1,
        shift = {0, 0},
      },
      west =
      {
        filename = "__PavementDriveAssist__/graphics/entity/road-sign-speed-limit-w.png",
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
},
{
    type = "constant-combinator",
    name = "pda-road-sign-speed-unlimit",
    icon = "__PavementDriveAssist__/graphics/icons/icon_speed_unlimit.png",
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
        filename = "__PavementDriveAssist__/graphics/entity/road-sign-speed-unlimit-n.png",
        width = 64,
        height = 64,
        frame_count = 1,
        shift = {0, 0},
      },
      east =
      {
        filename = "__PavementDriveAssist__/graphics/entity/road-sign-speed-unlimit-e.png",
        width = 64,
        height = 64,
        frame_count = 1,
        shift = {0, 0},
      },
      south =
      {
        filename = "__PavementDriveAssist__/graphics/entity/road-sign-speed-unlimit-n.png",
        width = 64,
        height = 64,
        frame_count = 1,
        shift = {0, 0},
      },
      west =
      {
        filename = "__PavementDriveAssist__/graphics/entity/road-sign-speed-unlimit-e.png",
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