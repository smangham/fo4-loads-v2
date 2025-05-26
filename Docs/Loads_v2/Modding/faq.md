# FAQ

> Does my variant need a new, unique variant keyword?

Variant keywords have to be unique per calibre.
So you could have 10mm AP, .32 AP e.t.c. all sharing a variant keyword,
but not 10mm AP and 10mm AP Mk 2.

> How important are types like AP, long-range e.t.c.?

Currently, not very. They're used for the 'next ammo by type' hotkey,
so players can e.g. flip between long and short-ranged ammo
without having to cycle through other types.

They could also be used for intelligent NPC ammo selection,
but this isn't implemented.

> Can I register one variant in multiple calibres?

Yes, if you want.
You can even register the same `AMMO` & `KYWD` with a different `OMOD`.
This is the way I handle homing missiles.
Technically, "Homing missile" is a different calibre to "Regular missile",
but it's registered with a different `OMOD` in both `a0aLOADS_FLST_AmmoMissile_Tracking` and `a0aLOADS_FLST_AmmoMissile_Tracking_OMOD`.
That way, you can fire the same ammo with different modifications.

> Can I edit the *Loads* lists myself to add the variants?

Please don't, this will cause conflicts.

> Can I add a variant to the *Loads* lists using `AddFormToFormList`?

Please don't.
The indexes need to line up between the `AMMO`, `KYWD` and `OMOD` lists,
and if different mods try adding to those lists, you can't guarantee each mod
will add to the different lists in the same order,
as each call of `AddFormToFormList` causes a 1-frame delay.

Use the patch functions from `a0aLOADS_QST_ManagerScript`, which are designed to cope with Papyrus parallelism:

* `a0aLOADS_QST_PatcherCore.PatchInNewCalibreBase`
* `a0aLOADS_QST_PatcherCore.PatchInNewCalibreConverted`
* `a0aLOADS_QST_PatcherCore.PatchInNewVariant`
* `a0aLOADS_QST_PatcherCore.PatchInNewCalibreBase`

There's a template set up in `Loads_v2_Template.esp` if you'd like an example of how it's done.

> Can I add a variant/calibre/weapon to the *Loads* lists using RobCo Autopatcher/Real Time Form Patcher?

...I don't know. I *think* so?
