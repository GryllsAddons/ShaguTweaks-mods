# ShaguTweaks-Mods
Custom mods for the [ShaguTweaks](https://shagu.org/ShaguTweaks/) addon.    
These mods aim to preserve the spirit of the default UI while providing modern quality of life features.

## Credit
Credit to [shagu](https://github.com/shagu)
<br>
Code from [ShaguTweaks](https://shagu.org/ShaguTweaks/)
<br>
Code from [pfUI](https://shagu.org/pfUI/)

## Installation
1. Copy the .lua files inside the mods folder to <i>\Interface\AddOns\ShaguTweaks\mods</i>
2. Add the appropriate line(s) from the mods section below to <i>\Interface\AddOns\ShaguTweaks\ShaguTweaks.toc</i>
3. Enable the mod(s) by selecting them in the ShaguTweaks menu (Esc > Advanced Options)

## Mods
*mods\actionbar-hide-hotkey.lua*    
*mods\actionbar-hide-macro.lua*    
*mods\actionbar-mouseover-bar-bottomleft.lua*    
*mods\actionbar-mouseover-bar-bottomright.lua*    
*mods\actionbar-mouseover-bar-right.lua*    
*mods\actionbar-mouseover-bar-right2.lua*    
*mods\actionbar-improved-expbar.lua*    
*mods\basic-chat.lua*    
*mods\central-ui.lua*    
*mods\central-ui-windows.lua*    
*mods\cursor-tooltip.lua*    
*mods\hide-combat-tooltip.lua*    
*mods\hide-ui-frames.lua*    
*mods\improved-advanced-options.lua*    
*mods\improved-castbar.lua*    
*mods\improved-interface-options.lua*    
*mods\loot-monitor.lua*    
*mods\minimap-framerate-latency.lua*    
*mods\minimap-timer.lua*    
*mods\modifier-actions.lua*    
*mods\pet-happiness-colors.lua*    
*mods\restyle-ui.lua*    
*mods\smaller-errors-frame.lua*    
*mods\unitframes-classportrait-tot.lua*    
*mods\unitframes-combat-indicator.lua*    
*mods\unitframes-energy-tick.lua*    
*mods\unitframes-nameclasscolor.lua*

## Features
<img src="https://raw.githubusercontent.com/GryllsAddons/AddonPreviews/main/ShaguTweaks-Mods/ST_Restyle.png" width=40% height=40%/>

- **Hide Hotkey Text**    
*actionbar-hide-hotkey.lua*    
*Hides the hotkeys on the action bars.*

- **Hide Macro Text**    
*actionbar-hide-macro.lua*    
*Hides the macros on the action bars.*

- **Mouseover Bars**    
*The relevant action bar must be enabled in 'Interface Options' > 'Advanced Options'.*    
*Please reload the UI after enabling or disabling the action bar.*    

  ****Mouseover Bottom Left****    
  *actionbar-mouseover-bar-bottomleft.lua*    
  *Hide the Bottom Left ActionBar and show on mouseover.*    
  *The pet/shapeshift/aura/stance bars will not be clickable if in the same position as the mouseover bar.*    

  ****Mouseover Bottom Right****    
  *actionbar-mouseover-bar-bottomright.lua*    
  *Hide the Bottom Right ActionBar and show on mouseover.*    
  *The pet/shapeshift/aura/stance bars will not be clickable if in the same position as the mouseover bar.*    

  ****Mouseover Right****    
  *actionbar-mouseover-bar-right.lua*    
  *Hide the Right ActionBar and show on mouseover.*    

  ****Mouseover Right 2****    
  *actionbar-mouseover-bar-right2.lua*    
  *Hide the Right ActionBar 2 and show on mouseover.*

- **Improved Exp Bar**    
*actionbar-improved-expbar.lua*    
*Improved exp information on mouseover.*    
*Shows rested percent while resting and changes color when fully rested.*

- **Basic Chat**    
*basic-chat.lua*    
*Creates General, Combat Log and 'Loot & Spam' chat boxes and resets chat channels on every login.*

- **Central UI**    
*central-ui.lua*    
*Moves unit frames, minimap and buffs to a central layout.*

- **Central UI Windows**    
*central-ui-windows.lua*    
*Moves interaction windows to a central layout.*    

- **Cursor Tooltip**    
*cursor-tooltip.lua*    
*Attaches the tooltip to the cursor.*

- **Hide Combat Tooltip**    
*hide-combat-tooltip.lua*    
*Hides the tooltip while in combat.*
*While in combat, holding shift will show the tooltip.*

- **Hide UI Frames**    
*hide-ui-frames.lua*    
*Hides the player and pet frame based on conditions.*

- **Improved Advanced Options**    
*improved-advanced-options.lua*    
*Rescales the Advanced Options menu to fit the increased number of mods.*

- **Improved Castbar**    
*improved-castbar.lua*    
*Adds a spell icon and remaining cast time to the castbar.*

- **Improved Interface Options**   
*improved-interface-options.lua*     
*Rescales the interface options menu and removes the background.*

- **Loot Monitor**    
*loot-monitor.lua*    
*Display recent loot text in a central scrolling window.*    
*Hold Alt or Alt+Shift to scroll*    
*Hold Alt+Ctrl while scrolling to filter by quality.*    
*Click the item name to get item details.*    
*Items looted over 1 minute ago will be shown at 50% transparency.*    
*Items looted over 10 minutes ago will be shown at 25% transparency.*

- **MiniMap Framerate & Latency**    
*minimap-framerate-latency.lua*    
*Adds a small framerate & latency display to the mini map.*

- **MiniMap Timer**    
*minimap-timer.lua*    
*Adds a togglable timer to the minimap clock.*    
*Left click the clock to toggle the timer.*    
*Left click the timer to start or right click to reset.*

- **Modifier Actions**    
*modifier-actions.lua*    
*Use Ctrl (C), Alt (A) & Shift (S) for in game actions.*    
*CAS: Logout, CA: Initiate/Accept Trade, CS: Follow, AS: Inspect, S: Sell & Repair.*

- **Pet Happiness Colors**    
*pet-happiness-colors.lua*    
*Colors Hunter pet healthbar by happiness.*

- **Restyle UI**    
*restyle-ui.lua*    
*Restyles supported addons, buffs, buttons, minimap and unit names.*    
*If you are using [MinimapButtonBag-vanilla](https://github.com/laytya/MinimapButtonBag-vanilla) or [MinimapButtonBag-TurtleWoW](https://github.com/McPewPew/MinimapButtonBag-TurtleWoW) the MinimapButtonBag button will be repositioned to the bottom left of the minimap and will shown on mouseover.*

- **Smaller Errors Frame**    
*smaller-errors-frame.lua*    
*Resizes the error frame to 1 line instead of 3.*    

- **Unit Frame Class Portraits ToT**    
*unitframes-classportrait-tot.lua*    
*Extends class portraits to Target of Target.*

- **Unit Frame Combat Indicator**    
*unitframes-combat-indicator.lua*    
*Adds a combat indicator to the target frame.*

- **Unit Frame Energy & Mana Tick**    
*unitframes-energy-tick.lua*    
*Adds an energy & mana tick to the player frame.*

- **Unit Frame Name Class Colors**    
*unitframes-nameclasscolor.lua*   
*Adds name class colors to the player, pet, target, tot and party unit frames.*

## Screenshots
![preview](https://raw.githubusercontent.com/GryllsAddons/AddonPreviews/main/ShaguTweaks-Mods/ST_ImpCastbar.png)    
*improved-castbar*

![preview](https://github.com/GryllsAddons/AddonPreviews/blob/main/ShaguTweaks-Mods/ST_ImpExp1.png)   
*actionbar-improved-exp exp*

![preview](https://github.com/GryllsAddons/AddonPreviews/blob/main/ShaguTweaks-Mods/ST_ImpExp2.png)   
*actionbar-improved-exp rep*

![preview](https://github.com/GryllsAddons/AddonPreviews/blob/main/ShaguTweaks-Mods/ST_ImpExp3.png)   
*actionbar-improved-exp fully rested*

![preview](https://raw.githubusercontent.com/GryllsAddons/AddonPreviews/main/ShaguTweaks-Mods/ST_TooltipCursor.png)  
*cursor-tooltip*

![preview](https://raw.githubusercontent.com/GryllsAddons/AddonPreviews/main/ShaguTweaks-Mods/ST_LootMonitor1.png)  
*loot-monitor All loot*

![preview](https://raw.githubusercontent.com/GryllsAddons/AddonPreviews/main/ShaguTweaks-Mods/ST_LootMonitor2.png)  
*loot-monitor Poor loot*

![preview](https://raw.githubusercontent.com/GryllsAddons/AddonPreviews/main/ShaguTweaks-Mods/ST_LootMonitor3.png)  
*loot-monitor Common loot*

![preview](https://raw.githubusercontent.com/GryllsAddons/AddonPreviews/main/ShaguTweaks-Mods/ST_FPSMS2.png)  
*minimap-framerate-latency*

![preview](https://raw.githubusercontent.com/GryllsAddons/AddonPreviews/main/ShaguTweaks-Mods/ST_TOTPortrait.png)  
*unitframes-classportrait-tot*

![preview](https://raw.githubusercontent.com/GryllsAddons/AddonPreviews/main/ShaguTweaks-Mods/ST_CombatIndicator.png)  
*unitframes-combat-indicator*

![preview](https://raw.githubusercontent.com/GryllsAddons/AddonPreviews/main/ShaguTweaks-Mods/ST_UIRestyle.png)  
*restyle-ui minimap and MinimapButtonBag button*

![preview](https://raw.githubusercontent.com/GryllsAddons/AddonPreviews/main/ShaguTweaks-Mods/ST_BuffRestyle.png)  
*restyle-ui buffs*

![preview](https://raw.githubusercontent.com/GryllsAddons/AddonPreviews/main/ShaguTweaks-Mods/ST_Timer.png)  
*timer*
