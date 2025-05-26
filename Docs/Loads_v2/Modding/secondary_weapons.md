# New Weapons with Secondaries

It's fairly straightforward to add the ability for a weapon to use primary modes.
It's easiest to copy the set-up of weapon modes from an existing weapon to a new one,
e.g. the common set-up for ballistic weapons of automatic and/or silenced modes.

1. **Create a new Secondaries master list for your weapon**
   Copy an existing secondaries master list for a weapon,
   e.g. the Combat Rifle, and copy all the lists referenced in it.
   (E.g. copy `a0aLOADS_FLST_Secondary_WeapCombatRifle`, `a0aLOADS_FLST_Secondary_WeapCombatRifle_FLST`, `a0aLOADS_FLST_Secondary_WeapCombatRifle_KYWD` and `a0aLOADS_FLST_Secondary_WeapCombatRifle_OMOD`).

2. **Update your new Secondaries master list**
   You need to update it to use your new copies of the original lists,
   in a matching order. E.g. `MyGun_Secondaries` should contain:

   | Index | ObjectID                 |
   | ----- | ------------------------ |
   | 0     | `MyGun_Secondaries_FLST` |
   | 1     | `MyGun_Secondaries_KYWD` |
   | 2     | `MyGun_Secondaries_OMOD` |

   You can then make new `FLST`, `KYWD` and `OMOD` entries as required for your secondaries;
   see the guide on [Adding Secondaries to an Existing Weapon](./secondary.md) for what's needed.
   You can put them directly into your lists, instead of using the patch framework to add them.

3. **Create Patch Form List:** *Loads* adds new weapons that can have secondaries using scripts,
   to avoid conflicts.
   Create a new `FLST` for your mode (e.g. `MyGun_SecondariesPatch`).
   It needs to contain, *in the following order*,
   the weapon type keyword you're adding the modes for (e.g. `ma_MyGun` for your gun),
   and your secondaries master list (e.g. `MyGun_Secondaries`).

   | Index | ObjectID             |
   | ----- | -------------------- |
   | 0     | `ma_MyGun`           |
   | 1     | `MyGun_Secondaries`  |

4. **Create Patch Quest:** You need to register the `FLST` with the details of your mode with *Loads*.
   Create a new `QST` that uses the `QST_LoadsPatcherScript` script (e.g. `_TEMPLATE_QST_LoadsPatcher`).
   Then, edit the `NewWeaponsWithSecondaries` property and add your patch form list (e.g. `MyGun_SecondariesPatch`).
   You can add multiple new weapons with secondaries, with a new patch list for each.

Now you're done! When the player activates your mod, it'll automatically register the secondaries for your new weapon.

## Updating Your Mod

The registration quest will only run once.
If you update your mod and want to add more weapons with secondaries,
you'll need to create a new copy of the Patch Quest, with just the new ones in.

If you want to add new secondaries, you can just add them straight to your formlists.
People can also use the patch framework to expand your weapon's secondaries in other mods -
[see Adding Secondaries to An Existing Weapon](./secondary.md).

### IMPORTANT

Don't add them to *both* the old *and* new quest.
Each new weapon that can take secondaries should only be added once.
It shouldn't *break*, but it will be inefficient.

## FAQ

See [the FAQ page](./faq.md).
