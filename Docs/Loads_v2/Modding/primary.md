# New Primary Modes

If you'd like to create a new primary mode for an existing weapon,
look at the example in `Loads_v2_template.esp`.
It's a new grip for the 10mm pistol that adds a new firing mode.

Each new mode requires 5 (or 6) things:

* **Object Modifier - Mode Allowed (`OMOD`)**
  * The object mod that lets the weapon switch into your new mode.
  * In the example, `_TEMPLATE_OMOD_Weap10mm_Grip_NewPrimaryMode`.
* **Keyword - Mode Allowed (`KYWD`)**
  * The keyword the `OMOD` applies, that flags the weapon as having that mode as an option.
  * In the example, `_TEMPLATE_KYWD_Weap10mm_NewPrimaryMode`.
* **Object Modifier - Selected (`OMOD`)**
  * The effects the mode applies to the weapon when active.
  * In the example, `_TEMPLATE_OMOD_Weap10mm_Grip_NewPrimaryMode_Active`
* **Keyword - Mode Selected (`KYWD`)**
  * The keyword the mode selected `OMOD` applies, used to tell which mode is active.
  * In the example, `_TEMPLATE_KYWD_Weap10mm_NewPrimaryMode_Active`.
* **Message - Mode Selected (`MESG`)**
  * The message shown when the mode's selected by the player.
  * In the example, `_TEMPLATE_MESG_Weap10mm_NewPrimaryMode_Active`.
* **Crafting Recipe (`COBJ`, optional)**
  * The recipe used to build the `OMOD` that unlocks the primary mode.
  * In the example, `_TEMPLATE_COBJ_Weap10mm_Grip_NewPrimaryMode`.

## Custom Modes

If you want to make a new mode for an existing weapon,
it's easiest to copy and edit the template `.esp`:

1. **Create Allowed Keyword (optional):** Create a new `KYWD` for your mode
   (e.g. `_TEMPLATE_KYWD_Weap10mm_NewPrimaryMode`).
   If your new mode is something like 'full auto' or 'shotgun',
   and the weapon doesn't already have a mode like that,
   you might be able to use one of the existing keywords instead (e.g. `a0aLOADS_KYWD_PrimaryMode_Automatic1_Allowed`).
2. **Create Selected Keyword (optional):** Create a new `KYWD` for your mode
   (e.g. `_TEMPLATE_KYWD_Weap10mm_NewPrimaryMode_Active`).
   If you used an existing 'Allowed' keyword, you can use an existing 'Selected' one, e.g. (`a0aLOADS_KYWD_PrimaryMode_Automatic1_Selected`).
3. **Create Object Modifier - Mode Allowed:** Create a new `OMOD` for your weapon,
  that unlocks your new mode for it
   (e.g. `_TEMPLATE_OMOD_Weap10mm_Grip_NewPrimaryMode`). It needs:
   * **Add -> Keywords:** Your mode keyword (e.g.`_TEMPLATE_KYWD_Weap10mm_NewPrimaryMode`).
     A single Object Modifier can allow as many modes as you want.
4. **Create Object Modifier - Mode Selected:** Create a new `OMOD` for your mode,
   that will be equipped when it's active.
   (e.g. `_TEMPLATE_OMOD_Weap10mm_Grip_NewPrimaryMode_Active`). It needs:
   * **Attach Point:** `a0aLOADS_KYWD_Slot_PrimaryMode`
   * **Add -> Keywords:** Your 'selected' keyword (e.g.`_TEMPLATE_KYWD_Weap10mm_NewPrimaryMode_Active`).
5. **Create Crafting Recipe:** Create a new `COBJ` for the Object Modifier
  that unlocks your new Primary Modes
  (e.g. `_TEMPLATE_COBJ_Weap10mm_Grip_NewPrimaryMode`). It needs:
   * **Created Object:** Your new 'mode allowed' object modifier (e.g. `_TEMPLATE_KYWD_Weap10mm_NewPrimaryMode`).
6. **Create Selected Message:** Create a new `MESG` that will be shown
   when the player selects your new mode (e.g. `_TEMPLATE_MESG_Weap10mm_NewPrimaryMode`).
7. **Create Patch Form List:** *Loads* adds new Primary Modes using scripts, to avoid conflicts.
   Create a new `FLST` for your mode (e.g. `_TEMPLATE_FLST_PatchPrimaryMode_Weap10mm_NewPrimaryMode`).
   It needs to contain, *in the following order*,
   the primary mode list for the weapon you're adding the mode for (e.g. `a0aLOADS_FLST_PrimaryMode_Weap10mm` for the 10mm pistol),
   the 'Mode Allowed' `KYWD`, the 'Mode Selected' `KYWD`, the `OMOD` that applies the effects,
   and the `MESG` with the mode name.

   | Index | ObjectID                                        |
   | ----- | ----------------------------------------------- |
   | 0     | `a0aLOADS_FLST_PrimaryMode_Weap10mm`            |
   | 1     | `_TEMPLATE_KYWD_Weap10mm_NewPrimaryMode`        |
   | 2     | `_TEMPLATE_KYWD_Weap10mm_NewPrimaryMode_Active` |
   | 3     | `_TEMPLATE_OMOD_Weap10mm_NewPrimaryMode_Active` |
   | 4     | `_TEMPLATE_MESG_Weap10mm_NewPrimaryMode`        |

8. **Create Patch Quest:** You need to register the `FLST` with the details of your mode with *Loads*.
   Create a new `QST` that uses the `QST_LoadsPatcherScript` script (e.g. `_TEMPLATE_QST_LoadsPatcher`).
   Then, edit the `NewPrimaryModes` property and add your patch form list (e.g. `_TEMPLATE_FLST_PatchPrimaryMode_Weap10mm_NewPrimaryMode`).
   You can add multiple new modes, with a new patch list for each.

Now you're done! When the player activates your mod, it'll automatically register your new mode.

## Updating Your Mod

The registration quest will only run once.
If you update your mod and want to add more modes,
you'll need to create a new copy of the Patch Quest, with just the new modes in.

### IMPORTANT

Don't add them to *both* the old *and* new quest.
Each mode should only be added once.
It shouldn't *break*, but it will be inefficient.

## FAQ

See [the FAQ page](./faq.md).
