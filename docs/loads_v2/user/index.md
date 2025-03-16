# Getting Started

## First Steps
### Get Variant Ammunition

Build an **Ammunition Workbench** anywhere, and start crafting a bunch of variant ammunition for your weapons!
The workbench will only show recipes for ammunition you have in your inventory,
so you won't see the e.g. .32 variants unless you have some .32 rounds.

### Set Up Hotkeys

*Loads of Ammo* has 2 ways of switching - either with hotkey items, or using **MCM Hotkeys**.
At a minimum, you'll need the **Context Hotkeys** for **Next**, **Previous** and **Toggle**.

* **Hotkey Items:** Craft these at the **MCM Workbench**, and assign them into your usual hotkey slots.

* **MCM Hotkeys:** Open the pause menu and use the MCM sub-menu for *Loads v2* to assign hotkeys.

### Equip Your Weapon

You're ready to go! *Loads of Ammo* has the following features:

## Ammunition Switching

Each calibre of ammunition can have a wide range of variants, e.g. incendiary, armour-piercing, or tracer.
*Loads* uses 'calibre' to refer to a category of ammo, e.g. .32, Fusion Cell, or even Missiles.

* **Context - Next / Previous:** Switches to the next/previous ammo variant you have for the current weapon.
* **Context - Default:** Switches to the default ammo variant you have for the current weapon.

You can jump straight to specific 'types' of ammo using Type Hotkeys. Set them in MCM, or craft them:

* **Type - Anti-Armour / Anti-Personnel / Short Range / Long Range** are self-explanatory.
* **Type - Superior** ammo is better than the default at all ranges, against any targets.

## Scope Zoom & Modes

When you're zoomed in with a scope, the context hotkeys switch to managing it.

* **Context - Next / Previous:** Zooms in or out.
* **Context - Default:** Returns to default (maximum) zoom.
* **Context - Toggle:** Switches between normal and alternate scope mode.

Scopes with alternate modes are:

* **Night Vision** <-> **Normal**.
* **Recon Night Vision** <-> **Recon**.

## Secondary Fire

Some weapons can be equipped with secondary weapons or modes - like underslung grenade launchers.
You can *also* switch between ammo types for the secondary weapon/mode.

* **Context - Toggle:** Activates or deactivates the secondary weapon.

Craft a weapon mod to add a secondary mode! *Loads* starts out with:

* **Combat Rifle**
  * **Under-barrel flamethrower**
  * **Under-barrel grenade launcher**
* **Missile Launcher**
  * **Targeting System (Secondary):** When active, causes missiles to home on their targets.
* **Fat Man**
  * **MIRV Barrel (Secondary):** When active, causes basic Mini Nukes to split into MIRVs.
    *(Arguably, MIRV rounds should be an ammo type instead...?)*

## Primary Modes

Some weapons can have optional primary modes that can be switched between, like silenced or full-auto mode.

* **Primary Mode - Next / Previous:** Switches to the next/previous mode for the current weapon.
* **Primary Mode - Default:** Switches to the default mode.

Craft a weapon mod to add a primary mode! *Loads* starts out with:

* **10mm Pistol / Assault Rifle / Combat Rifle / Handmade Gun / Pipe Gun / Radium Rifle / Shotgun**
  * Automatic Mode
  * Suppressed Mode

* **Deliverer Pistol / Gauss Rifle / Hunting Rifle / Lever Gun / Pipe Bolt-Action / Pipe Revolver**
  * Suppressed Mode

* **Laser Gun / Institute Laser / Railway Rifle**
  * Automatic Mode

* **Plasma Gun**
  * Automatic Mode
  * Shotgun Mode

* **Gamma Gun**
  * Automatic Mode
  * Charged Mode

### FAQ

> What's the difference between Primary and Secondary Modes?

Secondary modes can have different ammo and/or different projectiles per ammo variant.
For example, the missile launcher needs to fire different projectiles that have tracking.

> Can I use multiple primary modes at once?

Nope, you can have e.g. *either* automatic *or* suppressed mode active.
If you want suppressed automatic fire, build a gun with a non-mode Suppressor.

## Compatibility

You should be able to switch ammo for any weapon that uses a vanilla calibre without a patch.
However, this functionality uses the `NULL` modification slot, which some other mods do too.
If you get a conflict, you can fix it with a patch.

Rechambers/ammunition conversions rely on keywords on the object modification.
If you find a rechamber doesn't stick (switching ammo starts equipping variants of the *default* ammo),
then you can fix it with a patch.

Zooming and scope type toggling needs keywords applied to the scope modifications.
This requires a patch.

Primary and Secondary modes are unlocked using weapon modifications.
If you use a mod that rebalances weapons, you'll want a balance patch for the *Loads* modifications.

## Modding

You can add new ammo variants, calibres, types of scope, primary or secondary modes *fairly* easily.
Take a look at [the modding guide here](modding/index.md).
