# ShaguTweaks-Mods
Adds additional vanilla 1.12 custom mods to the [ShaguTweaks](https://shagu.org/ShaguTweaks/) addon.    
These mods aim to preserve the spirit of the default UI while providing modern quality of life features.

## Credit
Credit to [shagu](https://github.com/shagu)    
Code from [ShaguTweaks](https://shagu.org/ShaguTweaks/)    
Code from [pfUI](https://shagu.org/pfUI/)    
Code from [zUI](https://github.com/Ko0z/zUI)

## Installation
#### The mods included with this download require [ShaguTweaks](https://shagu.org/ShaguTweaks/) to work.    
This download contains a mods folder and a .toc file to allow the mods to load.

1. Install [ShaguTweaks](https://shagu.org/ShaguTweaks/) if not already installed.
2. Unpack the Zip file included with this download.
3. Copy the "ShaguTweaks" folder within "ShaguTweaks-Mods-main" to "\Interface\AddOns\".    
4. Replace/overwrite any existing files when copying.
5. Once in game, enable the mod(s) by selecting them in the ShaguTweaks menu (Esc > Advanced Options).
6. (Optional) The download contains an image file containing alternative high resolution unitframe class icons (UI-Classes-Circles.tga). Copy this file to "\Interface\AddOns\ShaguTweaks\img".

#### When updating the ShaguTweaks addon, don't overwrite the .toc file supplied inside the "ShaguTweaks" folder.

## Mods

- **Accept Group Invites**    
*Accept group invites from friends and guildies.*

- **Hide Hotkey Text**    
*Hides the hotkeys on the action bars.*

- **Hide Macro Text**    
*Hides the macros on the action bars.*

- **Improved Exp Bar**    
*Shows rested percent while resting and changes color when fully rested.*    
*Improved exp information on mouseover.*    

- **Macro Icons & Cooldowns**    
*Show macro icons & cooldowns on the action bars.*    
In order to have the range and mana colors show on macros, you have to write the following line at the top of each macro:    
***/run if nil then CastSpellByName("SPELLNAME"); end***    
Make sure to replace ***SPELLNAME*** with the actual name of your spell.

- **Mouseover Bars**    
*Hides the relevant action bar and shows on mouseover.*    
*The action bar must be enabled in 'Interface Options' > 'Advanced Options'.*    
*Please reload the UI after enabling or disabling the action bar.*    
*The pet/shapeshift/aura/stance bars will not be clickable if in the same position as the mouseover bar.*   

- **Quick Actions**    
*Action buttons will be activated on key down.*

- **Range Color**    
*Action buttons will be colored red when out of range.*

- **Basic Chat**    
*Creates General, Combat Log and 'Loot & Spam' chat boxes and resets chat channels on every login.*

- **Max Camera Distance**    
*Increases the maximum zoom out distance of the camera.*    

- **Central Interaction Windows**    
*Interaction windows will be positioned centrally.*    

- **Chat Tweaks Extended**    
*Extends "Chat Tweaks".*    
*Removes chat buttons, shortens channel names, shows item links on mouseover, adds Alt click chat names to invite and Ctrl click chat names to target.*

- **Cursor Tooltip**    
*Attaches the tooltip to the cursor.*

- **Real Health Numbers Extended**    
*Adds health numbers to ToT and party unit frames.*

- **Hide Combat Tooltip**    
*Hides the tooltip while in combat. While in combat, holding shift will show the tooltip.*

- **Hide Unit Frames**    
*Hide the player and pet frame if full health & mana, happy, no target and out of combat. Show on mouseover.*

- **World Chat Hider**    
*Looks for world chat in the chat frames and hides it while in an instance.*

- **Improved Advanced Options**   
*Allows moving and scaling of the Advanced Options menu (drag to move, ctrl + mousewheel to scale).*

- **Improved Castbar**    
*Adds a spell icon and remaining cast time to the castbar.*

- **Improved Interface Options**   
*Rescales the interface options menu and removes the background.*

- **Improved Roll Frames**   
*Restyles the roll frames, shows who has clicked need/greed/pass (requires "Detailed Loot information" to be checked in interface options).*

- **Loot Monitor**    
*Display recent loot text in a central scrolling window.*    
*Hold Alt or Alt+Shift to scroll*    
*Hold Alt+Ctrl while scrolling to filter by quality.*    
*Click the item name to get item details.*    
*Items looted over 1 minute ago will be shown at 50% transparency.*    
*Items looted over 10 minutes ago will be shown at 25% transparency.*

- **MiniMap Framerate & Latency**    
*Adds a small framerate & latency display to the mini map.*

- **MiniMap Timer**    
*Adds a togglable timer to the minimap clock.*    
*Left click the clock to toggle the timer, left click the timer to start/pause or right click to reset.*

- **Modifier Actions**    
*Use Ctrl (C), Alt (A) & Shift (S) for in game actions.*    
*S: Sell & Repair, A: Accept Release/Resurrect/Summon/Invite/Battleground, CA: Initiate/Accept Trade, CS: Follow, AS: Inspect, CAS: Logout.*

- **Mouseover Cast**    
*Adds /stcast and /stcastself functions for use in macros ([HCWarn](https://github.com/GryllsAddons/HCWarn) supported).*    
*/stcast functions like /pfcast in pfUI (same as /cast but for mouseover units). /stcastself will always cast the spell on yourself.*    
*examples: /stcast spellname, /stcastself spellname*

- **Movable Unitframes Extended**    
*Party frames, Minimap, Buffs, Weapon Buffs and Debuffs can be moved while Shift and Ctrl are pressed together. Drag the first (end) buff or debuff to move.*   

- **Pet Name Happiness**    
*Colors Hunter pet name by happiness level.*

- **Restyle UI**    
*Restyles supported addons and the minimap. Changes fonts for units, buffs, buttons & chat.*    
*Supported Addons:*    
*[SP_SwingTimer (vanilla)](https://github.com/EinBaum/SP_SwingTimer) / [SP_SwingTimer (TurtleWoW)](https://github.com/geojak/SP_SwingTimer): Style and Position*    
*[MinimapButtonBag (vanilla)](https://github.com/laytya/MinimapButtonBag-vanilla) / [MinimapButtonBag (TurtleWoW)](https://github.com/McPewPew/MinimapButtonBag-TurtleWoW): MinimapButtonBag button will be repositioned to the bottom left of the minimap and will shown on mouseover.*

- **Skip Gossip Text**    
*Skip gossip text when interacting with NPCs unless holding shift.*

- **Smaller Errors Frame**    
*Resizes the error frame to 1 line instead of 3.*

- **Unit Frame Combat Indicator**    
*Adds a combat indicator to the target frame.*

- **Unit Frame Energy & Mana Tick**    
*Adds an energy & mana tick to the player frame.*

- **Unit Frame Healthbar Colors**    
*Changes the unitframe and nameplate healthbar color when at 20% health or lower.*

- **Unit Frame White Mana**    
*Changes unit frame mana color to white.*

- **WorldMap Reveal**    
*Reveals unexplored areas on the world map.*    

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
