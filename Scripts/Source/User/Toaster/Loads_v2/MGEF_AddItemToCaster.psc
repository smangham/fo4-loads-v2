Scriptname Toaster:Loads_v2:MGEF_AddItemToCaster extends ActiveMagicEffect Const
{This script runs when someone is hit with a spell, and adds an item to the caster (or firer of the enchanted weapon).}

Form Property formItemToAdd Auto Const

Event OnEffectStart(Actor akTarget, Actor akCaster)
    ; Debug.Trace("Loads_v2:AddItemToCaster:OnEffectStart: Caster "+akCaster+" hit "+akTarget+", adding "+formItemToAdd)
    akCaster.additem(formItemToAdd)
EndEvent
