# ShaguTweaks-Mods
Custom mods for the [ShaguTweaks](https://shagu.org/ShaguTweaks/) addon

### Credit:<br>
Credit to [shagu](https://github.com/shagu)
<br>
Code from [pfUI](https://shagu.org/pfUI/)

### Installation

##### 1: Copy the .lua files inside the mods folder to \Interface\AddOns\ShaguTweaks\mods

##### 2: Add the following lines to ShaguTweaks.toc:
<i>
mods\cursor-tooltip.lua<br>
mods\hide-combat-tooltip.lua<br>
mods\nameplate-lowhealth.lua<br>
mods\minimap-fps.lua<br>
mods\minimap-ms.lua<br>
mods\minimap-restyle.lua<br>
</i>
<br>
You should now be able to enable the mods by selecting them in the ShaguTweaks menu (Esc > Advanced Options)

### Description
### cursor-tooltip
Attaches the tooltip to the cursor<br>

### Preview:
<img src="https://raw.githubusercontent.com/GryllsAddons/AddonPreviews/main/ShaguTweaks-Mods/ST_TooltipCursor.png" width=20% height=20%/><br>

### hide-combat-tooltip
Hides the tooltip while in combat<br>
While in combat, holding shift while mousing over a new target will show the tooltip<br>

### nameplate-lowhealth
Recolors the nameplate when an enemy or friendly is at low health (20% or lower)<br>
Enemy health will be colored orange<br>
Friendly health will be colored blue<br>
The colors can be customised by editing the .lua file<br>

### Preview:
<img src="https://raw.githubusercontent.com/GryllsAddons/AddonPreviews/main/ShaguTweaks-Mods/ST_Lowhealth.png" width=20% height=20%/><br>

### minimap-fps
Adds a fps display to the bottomleft of the minimap<br>
Mouseover to see the high and low fps for your WoW session<br>
The display will be hidden unless your FPS falls below the target FPS (set at the top line of the minimap-fps.lua file - default 60)<br>
The color will change in relation to the target fps<br>

### minimap-ms
Adds a ms display to the bottomright of the minimap<br>
Mouseover to see the high and low ms for your WoW session<br>
The display will be hidden unless your ms increases above the target ms (set at the top line of the minimap-ms.lua file - default 150)<br>
The color will change in relation to the target ms<br>

### Preview:
<img src="https://raw.githubusercontent.com/GryllsAddons/AddonPreviews/main/ShaguTweaks-Mods/ST_FPSMS.png" width=20% height=20%/><br>

### minimap-restyle
Restyles the minimap<br>
Adds square Tracking and Mail icons and repositions the PVP icon when using the square minimap module<br>
Restyles the Zone Text, Clock, FPS and MS display<br>

If you are using the [MinimapButtonBag](https://github.com/McPewPew/MinimapButtonBag-TurtleWoW) addon the MinimapButtonBag button will be repositioned below the minimap or clock<br>
The MinimapButtonBag button will be hidden unless you mouse over it<br>

### Preview:
<img src="https://raw.githubusercontent.com/GryllsAddons/AddonPreviews/main/ShaguTweaks-Mods/ST_Restyle.png" width=20% height=20%/><br>
