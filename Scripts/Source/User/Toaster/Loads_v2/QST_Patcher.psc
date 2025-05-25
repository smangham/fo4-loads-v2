Scriptname Toaster:Loads_v2:QST_Patcher extends Quest

Toaster:Loads_v2:QST_PatcherCore Property a0aLOADS_QST_Patcher Auto Const
Toaster:Loads_v2:QST_Manager Property a0aLOADS_QST_Manager Auto Const

; ------------------------------------------------------------------------------
; Properties containing the lists used for adding new calibres and variants.
; -------------------------------------------------------------------------------
FormList[] Property NewCalibres Auto Const
FormList[] Property NewConvertedCalibres Auto Const
FormList[] Property NewAmmoVariants Auto Const
FormList[] Property NewPrimaryModes Auto Const
FormList[] Property NewSecondaries Auto Const
FormList[] Property NewWeaponsWithPrimaryModes Auto Const
FormList[] Property NewWeaponsWithSecondaries Auto Const


Event OnQuestInit()
    ; ----------------------------------------
    ; Triggers the initial patch when the mod starts up.
    ; ----------------------------------------
    Debug.Trace(self+":Patcher: Quest initialised...")
    RegisterForCustomEvent(a0aLOADS_QST_Manager, "OnLoadsRevertPatches")
    Patch()
EndEvent


Event Toaster:Loads_v2:QST_Manager.OnLoadsRevertPatches(Toaster:Loads_v2:QST_Manager akSender, Var[] akArgs)
    ; ----------------------------------------
    ; Re-patch if Loads has purged the form lists
    ; ----------------------------------------
    Patch()
EndEvent


Function Patch()
    ; ----------------------------------------
    ; Patches new calibres and ammo variants into the main LOADS lists.
    ; **Frames:** Minimum 0.
    ; **Threads:** Runs each patch type as a new thread.
    ; ----------------------------------------
    Debug.Trace(self+":Patcher: Quest initialised...")
    CallFunctionNoWait("PatchNewCalibres", None)
    CallFunctionNoWait("PatchNewConvertedCalibres", None)
    CallFunctionNoWait("PatchNewAmmoVariants", None)
EndFunction


Function PatchNewCalibres()
    ; ----------------------------------------
    ; Patches new calibres into the main LOADS lists.
    ; **Frames:** 1 per new calibre (plus many from patch function).
    ; **Threads:** 1, each patch type is thread-locked so no further gain.
    ; ----------------------------------------
    Int iLoop = NewCalibres.Length

    If iLoop > 0
        Debug.Trace(self+":PatchNewCalibres: Patching in "+iLoop+" new calibres")

        While (iLoop > 0)
            iLoop -= 1
            a0aLOADS_QST_Patcher.PatchInNewCalibreBase(NewCalibres[iLoop], GetFormID())
        EndWhile
    EndIf
EndFunction


Function PatchNewConvertedCalibres()
    ; ----------------------------------------
    ; Patches new 'converted calibre' keywords into the main LOADS lists.
    ; **Frames:** 1 per new keyword (plus many from patch function).
    ; **Threads:** 1, each patch type is thread-locked so no further gain.
    ; ----------------------------------------
    Int iLoop = NewConvertedCalibres.Length

    If iLoop > 0
        Debug.Trace(self+":PatchNewCalibreConverted: Patching in "+iLoop+" converted calibres")
        While (iLoop > 0)
            iLoop -= 1
            a0aLOADS_QST_Patcher.PatchInNewCalibreConverted(NewConvertedCalibres[iLoop], GetFormID())
        EndWhile
    EndIf
EndFunction


Function PatchNewAmmoVariants()
    ; ----------------------------------------
    ; Patches new ammo variants into the main LOADS lists.
    ; **Frames:** 1 per new calibre (plus many from patch function).
    ; **Threads:** 1, each patch type is thread-locked so no further gain.
    ; ----------------------------------------
    Int iLoop = NewAmmoVariants.Length

    If iLoop > 0
        Debug.Trace(self+":PatchNewAmmoVariants: Patching in "+iLoop+" new variants")
        While (iLoop > 0)
            iLoop -= 1
            a0aLOADS_QST_Patcher.PatchInNewVariant(NewAmmoVariants[iLoop], GetFormID())
        EndWhile
    EndIf
EndFunction


Function PatchNewPrimaryModes()
    ; ----------------------------------------
    ; Patches new primary modes variants into the main LOADS lists.
    ; **Frames:** 1 per new mode (plus many from patch function).
    ; **Threads:** 1, each patch type is thread-locked so no further gain.
    ; ----------------------------------------
    Int iLoop = NewPrimaryModes.Length

    If iLoop > 0
        Debug.Trace(self+":PatchNewPrimaryModes: Patching in "+iLoop+" new variants")
        While (iLoop > 0)
            iLoop -= 1
            a0aLOADS_QST_Patcher.PatchInNewPrimaryMode(NewPrimaryModes[iLoop], self)
        EndWhile
    EndIf
EndFunction


Function PatchNewSecondaries()
    ; ----------------------------------------
    ; Patches new secondaries into the main LOADS lists.
    ; **Frames:** 1 per new secondary (plus many from patch function).
    ; **Threads:** 1, each patch type is thread-locked so no further gain.
    ; ----------------------------------------
    Int iLoop = NewSecondaries.Length

    If iLoop > 0
        Debug.Trace(self+":PatchNewSecondaries: Patching in "+iLoop+" new secondaries")
        While (iLoop > 0)
            iLoop -= 1
            a0aLOADS_QST_Patcher.PatchInNewPrimaryMode(NewSecondaries[iLoop], self)
        EndWhile
    EndIf
EndFunction


Function PatchNewWeaponsWithSecondaries()
    ; ----------------------------------------
    ; Patches new weapons with secondaries into the main LOADS lists.
    ; **Frames:** 1 per new weapons with secondaries (plus many from patch function).
    ; **Threads:** 1, each patch type is thread-locked so no further gain.
    ; ----------------------------------------
    Int iLoop = NewWeaponsWithSecondaries.Length

    If iLoop > 0
        Debug.Trace(self+":PatchNewWeaponsWithSecondaries: Patching in "+iLoop+" new weapons with secondaries")
        While (iLoop > 0)
            iLoop -= 1
            a0aLOADS_QST_Patcher.PatchInNewWeaponWithSecondaries(NewWeaponsWithSecondaries[iLoop], self)
        EndWhile
    EndIf
EndFunction


Function PatchNewWeaponsWithPrimaryModes()
    ; ----------------------------------------
    ; Patches new weapons with primary modes into the main LOADS lists.
    ; **Frames:** 1 per new weapons with secondaries (plus many from patch function).
    ; **Threads:** 1, each patch type is thread-locked so no further gain.
    ; ----------------------------------------
    Int iLoop = NewWeaponsWithPrimaryModes.Length

    If iLoop > 0
        Debug.Trace(self+":PatchNewWeaponsWithPrimaryModes: Patching in "+iLoop+" new weapons with primary modes")
        While (iLoop > 0)
            iLoop -= 1
            a0aLOADS_QST_Patcher.PatchInNewWeaponWithPrimaryModes(NewWeaponsWithPrimaryModes[iLoop], self)
        EndWhile
    EndIf
EndFunction
