# ShaguTweaks-Mods
Custom mods for the [ShaguTweaks](https://shagu.org/ShaguTweaks/) addon

## Credit:<br>
Credit to [shagu](https://github.com/shagu)
<br>
Code from [pfUI](https://shagu.org/pfUI/)

## Installation

##### 1: Copy the .lua files inside the mods folder to \Interface\AddOns\ShaguTweaks\mods

##### 2: To enable the mod(s) add the appropriate line(s) below to \Interface\AddOns\ShaguTweaks\ShaguTweaks.toc:

<i>
mods\basic-chat.lua<br>
mods\buff-restyle.lua<br>
mods\central-ui.lua<br>
mods\cursor-tooltip.lua<br>
mods\hide-combat-tooltip.lua<br>
mods\hide-ui-frames.lua<br>
mods\improved-exp.lua<br>
mods\improved-interface-options.lua<br>
mods\minimap-framerate-latency.lua<br>
mods\minimap-restyle.lua<br>
mods\unitframes-classportrait-tot.lua<br>
mods\unitframes-combat-indicator.lua<br>
mods\unitframes-energy-tick.lua<br>
mods\unitframes-lowhealth.lua<br>
mods\unitframes-namecolor.lua<br>
</i>

##### You should now be able to enable the mod(s) by selecting them in the ShaguTweaks menu (Esc > Advanced Options)

## Mods:

### basic-chat
Creates non-configurable General, Combat Log and Loot & Spam chat boxes

### buff-restyle
Restyles buff and debuff font and timer<br>

##### Preview:
<img src="https://raw.githubusercontent.com/GryllsAddons/AddonPreviews/main/ShaguTweaks-Mods/ST_BuffRestyle.png" width=15% height=15%/>

### central-ui.lua
Moves the unit frames, castbar, buffs and minimap into a more central layout

### cursor-tooltip
Attaches the tooltip to the cursor

##### Preview:
<img src="https://raw.githubusercontent.com/GryllsAddons/AddonPreviews/main/ShaguTweaks-Mods/ST_TooltipCursor.png" width=20% height=20%/>

### hide-combat-tooltip
Hides the tooltip while in combat<br>
While in combat, holding shift while mousing over a new target will show the tooltip

### hide-ui-frames
An adaptable framework for hiding UI frames (please see .lua instructions)<br>
Currently hides the player and pet frame based on conditions

### improved-exp
Shows detailed exp, rested exp and rep values on mouseover

##### Preview:
<img src="https://github.com/GryllsAddons/AddonPreviews/blob/main/ShaguTweaks-Mods/ST_ImpExp1.png" width=50% height=20%/>

##### Preview:
<img src="https://github.com/GryllsAddons/AddonPreviews/blob/main/ShaguTweaks-Mods/ST_ImpExp2.png" width=50% height=20%/>

### improved-interface-options
Removes the background while in the Interface Options

### minimap-framerate-latency.lua
Adds a small Framerate & Latency display to the mini map.
Mouseover to see the high and low framerate and latency for your WoW session<br>
The color will change in relation to the target values set at the top line of the minimap-fps.lua file

##### Preview:
<img src="https://raw.githubusercontent.com/GryllsAddons/AddonPreviews/main/ShaguTweaks-Mods/ST_FPSMS2.png" width=20% height=20%/><br>

### minimap-restyle
Restyles the minimap<br>
Adds square Tracking and Mail icons and repositions the PVP icon when using the square minimap module<br>
Restyles the Zone Text, Clock, FPS and MS display

If you are using the [MinimapButtonBag](https://github.com/McPewPew/MinimapButtonBag-TurtleWoW) addon the MinimapButtonBag button will be repositioned below the minimap or clock<br>
The MinimapButtonBag button will be hidden unless you mouse over it<br>

##### Preview:
<img src="https://raw.githubusercontent.com/GryllsAddons/AddonPreviews/main/ShaguTweaks-Mods/ST_Restyle.png" width=20% height=20%/>

### unitframes-classportrait-tot
Extends class portraits to Target of Target

##### Preview:
<img src="https://raw.githubusercontent.com/GryllsAddons/AddonPreviews/main/ShaguTweaks-Mods/ST_TOTPortrait.png" width=20% height=20%/>

### unitframes-combat-indicator
Adds a combat indicator to the target frame

##### Preview:
<img src="https://raw.githubusercontent.com/GryllsAddons/AddonPreviews/main/ShaguTweaks-Mods/ST_CombatIndicator.png" width=20% height=20%/>

### unitframes-energy-tick
Adds an energy tick to the player frame

##### Preview:
<img src="https://github.com/GryllsAddons/AddonPreviews/blob/main/ShaguTweaks-Mods/ST_EnergyTick.png" width=20% height=20%/>

### unitframes-lowhealth
Changes the nameplate and unitframe healthbar colors when at 20% health or lower<br>
Enemy health will be colored orange<br>
Friendly health will be colored blue<br>
The colors can be customised by editing the .lua file

##### Preview:
<img src="https://raw.githubusercontent.com/GryllsAddons/AddonPreviews/main/ShaguTweaks-Mods/ST_Lowhealth2.png" width=30% height=30%/>

### unitframes-namecolor
Adds class and pet coloring (if Warlock or Hunter pet) to the unitframes.
