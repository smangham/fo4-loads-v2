Scriptname a0aLOADS_QST_ManagerScript extends Quest
{Handles the hotkey triggers from MCM}

; ----------------------------------------
; Generic Properties
; ----------------------------------------
; Used whenever an ObjectMod can't be applied
Message Property a0aLOADS_MESG_Error_TooManyItems Auto Const
Message Property a0aLOADS_MESG_Error_Unknown Auto Const

; Used for unequip-equip switches
Bool bScriptedReequip = False

; More performant than Game.GetPlayer()
; Actor Property PlayerRef Auto Const
Actor PlayerRef

; Updates when player switches weapon
Weapon weapPlayerCurrentWeapon = None

; Used whenever a var of just "[False,]" is needed
Var[] varArFalse = None

; ----------------------------------------
; MCM Menu Properties
; ----------------------------------------
; Used to prevent repeated clicks of rebuild cache
Bool Property bRebuildCache = False Auto
Bool Property bResetWeapon = False Auto
Bool Property bRevertPatches = False Auto
; Used when parallelising cache rebuilds
; Int Property iParallelCachesProcessing = -1 Auto
; Int Property iParallelCachesRebuilt = 0 Auto

; Used to filter crafting menus to remove unnecessary entries
GlobalVariable Property a0aLOADS_GLOB_HideLoadsWorkbench Auto Const
GlobalVariable Property a0aLOADS_GLOB_HideHotkeyConsumables Auto Const

; ----------------------------------------
; Ammo Switch Properties
; ----------------------------------------
; Is this a weapon?
Keyword Property ObjectTypeWeapon Auto Const
FormList Property a0aLOADS_FLST_Invalid_KYWD Auto Const

; What base ammo for a weapon corresponds to what set of lists?
FormList Property a0aLOADS_FLST_CalibreBase_AMMO Auto Const
FormList Property a0aLOADS_FLST_CalibreBase_FLST Auto Const
; Cached versions recalculated as required
Ammo[] ammoArCalibreBase = None
FormList[] flstArCalibreBase = None
Int iCalibreBaseLength = 0

; If this weapon has a converted receiver, what keyword matches corresponds to what set of lists?
FormList Property a0aLOADS_FLST_CalibreConverted_KYWD Auto Const
FormList Property a0aLOADS_FLST_CalibreConverted_FLST Auto Const
Keyword Property dn_HasReceiver_Converted Auto Const
; Cached versions recalculated as required
Keyword[] kywdArCalibreConverted = None
FormList[] flstArCalibreConverted = None
Int iCalibreConvertedLength = 0

; NULL slot OMod for applying LOADS slots to unpatched weapons
ObjectMod Property a0aLOADS_OMOD_Slots Auto Const

; Default 'No Loads ammo switch' object mod
ObjectMod Property a0aLOADS_OMOD_Ammo_Default Auto Const

; Errors when switching ammo
Message Property a0aLOADS_MESG_AmmoError_Calibre Auto Const
Message Property a0aLOADS_MESG_AmmoWarning_NoAmmo Auto Const

; Caches for primary weapon calibre, filled when the player equips weapon
Ammo[] ammoArPlayerPrimaryCalibre = None
Keyword[] kywdArPlayerPrimaryCalibre = None
ObjectMod[] omodArPlayerPrimaryCalibre = None
Int iPlayerPrimaryCalibreLength = 0
Int iPlayerPrimaryCalibreAmmoCurrent = -1

; Keywords showing that the weapon had previously had an ammo selected
Keyword Property a0aLOADS_KYWD_AmmoLast Auto Const
; Lists of keywords referring to last equipped ammo for other mode (primary if secondary, secondary if primary)
Keyword[] Property kywdArAmmoLast Auto Const
ObjectMod[] Property omodArAmmoLast Auto Const

; ----------------------------------------
; Scope Zoom Properties
; ----------------------------------------
; What scope keyword corresponds to what set of lists of current zoom OMods?
FormList Property a0aLOADS_FLST_ScopeTypeBase_KYWD Auto Const
FormList Property a0aLOADS_FLST_ScopeTypeBase_FLST Auto Const
FormList Property a0aLOADS_FLST_ScopeTypeAlt_KYWD Auto Const
FormList Property a0aLOADS_FLST_ScopeTypeAlt_FLST Auto Const
; Cached versions recalculated as required
FormList[] flstArScopeTypeBase = None
Keyword[] kywdArScopeTypeBase = None
Int iScopeTypeBaseLength = 0
FormList[] flstArScopeTypeAlt = None
Keyword[] kywdArScopeTypeAlt = None
Int iScopeTypeAltLength = 0

; Lists of keywords for max and current zooms for looking up spot in OMod list
FormList Property a0aLOADS_FLST_ScopeZoomMax_KYWD Auto Const
FormList Property a0aLOADS_FLST_ScopeZoomCurrent_KYWD Auto Const
; Cached versions recalculated as required
Keyword[] kywdArScopeZoomMax = None
Keyword[] kywdArScopeZoomCurrent = None
Int iScopeZoomLength = 0

; Clear Zoom modifiers, return to default
ObjectMod Property a0aLOADS_OMOD_ScopeZoomCurrent_Default Auto Const

; List of object mods for 'normal' (no type) scope current zooms
FormList Property a0aLOADS_FLST_ScopeType_Normal_OMOD Auto Const
; Cached version
ObjectMod[] omodArScopeType_Normal = None

; Should we bother evaluating the scope for this weapon
Keyword Property HasScope Auto Const

; Used for switching to secondary scopes
Bool bScopeTypeAlt = False
Keyword Property a0aLOADS_KYWD_ScopeType_Alt Auto Const
ObjectMod Property a0aLOADS_OMOD_ScopeType_Base Auto Const
ObjectMod Property a0aLOADS_OMOD_ScopeType_Alt Auto Const
Message Property a0aLOADS_MESG_ScopeType_Base Auto Const
Message Property a0aLOADS_MESG_ScopeType_Alt Auto Const

; The set of OMods applied when the player switches zoom, cached on equip
ObjectMod[] omodArPlayerScopeTypeBase = None
ObjectMod[] omodArPlayerScopeTypeAlt = None
Int iPlayerScopeZoomMax = -1
Int iPlayerScopeZoomCurrent = -1

; If the player tries to zoom with an unsupported scope
Message Property a0aLOADS_MESG_ScopeError_NotSupported Auto Const


; ----------------------------------------
; Secondary Weapon properties
; ----------------------------------------
; Secondary Weapon lists
FormList Property a0aLOADS_FLST_Secondary_KYWD Auto Const
FormList Property a0aLOADS_FLST_Secondary_FLST Auto Const
; Cached versions recalculated as required
Keyword[] kywdArSecondary = None
FormList[] flstArSecondary = None
Int iSecondaryLength = 0

ObjectMod Property a0aLOADS_OMOD_Secondary_Default Auto Const
; Has a secondary weapon available
Keyword Property a0aLOADS_KYWD_Secondary Auto Const
Keyword Property a0aLOADS_KYWD_Secondary_Active Auto Const

; For current weapon, recalculated on equip
ObjectMod omodPlayerSecondary
Bool bPlayerSecondaryActive = False

; Caches for secondary weapon calibre, filled when the player equips weapon
Ammo[] ammoArPlayerSecondaryCalibre = None
Keyword[] kywdArPlayerSecondaryCalibre = None
ObjectMod[] omodArPlayerSecondaryCalibre = None
Int iPlayerSecondaryCalibreLength = 0
Int iPlayerSecondaryCalibreAmmoCurrent = -1

; This weapon doesn't support secondary weapons
Message Property a0aLOADS_MESG_SecondaryError_NotSupported Auto Const
; This weapon has no valid secondary weapon keywords
Message Property a0aLOADS_MESG_SecondaryWarning_None Auto Const


; ----------------------------------------
; Primary mode properties
; ----------------------------------------
; Primary fire is used for attacks with the same ammo type,
; but a different mode - e.g. burst fire, full-auto.
; ----------------------------------------
; Primary Fire modes (e.g. burst, full auto)
FormList Property a0aLOADS_FLST_PrimaryMode_KYWD Auto Const
FormList Property a0aLOADS_FLST_PrimaryMode_FLST Auto Const
; Cached versions recalculated as required
Keyword[] kywdArPrimaryMode = None
FormList[] flstArPrimaryMode = None
Int iPrimaryModeLength = 0

ObjectMod Property a0aLOADS_OMOD_PrimaryMode_Default Auto Const  ; Default mode object mod
Keyword Property a0aLOADS_KYWD_PrimaryMode Auto Const  ; Weapon has a primary mode setting, used to indicate it's worth searching for the keyword

; Caches for alternate modes for the current weapon, filled when the player switches weapon
Keyword[] kywdArPlayerPrimaryModeAllowed = None
Keyword[] kywdArPlayerPrimaryModeSelected = None
ObjectMod[] omodArPlayerPrimaryModeSelected = None
Int iPlayerPrimaryModeLength = 0
Int iPlayerPrimaryModeCurrent = -1

; The weapon had a primary mode set when switched to secondary weapon
Keyword Property a0aLOADS_KYWD_PrimaryModeLast Auto Const
; Lists of keywords referring to last equipped mode for primary weapon
Keyword[] Property kywdArPrimaryModeLast Auto Const
ObjectMod[] Property omodArPrimaryModeLast Auto Const

; This weapon doesn't support alternate primary modes
Message Property a0aLOADS_MESG_PrimaryModeError_NotSupported Auto Const
; This weapon has the secondary weapon active
Message Property a0aLOADS_MESG_PrimaryModeWarning_SecondaryActive Auto Const



Form[] Function FillArrayFromFormList(FormList akFormList, Form[] aArray)
    ; ------------------------------------------------------------------------------
    ; Iterates over a formlist and copies its values to an array.
    ; **Frames:** Minimum 1 + length of FormList.
    ; **Parallelism:** Not parallelisable, but can be run in parallel.
    ;
    ; @param akFormList: The formlist we want to cache as an array on the script.
    ; @aparam aArray: The array, defined outside the function with 'new Type[]'.
    ; @returns: The array, to be set to a variable so there's a reference to the `new Type[]` data.
    ; -------------------------------------------------------------------------------
    Int iLoop = 0
    Int iSize = akFormList.GetSize()
    While (iLoop < iSize)
        aArray[iLoop] = akFormList.GetAt(iLoop)
        iLoop += 1
    EndWhile
    Return aArray
EndFunction


Event OnQuestInit()
    ; ----------------------------------------
    ; Register for the events the framework needs, and initial set-up of array caches.
    ; **Frames:** Minimum 1 + called functions.
    ; **Parallelism:** N/A
    ; ----------------------------------------
    PlayerRef = Game.GetPlayer()
    RegisterForEvents()
    CacheFormLists()
endEvent


Event Actor.OnPlayerLoadGame(Actor akSender)
    ; ----------------------------------------
    ; When we load the game, re-calculate form list caches in case they've changed.
    ; **Frames:** Minimum 1 + called functions.
    ; **Parallelism:** N/A
    ;
    ; @param akSender: Unused
    ; ----------------------------------------
    PlayerRef = Game.GetPlayer()
    Debug.Trace("Loads_v2:OnPlayerLoadGame: Registering events")
    RegisterForEvents()
    Debug.Trace("Loads_v2:OnPlayerLoadGame: Caching form lists")
    CacheFormLists()
    Debug.Trace("Loads_v2:OnPlayerLoadGame: Finished")

    varArFalse = new Var[1]
    varArFalse[0] = False
endEvent


Function RegisterForEventsLoud()
    ; ----------------------------------------
    ; Register for events, but with messages for the user
    ; TEST: Perhaps needed for MCM?
    ; ----------------------------------------
    RegisterForEvents(True)
EndFunction


Function RegisterForEvents(Bool bLoud = False)
    ; ----------------------------------------
    ; Register for the events required by the mod
    ; **Frames:** In theory, 1?
    ; **Parallelism:** N/A
    ;
    ; @param bLoud: Whether to message the progress to the user
    ; ----------------------------------------
    Debug.Trace("Loads_v2:RegisterForEvents: Registering...")
    UnregisterForAllEvents()
	RegisterForRemoteEvent(PlayerRef, "OnItemEquipped")
	RegisterForRemoteEvent(PlayerRef, "OnItemUnEquipped")
    RegisterForRemoteEvent(PlayerRef, "OnPlayerLoadGame")
    RegisterForMenuOpenCloseEvent("PauseMenu")
    RegisterForMenuOpenCloseEvent("ScopeMenu")
    RegisterForMenuOpenCloseEvent("ExamineMenu")
    RegisterForExternalEvent("OnMCMOpen|Loads_v2", "OnMCMOpen")
    RegisterForExternalEvent("OnMCMSettingChange|Loads_v2", "OnMCMSettingChange")
    Debug.Trace("Loads_v2:RegisterForEvents: Registered")
    If bLoud
        Debug.Notification("Loads of Ammo re-registered for events")
    EndIf
EndFunction


Event OnMenuOpenCloseEvent(string asMenuName, bool abOpening)
    ; ----------------------------------------
    ; If we close the pause menu, rebuild caches if required
    ; If we open the scope menu, record that to switch state.
    ;
    ; NOTE:
    ; OnMCMClose() doesn't run when the MCM menu closes, only when we switch tabs
    ; within it to another MCM mod, which is why we need PauseMenu.
    ;
    ; @param asMenuName: The menu, should be either "PauseMenu" or "ScopeMenu"
    ; @param abOpening: Whether it opened or closed
    ; ----------------------------------------
    Debug.Trace("Loads_v2:OnMenuOpenCloseEvent: "+asMenuName+", "+abOpening)
    If asMenuName == "ScopeMenu"
        If abOpening
            GotoState("ZoomedIn")
        Else
            GotoState("")
        EndIf
    ElseIf asMenuName == "ExamineMenu"
        CacheFormLists()

    ElseIf asMenuName == "PauseMenu"
        If !abOpening && bResetWeapon
            DebugResetWeapon()
        EndIf
        If !abOpening && bRebuildCache
            CacheFormLists(bForce=True)
        EndIf
        If !abOpening && bRevertPatches
            DebugRevertPatches()
        EndIf
    EndIf
endEvent


CustomEvent OnLoadsRevertPatches

Function DebugRevertPatches()
    ; ----------------------------------------
    ; Resets *all* the form lists by removing script-added entries,
    ; then requests the patches re-add their content.
    ;
    ; **Frames:** Lots. Expect this to take seconds.
    ; ----------------------------------------
    FormList flstLoop = None
    Int iLoop = -1

    a0aLOADS_FLST_ScopeTypeBase_KYWD.Revert()
    a0aLOADS_FLST_ScopeTypeBase_FLST.Revert()
    a0aLOADS_FLST_ScopeTypeAlt_KYWD.Revert()
    a0aLOADS_FLST_ScopeTypeAlt_FLST.Revert()

    iLoop = a0aLOADS_FLST_CalibreBase_FLST.GetSize()
    While(iLoop > -1)
        flstLoop = a0aLOADS_FLST_CalibreBase_FLST.GetAt(iLoop) as FormList
        (flstLoop.GetAt(0) as FormList).Revert()
        (flstLoop.GetAt(1) as FormList).Revert()
    endWhile
    a0aLOADS_FLST_CalibreBase_AMMO.Revert()
    a0aLOADS_FLST_CalibreBase_FLST.Revert()
    a0aLOADS_FLST_CalibreConverted_KYWD.Revert()
    a0aLOADS_FLST_CalibreConverted_FLST.Revert()

    iLoop = a0aLOADS_FLST_Secondary_FLST.GetSize()
    While(iLoop > -1)
        flstLoop = a0aLOADS_FLST_Secondary_FLST.GetAt(iLoop) as FormList
        (flstLoop.GetAt(0) as FormList).Revert()
        (flstLoop.GetAt(1) as FormList).Revert()
    endWhile
    a0aLOADS_FLST_Secondary_KYWD.Revert()
    a0aLOADS_FLST_Secondary_FLST.Revert()

    iLoop = a0aLOADS_FLST_PrimaryMode_FLST.GetSize()
    While(iLoop > -1)
        flstLoop = a0aLOADS_FLST_PrimaryMode_FLST.GetAt(iLoop) as FormList
        (flstLoop.GetAt(0) as FormList).Revert()
        (flstLoop.GetAt(1) as FormList).Revert()
    endWhile
    a0aLOADS_FLST_PrimaryMode_KYWD.Revert()
    a0aLOADS_FLST_PrimaryMode_FLST.Revert()

    SendCustomEvent("OnLoadsRevertPatches", None)
EndFunction


Function DebugResetWeapon()
    ; ----------------------------------------
    ; If we close the pause menu, rebuild caches if required
    ; If we open the scope menu, record that to switch state.
    ;
    ; NOTE:
    ; OnMCMClose() doesn't run when the MCM menu closes, only when we switch tabs
    ; within it to another MCM mod, which is why we need PauseMenu.
    ;
    ; @param asMenuName: The menu, should be either "PauseMenu" or "ScopeMenu"
    ; @param abOpening: Whether it opened or closed
    ; ----------------------------------------
    Debug.Trace("Loads_v2:DebugResetWeapon: Resetting - "+weapPlayerCurrentWeapon.GetName())
    PlayerRef = Game.GetPlayer()
    PlayerRef.AttachModToInventoryItem(weapPlayerCurrentWeapon, a0aLOADS_OMOD_Ammo_Default)
    PlayerRef.AttachModToInventoryItem(weapPlayerCurrentWeapon, a0aLOADS_OMOD_PrimaryMode_Default)
    PlayerRef.AttachModToInventoryItem(weapPlayerCurrentWeapon, a0aLOADS_OMOD_Secondary_Default)
    PlayerRef.AttachModToInventoryItem(weapPlayerCurrentWeapon, omodArAmmoLast[0])
    bResetWeapon = False
EndFunction

Function OnMCMSettingChange(string modName, string id)
    ; ----------------------------------------
    ; Called when an MCM setting for Loads_v2 is changed.
    ; ----------------------------------------
    Debug.Trace("Loads_v2:OnMCMSettingChange: "+modName+", "+id)
    If (modName == "Loads_v2") ; if you registered with OnMCMSettingChange|MCM_Demo this should always be true
        If (id == "bHideLoadsWorkbench")
            If MCM.GetModSettingBool("Loads_v2", "bHideLoadsWorkbench")
                a0aLOADS_GLOB_HideLoadsWorkbench.SetValue(1)
            Else
                a0aLOADS_GLOB_HideLoadsWorkbench.SetValue(0)
            EndIf
        ElseIf (id == "bHideHotkeyConsumables")
            If MCM.GetModSettingBool("Loads_v2", "bHideHotkeyConsumables")
                a0aLOADS_GLOB_HideHotkeyConsumables.SetValue(1)
            Else
                a0aLOADS_GLOB_HideHotkeyConsumables.SetValue(0)
            EndIf
        EndIf
    EndIf
EndFunction


Function OnMCMOpen()
    ; ----------------------------------------
    ; Called when the MCM tab for Loads_v2 is opened.
    ; PLACEHOLDER: Currently unused.
    ; ----------------------------------------
    Debug.Trace("Loads_v2:OnMCMOpen: Menu opened")
EndFunction


Function CacheFormLists(Bool bForce = False)
    ; ----------------------------------------
    ; Update the ammo array caches from their base formlists.
    ; Only updates caches where they are of a different length to their base formlist.
    ; **Frames:** 7 + 1 per item in each list cached, so potentially a few seconds' worth.
    ; **Parallelism:** Caching could be parallelised but would need a sync at the end.
    ;
    ; @param bForce: Whether to force an update, even of lists that are the same length.
    ; ----------------------------------------
    Debug.Trace("Loads_v2:CacheFormLists: Starting...")
    ; iParallelCachesRebuilt = 0
    ; iParallelCachesProcessing = 4
    Int iSize = 0
    Int iCachesUpdated = 0

    iSize = a0aLOADS_FLST_CalibreBase_FLST.GetSize()
    If (iSize != iCalibreBaseLength) || bForce
        Debug.Trace("Loads_v2:CacheFormLists: Updating base calibres... (currently "+iCalibreBaseLength+")")
        iCalibreBaseLength = iSize
        ammoArCalibreBase = FillArrayFromFormList(a0aLOADS_FLST_CalibreBase_AMMO, new Ammo[128] as Form[]) as Ammo[]
        flstArCalibreBase = FillArrayFromFormList(a0aLOADS_FLST_CalibreBase_FLST, new FormList[128] as Form[]) as FormList[]
        iCachesUpdated += 1
        Debug.Trace("Loads_v2:CacheFormLists: Updated base calibres... (now "+iCalibreBaseLength+")")
    EndIf

    iSize = a0aLOADS_FLST_CalibreConverted_FLST.GetSize()
    If (iSize != iCalibreConvertedLength) || bForce
        Debug.Trace("Loads_v2:CacheFormLists: Updating converted calibres... (currently "+iCalibreConvertedLength+")")
        iCalibreConvertedLength = iSize
        kywdArCalibreConverted = FillArrayFromFormList(a0aLOADS_FLST_CalibreConverted_KYWD, new Keyword[128] as Form[]) as Keyword[]
        flstArCalibreConverted = FillArrayFromFormList(a0aLOADS_FLST_CalibreConverted_FLST, new FormList[128] as Form[]) as FormList[]
        iCachesUpdated += 1
        Debug.Trace("Loads_v2:CacheFormLists: Updated converted calibres... (now "+iCalibreConvertedLength+")")
    EndIf

    iSize = a0aLOADS_FLST_ScopeZoomMax_KYWD.GetSize()
    If (iSize != iScopeZoomLength) || bForce
        Debug.Trace("Loads_v2:CacheFormLists: Updating scope zoom levels... (currently "+iScopeZoomLength+")")
        iScopeZoomLength = iSize
        kywdArScopeZoomMax = FillArrayFromFormList(a0aLOADS_FLST_ScopeZoomMax_KYWD, new Keyword[16] as Form[]) as Keyword[]
        kywdArScopeZoomCurrent = FillArrayFromFormList(a0aLOADS_FLST_ScopeZoomCurrent_KYWD, new Keyword[16] as Form[]) as Keyword[]
        omodArScopeType_Normal = FillArrayFromFormList(a0aLOADS_FLST_ScopeType_Normal_OMOD, new ObjectMod[16] as Form[]) as ObjectMod[]
        iCachesUpdated += 1
        Debug.Trace("Loads_v2:CacheFormLists: Updated scope zoom levels... (now "+iScopeZoomLength+")")
    EndIf

    iSize = a0aLOADS_FLST_ScopeTypeBase_KYWD.GetSize()
    If (iSize != iScopeTypeBaseLength) || bForce
        Debug.Trace("Loads_v2:CacheFormLists: Updating scope types... (currently "+iScopeTypeBaseLength+")")
        iScopeTypeBaseLength = iSize
        kywdArScopeTypeBase = FillArrayFromFormList(a0aLOADS_FLST_ScopeTypeBase_KYWD, new Keyword[16] as Form[]) as Keyword[]
        flstArScopeTypeBase = FillArrayFromFormList(a0aLOADS_FLST_ScopeTypeBase_FLST, new FormList[16] as Form[]) as FormList[]
        iCachesUpdated += 1
        Debug.Trace("Loads_v2:CacheFormLists: Updated scope types... (now "+iScopeTypeBaseLength+")")
    EndIf

    iSize = a0aLOADS_FLST_ScopeTypeAlt_KYWD.GetSize()
    If (iSize != iScopeTypeAltLength) || bForce
        Debug.Trace("Loads_v2:CacheFormLists: Updating scope alt-types... (currently "+iScopeTypeAltLength+")")
        iScopeTypeAltLength = iSize
        kywdArScopeTypeAlt = FillArrayFromFormList(a0aLOADS_FLST_ScopeTypeAlt_KYWD, new Keyword[16] as Form[]) as Keyword[]
        flstArScopeTypeAlt = FillArrayFromFormList(a0aLOADS_FLST_ScopeTypeAlt_FLST, new FormList[16] as Form[]) as FormList[]
        iCachesUpdated += 1
        Debug.Trace("Loads_v2:CacheFormLists: Updated scope alt-types... (now "+iScopeTypeAltLength+")")
    EndIf

    iSize = a0aLOADS_FLST_Secondary_KYWD.GetSize()
    If (iSize != iSecondaryLength) || bForce
        Debug.Trace("Loads_v2:CacheFormLists: Updating weapons with secondaries... (currently "+iSecondaryLength+")")
        iSecondaryLength = iSize
        kywdArSecondary = FillArrayFromFormList(a0aLOADS_FLST_Secondary_KYWD, new Keyword[64] as Form[]) as Keyword[]
        flstArSecondary = FillArrayFromFormList(a0aLOADS_FLST_Secondary_FLST, new FormList[64] as Form[]) as FormList[]
        iCachesUpdated += 1
        Debug.Trace("Loads_v2:CacheFormLists: Updated weapons with secondaries... (now "+iSecondaryLength+")")
    EndIf

    iSize = a0aLOADS_FLST_PrimaryMode_KYWD.GetSize()
    If (iSize != iPrimaryModeLength) || bForce
        Debug.Trace("Loads_v2:CacheFormLists: Updating primary fire modes... (currently "+iPrimaryModeLength+")")
        iPrimaryModeLength = iSize
        kywdArPrimaryMode = FillArrayFromFormList(a0aLOADS_FLST_PrimaryMode_KYWD, new Keyword[64] as Form[]) as Keyword[]
        flstArPrimaryMode = FillArrayFromFormList(a0aLOADS_FLST_PrimaryMode_FLST, new FormList[64] as Form[]) as FormList[]
        iCachesUpdated += 1
        Debug.Trace("Loads_v2:CacheFormLists: Updated primary fire modes... (now "+iPrimaryModeLength+")")
    EndIf

    If bForce
        ; Forces a rebuild of the player calibre cache
        weapPlayerCurrentWeapon = None
        Weapon weapCurrent = PlayerRef.GetEquippedWeapon()
        PlayerRef.UnequipItem(weapCurrent)
        PlayerRef.EquipItem(weapCurrent)
    EndIf

    If iCachesUpdated > 0
        ; Let the player know we've done something
        Debug.Notification("Loads of Ammo updated "+iCachesUpdated+" caches")
    EndIf

    ; Update the MCM variables, to re-allow cache resetting
    bRebuildCache = False
    Debug.Trace("Loads_v2:CacheFormLists: Finished")
EndFunction


; Function ParallelCacheCalibreBase(Bool bForce)
;     Int iSize = a0aLOADS_FLST_CalibreBase_FLST.GetSize()
;     If (iSize != iCalibreBaseLength) || bForce
;         Debug.Trace("Loads_v2:ParallelCacheCalibreBase: Updating base calibres... (currently "+iCalibreBaseLength+")")
;         iCalibreBaseLength = iSize
;         ammoArCalibreBase = FillArrayFromFormList(a0aLOADS_FLST_CalibreBase_AMMO, new Ammo[128] as Form[]) as Ammo[]
;         flstArCalibreBase = FillArrayFromFormList(a0aLOADS_FLST_CalibreBase_FLST, new FormList[128] as Form[]) as FormList[]
;         iParallelCachesRebuilt += 1
;         Debug.Trace("Loads_v2:ParallelCacheCalibreBase: Updated base calibres... (now "+iCalibreBaseLength+")")
;     EndIf
;     iParallelCachesProcessing =-1
;     If !iParallelCachesProcessing
;         ParallelCacheConclude()
;     EndIf
; EndFunction


Event Actor.OnItemUnequipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
    ; If !bLoadsForcedEquip && (akBaseObject == weapPlayerCurrentWeapon)
    ;     ; weapPlayerCurrentWeapon = None

        ; iPlayerCalibreLength = 0
        ; iPlayerCalibreAmmoCurrent = -1

        ; bPlayerSecondaryActive = False
        ; iPlayerSecondaryLength = 0

        ; omodArPlayerScopeTypeBase = None
        ; omodArPlayerScopeTypeAlt = None
        ; iPlayerScopeZoomMax = -1
        ; iPlayerScopeZoomCurrent = -1
    ; EndIf
EndEvent


Event Actor.OnItemEquipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
    ; ----------------------------------------
    ; @brief Called when PlayerRef equips any item
    ;
    ; Handles updating the internal caches when the player switches weapon,
    ; as well as applying the 'Last ammo' tags onto weapons
    ;
    ; @param akSender: Should always be PlayerRef.
    ; @param akBaseObject: What was equipped, we only care if it's a weapon.
    ; @param akReference: Can never be relied on in this context.
    ; ----------------------------------------
    If bScriptedReequip
        bScriptedReequip = False

    ElseIf (akBaseObject == weapPlayerCurrentWeapon)
        Debug.Trace("Loads_v2:OnItemEquipped: Force equip of "+akBaseObject.GetName()+" "+akBaseObject+", time "+Utility.GetCurrentRealTime()+", secondary? "+bPlayerSecondaryActive)

    ElseIf (akBaseObject.HasKeyword(ObjectTypeWeapon) && !akBaseObject.HasKeywordInFormList(a0aLOADS_FLST_Invalid_KYWD))
        ; If the player was in secondary mode...
        If (bPlayerSecondaryActive)
            ; Was their primary in a non-default mode?
            If(iPlayerPrimaryModeCurrent > 0)
                ; If so, attach a reminder mod to the weapon
                PlayerRef.AttachModToInventoryItem(weapPlayerCurrentWeapon, omodArPrimaryModeLast[iPlayerPrimaryModeCurrent])
            EndIf

            ; Was the player's primary ammo non-default?
            If (iPlayerPrimaryCalibreAmmoCurrent > -1)
                ; If so, attach a reminder mod to the weapon
                PlayerRef.AttachModToInventoryItem(weapPlayerCurrentWeapon, omodArAmmoLast[iPlayerPrimaryCalibreAmmoCurrent])
            EndIf
        Else
            ; Was the player's secondary ammo non-default?
            If (iPlayerSecondaryCalibreAmmoCurrent > -1)
                ; If so, attach a reminder mod to the weapon
                PlayerRef.AttachModToInventoryItem(weapPlayerCurrentWeapon, omodArAmmoLast[iPlayerSecondaryCalibreAmmoCurrent])
            EndIf
        EndIf

        If (akBaseObject)
            If (weapPlayerCurrentWeapon)
                Debug.Trace("Loads_v2:OnItemEquipped: Switched from "+weapPlayerCurrentWeapon.GetName()+" "+weapPlayerCurrentWeapon+" to "+akBaseObject.GetName()+" "+akBaseObject+" on "+PlayerRef+", time "+Utility.GetCurrentRealTime())
            Else
                Debug.Trace("Loads_v2:OnItemEquipped: Switched from nothing to "+akBaseObject.GetName()+" "+akBaseObject+" on "+PlayerRef+", time "+Utility.GetCurrentRealTime())
            EndIf
            weapPlayerCurrentWeapon = akBaseObject as Weapon
            bPlayerSecondaryActive = PlayerRef.WornHasKeyword(a0aLOADS_KYWD_Secondary_Active)
        Else
            Debug.Trace("Loads_v2:OnItemEquipped: Unequipped "+weapPlayerCurrentWeapon.GetName()+" "+weapPlayerCurrentWeapon+" on "+PlayerRef+", time "+Utility.GetCurrentRealTime())
            weapPlayerCurrentWeapon = None
            bPlayerSecondaryActive = False
        EndIf
        ; We check secondary active before calling the parallel subroutines, as it's needed in multiple

        CallFunctionNoWait("ParallelCachePlayerPrimaryAmmoType", None)
        CallFunctionNoWait("ParallelCachePlayerPrimaryMode", None)
        CallFunctionNoWait("ParallelCachePlayerSecondary", None)
        CallFunctionNoWait("ParallelCachePlayerScope", None)
    EndIf
EndEvent


Function ParallelCachePlayerScope()
    ; ----------------------------------------
    ; @brief Caches the arrays and details for the player's scope
    ;
    ; Caches the player's base and alt scope, and calculates what their max and current zoom is,
    ; along with whether they're currently in alt-scope mode.
    ;
    ; **Frames:** 1 + <=1 per base scope type + <=1 per alt scope type + 2 * <=1 per zoom level
    ; **Parallel:** Yes, can parallelise - no changes to actors.
    ; ----------------------------------------
    omodArPlayerScopeTypeBase = None
    omodArPlayerScopeTypeAlt = None
    iPlayerScopeZoomMax = -1
    iPlayerScopeZoomCurrent = -1

    If !weapPlayerCurrentWeapon
        Return
    ElseIf PlayerRef.WornHasKeyword(HasScope)
        ; Check if it's currently in alternate mode
        bScopeTypeAlt = PlayerRef.WornHasKeyword(a0aLOADS_KYWD_ScopeType_Alt)
        Debug.Trace("Loads_v2:ParallelCachePlayerScope: Player weapon has scope, is alt scope active? "+bScopeTypeAlt)

        ; If the player has a scope, sift through the list of special scope types and find the list of zoom OMods associated
        FormList flstTemp = GetFormForWornKeyword(PlayerRef, kywdArScopeTypeBase, flstArScopeTypeBase as Form[], iScopeTypeBaseLength) as FormList
        If flstTemp
            omodArPlayerScopeTypeBase = FillArrayFromFormList(flstTemp, new ObjectMod[16] as Form[]) as ObjectMod[]
        EndIf

        If !omodArPlayerScopeTypeBase
            ; If we didn't find any of the special scope type tags, then just set the scope array to the 'normal' one
            omodArPlayerScopeTypeBase = omodArScopeType_Normal
        Else
            ; If it had a special scope type... does it have an alt-type too?
            Debug.Trace("Loads_v2:ParallelCachePlayerScope: Looking for alt scope")
            flstTemp = GetFormForWornKeyword(PlayerRef, kywdArScopeTypeAlt, flstArScopeTypeAlt as Form[], iScopeTypeAltLength) as FormList
            If flstTemp
                omodArPlayerScopeTypeAlt = FillArrayFromFormList(flstTemp, new ObjectMod[16] as Form[]) as ObjectMod[]
            EndIf
        EndIf

        ; Loop through the player's weapon to see what the maximum zoom is
        iPlayerScopeZoomMax = GetIndexForWornKeyword(PlayerRef, kywdArScopeZoomMax, iScopeZoomLength)
        iPlayerScopeZoomCurrent = GetIndexForWornKeyword(PlayerRef, kywdArScopeZoomCurrent, iPlayerScopeZoomMax)
        If iPlayerScopeZoomCurrent < 0
            ; If it's not zoomed out, then the 'current zoom' is the maximum
            iPlayerScopeZoomCurrent = iPlayerScopeZoomMax
        EndIf

        Debug.Trace("Loads_v2:ParallelCachePlayerScope: Finished checking scope - zoom "+iPlayerScopeZoomCurrent+"/"+iPlayerScopeZoomMax)
    EndIf
EndFunction

Function DebugTraceArray(Form[] akForms, int aiLength)
    Int iLoop = aiLength -1
    While (iLoop > -1)
        Debug.Trace("- "+akForms[iLoop]+" "+iLoop+"/"+aiLength)
        iLoop -= 1
    EndWhile
EndFunction


Function ParallelCachePlayerSecondary()
    ; ----------------------------------------
    ; @brief Caches the arrays and details for the player's secondary weapon
    ;
    ; Looks up the possible secondaries for their current weapon,
    ; then figures out which (if any) is equipped.
    ; Then records the OMod and caches the ammo list for the secondary calibre.
    ;
    ; **Parallel:** Yes, can parallelise - no changes to actors.
    ; ----------------------------------------
    omodPlayerSecondary = None
    If !weapPlayerCurrentWeapon
        Return
    EndIf

    FormList flstSecondary = GetPossibleSecondaryLists(PlayerRef)
    If flstSecondary
        Debug.Trace("Loads_v2:ParallelCachePlayerSecondary: Caching secondary mode - "+flstSecondary)

        Int iPlayerSecondaryIndex = -1

        ; This formlist contains:
        ; 0 - List of calibre formlists for each possible secondary
        ; 1 - List of keywords for each possible secondary
        ; 2 - List of omods for each possible secondary

        FormList flstPossibleSecondaryKeywords = flstSecondary.GetAt(1) as FormList
        Int iLoop = flstPossibleSecondaryKeywords.GetSize() -1

        ; This isn't using the functions as it's checking the actual formlist, to save the overhead of converting it
        While(iLoop > -1 && iPlayerSecondaryIndex < 0)
            Debug.Trace("Loads_v2:ParallelCachePlayerSecondary: Loop "+iLoop+", keyword "+(flstPossibleSecondaryKeywords.GetAt(iLoop) as Keyword))
            If PlayerRef.WornHasKeyword(flstPossibleSecondaryKeywords.GetAt(iLoop) as Keyword)
                iPlayerSecondaryIndex = iLoop
                Debug.Trace("Loads_v2:ParallelCachePlayerSecondary: Player's secondary is - "+iPlayerSecondaryIndex)
            Else
                iLoop -= 1
            EndIf
        EndWhile

        If (iPlayerSecondaryIndex > -1)
            ; If they have a secondary, let's get the details and cache it
            omodPlayerSecondary = (flstSecondary.GetAt(2) as FormList).GetAt(iPlayerSecondaryIndex) as ObjectMod
            FormList flstPlayerSecondaryCalibre = (flstSecondary.GetAt(0) as FormList).GetAt(iPlayerSecondaryIndex) as FormList

            Debug.Trace("Loads_v2:ParallelCachePlayerSecondaryAmmoType: Caching calibre list - "+flstPlayerSecondaryCalibre)
            iPlayerSecondaryCalibreLength = (flstPlayerSecondaryCalibre.GetAt(0) as FormList).GetSize()
            ammoArPlayerSecondaryCalibre = FillArrayFromFormList(flstPlayerSecondaryCalibre.GetAt(0) as FormList, new Ammo[32] as Form[]) as Ammo[]
            kywdArPlayerSecondaryCalibre = FillArrayFromFormList(flstPlayerSecondaryCalibre.GetAt(1) as FormList, new Keyword[32] as Form[]) as Keyword[]
            omodArPlayerSecondaryCalibre = FillArrayFromFormList(flstPlayerSecondaryCalibre.GetAt(2) as FormList, new ObjectMod[32] as Form[]) as ObjectMod[]
            Debug.Trace("Loads_v2:ParallelCachePlayerSecondaryAmmoType: Cached calibre - "+iPlayerSecondaryCalibreLength+" types")
            DebugTraceArray(omodArPlayerSecondaryCalibre as Form[], iPlayerSecondaryCalibreLength)

            Debug.Trace("Loads_v2:ParallelCachePlayerSecondary: Cached secondary mode - "+omodPlayerSecondary.GetName()+" "+omodPlayerSecondary+", active? "+bPlayerSecondaryActive)
            If bPlayerSecondaryActive
                ; If the player's secondary is active, find the ammo from the lists
                Debug.Notification(omodPlayerSecondary.GetName()+" active")
                iPlayerSecondaryCalibreAmmoCurrent = GetIndexForWornKeyword(PlayerRef, kywdArPlayerSecondaryCalibre, iPlayerSecondaryCalibreLength, aiDefault=0)
            Else
                ; Otherwise, that last ammo is on the 'last ammo' tags
                iPlayerSecondaryCalibreAmmoCurrent = GetIndexForWornKeyword(PlayerRef, kywdArAmmoLast, kywdArAmmoLast.Length, aiDefault=0)
            EndIf
            Debug.Trace("Loads_v2:ParallelCachePlayerSecondary: Current ammo type - "+iPlayerSecondaryCalibreAmmoCurrent+"/"+iPlayerSecondaryCalibreLength)
        EndIf

    Else
        Debug.Trace("Loads_v2:ParallelCachePlayerSecondary: No supported secondary modes")
    EndIf
EndFunction


Function ParallelCachePlayerPrimaryMode()
    ; ----------------------------------------
    ; Checks the player for keywords indicating a list of supported modes,
    ; then caches the formlists for those modes and checks the current one.
    ;
    ; **Parallel:** Yes, can parallelise - no changes to actors
    ; ----------------------------------------
    Debug.Trace("Loads_v2:ParallelCachePlayerPrimaryMode: Caching for "+PlayerRef)
    iPlayerPrimaryModeLength = 0
    iPlayerPrimaryModeCurrent = -1
    kywdArPlayerPrimaryModeAllowed = None
    kywdArPlayerPrimaryModeSelected = None
    omodArPlayerPrimaryModeSelected = None

    If !weapPlayerCurrentWeapon
        Return
    EndIf

    ; Lookup if the player has any of kywdArPrimaryModes: This means they have the flstArPrimaryModes at the same index available.
    FormList flstPrimaryModes = GetPrimaryModeLists(PlayerRef, weapPlayerCurrentWeapon)

    If flstPrimaryModes
        ; If they do, cache the arrays of keywords of the modes available (flstPrimaryModes[0]) and the corresponding omod for that keyword (flstPrimaryModes[1])
        Debug.Trace("Loads_v2:ParallelCachePlayerPrimaryMode: Caching modes from "+flstPrimaryModes)
        iPlayerPrimaryModeLength = (flstPrimaryModes.GetAt(0) as FormList).GetSize()
        kywdArPlayerPrimaryModeAllowed = FillArrayFromFormList(flstPrimaryModes.GetAt(0) as FormList, new Keyword[32] as Form[]) as Keyword[]
        kywdArPlayerPrimaryModeSelected = FillArrayFromFormList(flstPrimaryModes.GetAt(1) as FormList, new Keyword[32] as Form[]) as Keyword[]
        omodArPlayerPrimaryModeSelected = FillArrayFromFormList(flstPrimaryModes.GetAt(2) as FormList, new ObjectMod[32] as Form[]) as ObjectMod[]
        Debug.Trace("Loads_v2:ParallelCachePlayerPrimaryMode: Cached modes - "+iPlayerPrimaryModeLength+" types")

        If bPlayerSecondaryActive
            Debug.Trace("Loads_v2: Secondary active, looking for last mode")
            ; DebugTraceArray(kywdArPrimaryModeLast as Form[], kywdArPrimaryModeLast.Length)
            iPlayerPrimaryModeCurrent = GetIndexForWornKeyword(PlayerRef, kywdArPrimaryModeLast, kywdArPrimaryModeLast.Length, aiDefault=0)
        Else
            iPlayerPrimaryModeCurrent = GetIndexForWornKeyword(PlayerRef, kywdArPlayerPrimaryModeSelected, iPlayerPrimaryModeLength, aiDefault=0)
        EndIf

        Debug.Trace("Loads_v2:ParallelCachePlayerPrimaryMode: Current primary mode - "+iPlayerPrimaryModeCurrent+"/"+iPlayerPrimaryModeLength)

    Else
        Debug.Trace("Loads_v2:ParallelCachePlayerPrimaryMode: No primary mode keywords found")
    EndIf
EndFunction


Function ParallelCachePlayerPrimaryAmmoType()
    ; ----------------------------------------
    ; Examines the player's primary weapon to find the ammo calibre,
    ; caches the formlists to arrays, then finds their current equipped ammo

    ; **Parallel:** Yes, can parallelise - no changes to actors
    ; ----------------------------------------
    Debug.Trace("Loads_v2:ParallelCachePlayerPrimaryAmmoType: Caching for "+PlayerRef)
    iPlayerPrimaryCalibreAmmoCurrent = -1
    iPlayerPrimaryCalibreLength = -1
    ammoArPlayerPrimaryCalibre = None
    kywdArPlayerPrimaryCalibre = None
    omodArPlayerPrimaryCalibre = None

    If !weapPlayerCurrentWeapon
        Return

    ElseIf weapPlayerCurrentWeapon.GetAmmo()
        ; If the player's weapon uses ammo, try to find the calibre list for it
        FormList flstCalibre = GetCalibreLists(PlayerRef, weapPlayerCurrentWeapon)

        If flstCalibre
            ; If we do, then cache the contents
            Debug.Trace("Loads_v2:ParallelCachePlayerPrimaryAmmoType: Caching calibre list - "+flstCalibre)
            iPlayerPrimaryCalibreLength = (flstCalibre.GetAt(0) as FormList).GetSize()
            ammoArPlayerPrimaryCalibre = FillArrayFromFormList(flstCalibre.GetAt(0) as FormList, new Ammo[32] as Form[]) as Ammo[]
            kywdArPlayerPrimaryCalibre = FillArrayFromFormList(flstCalibre.GetAt(1) as FormList, new Keyword[32] as Form[]) as Keyword[]
            omodArPlayerPrimaryCalibre = FillArrayFromFormList(flstCalibre.GetAt(2) as FormList, new ObjectMod[32] as Form[]) as ObjectMod[]
            Debug.Trace("Loads_v2:ParallelCachePlayerPrimaryAmmoType: Cached calibre - "+iPlayerPrimaryCalibreLength+" types")

            If bPlayerSecondaryActive
                ; If the player's secondary is active, then the 'current' primary ammo is determined by the 'Last Ammo' keyword
                iPlayerPrimaryCalibreAmmoCurrent = GetIndexForWornKeyword(PlayerRef, kywdArAmmoLast, kywdArAmmoLast.Length, aiDefault=0)
            Else
                ; Look up the player's current ammo from the lists
                iPlayerPrimaryCalibreAmmoCurrent = GetIndexForWornKeyword(PlayerRef, kywdArPlayerPrimaryCalibre, iPlayerPrimaryCalibreLength, aiDefault=0)
            EndIf
            Debug.Trace("Loads_v2:ParallelCachePlayerPrimaryAmmoType: Current ammo type - "+iPlayerPrimaryCalibreAmmoCurrent+"/"+iPlayerPrimaryCalibreLength)

        Else
            Debug.Trace("Loads_v2:ParallelCachePlayerPrimaryAmmoType: Not a supported calibre")
        EndIf

    Else
        Debug.Trace("Loads_v2:ParallelCachePlayerPrimaryAmmoType: Weapon doesn't use ammo")
    EndIf
EndFunction


Int Function GetPlayerAmmoLastIndex()
    ; ----------------------------------------
    ; What was the last ammo the player had equipped?
    ;
    ; **Frames:** 1 + up to 1 per possible last ammo index
    ;
    ; @returns: The index of the last equipped ammo for the <primary if secondary/secondary if primary>,
    ;    or -1 if it's not recorded, or 0 if none found.
    ; ----------------------------------------
    If PlayerRef.WornHasKeyword(a0aLOADS_KYWD_AmmoLast)
        Debug.Trace("Loads_v2:GetPlayerAmmoLastIndex: Had previous equipped ammo, checking for keyword")
        Return GetIndexForWornKeyword(PlayerRef, kywdArAmmoLast, kywdArAmmoLast.Length, aiDefault=0)
    Else
        Debug.Trace("Loads_v2:GetPlayerAmmoLastIndex: No generic last ammo index keyword")
        Return -1
    EndIf
EndFunction


Int Function GetPlayerPrimaryModeLastIndex()
    ; ----------------------------------------
    ; @brief: When switching between primary <-> secondary, what was the last mode for the primary weapon?
    ;
    ; **Frames:** 1 + up to 1 per possible primary mode history
    ; **Parallelism:** No writes. Could be called in parallel, but needs a blocker
    ;
    ; @returns: The index of the last equipped mode for the primary weapon,
    ;    or -1 if it's not recorded, or 0 if none found.
    ; ----------------------------------------
    If PlayerRef.WornHasKeyword(a0aLOADS_KYWD_PrimaryModeLast)
        Debug.Trace("Loads_v2:GetPlayerPrimaryModeLastIndex: Has primary mode options, checking for keyword")
        Return GetIndexForWornKeyword(PlayerRef, kywdArPrimaryModeLast, kywdArPrimaryModeLast.Length, aiDefault=0)
    Else
        Debug.Trace("Loads_v2:GetPlayerPrimaryModeLastIndex: No generic last mode index keyword")
        Return -1
    EndIf
EndFunction


FormList Function GetPrimaryModeLists(Actor akActor, Weapon weapEquipped)
    ; ----------------------------------------
    ; @brief: Gets the list of possible modes of fire for an actor's weapon
    ;
    ; **Frames:** 1 + up to 1 per possible primary mode
    ; **Parallelism:** No writes. Could be called in parallel, but needs a blocker
    ;
    ; @param akActor: The actor to check
    ; @param weapEquipped: Their equipped weapon (passed rather than re-found to save reuse)
    ; @returns: A list containing the lists of KYWD[allowed], KYWD[selected] & OMOD[selected], or `None` if it has no options
    ; ----------------------------------------
    If akActor.WornHasKeyword(a0aLOADS_KYWD_PrimaryMode)
        Debug.Trace("Loads_v2:GetPrimaryModeLists: Has primary mode options, checking for keyword")
        return GetFormForWornKeyword(PlayerRef, kywdArPrimaryMode, flstArPrimaryMode as Form[], iPrimaryModeLength) as FormList
    Else
        Debug.Trace("Loads_v2:GetPrimaryModeLists: Has generic primary mode keyword")
        Return None
    EndIf
EndFunction


FormList Function GetPossibleSecondaryLists(Actor akActor)
    ; ----------------------------------------
    ; @brief: Gets the list of secondary modes possible for an actor's weapon
    ;
    ; **Frames:** 1 + up to 1 per possible weapon with secondary weapon options
    ; **Parallelism:** No writes. Could be called in parallel, but needs a blocker
    ;
    ; @param akActor: The actor to check for.
    ; @returns: The list containing the lists of KYWD, OMOD & FLST, or `None` if the weapon does not support secondaries
    ; ----------------------------------------
    If akActor.WornHasKeyword(a0aLOADS_KYWD_Secondary)
        Debug.Trace("Loads_v2:GetPossibleSecondaryLists: Has a secondary, checking for keyword")
        Return GetFormForWornKeyword(PlayerRef, kywdArSecondary, flstArSecondary as Form[], iSecondaryLength) as FormList
    Else
        Debug.Trace("Loads_v2:GetPossibleSecondaryLists: No generic secondary keyword")
        Return None
    EndIf
EndFunction


FormList Function GetCalibreLists(Actor akActor, Weapon weapEquipped)
    ; ----------------------------------------
    ; @brief: Gets the list of ammo types available for an actor's weapon
    ;
    ; **Frames:** 1 + up to 1 per possible ammo for the current calibre
    ; **Parallelism:** No writes. Could be called in parallel, but needs a blocker
    ;
    ; @param akActor: The actor to check
    ; @param weapEquipped: Their equipped weapon (passed rather than re-found to save reuse)
    ; @returns: A formlist containing 3 formlists - ammo type keyword, ammo item, ammo object modifier
    ;    [FLST[AMMO], FLST[KYWD], FLST[OMOD]] or 'none' if it's not convered
    ; ----------------------------------------
    If akActor.WornHasKeyword(dn_HasReceiver_Converted)
        Debug.Trace("Loads_v2:GetCalibreLists: Has a rechambered weapon, checking for keyword")
        Return GetFormForWornKeyword(PlayerRef, kywdArCalibreConverted, flstArCalibreConverted as Form[], iCalibreConvertedLength) as FormList

    Else
        Debug.Trace("Loads_v2:GetCalibreLists: Has a normal weapon, looking up ammo for "+weapEquipped.GetName()+" "+weapEquipped)
        Int iIndex = ammoArCalibreBase.Find(weapEquipped.GetAmmo())
        If (iIndex > -1)
            Return flstArCalibreBase[iIndex]
        Else
            Return None
        EndIf
    EndIf
EndFunction


; FormList Function _flstGetCalibreListsF4SE(Actor akActor, Weapon weapEquipped)
;     ; pppp

;     int iEquippedType = akActor.GetEquippedItemType(0) ; get the equipped item type for primary equip (weapons)
;     int iEquippedSlot = iEquippedType + 32 ; add 32 because that's where the biped slot for weapons begins

;     InstanceData:Owner instWeapon = akActor.GetInstanceOwner(iEquippedSlot)
;     Keyword[] kywdArrayInstance = InstanceData.GetKeywords(instWeapon)

;     ; If this weapon has a converted receiver...
;     If kywdArrayInstance.Find(dn_HasReceiver_Converted) > -1
;         Int iLoop = 0

;         ; Then step through our list of receiver conversion tags until we find one it has
;         While (iLoop < a0aLOADS_FLST_CalibreConverted_KYWD.GetSize())
;             If kywdArrayInstance.Find(a0aLOADS_FLST_CalibreConverted_KYWD.GetAt(iLoop) as Keyword)
;                 Return a0aLOADS_FLST_CalibreConverted_FLST.GetAt(iLoop) as FormList
;             Else
;                 iLoop += 1
;             EndIf
;         EndWhile

;     Else
;         Int iIndex = a0aLOADS_FLST_CalibreBase_AMMO.Find(weapEquipped.GetAmmo())
;         If (iIndex > -1)
;             Return a0aLOADS_FLST_CalibreBase_FLST.GetAt(iIndex) as FormList
;         EndIf
;     EndIf

;     Return None
; EndFunction


; Int Function _iGetCurrentAmmoIndexF4SE(InstanceData:Owner akWeaponInstance, FormList akFlstCalibreAMMO)
;     ; ----------------------------------------
;     ; What index does the current ammo type have?
;     ;
;     ; @param akWeaponInstance: The instance of the weapon
;     ; @param flstKeywords: The list of ammo for a calibre
;     ; @returns The index of the current ammo in the ammo list, or -1 if it's not in the list
;     ; ----------------------------------------
;     Return ammoArPlayerCalibre.Find(InstanceData.GetAmmo(akWeaponInstance))
; EndFunction


Int Function GetIndexForWornKeyword(Actor akActor, Keyword[] akKeywords, Int aiLength, Int aiStart = 0, Int aiDefault = -1)
    ; ----------------------------------------
    ; Given a list of keywords, what's the index for first one the specified actor wears?
    ;
    ; **Frames:** 1 + up to 1 per possible keyword
    ; **Parallelism:** Fine, does not change actor state.
    ;
    ; @param akActor: The actor to check
    ; @param akKeywords: The list of keywords to check
    ; @param aiLength: How long that list is (needed for cached lists without content beyond a point)
    ; @param aiStart: Where in the list to start, default 0
    ; @param aiDefault: What to return if not found
    ; @returns aiDefault if not found, otherwise the index for the first keyword the actor is wearing
    ; ----------------------------------------
    Int iLoop = aiStart
    While (iLoop < aiLength)
        If akActor.WornHasKeyword(akKeywords[iLoop])
            Return iLoop
        Else
            iLoop += 1
        EndIf
    EndWhile
    Return aiDefault
EndFunction


Int Function GetIndexForWornKeywordReverse(Actor akActor, Keyword[] akKeywords, Int aiStart, Int aiMinimum = 0, Int aiDefault = -1)
    ; ----------------------------------------
    ; Given a list of keywords, what's the index for first one the specified actor wears (from the end back)?
    ;
    ; **Frames:** 1 + up to 1 per possible keyword
    ; **Parallelism:** Fine, does not change actor state.
    ;
    ; @param akActor: The actor to check
    ; @param akKeywords: The list of keywords to check
    ; @param aiStart: Where in the list to start, usually the length - 1
    ; @param aiMinimum: Where to stop scrolling down to (e.g. 1)
    ; @param aiDefault: What to return if not found
    ; @returns aiDefault if not found, otherwise the index for the first keyword the actor is wearing from the end back
    ; ----------------------------------------
    Int iLoop = aiStart
    While (iLoop >= aiMinimum)
        If akActor.WornHasKeyword(akKeywords[iLoop])
            Return iLoop
        Else
            iLoop -= 1
        EndIf
    EndWhile
    Return aiDefault
EndFunction


Form Function GetFormForWornKeyword(Actor akActor, Keyword[] akKeywords, Form[] akForms, Int aiLength, Int aiStart = 0, Form akFormDefault = None)
    ; ----------------------------------------
    ; Given a list of keywords and list of forms, find the form matching the index of the first found keyword
    ;
    ; **Frames:** 1 + up to 1 per possible keyword
    ; **Parallelism:** Fine, does not change actor state.
    ;
    ; @param akActor: The actor to check
    ; @param akKeywords: The list of keywords to check
    ; @param akForms: The list of forms to return from
    ; @param aiLength: How long that list is (needed for cached lists without content beyond a point)
    ; @param aiStart: Where in the list to start, usually the length - 1
    ; @param akFormDefault: What to return if not found
    ; @returns akFormDefault if not found, otherwise the form matching the first keyword the actor is wearing
    ; ----------------------------------------
    Int iLoop = aiStart
    While (iLoop < aiLength)
        If akActor.WornHasKeyword(akKeywords[iLoop])
            Return akForms[iLoop]
        Else
            iLoop += 1
        EndIf
    EndWhile
    Return akFormDefault
EndFunction


Bool Function bEquipThreeOMods(Actor akActor, Weapon akWeap, ObjectMod akOmod1, ObjectMod akOmod2, ObjectMod akOmod3, bool bLoud = False)
    ; ----------------------------------------
    ; @brief: Applies three object mods to the actor's weapon, or warns if it can't
    ;
    ; If the second or third OMod can't be applied, it removes the first to leave the state as originally found.
    ;
    ; **Frames:** 5-7
    ; **Parallelism:** Changes actor state, do not call with NoWait
    ;
    ; @param akActor: The actor wanting to switch
    ; @param akWeap: Their equipped weapon
    ; @param akOMod1: The first object mod
    ; @param akOMod2: The second object mod
    ; @param bLoud: Whether to show warning messages
    ; @returns: True if both OMods were successfully applied, false if not
    ; ----------------------------------------
    If (akActor.GetItemCount(akWeap) > 1)
        If bLoud
            a0aLOADS_MESG_Error_TooManyItems.Show()
        EndIf

    Else
        If !akActor.AttachModToInventoryItem(akWeap, akOmod1)
            ; Something went wrong with the first OMod application, show error message if loud
            If bLoud
                a0aLOADS_MESG_Error_Unknown.Show()
            EndIf

        ElseIf !akActor.AttachModToInventoryItem(akWeap, akOmod2)
            ; Something went wrong with this second OMod application,
            ; so remove the first and show the error message if loud (i.e. called by player)
            akActor.RemoveModFromInventoryItem(akWeap, akOmod1)
            If bLoud
                a0aLOADS_MESG_Error_Unknown.Show()
            EndIf

        ElseIf !akActor.AttachModToInventoryItem(akWeap, akOmod3)
            ; Something went wrong with this third OMod application,
            ; so remove the first and second and show the error message if loud (i.e. called by player)
            akActor.RemoveModFromInventoryItem(akWeap, akOmod1)
            akActor.RemoveModFromInventoryItem(akWeap, akOmod2)
            If bLoud
                a0aLOADS_MESG_Error_Unknown.Show()
            EndIf
        Else
            ; Everything went fine!
            return True
        EndIf
    EndIf
    return False
EndFunction


Bool Function bEquipTwoOMods(Actor akActor, Weapon akWeap, ObjectMod akOmod1, ObjectMod akOmod2, bool bLoud = False)
    ; ----------------------------------------
    ; @brief: Applies two object mods to the actor's weapon, or warns if it can't
    ;
    ; If the second OMod can't be applied, it removes the first to leave the state as originally found.
    ;
    ; **Frames:** 5-7
    ; **Parallelism:** Changes actor state, do not call with NoWait
    ;
    ; @param akActor: The actor wanting to switch
    ; @param akWeap: Their equipped weapon
    ; @param akOMod1: The first object mod
    ; @param akOMod2: The second object mod
    ; @param bLoud: Whether to show warning messages
    ; @returns: True if both OMods were successfully applied, false if not
    ; ----------------------------------------
    If (akActor.GetItemCount(akWeap) > 1)
        If bLoud
            a0aLOADS_MESG_Error_TooManyItems.Show()
        EndIf
    Else
        If !akActor.AttachModToInventoryItem(akWeap, akOmod1)
            ; Something went wrong with the first OMod application, show error message if loud
            If bLoud
                a0aLOADS_MESG_Error_Unknown.Show()
            EndIf

        ElseIf !akActor.AttachModToInventoryItem(akWeap, akOmod2)
            ; Something went wrong with this second OMod application,
            ; so remove the first and show the error message if loud (i.e. called by player)
            akActor.RemoveModFromInventoryItem(akWeap, akOmod1)
            If bLoud
                a0aLOADS_MESG_Error_Unknown.Show()
            EndIf
        Else
            ; Everything went fine!
            return True
        EndIf
    EndIf
    return False
EndFunction


Bool Function bEquipOMod(Actor akActor, Weapon akWeap, ObjectMod akOmod, bool bLoud = False)
    ; ----------------------------------------
    ; @brief: Applies an OMod (corresponding to e.g. ammo, mode), or warns if it can't.
    ;
    ; **Frames:** 1-4
    ; **Parallelism:** Changes actor state, do not call with NoWait
    ;
    ; @param akActor: The actor wanting to switch
    ; @param akWeap: Their equipped weapon
    ; @param akOMod: The object mod to apply
    ; @param bLoud: Whether to show warning messages
    ; @returns: True if the OMod was successfully applied, false if not.
    ; ----------------------------------------
    If (akActor.GetItemCount(akWeap) > 1)
        If bLoud
            a0aLOADS_MESG_Error_TooManyItems.Show()
        EndIf
    ElseIf akActor.AttachModToInventoryItem(akWeap, akOmod)
        return True
    ElseIf akActor.AttachModToInventoryItem(akWeap, a0aLOADS_OMOD_Slots)
        akActor.AttachModToInventoryItem(akWeap, akOmod)
        return True
    ElseIf bLoud
        a0aLOADS_MESG_Error_Unknown.Show()
    EndIf
    return False
EndFunction


Function AmmoCyclePrimaryNext(Keyword akKywdRequired = None)
    ; ----------------------------------------
    ; @brief: Switches to the next ammunition type in the player's inventory, or warns if there's none.
    ;
    ; **Frames:** Up to 1 per possible ammo the player's weapon can have
    ; **Parallelism:** Changes actor state, do not call with NoWait
    ;
    ; @param akKywdRequired: Optional tag to specify the type of ammo, e.g. AP, long-range
    ; ----------------------------------------
    If akKywdRequired
        Debug.Trace("Loads_v2:AmmoCyclePrimaryNext: Cycling with keyword "+akKywdRequired)
    Else
        Debug.Trace("Loads_v2:AmmoCyclePrimaryNext: Cycling")
    EndIf

    If iPlayerPrimaryCalibreLength > 0
        Ammo ammoNew = None

        ; What index does the next available ammo have?
        ; Starting at current ammo, go up until we find one.
        Int iLoop = iPlayerPrimaryCalibreAmmoCurrent + 1

        While (iLoop < iPlayerPrimaryCalibreLength) && !ammoNew
            If PlayerRef.GetItemCount(ammoArPlayerPrimaryCalibre[iLoop]) > 0
                If !akKywdRequired || ammoArPlayerPrimaryCalibre[iLoop].HasKeyword(akKywdRequired)
                    ammoNew = ammoArPlayerPrimaryCalibre[iLoop]
                EndIf
            Else
                iLoop += 1
            EndIf
        EndWhile

        If !ammoNew
            ; If we haven't found it, loop from the bottom up to see if it's there.
            iLoop = 0
            While (iLoop < iPlayerPrimaryCalibreAmmoCurrent) && !ammoNew
                If PlayerRef.GetItemCount(ammoArPlayerPrimaryCalibre[iLoop]) > 0
                    If !akKywdRequired || ammoArPlayerPrimaryCalibre[iLoop].HasKeyword(akKywdRequired)
                        ammoNew = ammoArPlayerPrimaryCalibre[iLoop]
                    EndIf
                Else
                    iLoop += 1
                EndIf
            EndWhile
        EndIf

        If ammoNew
            ; If we did find a new ammo type in inventory, equip it, or let the player know they're out!
            If bEquipOMod(PlayerRef, weapPlayerCurrentWeapon, omodArPlayerPrimaryCalibre[iLoop], True)
                ; The equip was successful, so trigger the equip message and update the current ammo.
                Debug.Notification(ammoNew.GetName()+" equipped")
                iPlayerPrimaryCalibreAmmoCurrent = iLoop
            EndIf
        Else
            ; There are no other types of acceptable ammo here
            a0aLOADS_MESG_AmmoWarning_NoAmmo.Show()
        EndIf
    Else
        ; This weapon isn't in a supported ammo type!
        a0aLOADS_MESG_AmmoError_Calibre.Show()
    EndIf
EndFunction


Function AmmoCyclePrimaryPrev(Keyword akKywdRequired = None)
    ; ----------------------------------------
    ; Switches to the previous ammunition type in the player's inventory, or warns if there's none.
    ;
    ; @param akKywdRequired: Optional tag to specify the type of ammo, e.g. AP, long-range.
    ; ----------------------------------------
    If akKywdRequired
        Debug.Trace("Loads_v2:AmmoCyclePrimaryPrev: Cycling with keyword "+akKywdRequired)
    Else
        Debug.Trace("Loads_v2:AmmoCyclePrimaryPrev: Cycling")
    EndIf

    If iPlayerPrimaryCalibreLength > 0
        Ammo ammoNew = None

        ; What index does the next available ammo have?
        ; Starting at current ammo, go down until we find one.
        Int iLoop = iPlayerPrimaryCalibreAmmoCurrent - 1

        While (iLoop > -1) && !ammoNew
            If PlayerRef.GetItemCount(ammoArPlayerPrimaryCalibre[iLoop]) > 0
                If !akKywdRequired || ammoArPlayerPrimaryCalibre[iLoop].HasKeyword(akKywdRequired)
                    ammoNew = ammoArPlayerPrimaryCalibre[iLoop]
                EndIf
            Else
                iLoop -= 1
            EndIf
        EndWhile

        If !ammoNew
            ; If we haven't found it, loop from the bottom up to see if it's there.
            iLoop = iPlayerPrimaryCalibreLength - 1
            While (iLoop > iPlayerPrimaryCalibreAmmoCurrent) && !ammoNew
                If PlayerRef.GetItemCount(ammoArPlayerPrimaryCalibre[iLoop]) > 0
                    If !akKywdRequired || ammoArPlayerPrimaryCalibre[iLoop].HasKeyword(akKywdRequired)
                        ammoNew = ammoArPlayerPrimaryCalibre[iLoop]
                    EndIf
                Else
                    iLoop -= 1
                EndIf
            EndWhile
        EndIf

        If ammoNew
            ; If we did find a new ammo type in inventory, equip it, or let the player know they're out!
            If bEquipOMod(PlayerRef, weapPlayerCurrentWeapon, omodArPlayerPrimaryCalibre[iLoop], True)
                ; The equip was successful, so trigger the equip message and update the current ammo.
                Debug.Notification(ammoNew.GetName()+" equipped")
                iPlayerPrimaryCalibreAmmoCurrent = iLoop
            EndIf
        Else
            ; There are no other types of acceptable ammo here
            a0aLOADS_MESG_AmmoWarning_NoAmmo.Show()
        EndIf
    Else
        ; This weapon isn't in a supported ammo type!
        a0aLOADS_MESG_AmmoError_Calibre.Show()
    EndIf
EndFunction


Function AmmoCycleSecondaryNext(Keyword akKywdRequired = None)
    ; ----------------------------------------
    ; @brief: Switches to the next ammunition type in the player's inventory, or warns if there's none.
    ;
    ; Duplicate of AmmoCyclePrimaryNext - concerned that passing variables won't be by pointer and will have a time cost
    ;
    ; **Frames:** Up to 1 per possible ammo the player's weapon can have
    ; **Parallelism:** Changes actor state, do not call with NoWait
    ;
    ; @param akKywdRequired: Optional tag to specify the type of ammo, e.g. AP, long-range
    ; ----------------------------------------
    If akKywdRequired
        Debug.Trace("Loads_v2:AmmoCycleSecondaryNext: Cycling with keyword "+akKywdRequired)
    Else
        Debug.Trace("Loads_v2:AmmoCycleSecondaryNext: Cycling")
    EndIf

    If iPlayerSecondaryCalibreLength > 0
        Ammo ammoNew = None

        ; What index does the next available ammo have?
        ; Starting at current ammo, go up until we find one.
        Int iLoop = iPlayerSecondaryCalibreAmmoCurrent + 1

        While (iLoop < iPlayerSecondaryCalibreLength) && !ammoNew
            If PlayerRef.GetItemCount(ammoArPlayerSecondaryCalibre[iLoop]) > 0
                If !akKywdRequired || ammoArPlayerSecondaryCalibre[iLoop].HasKeyword(akKywdRequired)
                    ammoNew = ammoArPlayerSecondaryCalibre[iLoop]
                EndIf
            Else
                iLoop += 1
            EndIf
        EndWhile

        If !ammoNew
            ; If we haven't found it, loop from the bottom up to see if it's there.
            iLoop = 0
            While (iLoop < iPlayerSecondaryCalibreAmmoCurrent) && !ammoNew
                If PlayerRef.GetItemCount(ammoArPlayerSecondaryCalibre[iLoop]) > 0
                    If !akKywdRequired || ammoArPlayerSecondaryCalibre[iLoop].HasKeyword(akKywdRequired)
                        ammoNew = ammoArPlayerSecondaryCalibre[iLoop]
                    EndIf
                Else
                    iLoop += 1
                EndIf
            EndWhile
        EndIf

        If ammoNew
            ; If we did find a new ammo type in inventory, equip it, or let the player know they're out!
            If bEquipOMod(PlayerRef, weapPlayerCurrentWeapon, omodArPlayerSecondaryCalibre[iLoop], True)
                ; The equip was successful, so trigger the equip message and update the current ammo.
                Debug.Notification(ammoNew.GetName()+" equipped")
                iPlayerSecondaryCalibreAmmoCurrent = iLoop
            EndIf
        Else
            ; There are no other types of acceptable ammo here
            a0aLOADS_MESG_AmmoWarning_NoAmmo.Show()
        EndIf
    Else
        ; This weapon isn't in a supported ammo type!
        a0aLOADS_MESG_AmmoError_Calibre.Show()
    EndIf
EndFunction



Function AmmoCycleSecondaryPrev(Keyword akKywdRequired = None)
    ; ----------------------------------------
    ; Switches to the previous ammunition type in the player's inventory, or warns if there's none.
    ;
    ; Duplicate of AmmoCyclePrimaryPrev - concerned that passing variables won't be by pointer and will have a time cost
    ;
    ; @param akKywdRequired: Optional tag to specify the type of ammo, e.g. AP, long-range.
    ; ----------------------------------------
    If akKywdRequired
        Debug.Trace("Loads_v2:AmmoCycleSecondaryPrev: Cycling with keyword "+akKywdRequired)
    Else
        Debug.Trace("Loads_v2:AmmoCycleSecondaryPrev: Cycling")
    EndIf

    If iPlayerSecondaryCalibreLength > 0
        Ammo ammoNew = None

        ; What index does the next available ammo have?
        ; Starting at current ammo, go down until we find one.
        Int iLoop = iPlayerSecondaryCalibreAmmoCurrent - 1

        While (iLoop > -1) && !ammoNew
            If PlayerRef.GetItemCount(ammoArPlayerSecondaryCalibre[iLoop]) > 0
                If !akKywdRequired || ammoArPlayerSecondaryCalibre[iLoop].HasKeyword(akKywdRequired)
                    ammoNew = ammoArPlayerSecondaryCalibre[iLoop]
                EndIf
            Else
                iLoop -= 1
            EndIf
        EndWhile

        If !ammoNew
            ; If we haven't found it, loop from the bottom up to see if it's there.
            iLoop = iPlayerSecondaryCalibreLength - 1
            While (iLoop > iPlayerSecondaryCalibreAmmoCurrent) && !ammoNew
                If PlayerRef.GetItemCount(ammoArPlayerSecondaryCalibre[iLoop]) > 0
                    If !akKywdRequired || ammoArPlayerSecondaryCalibre[iLoop].HasKeyword(akKywdRequired)
                        ammoNew = ammoArPlayerSecondaryCalibre[iLoop]
                    EndIf
                Else
                    iLoop -= 1
                EndIf
            EndWhile
        EndIf

        If ammoNew
            ; If we did find a new ammo type in inventory, equip it, or let the player know they're out!
            If bEquipOMod(PlayerRef, weapPlayerCurrentWeapon, omodArPlayerSecondaryCalibre[iLoop], True)
                ; The equip was successful, so trigger the equip message and update the current ammo.
                Debug.Notification(ammoNew.GetName()+" equipped")
                iPlayerSecondaryCalibreAmmoCurrent = iLoop
            EndIf
        Else
            ; There are no other types of acceptable ammo here
            a0aLOADS_MESG_AmmoWarning_NoAmmo.Show()
        EndIf
    Else
        ; This weapon isn't in a supported ammo type!
        a0aLOADS_MESG_AmmoError_Calibre.Show()
    EndIf
EndFunction


Function HotkeyPrimaryModeDefault()
    ; ----------------------------------------
    ; Switches to the next mode for the player's weapon.
    ; Entry-point for MCM.
    ; ----------------------------------------
    Debug.Trace("Loads_v2:HotkeyPrimaryModeDefault: Resetting")

    If bPlayerSecondaryActive
        a0aLOADS_MESG_PrimaryModeWarning_SecondaryActive.show()

    ElseIf iPlayerPrimaryModeLength > 0
        If bEquipOMod(PlayerRef, weapPlayerCurrentWeapon, a0aLOADS_OMOD_PrimaryMode_Default)
            Debug.Notification("Default mode")
        EndIf
    Else
        a0aLOADS_MESG_PrimaryModeError_NotSupported.Show()
    EndIf
EndFunction


Function HotkeyPrimaryModeCycleNext()
    ; ----------------------------------------
    ; Switches to the next mode for the player's weapon, or warns if there's none.
    ; Entry-point for MCM.
    ; ----------------------------------------
    Debug.Trace("Loads_v2:HotkeyPrimaryModeCycleNext: Cycling - "+weapPlayerCurrentWeapon)

    If bPlayerSecondaryActive
        a0aLOADS_MESG_PrimaryModeWarning_SecondaryActive.show()
        Return

    ElseIf iPlayerPrimaryModeLength > 0
        If ((iPlayerPrimaryModeCurrent+1) == iPlayerPrimaryModeLength)
            iPlayerPrimaryModeCurrent = 0
        Else
            iPlayerPrimaryModeCurrent = GetIndexForWornKeyword(PlayerRef, kywdArPlayerPrimaryModeAllowed, iPlayerPrimaryModeLength, aiStart=iPlayerPrimaryModeCurrent+1, aiDefault=0)
        EndIf

        ; Equip the found primary mode
        If bEquipOMod(PlayerRef, weapPlayerCurrentWeapon, omodArPlayerPrimaryModeSelected[iPlayerPrimaryModeCurrent], True)
            ; The equip was successful, so trigger the equip message and update the current ammo.
            Debug.Trace("Loads_v2:HotkeyPrimaryModeCycleNext: Switched to mode "+iPlayerPrimaryModeCurrent+"/"+iPlayerPrimaryModeLength+", "+omodArPlayerPrimaryModeSelected[iPlayerPrimaryModeCurrent])
            Debug.Notification(omodArPlayerPrimaryModeSelected[iPlayerPrimaryModeCurrent].GetName()+" mode")
        EndIf

    Else
        a0aLOADS_MESG_PrimaryModeError_NotSupported.Show()
    EndIf
EndFunction


Function HotkeyPrimaryModeCyclePrev()
    ; ----------------------------------------
    ; Switches to the previous mode for the player's weapon, or warns if there's none.
    ; Entry-point for MCM.
    ; ----------------------------------------
    Debug.Trace("Loads_v2:HotkeyPrimaryModeCyclePrev: Cycling - "+weapPlayerCurrentWeapon)

    If bPlayerSecondaryActive
        a0aLOADS_MESG_PrimaryModeWarning_SecondaryActive.show()
        return

    ElseIf (iPlayerPrimaryModeLength > 0)
        If (iPlayerPrimaryModeCurrent == 1)
            iPlayerPrimaryModeCurrent = 0
        ElseIf(iPlayerPrimaryModeCurrent == 0)
            iPlayerPrimaryModeCurrent = GetIndexForWornKeywordReverse(PlayerRef, kywdArPlayerPrimaryModeAllowed, aiStart=iPlayerPrimaryModeLength-1, aiMinimum=1, aiDefault=0)
        Else
            iPlayerPrimaryModeCurrent = GetIndexForWornKeywordReverse(PlayerRef, kywdArPlayerPrimaryModeAllowed, aiStart=iPlayerPrimaryModeCurrent-1, aiMinimum=1, aiDefault=0)
        EndIf

        ; Equip the found primary mode
        If bEquipOMod(PlayerRef, weapPlayerCurrentWeapon, omodArPlayerPrimaryModeSelected[iPlayerPrimaryModeCurrent], True)
            ; The equip was successful, so trigger the equip message and update the current ammo.
            Debug.Trace("Loads_v2:HotkeyPrimaryModeCyclePrev: Switched to "+iPlayerPrimaryModeCurrent+"/"+iPlayerPrimaryModeLength+", "+omodArPlayerPrimaryModeSelected[iPlayerPrimaryModeCurrent])
            Debug.Notification(omodArPlayerPrimaryModeSelected[iPlayerPrimaryModeCurrent].GetName()+" mode")
        EndIf

    Else
        a0aLOADS_MESG_PrimaryModeError_NotSupported.Show()
    EndIf
EndFunction


Function HotkeyAmmoCycleType(Keyword akAmmoKeyword)
    ; ----------------------------------------
    ; Select next available ammo with the given keyword
    ;
    ; MCM entrypoint.
    ;
    ; @param akAmmoKeyword: The keyword to require
    ; ----------------------------------------
    If bPlayerSecondaryActive
        AmmoCycleSecondaryNext(akAmmoKeyword)
    Else
        AmmoCyclePrimaryNext(akAmmoKeyword)
    EndIf
EndFunction


; ========================================
; CONTEXT HOTKEYS: Normal
; ========================================
Function HotkeyContextNext()
    ; ----------------------------------------
    ; Select next available ammo of any type
    ;
    ; MCM entrypoint.
    ; ----------------------------------------
    Debug.Trace("Loads_v2:HotkeyContextNext: Secondary - "+bPlayerSecondaryActive)
    If bPlayerSecondaryActive
        AmmoCycleSecondaryPrev(None)
    Else
        AmmoCyclePrimaryNext(None)
    EndIf
EndFunction

Function HotkeyContextPrev()
    ; ----------------------------------------
    ; Select previous available ammo of any type
    ;
    ; MCM entrypoint.
    ; ----------------------------------------
    Debug.Trace("Loads_v2:HotkeyContextPrev: Secondary - "+bPlayerSecondaryActive)
    If bPlayerSecondaryActive
        AmmoCycleSecondaryPrev(None)
    Else
        AmmoCyclePrimaryPrev(None)
    EndIf
EndFunction

Function HotkeyContextDefault()
    ; ----------------------------------------
    ; Switches the current weapon to the default ammo, if it's a supported ammo type.
    ; ----------------------------------------
    If !bPlayerSecondaryActive && iPlayerPrimaryCalibreLength > 0
        Debug.Trace("Loads_v2:HotkeyContextDefault: Switching primary ammo to default")
        If bEquipOMod(PlayerRef, weapPlayerCurrentWeapon, a0aLOADS_OMOD_Ammo_Default, True)
            ; The equip was successful, so trigger the equip message and update the current ammo.
            iPlayerPrimaryCalibreAmmoCurrent = 0
            Debug.Notification(ammoArPlayerPrimaryCalibre[0].getName()+" equipped")
        EndIf

    ElseIf bPlayerSecondaryActive && iPlayerSecondaryCalibreLength > 0
        Debug.Trace("Loads_v2:HotkeyContextDefault: Switching secondary ammo to default")
        If bEquipOMod(PlayerRef, weapPlayerCurrentWeapon, a0aLOADS_OMOD_Ammo_Default, True)
            ; The equip was successful, so trigger the equip message and update the current ammo.
            iPlayerSecondaryCalibreAmmoCurrent = 0
            Debug.Notification(ammoArPlayerSecondaryCalibre[0].getName()+" equipped")
        EndIf

    Else
        ; This weapon isn't in a supported ammo type!
        a0aLOADS_MESG_AmmoError_Calibre.Show()
    EndIf
EndFunction


Function HotkeyContextToggle()
    ; ----------------------------------------
    ; Toggles on or off the secondary weapon
    ; ----------------------------------------
    If bPlayerSecondaryActive
        If PlayerRef.AttachModToInventoryItem(weapPlayerCurrentWeapon, a0aLOADS_OMOD_Secondary_Default)
            bPlayerSecondaryActive = False
            Debug.Notification(weapPlayerCurrentWeapon.GetName()+" active")

            ; Restore the player's primary mode and ammo
            PlayerRef.AttachModToInventoryItem(weapPlayerCurrentWeapon, omodArPlayerPrimaryCalibre[iPlayerPrimaryCalibreAmmoCurrent])
            PlayerRef.AttachModToInventoryItem(weapPlayerCurrentWeapon, omodArPlayerPrimaryModeSelected[iPlayerPrimaryModeCurrent])
        Else
            a0aLOADS_MESG_Error_TooManyItems.Show()
        EndIf

    ElseIf omodPlayerSecondary
        If PlayerRef.AttachModToInventoryItem(weapPlayerCurrentWeapon, omodPlayerSecondary)
            bPlayerSecondaryActive = True
            Debug.Notification(omodPlayerSecondary.GetName()+" active")

            ; Restore the secondary's ammo, and set the primary mode reminder
            PlayerRef.AttachModToInventoryItem(weapPlayerCurrentWeapon, omodArPlayerSecondaryCalibre[iPlayerSecondaryCalibreAmmoCurrent])
            PlayerRef.AttachModToInventoryItem(weapPlayerCurrentWeapon, omodArPrimaryModeLast[iPlayerPrimaryModeCurrent])
        Else
            a0aLOADS_MESG_Error_TooManyItems.Show()
        EndIf
    Else
        a0aLOADS_MESG_SecondaryWarning_None.Show()
    EndIf
EndFunction


State ZoomedIn
    ; ========================================
    ; CONTEXT HOTKEYS: Zoomed
    ; ========================================
    Function HotkeyContextNext()
        ; ----------------------------------------
        ; Zoom in, if the player has a scope and it's not at maximum zoom already
        ; ----------------------------------------
        If iPlayerScopeZoomMax > 0
            If iPlayerScopeZoomCurrent < iPlayerScopeZoomMax
                ; If the scope isn't already at maximum zoom, apply the scope modifier, and if that works then increment the 'zoom level'
                ; Otherwise, a failed application would leave the weapon not zoomed in, but internally it would be recorded as such
                If bScopeTypeAlt
                    Debug.Trace("Loads_v2:HotkeyContextNext: Equipping alt scope: "+omodArPlayerScopeTypeAlt[iPlayerScopeZoomCurrent+1].GetName())
                    If PlayerRef.AttachModToInventoryItem(weapPlayerCurrentWeapon, omodArPlayerScopeTypeAlt[iPlayerScopeZoomCurrent+1])
                        iPlayerScopeZoomCurrent += 1
                    EndIf
                Else
                    Debug.Trace("Loads_v2:HotkeyContextNext: Equipping base scope: "+omodArPlayerScopeTypeAlt[iPlayerScopeZoomCurrent+1].GetName())
                    If PlayerRef.AttachModToInventoryItem(weapPlayerCurrentWeapon, omodArPlayerScopeTypeBase[iPlayerScopeZoomCurrent+1])
                        iPlayerScopeZoomCurrent += 1
                    EndIf
                EndIf
            EndIf
        EndIf
    EndFunction

    Function HotkeyContextPrev()
        ; ----------------------------------------
        ; Zoom out, if the player has a scope and it's not at minimum zoom already
        ; ----------------------------------------
        If iPlayerScopeZoomMax > 0
            If iPlayerScopeZoomCurrent > 0
                ; If the scope isn't already at maximum zoom, apply the scope modifier, and if that works then increment the 'zoom level'
                ; Otherwise, a failed application would leave the weapon not zoomed in, but internally it would be recorded as such
                If bScopeTypeAlt
                    Debug.Trace("Loads_v2:HotkeyContextPrev: Equipping alt scope: "+omodArPlayerScopeTypeAlt[iPlayerScopeZoomCurrent-1].GetName())
                    If PlayerRef.AttachModToInventoryItem(weapPlayerCurrentWeapon, omodArPlayerScopeTypeAlt[iPlayerScopeZoomCurrent-1])
                        iPlayerScopeZoomCurrent -= 1
                    EndIf
                Else
                    Debug.Trace("Loads_v2:HotkeyContextPrev: Equipping base scope: "+omodArPlayerScopeTypeBase[iPlayerScopeZoomCurrent-1].GetName())
                    If PlayerRef.AttachModToInventoryItem(weapPlayerCurrentWeapon, omodArPlayerScopeTypeBase[iPlayerScopeZoomCurrent-1])
                        iPlayerScopeZoomCurrent -= 1
                    EndIf
                EndIf
            EndIf
        EndIf
    EndFunction

    Function HotkeyContextDefault()
        ; ----------------------------------------
        ; Zooms the scope out to the default level of zoom
        ; ----------------------------------------
        If omodArPlayerScopeTypeBase
            If PlayerRef.AttachModToInventoryItem(weapPlayerCurrentWeapon, a0aLOADS_OMOD_ScopeZoomCurrent_Default)
                iPlayerScopeZoomCurrent == iPlayerScopeZoomMax
            EndIf
        EndIf
    EndFunction

    Function HotkeyContextToggle()
        ; ----------------------------------------
        ; Toggle off the scope zoom special effects, or them on if they're already off
        ; ----------------------------------------
        Debug.Trace("Loads_v2:HotkeyContextToggle: Triggered in zoom mode")
        If omodArPlayerScopeTypeAlt
            Debug.Trace("Loads_v2:HotkeyContextToggle: Toggling with alternate scope available")
            If bScopeTypeAlt
                Debug.Trace("Loads_v2:HotkeyContextToggle: Toggling with alternate scope active")


                If bEquipTwoOMods(PlayerRef, weapPlayerCurrentWeapon, a0aLOADS_OMOD_ScopeType_Base, omodArPlayerScopeTypeBase[iPlayerScopeZoomCurrent], bLoud=True)

                ; If PlayerRef.AttachModToInventoryItem(weapPlayerCurrentWeapon, a0aLOADS_OMOD_ScopeType_Base)
                    Debug.Trace("Loads_v2:HotkeyContextToggle: Switched off alternate scope")
                    ; PlayerRef.AttachModToInventoryItem(weapPlayerCurrentWeapon, omodArPlayerScopeTypeBase[iPlayerScopeZoomCurrent])
                    bScopeTypeAlt = False
                    a0aLOADS_MESG_ScopeType_Base.Show()
                Else
                    a0aLOADS_MESG_Error_TooManyItems.Show()
                EndIf

            Else
                Debug.Trace("Loads_v2:HotkeyContextToggle: Toggling with alternate scope inactive")

                If bEquipTwoOMods(PlayerRef, weapPlayerCurrentWeapon, a0aLOADS_OMOD_ScopeType_Alt, omodArPlayerScopeTypeAlt[iPlayerScopeZoomCurrent], bLoud=True)

                ; If PlayerRef.AttachModToInventoryItem(weapPlayerCurrentWeapon, a0aLOADS_OMOD_ScopeType_Alt)
                    Debug.Trace("Loads_v2:HotkeyContextToggle: Switched on alternate scope")
                    ; PlayerRef.AttachModToInventoryItem(weapPlayerCurrentWeapon, omodArPlayerScopeTypeAlt[iPlayerScopeZoomCurrent])
                    bScopeTypeAlt = True
                    a0aLOADS_MESG_ScopeType_Alt.Show()
                Else
                    a0aLOADS_MESG_Error_TooManyItems.Show()
                EndIf
            EndIf
        Else
            a0aLOADS_MESG_ScopeError_NotSupported.Show()
        EndIf
    EndFunction
endState


