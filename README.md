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
mods\actionbar-hide-hotkey.lua<br>
mods\actionbar-hide-macro.lua<br>
mods\actionbar-mouseover-bar-bottomleft.lua<br>
mods\actionbar-mouseover-bar-bottomright.lua<br>
mods\actionbar-mouseover-bar-right.lua<br>
mods\actionbar-mouseover-bar-right2.lua<br>
mods\actionbar-improved-exp.lua<br>
mods\basic-chat.lua<br>
mods\central-ui.lua<br>
mods\cursor-tooltip.lua<br>
mods\healthbar-color<br>
mods\hide-combat-tooltip.lua<br>
mods\hide-ui-frames.lua<br>
mods\improved-advanced-options.lua<br>
mods\improved-interface-options.lua<br>
mods\minimap-framerate-latency.lua<br>
mods\ui-restyle.lua<br>
mods\unitframes-classportrait-tot.lua<br>
mods\unitframes-combat-indicator.lua<br>
mods\unitframes-energy-tick.lua<br>
mods\unitframes-namecolor.lua<br>
</i>

##### You should now be able to enable the mod(s) by selecting them in the ShaguTweaks menu (Esc > Advanced Options)

## Mods:

### actionbar-hide-hotkey
Hides the hotkeys on the action bars

### actionbar-hide-macro
Hides the macros on the action bars

### actionbar-mouseover-bar-bottomleft
Hide the Bottom Left ActionBar and show on mouseover.<br>
The action bar must be enabled in 'Interface Options' > 'Advanced Options'.<br>
Please reload the UI after enabling or disabling the action bar.

### actionbar-mouseover-bar-bottomright
Hide the Bottom Right ActionBar and show on mouseover.<br>
The action bar must be enabled in 'Interface Options' > 'Advanced Options'.<br>
Please reload the UI after enabling or disabling the action bar.

### actionbar-mouseover-bar-right
Hide the Right ActionBar and show on mouseover.<br>
The action bar must be enabled in 'Interface Options' > 'Advanced Options'.<br>
Please reload the UI after enabling or disabling the action bar.

### actionbar-mouseover-bar-right2
Hide the Right ActionBar 2 and show on mouseover.<br>
The action bar must be enabled in 'Interface Options' > 'Advanced Options'.<br>
Please reload the UI after enabling or disabling the action bar.

### actionbar-improved-exp
Shows detailed exp, rested exp and rep values on mouseover.

##### Preview:
<img src="https://github.com/GryllsAddons/AddonPreviews/blob/main/ShaguTweaks-Mods/ST_ImpExp1.png" width=50% height=20%/>

##### Preview:
<img src="https://github.com/GryllsAddons/AddonPreviews/blob/main/ShaguTweaks-Mods/ST_ImpExp2.png" width=50% height=20%/>

### basic-chat
Create General, Combat Log and 'Loot & Spam' chat boxes and setup chat channels.<br>
The mod will create and reposition the chat boxes and setup channels on every login unless disabled.

### central-ui.lua
Moves the unit frames, castbar, buffs and minimap into a more central layout

### cursor-tooltip
Attaches the tooltip to the cursor

##### Preview:
<img src="https://raw.githubusercontent.com/GryllsAddons/AddonPreviews/main/ShaguTweaks-Mods/ST_TooltipCursor.png" width=20% height=20%/>

### healthbar-colors
Changes the unitframe and nameplate healthbar color when at 20% health or lower.<br>
Adds Hunter pet healthbar coloring by happiness.<br>
Enemy health will be colored orange<br>
Friendly health will be colored blue<br>

##### Preview:
<img src="https://raw.githubusercontent.com/GryllsAddons/AddonPreviews/main/ShaguTweaks-Mods/ST_Lowhealth2.png" width=30% height=30%/>

### hide-combat-tooltip
Hides the tooltip while in combat<br>
While in combat, holding shift will show the tooltip.

### hide-ui-frames
A framework for hiding UI frames.<br>
Hides the player and pet frame based on conditions.<br>
Additional configuration available in the .lua.

### improved-advanced-options.lua
Advanced Options menu tweaks.

### improved-interface-options
Rescales the interface options menu and removes the background.

### minimap-framerate-latency.lua
Adds a small framerate & latency display to the mini map.<br>
Mouseover to see the high and low framerate and latency for your WoW session.<br>
The color will change in relation to the target values set in the minimap-framerate-latency.lua.

##### Preview:
<img src="https://raw.githubusercontent.com/GryllsAddons/AddonPreviews/main/ShaguTweaks-Mods/ST_FPSMS2.png" width=20% height=20%/><br>

### unitframes-classportrait-tot
Extends class portraits to Target of Target.

##### Preview:
<img src="https://raw.githubusercontent.com/GryllsAddons/AddonPreviews/main/ShaguTweaks-Mods/ST_TOTPortrait.png" width=20% height=20%/>

### unitframes-combat-indicator
Adds a combat indicator to the target frame

##### Preview:
<img src="https://raw.githubusercontent.com/GryllsAddons/AddonPreviews/main/ShaguTweaks-Mods/ST_CombatIndicator.png" width=20% height=20%/>

### unitframes-energy-tick
Adds an energy tick to the player frame.

##### Preview:
<img src="https://github.com/GryllsAddons/AddonPreviews/blob/main/ShaguTweaks-Mods/ST_EnergyTick.png" width=20% height=20%/>

### ui-restyle
Restyles minimap, buff/debuffs, unitframe names and buttons.

##### minimap-restyle
Adds square Tracking and Mail icons and repositions the PVP icon when using the square minimap module.<br>
Restyles the Zone Text, Clock, FPS and MS display.

If you are using the [MinimapButtonBag-vanilla](https://github.com/laytya/MinimapButtonBag-vanilla) or [MinimapButtonBag-TurtleWoW](https://github.com/McPewPew/MinimapButtonBag-TurtleWoW) addon the MinimapButtonBag button will be repositioned below the minimap or clock.<br>
The MinimapButtonBag button will be hidden unless you mouse over it.<br>

##### Preview:
<img src="https://raw.githubusercontent.com/GryllsAddons/AddonPreviews/main/ShaguTweaks-Mods/ST_Restyle.png" width=20% height=20%/>

##### buff-restyle
Restyles buff and debuff font and timer.

##### Preview:
<img src="https://raw.githubusercontent.com/GryllsAddons/AddonPreviews/main/ShaguTweaks-Mods/ST_BuffRestyle.png" width=15% height=15%/>

##### unitframe-name-restyle
Adds an outline to unit names.

##### buttons
Changes button font

### unitframes-namecolor
Adds class and pet coloring (if Warlock or Hunter pet) to the unitframes.
