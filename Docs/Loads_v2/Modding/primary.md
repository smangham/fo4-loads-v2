# New Primary Modes

If you'd like to create a new primary mode for an existing weapon,
look at the example in `Loads_v2_template.esp`.
It's a new grip for the 10mm pistol that adds a new firing mode.

Each new mode requires 4 (or 5) things:

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
* **Crafting Recipe (`COBJ`, optional)**
  * The recipe used to build the `OMOD`.
  * In the example, `_TEMPLATE_COBJ_Weap10mm_Grip_NewPrimaryMode`.


## Existing Modes on a New Weapon

Ballistic weapons in the vanilla game tend to have one or two different rates of automatic fire, and/or a silencer.
You can copy the set-up for this fairly easily.

1. **Create a new Primary Mode list for your weapon**


## Custom Modes

If you want to make a new ammo object modifier for an existing calibre,
it's easiest to copy and edit the template `.esp`:

1. **Create Allowed Keyword (optional):** Create a new `KYWD` for your mode
   (e.g. `_TEMPLATE_KYWD_Weap10mm_NewPrimaryMode`).
   If your new mode is something like 'full auto' or 'shotgun', and the weapon doesn't already have a mode like that,
   you might be able to use one of the existing keywords instead (e.g. `a0aLOADS_KYWD_PrimaryMode_Automatic1_Allowed`)
2. **Create Selected Keyword (optional):** Create a new `KYWD` for your mode
   (e.g. `_TEMPLATE_KYWD_Weap10mm_NewPrimaryMode_Active`).
   If you used an existing 'Allowed' keyword, you can use an existing 'Selected' one, e.g. (`a0aLOADS_KYWD_PrimaryMode_Automatic1_Selected`).
3. **Create Object Modifier:** Create a new `OMOD` for your mode
   (e.g. `_TEMPLATE_OMOD_Weap10mm_Grip_NewPrimaryMode_Active`). It needs:
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
