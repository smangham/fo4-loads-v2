# New Calibres

If you'd like to create a new calibre,
look at the example in `Loads_v2_template.esp`.

Each new calibre requires 4-6 things:

* **Ammo Form List (`FLST[AMMO]`)**
  * The list of ammo variants in this calibre,
    where the first entry is the 'default'.
  * In the example, `_TEMPLATE_FLST_AmmoNewCalibre_AMMO`.
* **Keyword Form List (`FLST[KYWD]`)**
  * The list of keywords applied by the object modifiers,
    used to tell which ammo variant is currently equipped.
  * In the example, `_TEMPLATE_FLST_AmmoNewCalibre_KYWD`.
* **Object Modifier Form List (`FLST[OMOD]`)**
  * The list of object modifiers that apply the effects of the ammo.
    These change the weapon to use the right `AMMO`, and apply the right `KYWD`.
  * In the example, `_TEMPLATE_FLST_AmmoNewCalibreOMOD`.
* **Master Form List (`FLST[FLST]`)**
  * The list of lists, used to match up an ammo with its keyword and modifier.
* **Converted Calibre Keyword (`KYWD`, optional)**
  * A keyword used to indicate when a weapon has been rechambered/converted into
    this new calibre (like `dn_hasReceiver_Converted44`).
  * In the example, `_TEMPLATE_dn_HasReceiver_ConvertedNewCalibre`.
* **Crafting Category Keyword (`KYWD`, optional)**
  * A keyword used to group crafting recipes for this calibre.
  * In the example, `_TEMPLATE_KYWD_Category_AmmoNewCalibre`.

If you want to make a new calibre,
it's easiest to copy and edit the template `.esp`:

1. **Create Ammo Form List:** Create a new `FLST` item
   (e.g. `_TEMPLATE_FLST_AmmoNewCalibre_AMMO`). It needs:
   * The 'default' ammo for your calibre first (index 0).
   * After that, the `AMMO` for the variants in this calibre.

2. **Create Keyword Form List:** Create a new `FLST` item
   (e.g.  `_TEMPLATE_FLST_AmmoNewCalibre_KYWD`). It needs:
   * The 'default' keyword `a0aLOADS_KYWD_Ammo_Default` first (index 0).
   * After that, the variant keywords for your variants of this calibre,
     in the same order as the corresponding `AMMO`.

3. **Create Object Modifier Form List:** Create a new `FLST` item
   (e.g.  `_TEMPLATE_FLST_AmmoNewCalibre_OMOD`). It needs:
   * The 'default' object modifier `a0aLOADS_OMOD_Ammo_Default` first (index 0).
   * After that, the object modifiers for your variants of this calibre,
     in the same order as the corresponding `AMMO` and `KYWD`.

4. **Create Master Form List:** Create a new `FLST` item
   (e.g.  `_TEMPLATE_FLST_AmmoNewCalibre`).
   It needs to contain, *in the following order*, the ammo form list,
   the keyword form list, and the object modifier form list. For example:

   | Index | ObjectID                             |
   | ----- | ------------------------------------ |
   | 0     | `_TEMPLATE_FLST_AmmoNewCalibre_AMMO` |
   | 1     | `_TEMPLATE_FLST_AmmoNewCalibre_KYWD` |
   | 2     | `_TEMPLATE_FLST_AmmoNewCalibre_OMOD` |

   This effectively creates a table. The example uses the 'generic' ballistic keywords:

   | Index | `_TEMPLATE_FLST_AmmoNewCalibre_AMMO` | `_TEMPLATE_FLST_AmmoNewCalibre_KYWD` | `_TEMPLATE_FLST_AmmoNewCalibre_OMOD` |
   | ----- | ------------------------------------ | ------------------------------------ | ------------------------------------ |
   | 0     | `_TEMPLATE_AmmoNewCalibre`           | `a0aLOADS_KYWD_Ammo_Default`         | `a0aLOADS_OMOD_Ammo_Default`         |
   | 1     | `_TEMPLATE_AmmoNewCalibre_AP`        | `a0aLOADS_KYWD_AmmoBallistic_AP`     | `_TEMPLATE_OMOD_AmmoNewCalibre_AP`   |
   | 2     | `_TEMPLATE_AmmoNewCalibre_DU`        | `a0aLOADS_KYWD_AmmoBallistic_DU`     | `_TEMPLATE_OMOD_AmmoNewCalibre_DU`   |

5. **Create Converted Calibre Keyword (optional):** Create a new `KYWD` for your calibre
   (e.g. `_TEMPLATE_dn_HasReceiver_ConvertedNewCalibre`).

6. **Create Crafting Category Keyword (optional):** Create a new `KYWD` for your calibre
   (e.g. `_TEMPLATE_KYWD_Category_AmmoNewCalibre`). It needs **Type -> Recipe Filter**.

7. **Create Patch Form List:** *Loads* adds new variants using scripts, to avoid conflicts.
   Create a new `FLST` for your calibre (e.g. `_TEMPLATE_FLST_PatchCalibre_AmmoNewCalibre`).
   It needs to contain, *in the following order*,
   the base ammo for your new calibre (e.g. `_TEMPLATE_AmmoNewCalibre`),
   and the master form list for youe new calibre (e.g. `_TEMPLATE_FLST_AmmoNewCalibre`). For example:

   | Index | ObjectID                        |
   | ----- | ------------------------------- |
   | 0     | `_TEMPLATE_AmmoNewCalibre`      |
   | 1     | `_TEMPLATE_FLST_AmmoNewCalibre` |

8. **Create Patch Form List for Conversion (optional):** If you created a conversion keyword,
   you also need to register your rechamber with *Loads*.
   It needs to contain, *in the following order*,
   the rechamber keyword for your new calibre (e.g. `_TEMPLATE_dn_HasReceiver_ConvertedNewCalibre`),
   and the master form list for youe new calibre (e.g. `_TEMPLATE_FLST_AmmoNewCalibre`). For example:

   | Index | ObjectID                                       |
   | ----- | ---------------------------------------------- |
   | 0     | `_TEMPLATE_dn_HasReceiver_ConvertedNewCalibre` |
   | 1     | `_TEMPLATE_FLST_AmmoNewCalibre`                |

9. **Create Patch Quest:** You need to register the `FLST` with the details of your calibre with *Loads*.
   Create a new `QST` that uses the `QST_LoadsPatcherScript` script (e.g. `_TEMPLATE_QST_LoadsPatcher`).
   Then, edit the `NewCalibres` property and add the new Patch Form List for your calibre (e.g. `_TEMPLATE_FLST_AmmoNewCalibre`).
   You can add multiple calibres, with a new Patch Form List for each.

   **Optionally,** if you created a converted calibre keyword and patch list for it,
   edit the `NewConvertedCalibres` property and add the new Patch Form List for Conversion for your calibre.

Now you're done! When the player activates your mod, it'll automatically register your new calibre.

## Updating Your Mod

The registration quest will only run once.
If you update your mod and want to add more calibres,
you'll need to create a new copy of the Patch Quest, with just the new calibres in.

### IMPORTANT

Don't add them to *both* the old *and* new quest.
Each calibre should only be added once. It shouldn't *break*, but it will be inefficient.

## FAQ

See [the FAQ page](./faq.md).
