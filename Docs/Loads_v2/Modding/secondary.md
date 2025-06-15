# New Secondary Weapons

If you'd like to create a new secondary weapon/mode for an existing weapon,
look at `a0aLOADS_FLST_Secondary_WeapCombatRifle` in `Loads_v2.esm`.

Each new secondary weapon/mode requires 3 (or 4) things:

* **Object Modifier - Secondary Weapon Fitted (`OMOD`)**
  * The weapon mod the player installs to add the secondary weapon.
  * E.g. `a0aLOADS_OMOD_Secondary_WeapCombatRifle_Barrel_ShortFlamer`.
* **Keyword - Secondary Weapon Fitted (`KYWD`)**
  * The keyword the `OMOD` applies, that flags the weapon as having that mode as an option.
  * E.g. `a0aLOADS_KYWD_Secondary_WeapCombatRifle_Barrel_ShortFlamer`.
* **Object Modifier - Secondary Weapon Active (`OMOD`)**
  * The effects the secondary weapon applies when active.
  * E.g. `a0aLOADS_OMOD_Secondary_WeapCombatRifle_Barrel_ShortFlamer_Active`
* **Crafting Recipe (`COBJ`, optional)**
  * The recipe used to build the `OMOD` that fits the secondary weapon.
  * E.g. `a0aLOADS_COBJ_WeapCombatRifle_Barrel_Flamer`.

## Custom Secondary Weapons

If you want to make a new secondary weapon for an existing weapon,
it's easiest to copy the setup for the Combat Rifle.

1. **Create Fitted Keyword:** Create a new `KYWD` for your mode
   (e.g. `a0aLOADS_KYWD_Secondary_WeapCombatRifle_Barrel_ShortFlamer`).
2. **Create Object Modifier - Secondary Weapon Fitted:** Create a new `OMOD` for your weapon,
  that flag it as having a secondary weapon/mode fitted
   (e.g. `a0aLOADS_OMOD_Secondary_WeapCombatRifle_Barrel_ShortFlamer`). It needs:
   * **Add -> Keywords:** The 'this weapon has a secondary weapon' keyword, `a0aLOADS_KYWD_Secondary`.
   * **Add -> Keywords:** Your new secondary weapon keyword (e.g.`a0aLOADS_KYWD_Secondary_WeapCombatRifle_Barrel_ShortFlamer`).
     Unlike primary fire modes, you can only have a *single* secondary weapon/mode per weapon.
   * **Attach Parent Slots**: Must include `a0aLOADS_KYWD_Slot_Secondary`, which is used to apply the effect.
3. **Create Object Modifier - Secondary Weapon Active:** Create a new `OMOD` for your mode,
   that will be equipped when it's active
   (e.g. `a0aLOADS_OMOD_Secondary_WeapCombatRifle_Barrel_ShortFlamer_Active`). It needs:
   * **Attach Point:** `a0aLOADS_KYWD_Slot_Secondary`
   * **Add -> Keywords:** The 'there is an active secondary weapon' keyword, `a0aLOADS_KYWD_Secondary_Active`.
4. **Create Crafting Recipe:** Create a new `COBJ` for the Object Modifier
  that fits your new secondary weapon
  (e.g. `a0aLOADS_COBJ_WeapCombatRifle_Barrel_Flamer`). It needs:
   * **Created Object:** Your new 'secondary weapon fitted' object modifier (e.g. `a0aLOADS_OMOD_Secondary_WeapCombatRifle_Barrel_ShortFlamer`).
5. **Create Patch Form List:** *Loads* adds new secondary weapons using scripts, to avoid conflicts.
   Create a new `FLST` for your mode (e.g. `MyWeap_SecondaryPatch`).
   It needs to contain, *in the following order*,
   the secondary weapon list for the weapon you're adding this to (e.g. `a0aLOADS_FLST_Secondary_WeapCombatRifle` for the Combat Rifle),
   the ammo list for the secondary weapon/mode, the 'Secondary Weapon Fitted' `KYWD`, and the `OMOD` that applies the effects.

   | Index | ObjectID                                                            |
   | ----- | ------------------------------------------------------------------- |
   | 0     | `a0aLOADS_FLST_Secondary_WeapCombatRifle`                           |
   | 1     | `a0aLOADS_FLST_AmmoFlamerFuel`                                      |
   | 2     | `a0aLOADS_KYWD_Secondary_WeapCombatRifle_Barrel_ShortFlamer`        |
   | 3     | `a0aLOADS_OMOD_Secondary_WeapCombatRifle_Barrel_ShortFlamer_Active` |

6. **Create Patch Quest:** You need to register the `FLST` with the details of your mode with *Loads*.
   Create a new `QST` that uses the `QST_LoadsPatcherScript` script (e.g. `_TEMPLATE_QST_LoadsPatcher`).
   Then, edit the `NewSecondaries` property and add your patch form list (e.g. `MyWeap_SecondaryPatch`).
   You can add multiple new secondary weapons/modes, with a new patch list for each.

Now you're done! When the player activates your mod, it'll automatically register your new secondary weapon/mode.

## Updating Your Mod

The registration quest will only run once.
If you update your mod and want to add more secondary weapons/modes,
you'll need to create a new copy of the Patch Quest, with just the new modes in.

### IMPORTANT

Don't add them to *both* the old *and* new quest.
Each mode should only be added once.
It shouldn't *break*, but it will be inefficient.

## FAQ

See [the FAQ page](./faq.md).
