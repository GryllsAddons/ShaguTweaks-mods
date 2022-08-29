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
mods\buff-restyle.lua<br>
mods\cursor-tooltip.lua<br>
mods\hide-combat-tooltip.lua<br>
mods\hide-ui-frames.lua<br>
mods\improved-exp.lua<br>
mods\improved-interface-options.lua<br>
mods\minimap-fps.lua<br>
mods\minimap-ms.lua<br>
mods\minimap-restyle.lua<br>
mods\nameplate-lowhealth.lua<br>
mods\unitframes-classportrait-tot.lua<br>
mods\unitframes-combat-indicator.lua<br>
mods\unitframes-energy-tick.lua<br>
</i>
<br>
You should now be able to enable the mod(s) by selecting them in the ShaguTweaks menu (Esc > Advanced Options)

## Mods:

### buff-restyle
Restyles buff and debuff font and timer<br>

##### Preview:
<img src="https://raw.githubusercontent.com/GryllsAddons/AddonPreviews/main/ShaguTweaks-Mods/ST_BuffRestyle.png" width=15% height=15%/>

### cursor-tooltip
Attaches the tooltip to the cursor<br>

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

### minimap-fps
Adds a fps display to the bottomleft of the minimap<br>
Mouseover to see the high and low fps for your WoW session<br>
The display will be hidden unless your FPS falls below the target FPS (set at the top line of the minimap-fps.lua file - default 60)<br>
The color will change in relation to the target fps

### minimap-ms
Adds a ms display to the bottomright of the minimap<br>
Mouseover to see the high and low ms for your WoW session<br>
The display will be hidden unless your ms increases above the target ms (set at the top line of the minimap-ms.lua file - default 150)<br>
The color will change in relation to the target ms

##### Preview:
<img src="https://raw.githubusercontent.com/GryllsAddons/AddonPreviews/main/ShaguTweaks-Mods/ST_FPSMS.png" width=20% height=20%/><br>

### minimap-restyle
Restyles the minimap<br>
Adds square Tracking and Mail icons and repositions the PVP icon when using the square minimap module<br>
Restyles the Zone Text, Clock, FPS and MS display

If you are using the [MinimapButtonBag](https://github.com/McPewPew/MinimapButtonBag-TurtleWoW) addon the MinimapButtonBag button will be repositioned below the minimap or clock<br>
The MinimapButtonBag button will be hidden unless you mouse over it<br>

##### Preview:
<img src="https://raw.githubusercontent.com/GryllsAddons/AddonPreviews/main/ShaguTweaks-Mods/ST_Restyle.png" width=20% height=20%/>

### nameplate-lowhealth
Recolors the nameplate when an enemy or friendly is at low health (20% or lower)<br>
Enemy health will be colored orange<br>
Friendly health will be colored blue<br>
The colors can be customised by editing the .lua file

##### Preview:
<img src="https://raw.githubusercontent.com/GryllsAddons/AddonPreviews/main/ShaguTweaks-Mods/ST_Lowhealth.png" width=20% height=20%/>

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
