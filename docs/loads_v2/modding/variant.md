# New Variants of Existing Calibres

If you'd like to create a new variant of an existing calibre,
look at the example in `Loads_v2_template.esp`.

Each new variant requires 4 (or 5) things:

* **Ammo (`AMMO`)**
  * The actual 'ammo' created and consumed.
  * In the example, `_TEMPLATE_Ammo10mm_NewVariant`.
* **Object Modifier (`OMOD`)**
  * The effects the ammo applies to the weapon.
  * In the example, `_TEMPLATE_OMOD_Ammo10mm_NewVariant`.
* **Keyword (`KYWD`)**
  * The keyword the ammo `OMOD` applies, used to tell which ammo is currently equipped.
  * In the example, `_TEMPLATE_KYWD_Ammo10mm_NewVariant`.
* **NPC Ammo List (`LVLI`, optional)**
  * The ammo that an NPC will have in inventory if they spawn with a weapon with the `OMOD` applied.
  * In the example, `_TEMPLATE_LL_Ammo10mm_NewVariant`.
* **Crafting Recipe (`COBJ`, optional)**
  * The ammo that an NPC will have in inventory if they spawn with a weapon with the `OMOD` applied.
  * In the example, `_TEMPLATE_COBJ_Ammo10mm_NewVariant`.

If you want to make a new ammo variant for an existing calibre,
it's easiest to copy and edit the template `.esp`:

1. **Create Ammo:** Create a new `AMMO` item (e.g. `_TEMPLATE_Ammo10mm_NewVariant`).

   Optionally, add some of the 'type' keyword to it to help with hotkeys:
   * `a0aLOADS_KYWD_AmmoType_RangeShort`/`a0aLOADS_KYWD_AmmoType_RangeLong`
     for ammo that's good at short or long range (e.g. tracers with low scatter are good long range rounds).
   * `a0aLOADS_KYWD_AmmoType_AntiArmour`/`a0aLOADS_KYWD_AmmoType_AntiPersonnel`
     for ammo good against armoured or unarmoured targets (e.g. AP rounds are good anti-armour).
   * `a0aLOADS_KYWD_AmmoType_Superior` for ammo that's better than the default
     in all situations (e.g. rounds that deal +25% damage).

2. **Create Keyword:** Create a new `KYWD` for your variant
   (e.g. `_TEMPLATE_KYWD_Ammo10mm_NewVariant`).
3. **Create NPC Ammo List (optional):** Create a new `LVLI` for your variant
   (e.g. `_TEMPLATE_LL_Ammo10mm_NewVariant`).
4. **Create Object Modifier:** Create a new `OMOD` for your variant
   (e.g. `_TEMPLATE_OMOD_Ammo10mm_NewVariant`). It needs:
   * **Attach Point:** `a0aLOADS_KYWD_Slot_Ammo`
   * **Set -> Ammo:** Your variant ammo (e.g. `_TEMPLATE_Ammo10mm_NewVariant`).
   * **Add -> Keywords:** Your variant keyword (e.g.`_TEMPLATE_KYWD_Ammo10mm_NewVariant`).
   * **Set -> NPCAmmoList (optional):** Your NPC ammo list (e.g. `_TEMPLATE_LL_Ammo10mm_NewVariant`).

5. **Create Crafting Recipe:** Create a new `COBJ` for your variant,
  (e.g. `_TEMPLATE_COBJ_Ammo10mm_NewVariant`). It needs:
   * **Created Object:** Your variant ammo (e.g. `TEMPLATE_Ammo10mm_NewVariant`).
   * **Workbench Keyword:** Ideally, `a0aLOADS_KYWD_Workbench`.
     You can always patch this or use a tool like RobCo Autopatcher for compatibility with ammo workbench mods.
   * **Category:** Whatever category is appropriate for the variant (e.g. `a0aLOADS_KYWD_Category_Ammo10mm`).
     You can always patch this or use a tool like RobCo Autopatcher for compatibility with ammo workbench mods.

6. **Create Patch Form List:** *Loads* adds new variants using scripts, to avoid conflicts.
   Create a new `FLST` for your variant (e.g. `_TEMPLATE_FLST_PatchVariant_10mm_NewVariant`).
   It needs to contain, *in the following order*,
   the master formlist for the calibre you're adding to (e.g. `a0aLOADS_FLST_Ammo10mm` for 10mm ammo),
   and then your ammo, variant keyword and object modifier. For example::

   | Index | ObjectID                             |
   | ----- | ------------------------------------ |
   | 0     | `a0aLOADS_FLST_Ammo10mm`             |
   | 1     | `_TEMPLATE_Ammo10mm_NewVariant`      |
   | 2     | `_TEMPLATE_KYWD_Ammo10mm_NewVariant` |
   | 3     | `_TEMPLATE_OMOD_Ammo10mm_NewVariant` |

7. **Create Patch Quest:** You need to register the `FLST` with the details of your variant with *Loads*.
   Create a new `QST` that uses the `QST_LoadsPatcherScript` script (e.g. `_TEMPLATE_QST_LoadsPatcher`).
   Then, edit the `NewAmmoVariants` property and add your patch form list (e.g. `_TEMPLATE_FLST_PatchVariant_10mm_NewVariant`).
   You can add multiple variants, with a new patch list for each.

Now you're done! When the player activates your mod, it'll automatically register your new variant.

## Updating Your Mod

The registration quest will only run once.
If you update your mod and want to add more variants,
you'll need to create a new copy of the Patch Quest, with just the new variants in.

### IMPORTANT

Don't add them to *both* the old *and* new quest.
Each variant should only be added once. It shouldn't *break*, but it will be inefficient.

## FAQ

See [the FAQ page](./faq.md).
