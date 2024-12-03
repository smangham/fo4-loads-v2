Scriptname QST_LoadsPatcherScript extends Quest

; What base ammo for a weapon corresponds to what set of lists?
a0aLOADS_QST_ManagerScript Property a0aLOADS_QST_Manager Auto Const


; ------------------------------------------------------------------------------
; Properties containing the lists used for adding new calibres and subtypes. 
; -------------------------------------------------------------------------------
FormList[] Property NewCalibres Auto Const
FormList[] Property NewConvertedCalibres Auto Const
FormList[] Property NewAmmoSubTypes Auto Const


Event OnQuestInit()    
    ; ----------------------------------------
    ; Triggers the initial patch when the mod starts up. 
    ; ----------------------------------------
    Debug.Trace(GetEditorID()+":LoadsPatcherScript: Quest initialised...")
    Patch()
endEvent


Function Patch()
    ; ----------------------------------------
    ; Patches new calibres and ammo subtypes into the main LOADS lists.
    ; **Frames:** Minimum 0.
    ; **Threads:** Runs each patch type as a new thread. 
    ; ----------------------------------------
    Debug.Trace(GetEditorID()+":LoadsPatcherScript: Quest initialised...")
    CallFunctionNoWait("PatchNewCalibres", new var[0])
    CallFunctionNoWait("PatchNewConvertedCalibres", new var[0])
    CallFunctionNoWait("PatchNewAmmoSubTypes", new var[0])
endFunction

  
Function PatchNewCalibres()
    ; ----------------------------------------
    ; Patches new calibres into the main LOADS lists.
    ; **Frames:** 1 per new calibre (plus many from patch function).
    ; **Threads:** 1, each patch type is thread-locked so no further gain.
    ; ----------------------------------------
    Int iLoop = NewCalibres.Length

    If iLoop > 0
        Debug.Trace(GetEditorID()+":PatchNewCalibres: Patching in "+iLoop+" new calibres")

        While (iLoop > 0)
            iLoop -= 1
            a0aLOADS_QST_Manager.PatchInNewCalibreBase(NewCalibres[iLoop])
        endWhile
    EndIf
endFunction


Function PatchNewConvertedCalibres()
    ; ----------------------------------------
    ; Patches new 'converted calibre' keywords into the main LOADS lists.
    ; **Frames:** 1 per new keyword (plus many from patch function).
    ; **Threads:** 1, each patch type is thread-locked so no further gain.
    ; ----------------------------------------   
    Int iLoop = NewConvertedCalibres.Length

    If iLoop > 0
        Debug.Trace(GetEditorID()+":PatchNewCalibreConverted: Patching in "+iLoop+" converted calibres")
        While (iLoop > 0)
            iLoop -= 1
            a0aLOADS_QST_Manager.PatchInNewCalibreConverted(NewConvertedCalibres[iLoop])
        endWhile
    EndIf
endFunction

 
Function PatchNewAmmoSubTypes()
    ; ----------------------------------------
    ; Patches new ammp subtypes into the main LOADS lists.
    ; **Frames:** 1 per new calibre (plus many from patch function).
    ; **Threads:** 1, each patch type is thread-locked so no further gain.
    ; ---------------------------------------- 
    Int iLoop = NewAmmoSubTypes.Length

    If iLoop > 0
        Debug.Trace(GetEditorID()+":PatchNewAmmoSubTypes: Patching in "+iLoop+" new subtypes")
        While (iLoop > 0)
            iLoop -= 1
            a0aLOADS_QST_Manager.PatchInNewSubType(NewAmmoSubTypes[iLoop])
        endWhile
    EndIf
endFunction
