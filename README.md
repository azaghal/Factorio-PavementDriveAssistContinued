# Pavement Drive Assist Continued

## Introduction

**Pavement Drive Assist Continued** is a helper mod that guides
player's vehicle alongside roads (with optional cruise capability) and
aids in improving survival rates of all surrounding structures.

The mod also sports road signs and circuitry that can be used for
making safer crossings and for improving player vehicle detection in
general.

Here is a small demo of *Pavement Drive Assist Continued* in action:

![Demo](https://thumbs.gfycat.com/WebbedIllinformedGlassfrog-size_restricted.gif)

For a higher-quality demo video, please
see [this page](https://gfycat.com/webbedillinformedglassfrog).

## Features

### Driving assistant

*The driving assistant* (toggleable via key binding **`i`**) keeps
player's vehicle on paved roads - so long as the road bends are not
too sharp. The assistant scans all tiles in front of the vehicle and
changes the orientation to follow tiles that are most likely to be
part of the road (which is determined by an internal scoring system of
the mod).

While active, manually turning left or right overrides the assistant,
steering the vehicle outside of roads or towards desired direction at
crossroads.

### Road tile detection

When upcoming road segment consists out of multiple types of tiles,
the driving assitant tries to follow along the tiles that have the
highest score assigned to them. Normally, the tile with highest score
is *refined concrete*, but stone can also be easily set as primary
(highest-scoring) tile via mod settings.

Besides the vanilla tiles for refined concrete, concrete, and stone,
some other mod tiles are supported as well. Additional tiles can be
introduced by including their name and score value into the scores
field found in the configuration file.

Here is a more complete list of scores, ranging from higest to lowest,
across both vanilla and mod tiles:

- Asphalt
- Refined concrete (vanilla + mod variants)
- Concrete (vanilla + mod variants)
- Stone (vanilla + mod variants)
- Gravel
- Wood
- Road lines

For a full list of mods with integrated support, see the *Mod
integration* section below.

### Cruise control

Cruise control (toggleable via key binding **`[o]`**) helps
vehicle maintain a constant (configurable) speed while moving. It is
an excellent option for long travel, safety zones, parking lots or for
vehicles that could otherwise reach uncontrollable speeds.

In order to ensure maximum safety, braking will always override cruise
control and if the vehicle is stopped or is moving backwards, the
system will be temporarily inactive.

Speed limit values can be set directly using a pop-up dialog (default
key binding **`ctrl+o`**).

If *Alternative cruise control toggle mode* option is enabled via
personal mod settings, toggling cruise control will set the cruise
speed to last used value (set by *speed limit signs*, for example)
instead of setting it to player's configured default.

### Speed limit signs

*Speed limit signs* can be placed on roads to impose a speed limit on
vehicles that drive across it. This helps prevent driving at breakneck
speed through gates, across railroad crossings or in a central parking
lot.

The limit can be changed by clicking on a sign and setting the desired
value for its output signal.

Driving across an *end of speed limit* sign or disabling the *cruise
control* removes all imposed limits.

*Speed limit* and *end of speed limit* signs affect the passing
vehicle only when **both** the driving assistant **and** cruise
control are active.

*Variable speed limits* can be set by linking speed limit signs to a
circuit network - by removing the limit on the sign itself and
providing at least one signal via red or green wire. Signals coming
over red wire are prioritized over the ones coming over the green
wire. Signals also take priority according to their internal ordering
(0 > 1 > 2 > ... > 9 > A > B > C > ... > Z).

### Automated traffic control

*Automated traffic control* can be employed for creating automated
railroad crossings or traffic junctions by using stop signs and road
sensors. This feature is explained in detail in FAQ section under
"[Automated railroad/railway crossing tutorial](https://mods.factorio.com/mod/PavementDriveAssistContinued/faq)".

![Imgur](http://i.imgur.com/W5NodqF.png)

### Additional features


- **Road departure warning**<br/>
  Provides acoustic or console output warning if the vehicle is
  leaving paved area, e.g. at a dead end or in very sharp curves. If
  not steered manually, an emergency brake will be activated to stop
  the vehicle.

- **Highspeed support**<br/>
  If vehicle reaches speeds over 100 kmph (customisable in
  configuration file) the "path finder" will increase its search area
  in front of it, allowing safe ride for speeds up to 350 kmph. It is
  highly recommended to design roads with appropriate curve radii
  before traveling at such high speeds!

- **Native mod support**<br/>
  All kinds of vehicles are supported, as long as they are valid
  "car"-type entities.

- **Blacklist vehicles**<br/>
  Vehicles can be explicitly black-listed based on type, in which case
  the mod will completely ignore them.

- **Global speed limit**<br/>
  Global speed limit can be set for all player-controlled vehicles.

- **Optimised code for multiplayer**<br/>
  Running a huge server? That's not an issue - the main routine causes
  almost zero load as long as no one is driving, and up to 10 players
  are able to drive simultaneously at any given time without causing
  any serious lag! Some benchmarks on an older laptop have resulted
  in 25 simulated players driving at 130 km/h and active cruise
  control causing only a 10 UPS drop.

- **Fine-tune CPU usage**<br/>
  It is always possible to reduce the tick rate of the *driving
  assistant* or to disable *cruise control* in case of issues via
  configuration file. Opposite is true as well - precision can be
  incresaed to up to 60 scans per second, effectively doubling the CPU
  load.

### Mod integration

- [Asphalt Roads](https://mods.factorio.com/mod/AsphaltRoads) was
  specifically designed to work with Pavement Drive Assist. Asphalt is
  preconfigured as the primary road tile and vehicles will try to
  avoid crossing lane marking tiles (roads with separated lanes will
  therefore allow safe two-way traffic). Unfortunately, Asphalt Roads
  has not been updated yet for Factorio 1.1.
- [Asphalt Paving](https://mods.factorio.com/mod/AsphaltPaving) is a
  fully compatible drop-in replacement for Asphalt Roads with support
  for Factorio 1.1.
- [Color Coding](https://mods.factorio.com/mod/color-coding)
- [5Dim's mod - New Decoration](https://mods.factorio.com/mod/5dim_decoration)
- [More Floors](https://mods.factorio.com/mod/More_Floors)
- ["Dectorio" by PantherX](https://mods.factorio.com/mod/Dectorio)
- [Krastorio 2](https://mods.factorio.com/mod/Krastorio2)

### Incompatible mods

Since the relase of version 2.1.0, there are no incompatible
mods. ["Vehicle Snap"](https://mods.factorio.com/mods/Zaflis/VehicleSnap) can
be used alongside PDA without issues - by simply disabling it with the
respective hotkey when entering assisted driving mode.

## Other information

### Effects on gameplay

This mod increases the importance of proper roads as it allows
crossing kilometres of land on roads, while doing nothing more than
pressing "forward"!

If this is still too much work, cruise control comes to the rescue and
the vehicle will accelerate on its own to maintain its speed. At this
point the only remaining task for the driver is to press "left" or
"right" at crossroads or to brake at destination. Meanwhile the driver
can perform useful tasks - like browsing through production statistics
or managing trains. Autonomous driving has reached Factorio!

### Technology

The technology required to use the driving assistant and cruise
control is called **Driver assistance systems** and only has
**Automobilism** as prerequisite.

Features can be used without research as well, provided that the
**Tech required** option in the map settings has been disabled.

The traffic signs used for sophisticated traffic management require
the **Smart roads** technology which is available mid-game.

### Current language support

- EN (English)
- DE (German)

If you like the mod and have created a translation of your own, please
do not hesitate to create a pull request on Github so that it can be
made accessible to everyone in the next version release. Thanks in
advance!

## History

Originally the idea was first implemented in
the
[Pavement Drive Assist](https://forums.factorio.com/viewtopic.php?f=190&t=21680) mod
created by *sillyfly*. Unfortunately, the mod was never updated to
work with Factorio 0.13+, and was subsequently taken over
by [Arcitos](https://mods.factorio.com/user/Arcitos), who also made it
available on
the [mod portal](https://mods.factorio.com/mod/PavementDriveAssist).

Arcitos had made huge improvements to the mod and redesigned it around
the excellent scanning routine from *sillifly*, adding a number of
additional features.

The mod had remained fully usable until *Factorio 1.1* came out, when
small changes to Factorio API broke it again. After a couple of months
of waiting for the original author to release an update, a fork
called
[Pavement Drive Assist Continued](https://mods.factorio.com/mod/PavementDriveAssistContinued) was
created by [azaghal](https://mods.factorio.com/user/azaghal) with the
necessary fixes.

### Interfaces

PDA main variables are accessible via remote functions.

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
