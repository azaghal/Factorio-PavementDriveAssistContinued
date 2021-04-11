# Pavement Drive Assist 2
---
## Introduction

*The nearly forgotten original from sillyfly, now available in a vastly improved version.*


**Pavement Drive Assist**

"PDA" is a helper mod dedicated to your vehicle's health and to improve survival rates of all structures surrounding your roads. No more unintentional crashing into chemical complexes or destruction of valuable chests! But this mod adds a lot more stuff for a whole new driving experience! 

The idea for this was first implemented in "Pavement Drive Assist" made by sillyfly, but this mod was unfortunately never updated to work with Factorio 0.13+. So i took action and redesigned it around the excellent scanning routine from sillifly. Beside this i've added some other stuff i thought that might be useful. I hope you'll enjoy it!

**Effects on gameplay**

This mod will increase the importance of proper roads as it will allow you to cross kilometres of land on roads, while doing nothing more than pressing "forward"! After activating cruise control your remaining task is to press "left" or "right" at junctions or to brake the vehicle if needed. Spend your travel time doing useful stuff like exploring your production statistics or managing trains. **Autonomous driving has reached Factorio!**

## Details

### Main features

- **The "Driving Assistant"**: It will automatically keep your vehicle on paved roads (if the road bends not to sharply)! The assistant scans all tiles in front of the vehicle and changes the orientation to follow tiles with a "pavement" score. Driving in left or right direction will override the assistant, so that you'll be allways able to leave roads or to choose your desired direction at junctions. Toggle the driving assistant by pressing **[I]** (key binding is customisable).

![](https://mods-data.factorio.com/pub_data/media_files/jK4Cft0x6GC0.png)

![](https://mods-data.factorio.com/pub_data/media_files/phTyjp8EZqLp.png)

- **Config your primary road tile**: PDA tries to follow the tiles with the highest score. By default this is concrete (or asphalt, if "[Asphalt Roads](https://mods.factorio.com/mods/Arcitos/AsphaltRoads "Asphalt Roads")" or "[More Floors](https://mods.factorio.com/mods/Tone/More_Floors)" are present), but if you use stone as your primary tile, just set the stats in the config file accordingly and everything will work fine for you too. Beside the vanilla tiles for stone, concrete and hazard concrete some other mod tiles are supported too. If you want to add additional tiles, just put their name and a value into the scores field found in the config file. 

![](https://mods-data.factorio.com/pub_data/media_files/ODCCqrp58rpE.png)

- **Cruise control**: Set up a cruising speed by pressing **[O]** (also customisable). Great for long travel, safety zones, parking lots or for cars that will otherwise reach uncontrollable speeds. Press the respective key again to disable it. In order to ensure maximum safety, braking will always override cruise control and if the car is stopped or is moving backwards, the system will be temporarily inactive. If you want to directly set up a certain value for your speed limit, press **[CTRL+O]**. A small text field will pop up, where you'll be able to insert a new cruise control speed limit.
- **Alternative cruise control toggle mode**: If this personal setting option is enabled, toggling cruise control (by pressing **[O]**) no longer sets a new speed limit and will just load the last valid value instead. 

![](https://mods-data.factorio.com/pub_data/media_files/qULH1DuszZR7.png)

- **Speed limit signs!**: Place speed limit signs on your roads to impose a speed limit on those vehicles that drive across it. This prevents driving at breakneck speed through gates, across railroad crossings or in your central parking lot. To change the limit, simply click on a sign and change the value of its output signal. Driving across a "End of speed limit"-sign will remove all imposed limits. To detect and process signs, both driving assistant and cruise control have to be activated. Switching cruise control to "off" will reset any speed limit.

- **New in 2.1.4: Set up variable speed limits by linking speed limit signs to a circuit network!** To do this, simply remove the limit on the sign itself and provide at least one signal via a red or green wire. Red signals will be prioritized over green signals and the signals itself will be treated according to their internal order (0>1>2>...>9>A>B>C>...>Z)

![Imgur](http://i.imgur.com/W5NodqF.png)

###Additional features:###

- **Road departure warning**: Warns you acoustically or via console output if your vehicle is leaving paved area, i.e. at a dead end or in very sharp curves. If the vehicle is not steered manually (by pressing "[W]") an emergency brake will be activated to stop the vehicle. 
- **Highspeed support**: If your vehicle reaches speeds over 100 kmph (customisable in config file) the "path finder" will increase its search area in front of your vehicle, allowing safe ride for speeds up to 350 kmph. It is highly recommended to design your roads with appropriate curve radii before traveling with speeds of this magnitude!
- **Native mod support**: All kinds of vehicles are supported if they are valid "car"-type entities.
- **Blacklist vehicles**: Set up a custom list of vehicles you dont want to be supported.
- **Global speed limit**: Limit the speed that rideable cars are able to reach in your game (works also in multiplayer)
- **Optimised code for multiplayer**: You are running a huge server? That's not an issue: The main routine causes almost zero load as long as no one is driving, and up to 10 players are able to drive simultaneously at any given time without causing any serious lags! But i bet your machines will support much more than my ancient laptop was able to: My benchmark tests with 25 simulated players driving at 130 km/h and active cruise control resulted in an 10 UPS drop. 
- **Fine-tune CPU usage**: You are always free to reduce the tick rate of the driving assistant or to disable cruise control if you experience load issues (just take a look at the config file). On the other hand: If your CPU is bored, you're also able to increase the precision (to 60 scans per second), while effectively doubling the load.



**Supported tilesets:**


- [Asphalt Roads](https://mods.factorio.com/mods/Arcitos/AsphaltRoads "Asphalt Roads"): This mod was specifically designed to work with Pavement Drive Assist. Asphalt is preconfigured as the primary road tile and vehicles will try to avoid crossing lane marking tiles (roads with separated lanes will therefore allow safe two-way traffic).

![](https://mods-data.factorio.com/pub_data/media_files/Q9HQ73wjeaOQ.png)

**Additional support for**:

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

---

### Changelog

  2.1.4 (2018-01-02)

- Updated for Factorio 0.16.x
- New Feature: Set values of speed limit signs via circuit network
- Added tile detection support for Dectorio 0.8.2
- Reduced amount of science pack 1 needed for research from 2 to 1 

  2.1.3 (2017-08-25)

- Added tile detection support for Asphalt Roads 1.1.0

  2.1.2 (2017-07-09)

- New Feature: Speed limit signs
- Improved handling of mod settings
- Added localised mod descritption for DE locale
- Added tile detection support for Dectorio 0.5.12
- Code optimisations

  2.1.1 (2017-05-14)

- Fixed an issue with the mod download manager caused by version numbering

  2.1.0 (2017-05-12)

- Updated to work with Factorio version 0.15.10
- Changed default key binding: [K]->[I] and [L]/[CTRL+L]->[O]/[CTRL+O] 
- Now fully compatible with Zaflis' "Vehicle Snap"
- Almost all important settings are now using the new setting mechanics
- New Feature: independent, personal settings
- New Feature: Alternative toggle mode for cruise control 
- Fixed: Applying/enabling a cruise control speed limit lower than the current vehicle speed will now lead to smooth deceleration instead of instant speed reduction. 


  2.0.3 (2017-02-17)

- New feature: Set or change your cruise control speed limit by pressing [CTRL + L]
- Added tile detection support for Asphalt Roads 1.0.2
- Added tile detection support for More Floors 1.1.0 
- Revisited major parts of the code for improved maintainability
- Added interface functions to get or set state of some variables
- Fixed: Exiting vehicles will now always reset the condition of the emergency brake
	
  2.0.2 (2017-01-24)

- Fixed: Changing the player's character while driving caused a crash (for example while using YARM in remote monitoring mode)
- Fixed: Loading a game where another player was currently driving caused a crash  
- Fixed: The game crashed when a player in a vehicle disconnected from a game in multiplayer


  2.0.1 (2017-01-20)

- New feature: Road departure warning system
- Fixed some typos

  2.0.0 (2017-01-13)

initial release of version 2:

- New feature: Toggle driving assistant
- New feature: Cruise control (can be disabled in config)
- New feature: High-speed support for driving assistant
- New feature: Support for all modded vehicles
- New feature: Option for server-wide speed limit
- New feature: Load balancing: Option to reduce tick rate to decrease the load
- Change: car whitelist is now a car blacklist
- improved check routine for valid car types
- lots of code optimisations

pre 2.0.0:  all credit to sillyfly!

