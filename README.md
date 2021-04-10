# Pavement Drive Assist 2
---
![](https://thumbs.gfycat.com/WebbedIllinformedGlassfrog-size_restricted.gif)
https://gfycat.com/webbedillinformedglassfrog
## Introduction

**Pavement Drive Assist** is a helper mod that guides your vehicle along roads (at a preset speed if you want) and aids greatly in improving survival rates of all structures surrounding your travel vector. But this mod adds a lot more stuff for a whole new driving experience!

The idea for this was first implemented in "Pavement Drive Assist" made by sillyfly, but this mod was unfortunately never updated to work with Factorio 0.13+. So i took action and redesigned it around the excellent scanning routine from sillifly. Beside this i've added some other stuff i thought that might be useful. I hope you'll enjoy it!


## Details

| Feature                       | Description                                                  |
| ----------------------------- | :----------------------------------------------------------- |
| **Driving Assistant**  | **The driving assistant will keep your vehicle on paved roads** (if the road bends not to sharply)! The assistant scans all tiles in front of the vehicle and changes the orientation to follow tiles with a "pavement" score. Driving in left or right direction will override the assistant, so that you'll be always able to leave roads or to choose your desired direction at junctions. Toggle the driving assistant by pressing **[I]** (key binding is customizable). |
| **Road tile detection** | **PDA tries to follow the tiles with the highest score.** By default this is concrete (or asphalt, if "[Asphalt Roads](https://mods.factorio.com/mods/Arcitos/AsphaltRoads)" is installed), but if you use stone as your primary tile, just set the value in mod settings accordingly and everything will work fine for you, too. Beside the vanilla tiles for stone, concrete and hazard concrete some other mod tiles are also supported. If you want to add additional tiles, just put their name and a value into the scores field found in the config file. |
| **Cruise control**      | **Set up a cruising speed by pressing** **[O]** (default key binding). Great for long travel, safety zones, parking lots or for cars that will otherwise reach uncontrollable speeds. Press the respective key again to disable it. In order to ensure maximum safety, braking will always override cruise control and if the car is stopped or is moving backwards, the system will be temporarily inactive. If you want to directly set up a certain value for your speed limit, press **[CTRL+O]**. A small text field will pop up, where you'll be able to insert a new cruise control speed limit. **Alternative cruise control toggle mode:** If this personal setting option is enabled, toggling cruise control (by pressing **[O]**) no longer sets a new speed limit and will just load the last valid value instead. |
| **Speed limit signs**         | **Place speed limit signs on your roads** to impose a speed limit on those vehicles that drive across it. This prevents driving at breakneck speed through gates, across railroad crossings or in your central parking lot. To change the limit, simply click on a sign and change the value of its output signal. Driving across a "End of speed limit"-sign will remove all imposed limits. To detect and process signs, both driving assistant and cruise control have to be activated. Switching cruise control to "off" will reset any speed limit.  **Set up variable speed limits** by linking speed limit signs to a circuit network: To do this, simply remove the limit on the sign itself and provide at least one signal via a red or green wire. Red signals will be prioritized over green signals and the signals itself will be treated according to their internal order (0>1>2>...>9>A>B>C>...>Z) |
| **Automated traffic control** | **Create automated railroad crossings or traffic junctions** by using stop signs and road sensors. This feature is explained in detail at the FAQ section under "[Automated railroad/railway crossing tutorial](https://mods.factorio.com/mod/PavementDriveAssist/faq)".

![Imgur](http://i.imgur.com/W5NodqF.png)

###Additional features:###

- **Road departure warning**
- **Highspeed support**
- **Native support for all mod vehicles**
- **Blacklist for vehicles**
- **Global speed limit**
- **Optimised code for multiplayer**
- **Fine-tune CPU usage**

All features are explained in detail in the attached readme file.

**Supported tilesets:**


- [Asphalt Roads](https://mods.factorio.com/mods/Arcitos/AsphaltRoads "Asphalt Roads") was specifically designed to work with Pavement Drive Assist. Asphalt is preconfigured as the primary road tile and vehicles will try to avoid crossing lane marking tiles (roads with separated lanes will therefore allow safe two-way traffic).

**Additional support for**:

- [Color-coding concrete floors](https://mods.factorio.com/mods/justarandomgeek/color-coding)
- [5Dims concrete floors](https://mods.factorio.com/mods/McGuten/5dim_decoration)
- [Tones "More Floors"](https://mods.factorio.com/mods/Tone/More_Floors)
- ["Dectorio" by PantherX](https://mods.factorio.com/mods/PantherX/Dectorio)
- [Krastorio 2 by Linver and Krastor](https://mods.factorio.com/mod/Krastorio2)

**Effects on gameplay**

This mod will increase the importance of proper roads as it will allow you to cross kilometres of land on roads, while doing nothing more than pressing "forward"! If this is still to much (maybe because your left middle finger starts to ache), then simply set up cruise control and the vehicle will accelerate on its own to maintain its speed. At this point your remaining task is to press "left" or "right" at junctions or to brake the vehicle if needed. Spend your travel time doing useful stuff like exploring your production statistics or managing trains. Autonomous driving has reached Factorio!


**Technology**

The technology required to use the driving assistant and cruise control is called **Driver assistance systems** and needs  only **Automobilism** as prerequisite. If you want to use the features without researching the tech beforehand, set "Tech required" in the map settings tab to "false".
The traffic signs used for sophisticated traffic management require the **Smart roads** tech which is available at mid-game.

**Incompatible mods:**

Since version 2.1.0 there are no incompatible mods anymore. ["Vehicle Snap"](https://mods.factorio.com/mods/Zaflis/VehicleSnap) does now work with PDA! Just disable it with the respective hotkey if you enter assisted driving mode.

**Interfaces:**

PDA main variables are accessible via remote functions. Please check the readme for more details.

### Current language support

- EN (English)
- DE (German)

If you like this mod and you've created a translation of your own, please do not hesitate to send it to me, so that it can be made accessible to all in the next version. Thanks in advance!
