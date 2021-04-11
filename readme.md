# Pavement Drive Assist 2
---
<iframe src='https://gfycat.com/ifr/WebbedIllinformedGlassfrog' frameborder='0' scrolling='no' allowfullscreen width='640' height='359'></iframe>

## Introduction

"PDA" is a helper mod dedicated to your vehicle's health and to improve survival rates of all structures surrounding your roads. No more unintentional crashing into chemical complexes or destruction of valuable chests! But this mod adds a lot more stuff for a whole new driving experience! 

The idea for this was first implemented in "Pavement Drive Assist" made by sillyfly, but this mod was unfortunately never updated to work with Factorio 0.13+. So i took action and redesigned it around the excellent scanning routine from sillifly. Beside this i've added some other stuff i thought that might be useful. I hope you'll enjoy it!

**Effects on gameplay**

This mod will increase the importance of proper roads as it will allow you to cross kilometres of land on roads, while doing nothing more than pressing "forward"! After activating cruise control your remaining task is to press "left" or "right" at junctions or to brake the vehicle if needed. Spend your travel time doing useful stuff like exploring your production statistics or managing trains. **Autonomous driving has reached Factorio!**



## Details

### Main features

| Feature                       | Description                                                  |
| ----------------------------- | :----------------------------------------------------------- |
| **Driving Assistant**<br />   | **The driving assistant will keep your vehicle on paved roads** (if the road bends not to sharply)! The assistant scans all tiles in front of the vehicle and changes the orientation to follow tiles with a "pavement" score. Driving in left or right direction will override the assistant, so that you'll be always able to leave roads or to choose your desired direction at junctions. Toggle the driving assistant by pressing **[I]** (key binding is customizable).<br /> |
| **Road tile detection**<br /> | **PDA tries to follow the tiles with the highest score.** By default this is concrete (or asphalt, if "[Asphalt Roads](https://mods.factorio.com/mods/Arcitos/AsphaltRoads "Asphalt Roads")" or "[More Floors](https://mods.factorio.com/mods/Tone/More_Floors)" are present), but if you use stone as your primary tile, just set the value in mod settings accordingly and everything will work fine for you, too. Beside the vanilla tiles for stone, concrete and hazard concrete some other mod tiles are also supported. If you want to add additional tiles, just put their name and a value into the scores field found in the config file.<br /> |
| **Cruise control**<br />      | **Set up a cruising speed by pressing** **[O]** (default key binding). Great for long travel, safety zones, parking lots or for cars that will otherwise reach uncontrollable speeds. Press the respective key again to disable it. In order to ensure maximum safety, braking will always override cruise control and if the car is stopped or is moving backwards, the system will be temporarily inactive. If you want to directly set up a certain value for your speed limit, press **[CTRL+O]**. A small text field will pop up, where you'll be able to insert a new cruise control speed limit.<br />**Alternative cruise control toggle mode:** If this personal setting option is enabled, toggling cruise control (by pressing **[O]**) no longer sets a new speed limit and will just load the last valid value instead.<br /> |
| **Speed limit signs**         | **Place speed limit signs on your roads** to impose a speed limit on those vehicles that drive across it. This prevents driving at breakneck speed through gates, across railroad crossings or in your central parking lot. To change the limit, simply click on a sign and change the value of its output signal. Driving across a "End of speed limit"-sign will remove all imposed limits. To detect and process signs, both driving assistant and cruise control have to be activated. Switching cruise control to "off" will reset any speed limit. <br />**Set up variable speed limits** by linking speed limit signs to a circuit network: To do this, simply remove the limit on the sign itself and provide at least one signal via a red or green wire. Red signals will be prioritized over green signals and the signals itself will be treated according to their internal order (0>1>2>...>9>A>B>C>...>Z) |

![Imgur](http://i.imgur.com/W5NodqF.png)

### Additional features:

- **Road departure warning**: Warns you acoustically or via console output if your vehicle is leaving paved area, i.e. at a dead end or in very sharp curves. If the vehicle is not steered manually (by pressing "[W]") an emergency brake will be activated to stop the vehicle. 
- **Highspeed support**: If your vehicle reaches speeds over 100 kmph (customisable in config file) the "path finder" will increase its search area in front of your vehicle, allowing safe ride for speeds up to 350 kmph. It is highly recommended to design your roads with appropriate curve radii before traveling with speeds of this magnitude!
- **Native mod support**: All kinds of vehicles are supported if they are valid "car"-type entities.
- **Blacklist vehicles**: Set up a custom list of vehicles you dont want to be supported.
- **Global speed limit**: Limit the speed that rideable cars are able to reach in your game (works also in multiplayer)
- **Optimised code for multiplayer**: You are running a huge server? That's not an issue: The main routine causes almost zero load as long as no one is driving, and up to 10 players are able to drive simultaneously at any given time without causing any serious lags! But i bet your machines will support much more than my ancient laptop was able to: My benchmark tests with 25 simulated players driving at 130 km/h and active cruise control resulted in an 10 UPS drop. 
- **Fine-tune CPU usage**: You are always free to reduce the tick rate of the driving assistant or to disable cruise control if you experience load issues (just take a look at the config file). On the other hand: If your CPU is bored, you're also able to increase the precision (to 60 scans per second), while effectively doubling the load.



**Supported tilesets:**


- [Asphalt Roads](https://mods.factorio.com/mods/Arcitos/AsphaltRoads "Asphalt Roads"): This mod was specifically designed to work with Pavement Drive Assist. Asphalt is preconfigured as the primary road tile and vehicles will try to avoid crossing lane marking tiles (roads with separated lanes will therefore allow safe two-way traffic).

**Additional support for**:

- [Dectorio](https://mods.factorio.com/mod/Dectorio)
- [Color-coding concrete floors](https://mods.factorio.com/mods/justarandomgeek/color-coding) 
- [5Dims concrete floors](https://mods.factorio.com/mods/McGuten/5dim_decoration) 
- [Tones "More Floors"](https://mods.factorio.com/mods/Tone/More_Floors) 

**Technology**

Required technology is called **Driver assistance systems** and needs **Robotics, Lasers and Automobilism** as prerequisites. If you want to use the features without researching the tech beforehand, set "Tech required" in the map settings tab to "false".

**Incompatible mods:**

Since version 2.1.0 there are no incompatible mods anymore. ["Vehicle Snap"](https://mods.factorio.com/mods/Zaflis/VehicleSnap) does now work perfectly with PDA! Just disable it with the respective hotkey if you enter assisted driving mode.

### Interfaces
To read/alter PDA's main variables call the following remote functions:

Name of the interface: **"PDA"**

List of functions:

    #1
    "get_state_of_cruise_control"
    parameter needed: playerindex (int or player)
    returns state of cruise control (boolean) for the specified player
    
    #2
    "set_state_of_cruise_control"
    parameter needed: playerindex (int or player), new state (boolean)
    sets state of cruise control for the specified player according to the handed over parameter
    
    #3
    "get_cruise_control_limit"
    parameter needed: playerindex (int or player)
    returns cruise control limit (float) for the specified player
    
    #4
    "set_cruise_control_limit"
    parameter needed: playerindex (int or player), new limit (float)
    sets cruise control limit for the specified player according to the handed over parameter
    
    #5
    "get_state_of_driving_assistant"
    parameter needed: playerindex (int or player)
    returns state of driving assistant (boolean) for the specified player
    
    #6
    "set_state_of_driving_assistant"
    parameter needed: playerindex (int or player), new state (boolean)
    sets state of driving assistant for the specified player according to the handed over parameter

### Current language support

- EN (English)
- DE (German)

If you like this mod and you've created a translation of your own, please do not hesitate to send it to me, so that it can be made accessible to all in the next version. Thanks in advance!
