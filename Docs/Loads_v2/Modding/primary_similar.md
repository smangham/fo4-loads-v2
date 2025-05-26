# New Primary Mode Weapons

It's fairly straightforward to add the ability for a weapon to use primary modes.
It's easiest to copy the set-up of weapon modes from an existing weapon to a new one,
e.g. the common set-up for ballistic weapons of automatic and/or silenced modes.

1. **Create a new Primary Modes master list for your weapon**
   Copy an existing weapon mode list for a weapon that has the same set-up,
   e.g. the Assault or Hunting Rifle, and copy all the lists referenced in it.
   (E.g. copy `a0aLOADS_FLST_PrimaryMode_WeapHuntingRifle`, `a0aLOADS_FLST_PrimaryMode_WeapHuntingRifle_Allowed_KYWD`, `a0aLOADS_FLST_PrimaryMode_WeapHuntingRifle_Selected_KYWD` and `a0aLOADS_FLST_PrimaryMode_WeapHuntingRifle_Selected_OMOD`).

2. **Update your new Primary Modes master list**
   You need to update it to use your new copies of the original lists,
   in a matching order. E.g. `MyGun_PrimaryModes` should contain:

   | Index | ObjectID                           |
   | ----- | ---------------------------------- |
   | 0     | `MyGun_PrimaryModes_Allowed_KYWD`  |
   | 1     | `MyGun_PrimaryModes_Selected_KYWD` |
   | 2     | `MyGun_PrimaryModes_Selected_OMOD` |

3. **Copy the Object Modifiers for the modes you're copying**
   Leave the `a0aLOADS_OMOD_PrimaryMode_Default` entry in index 0.
   Create copies of the other object modifiers in the `_Selected_OMOD` list, and then update the list to use those copies.
   E.g. if `MyGun_PrimaryModes_Selected_OMOD` contains `a0aLOADS_OMOD_PrimaryMode_WeapHuntingRifle_Muzzle_Suppressor`,
   create a copy of it named `MyGun_PrimaryModes_Suppressor` and update the list `MyGun_PrimaryModes_Selected_OMOD` to use it.
   This should effectively make the `MyGun_PrimaryModes` list of lists into a table:

   | Index | `MyGun_PrimaryModes_Allowed_KYWD`              | `MyGun_PrimaryModes_Selected_KYWD`              | `MyGun_PrimaryModes_Selected_OMOD`   |
   | ----- | ---------------------------------------------- | ----------------------------------------------- | ------------------------------------ |
   | 0     | `a0aLOADS_KYWD_PrimaryMode_Default_Allowed`    | `a0aLOADS_KYWD_PrimaryMode_Default_Selected`    | `a0aLOADS_OMOD_PrimaryMode_Default`  |
   | 1     | `a0aLOADS_KYWD_PrimaryMode_Suppressor_Allowed` | `a0aLOADS_KYWD_PrimaryMode_Suppressor_Selected` | `MyGun_PrimaryModes_Suppressor_OMOD` |

4. **Update the Object Modifiers as needed**
   You probably won't need to do much if you copy a similar enough weapon. They need:
   * **Attach Point:** `a0aLOADS_KYWD_Slot_PrimaryMode`
   * **Add -> Keywords:** The matching 'selected' keyword (e.g.`_TEMPLATE_KYWD_Weap10mm_NewPrimaryMode_Active`).

5. **Create Patch Form List:** *Loads* adds new weapons that can have modes using scripts,
   to avoid conflicts.
   Create a new `FLST` for your mode (e.g. `MyGun_PrimaryModes_Patch`).
   It needs to contain, *in the following order*,
   the weapon type keyword you're adding the modes for (e.g. `ma_MyGun` for your gun),
   and your primary modes master list (e.g. `MyGun_PrimaryModes`).

   | Index | ObjectID             |
   | ----- | -------------------- |
   | 0     | `ma_MyGun`           |
   | 1     | `MyGun_PrimaryModes` |

6. **Create Patch Quest:** You need to register the `FLST` with the details of your mode with *Loads*.
   Create a new `QST` that uses the `QST_LoadsPatcherScript` script (e.g. `_TEMPLATE_QST_LoadsPatcher`).
   Then, edit the `NewWeaponsWithPrimaryModes` property and add your patch form list (e.g. `MyGun_PrimaryModes`).
   You can add multiple new weapons, with a new patch list for each.

Now you're done! When the player activates your mod, it'll automatically register the primary modes for your new weapon.

## Updating Your Mod

The registration quest will only run once.
If you update your mod and want to add more weapons with Primary Modes,
you'll need to create a new copy of the Patch Quest, with just the new ones in.

If you want to add new Primary Modes, you can just add them straight to your formlists.
People can also use the patch framework to expand your weapon's Primary Modes in other mods -
[see Adding Modes to An Existing Weapon](./primary.md).

### IMPORTANT

Don't add them to *both* the old *and* new quest.
Each new weapon that can take primary modes should only be added once.
It shouldn't *break*, but it will be inefficient.

## FAQ

See [the FAQ page](./faq.md).
