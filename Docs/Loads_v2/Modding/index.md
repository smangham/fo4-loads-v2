# Adding to the Loads framework

## Introductions

*Loads of Ammo* basically just sets up a bunch of tables, where each row represents the various parts of a single thing - e.g. a new type of ammo, and the object modifier that applies its effects.

However, as Papyrus doesn't *have* tables, this is done by making lists of lists, that function as a table. For example, 10mm ammo is handled by the form list `a0aLOADS_FLST_Ammo10mm`:

| Index | ObjectID                      |
| ----- | ----------------------------- |
| 0     | `a0aLOADS_FLST_Ammo10mm_AMMO` |
| 1     | `a0aLOADS_FLST_Ammo10mm_KYWD` |
| 2     | `a0aLOADS_FLST_Ammo10mm_OMOD` |

Which *Loads* treats as a table like this:

| Index | `a0aLOADS_FLST_Ammo10mm_AMMO` | `a0aLOADS_FLST_Ammo10mm_KYWD`    | `a0aLOADS_FLST_Ammo10mm_OMOD` |
| ----- | ----------------------------- | -------------------------------- | ----------------------------- |
| 0     | `Ammo10mm`                    | `a0aLOADS_KYWD_Ammo_Default`     | `a0aLOADS_OMOD_Ammo_Default`  |
| 1     | `Ammo10mm_AP`                 | `a0aLOADS_KYWD_AmmoBallistic_AP` | `_TEMPLATE_OMOD_Ammo10mm_AP`  |
| 2     | `Ammo10mm_DU`                 | `a0aLOADS_KYWD_AmmoBallistic_DU` | `_TEMPLATE_OMOD_Ammo10mm_DU`  |
| ...   | ...                           | ...                              | ...                           |

There's a framework set up to make it easy to add a new variant of ammo, new calibre, or the other new features in an easy, compatible way.

## Guides

### Ammunition

* [Adding a new variant of an existing calibre](./variant.md)
* [Adding a new calibre](./calibre.md)

### Primary Modes

Primary modes are optional alternative fire modes that use the same ammo and projectiles as the primary weapon.

* [Adding a new primary mode to a weapon that already has one](./primary.md)
* [Adding a new weapon that can have primary modes](./primary_similar.md)

### Secondaries

Secondary weapons/modes are optional alternative fire modes that use *different* ammo and/or projectiles to the primary weapon.

* [Adding a new secondary weapon/mode to a weapon that already has one](./secondary.md)
* [Adding a new weapon that can have secondary weapons/modes](./secondary_weapons.md)

## FAQ

The FAQ expects you to have read one of the guides, and can be found [here](./faq.md).
