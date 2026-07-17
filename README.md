# Farm Buddy

<p align="center">
  <img width="380" src="assets/logo.png" alt="Projekt Logo">
</p>

**Farm Buddy** is a World of Warcraft AddOn that helps you track items while farming.

Track an item from your inventory or bank, set an optional target quantity, and follow your progress through a configurable progress bar or text display. Farm Buddy notifies you when you reach your goal and shows any amount collected beyond it.

> **Quickstart:** Hold **Alt** and **left-click** an item in your bags or bank to start tracking it.  
> You can change this shortcut or enter an item manually in the AddOn settings.

## Features

*   Track farmed items and monitor your progress while playing
*   Count items in your inventory only, or in both inventory and bank
*   Set an optional target quantity for each tracked item
*   Display progress as a progress bar or text
*   Show the amount collected beyond 100% of your target
*   Receive a notification when a target quantity is reached
*   Select an optional notification sound
*   Customize notification effects
*   Configure a custom shortcut for quick tracking (default: **Alt + left-click**)
*   Available in English and German

## How to Use

1.  Install **Farm Buddy** and log in to the game.
2.  Hold **Alt** and left-click an item in your bags or bank to start tracking it.
3.  Alternatively, open the Farm Buddy settings and enter an item name, item ID, or item link manually.
4.  Choose whether Farm Buddy should count your inventory only or both inventory and bank.
5.  Optionally set a target quantity, progress display mode, notification effect, and sound.
6.  Continue farming and watch your progress in the Farm Buddy display.

## Important Note

Due to World of Warcraft API limitations, Farm Buddy can only track items already known to your game client.

Items are typically known after they have appeared in your inventory, bank, or an item tooltip. When adding an item manually, using an **item ID** or **item link** is recommended because it is more reliable than entering an item name.

## Chat Commands

*   `/fbs track <item ID | item name | item link> (<quantity>)` — Sets the tracked item and, optionally, its target quantity
*   `/fbs quantity <item ID | item name | item link> <quantity>` — Sets the target quantity for an item
*   `/fbs settings` — Opens the AddOn settings
*   `/fbs reset <all | items>` — Resets all Farm Buddy settings or only the tracked items
*   `/fbs version` — Shows the installed Farm Buddy version
*   `/fbs help` — Shows all available chat commands

## Bug Reports and Feature Requests

Please use the [CurseForge issue tracker](https://wow.curseforge.com/projects/farm-buddy/issues) to report bugs or request features.

## Support

If you would like to support the development of Farm Buddy, you can do so on [Patreon](https://www.patreon.com/c/keldor).
