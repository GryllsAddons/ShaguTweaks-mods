# ShaguTweaks-Mods
Adds additional vanilla 1.12 custom mods to the [ShaguTweaks](https://shagu.org/ShaguTweaks/) addon.    
These mods aim to preserve the spirit of the default UI while providing modern quality of life features.

## Credit
Credit to [shagu](https://github.com/shagu)    
Code from [ShaguTweaks](https://shagu.org/ShaguTweaks/)    
Code from [pfUI](https://shagu.org/pfUI/)    
Code from [zUI](https://github.com/Ko0z/zUI)

## Installation
1. The "ShaguTweaks" folder provided with this download contains the mods and a .toc file to allow the mods to load.
2. Copy the "ShaguTweaks" folder (within the "ShaguTweaks-Mods-main" folder inside the .zip) to "\Interface\AddOns\"    
3. Replace/overwrite any existing files when copying
4. Enable the mod(s) by selecting them in the ShaguTweaks menu (Esc > Advanced Options)
5. When updating the ShaguTweaks addon, don't overwrite the .toc file supplied inside the "ShaguTweaks" folder

### Optional Install
The download contains an optional image file containing alternative high resolution unitframe class icons (UI-Classes-Circles.tga).    
Copy this file to the img folder located in "\Interface\AddOns\ShaguTweaks\img"

## Mods

- **Hide Hotkey Text**    
*mods\actionbar-hide-hotkey.lua*    
*Hides the hotkeys on the action bars.*

- **Hide Macro Text**    
*mods\actionbar-hide-macro.lua*    
*Hides the macros on the action bars.*

- **Quick Actions**    
*mods\actionbar-quick-actions.lua*    
*Action buttons will be activated on key down.*

- **Mouseover Bars**    
*The relevant action bar must be enabled in 'Interface Options' > 'Advanced Options'.*    
*Please reload the UI after enabling or disabling the action bar.*    

  ****Mouseover Bottom Left****    
  *mods\actionbar-mouseover-bar-bottomleft.lua*    
  *Hide the Bottom Left ActionBar and show on mouseover.*    
  *The pet/shapeshift/aura/stance bars will not be clickable if in the same position as the mouseover bar.*    

  ****Mouseover Bottom Right****    
  *mods\actionbar-mouseover-bar-bottomright.lua*    
  *Hide the Bottom Right ActionBar and show on mouseover.*    
  *The pet/shapeshift/aura/stance bars will not be clickable if in the same position as the mouseover bar.*    

  ****Mouseover Right****    
  *mods\actionbar-mouseover-bar-right.lua*    
  *Hide the Right ActionBar and show on mouseover.*    

  ****Mouseover Right 2****    
  *mods\actionbar-mouseover-bar-right2.lua*    
  *Hide the Right ActionBar 2 and show on mouseover.*

- **Improved Exp Bar**    
*mods\actionbar-improved-expbar.lua*    
*Improved exp information on mouseover.*    
*Shows rested percent while resting and changes color when fully rested.*

- **Range Color**    
*mods\actionbar-range-color.lua*    
*Action buttons will be colored red when out of range.*

- **Basic Chat**    
*mods\basic-chat.lua*    
*Creates General, Combat Log and 'Loot & Spam' chat boxes and resets chat channels on every login.*

- **Central UI**    
*mods\central-ui.lua*    
*Moves unit frames, minimap and buffs to a central layout.*

- **Central UI Windows**    
*mods\central-ui-windows.lua*    
*Makes interaction windows central and draggable.*    

- **Chat Tweaks Extended**    
*mods\chat-tweaks-extended.lua*    
*Extends "Chat Tweaks".*    
*Removes chat buttons, shortens channel names, shows item links on mouseover, adds Alt click chat names to invite and Ctrl click chat names to target.*

- **Cursor Tooltip**    
*mods\cursor-tooltip.lua*    
*Attaches the tooltip to the cursor.*

- **Hide Combat Tooltip**    
*mods\hide-combat-tooltip.lua*    
*Hides the tooltip while in combat.*
*While in combat, holding shift will show the tooltip.*

- **Hide UI Frames**    
*mods\hide-ui-frames.lua*    
*Hides the player and pet frame based on conditions.*

- **World Chat Hider**    
*mods\hide-world-chat.lua*    
*Looks for world chat in the chat frames and hides it while in an instance.*

- **Improved Castbar**    
*mods\improved-castbar.lua*    
*Adds a spell icon and remaining cast time to the castbar.*

- **Improved Interface Options**   
*mods\improved-interface-options.lua*     
*Rescales the interface options menu and removes the background.*

- **Improved Roll Frames**   
*mods\improved-roll-frames.lua*     
*Restyles the roll frames, shows who has clicked need/greed/pass (requires "Detailed Loot information" to be checked in interface options).*

- **Loot Monitor**    
*mods\loot-monitor.lua*    
*Display recent loot text in a central scrolling window.*    
*Hold Alt or Alt+Shift to scroll*    
*Hold Alt+Ctrl while scrolling to filter by quality.*    
*Click the item name to get item details.*    
*Items looted over 1 minute ago will be shown at 50% transparency.*    
*Items looted over 10 minutes ago will be shown at 25% transparency.*

- **MiniMap Framerate & Latency**    
*mods\minimap-framerate-latency.lua*    
*Adds a small framerate & latency display to the mini map.*

- **MiniMap Timer**    
*mods\minimap-timer.lua*    
*Adds a togglable timer to the minimap clock.*    
*Left click the clock to toggle the timer.*    
*Left click the timer to start or right click to reset.*

- **Modifier Actions**    
*mods\modifier-actions.lua*    
*Use Ctrl (C), Alt (A) & Shift (S) for in game actions.*    
*CAS: Logout, CA: Initiate/Accept Trade, CS: Follow, AS: Inspect, S: Sell & Repair.*

- **Mouseover Cast**    
*mods\mouseover.lua*    
*Adds /stcast and /stcastself functions for use in macros ([HCWarn](https://github.com/GryllsAddons/HCWarn) supported).*    
*/stcast functions like /pfcast in pfUI (same as /cast but for mouseover units). /stcastself will always cast the spell on yourself.*    
*examples: /stcast spellname, /stcastself spellname*

- **Pet Happiness Colors**    
*mods\pet-happiness-colors.lua*    
*Colors Hunter pet healthbar by happiness.*

- **Restyle UI**    
*mods\restyle-ui.lua*    
*Restyles supported addons, buffs, buttons, minimap and unit names.*    
*If you are using [MinimapButtonBag-vanilla](https://github.com/laytya/MinimapButtonBag-vanilla) or [MinimapButtonBag-TurtleWoW](https://github.com/McPewPew/MinimapButtonBag-TurtleWoW) the MinimapButtonBag button will be repositioned to the bottom left of the minimap and will shown on mouseover.*

- **Smaller Errors Frame**    
*mods\smaller-errors-frame.lua*    
*Resizes the error frame to 1 line instead of 3.*

- **Unit Frame Combat Indicator**    
*mods\unitframes-combat-indicator.lua*    
*Adds a combat indicator to the target frame.*

- **Unit Frame Energy & Mana Tick**    
*mods\unitframes-energy-tick.lua*    
*Adds an energy & mana tick to the player frame.*

- **Unit Frame Healthbar Colors**    
*mods\unitframes-healthbar-color.lua*    
*Changes the unitframe and nameplate healthbar color when at 20% health or lower.*

- **Unit Frame Name Class Colors**    
*mods\unitframes-nameclasscolor.lua*   
*Adds name class colors to the player, pet, target, tot and party unit frames.*

- **Unit Frame White Mana**    
*mods\unitframes-whitemana.lua*   
*Changes unit frame mana color to white.*

## Screenshots
![preview](https://raw.githubusercontent.com/GryllsAddons/AddonPreviews/main/ShaguTweaks-Mods/ST_ImpCastbar.png)    
*Improved Castbar*

![preview](https://github.com/GryllsAddons/AddonPreviews/blob/main/ShaguTweaks-Mods/ST_ImpExp1.png)   
*Improved Exp Bar*

![preview](https://github.com/GryllsAddons/AddonPreviews/blob/main/ShaguTweaks-Mods/ST_ImpExp2.png)   
*Improved Exp Bar*

![preview](https://github.com/GryllsAddons/AddonPreviews/blob/main/ShaguTweaks-Mods/ST_ImpExp3.png)   
*Improved Exp Bar*

![preview](https://raw.githubusercontent.com/GryllsAddons/AddonPreviews/main/ShaguTweaks-Mods/ST_TooltipCursor.png)  
*Cursor Tooltip*

![preview](https://raw.githubusercontent.com/GryllsAddons/AddonPreviews/main/ShaguTweaks-Mods/ST_LootMonitor1.png)  
*Loot Monitor*

![preview](https://raw.githubusercontent.com/GryllsAddons/AddonPreviews/main/ShaguTweaks-Mods/ST_LootMonitor2.png)  
*Loot Monitor*

![preview](https://raw.githubusercontent.com/GryllsAddons/AddonPreviews/main/ShaguTweaks-Mods/ST_LootMonitor3.png)  
*Loot Monitor*

![preview](https://raw.githubusercontent.com/GryllsAddons/AddonPreviews/main/ShaguTweaks-Mods/ST_FPSMS2.png)  
*MiniMap Framerate & Latency*

![preview](https://raw.githubusercontent.com/GryllsAddons/AddonPreviews/main/ShaguTweaks-Mods/ST_Timer.png)  
*MiniMap Timer*

![preview](https://raw.githubusercontent.com/GryllsAddons/AddonPreviews/main/ShaguTweaks-Mods/ST_Roll1.png)  
*Improved Roll Frames*

![preview](https://raw.githubusercontent.com/GryllsAddons/AddonPreviews/main/ShaguTweaks-Mods/ST_Roll2.png)  
*Improved Roll Frames*

![preview](https://raw.githubusercontent.com/GryllsAddons/AddonPreviews/main/ShaguTweaks-Mods/ST_CombatIndicator.png)  
*Unit Frame Combat Indicator*

![preview](https://raw.githubusercontent.com/GryllsAddons/AddonPreviews/main/ShaguTweaks-Mods/ST_UIRestyle.png)  
*Restyle UI*
