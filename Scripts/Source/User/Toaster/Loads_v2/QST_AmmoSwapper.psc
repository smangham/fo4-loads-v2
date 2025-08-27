Scriptname Toaster:Loads_v2:QST_AmmoSwapper extends Quest

FormList Property a0aLOADS_FLST_AmmoVariant_Old Auto
FormList Property a0aLOADS_FLST_AmmoVariant_New Auto


Event OnQuestInit()
    ; ----------------------------------------
    ; Replace the ammo the player has from v1 with v2 ammo.
    ;
    ; This will be slooooow, but only runs once so can't be meaningfully optimised.
    ; ----------------------------------------
    Actor PlayerRef = Game.GetPlayer()

    Int iLoop = a0aLOADS_FLST_AmmoVariant_Old.GetSize()
    Int iCount = 0
    Ammo ammoOld
    Ammo ammoNew

    If iLoop > 0
        Debug.Trace(self+":PatchNewCalibres: Patching in "+iLoop+" new calibres")

        While (iLoop > 0)
            iLoop -= 1
            ammoOld = a0aLOADS_FLST_AmmoVariant_Old.GetAt(iLoop) as Ammo
            ammoNew = a0aLOADS_FLST_AmmoVariant_New.GetAt(iLoop) as Ammo
            iCount = PlayerRef.GetItemCount(ammoOld)
            If (iCount)
                PlayerRef.AddItem(ammoNew, iCount, True)
            EndIf

        EndWhile
    EndIf
    PlayerRef.RemoveItem(a0aLOADS_FLST_AmmoVariant_Old, 65535, True)
EndEvent
