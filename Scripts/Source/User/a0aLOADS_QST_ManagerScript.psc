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

; Used to log origin of forced equips
String sForceEquipOrigin = ""

; Used whenever a var of just "[False,]" is needed
Var[] varArFalse = None

; ----------------------------------------
; MCM Menu Properties
; ----------------------------------------
; Used to prevent repeated clicks of rebuild cache
Bool Property bRebuildCache = False Auto
; Used when parallelising cache rebuilds
; Int Property iParallelCachesProcessing = -1 Auto
; Int Property iParallelCachesRebuilt = 0 Auto


; ----------------------------------------
; Ammo Switch Properties
; ----------------------------------------
; Is this a weapon?
Keyword Property ObjectTypeWeapon Auto Const

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
Int iPlayerAmmoLast = -1


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
Keyword Property a0aLOADS_KYWD_ScopeTypeAlt_On Auto Const
ObjectMod Property a0aLOADS_OMOD_ScopeTypeAlt_Off Auto Const
ObjectMod Property a0aLOADS_OMOD_ScopeTypeAlt_On Auto Const
Message Property a0aLOADS_MESG_ScopeTypeAlt_Off Auto Const
Message Property a0aLOADS_MESG_ScopeTypeAlt_On Auto Const

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

ObjectMod Property a0aLOADS_OMOD_PrimaryModeType_Default Auto Const  ; Default mode object mod
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
Int iPlayerPrimaryModeLast = -1

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
    ElseIf asMenuName == "PauseMenu"
        If !abOpening && bRebuildCache
            CacheFormLists(bForce=True)
        EndIf
    EndIf
endEvent


Function OnMCMSettingChange(string modName, string id)
    ; ----------------------------------------
    ; Called when an MCM setting for Loads_v2 is changed.
    ; PLACEHOLDER: Currently unused.
    ; ----------------------------------------
    Debug.Trace("Loads_v2:OnMCMSettingChange: "+modName+", "+id)
    If (modName == "Loads_v2") ; if you registered with OnMCMSettingChange|MCM_Demo this should always be true
        ; If (id == "loadsResetEventRegistration")
        ;     Debug.Trace("Loads_v2:OnMCMSettingChange: Matches criteria")
        ;     MCM.RefreshMenu()
        ; EndIf
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
    ;     Debug.Trace("Loads_v2:OnItemUnequipped: Force unequip - "+akBaseObject.GetName()+" "+akBaseObject+" - by -"+sForceEquipOrigin)
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
        Debug.Trace("Loads_v2:OnItemEquipped: Force equip of "+akBaseObject.GetName()+" "+akBaseObject+" by function "+sForceEquipOrigin+", time "+Utility.GetCurrentRealTime())

    ElseIf akBaseObject.HasKeyword(ObjectTypeWeapon)
        If sForceEquipOrigin != ""
            Debug.Trace("Loads_v2:OnItemEquipped: Force equip reason still set, from - "+sForceEquipOrigin)
        EndIf

        ; If the player was in secondary mode, was their primary in a non-standard mode?
        If (bPlayerSecondaryActive && iPlayerPrimaryModeLast > 0)
            ; If so, attach a reminder mod to the weapon
            PlayerRef.AttachModToInventoryItem(weapPlayerCurrentWeapon, omodArPrimaryModeLast[iPlayerPrimaryModeLast])
        EndIf

        ; Was the player's ammo non-default?
        If (iPlayerAmmoLast > 0)
            ; If so, attach a reminder mod to the weapon
            PlayerRef.AttachModToInventoryItem(weapPlayerCurrentWeapon, omodArAmmoLast[iPlayerAmmoLast])
        EndIf

        Debug.Trace("Loads_v2:OnItemEquipped: Switched from "+weapPlayerCurrentWeapon.GetName()+" "+weapPlayerCurrentWeapon+" to "+akBaseObject.GetName()+" "+akBaseObject+" on "+PlayerRef+", time "+Utility.GetCurrentRealTime())
        weapPlayerCurrentWeapon = akBaseObject as Weapon

        CallFunctionNoWait("ParallelCachePlayerPrimaryAmmoType", varArFalse)
        CallFunctionNoWait("ParallelCachePlayerPrimaryMode", varArFalse)
        CallFunctionNoWait("ParallelCachePlayerSecondary", None)
        CallFunctionNoWait("ParallelCachePlayerScope", None)

        If PlayerRef.WornHasKeyword(a0aLOADS_KYWD_PrimaryModeLast)
            iPlayerPrimaryModeLast = GetPlayerPrimaryModeLastIndex()
        Else
            iPlayerPrimaryModeLast = 0
        EndIf
    EndIf
EndEvent


Function ParallelCachePlayerScope()
    ; ----------------------------------------
    ; @brief Caches the arrays and details for the player's scope.
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

    If PlayerRef.WornHasKeyword(HasScope)
        ; Check if it's currently in alternate mode
        bScopeTypeAlt = PlayerRef.WornHasKeyword(a0aLOADS_KYWD_ScopeTypeAlt_On)
        Debug.Trace("Loads_v2:ParallelCachePlayerScope: Player weapon has scope, is alt scope active? "+bScopeTypeAlt)

        ; If the player has a scope, sift through the list of special scope types and find the list of zoom OMods associated
        Int iLoop = 0
        While (iLoop < iScopeTypeBaseLength) && !omodArPlayerScopeTypeBase
            If PlayerRef.WornHasKeyword(kywdArScopeTypeBase[iLoop])
                Debug.Trace("Loads_v2:ParallelCachePlayerScope: Found scope list "+flstArScopeTypeBase[iLoop].GetName()+" "+flstArScopeTypeBase[iLoop])
                omodArPlayerScopeTypeBase = FillArrayFromFormList(flstArScopeTypeBase[iLoop], new ObjectMod[16] as Form[]) as ObjectMod[]
            Else
                iLoop += 1
            EndIf
        EndWhile

        If !omodArPlayerScopeTypeBase
            ; If we didn't find any of the special scope type tags, then just set the scope array to the 'normal' one
            omodArPlayerScopeTypeBase = omodArScopeType_Normal
        Else
            ; If it had a special scope type... does it have an alt-type too?
            Debug.Trace("Loads_v2:ParallelCachePlayerScope: Looking for alt scope")
            FormList flstTemp = GetFormForWornKeyword(PlayerRef, kywdArScopeTypeAlt, flstArScopeTypeAlt as Form[], iScopeTypeAltLength) as FormList
            If flstTemp
                omodArPlayerScopeTypeAlt = FillArrayFromFormList(flstTemp, new ObjectMod[16] as Form[]) as ObjectMod[]
            EndIf
        EndIf

        ; Loop through the player's weapon to see what the maximum zoom is
        iPlayerScopeZoomMax = GetKeywordIndex(PlayerRef, kywdArScopeZoomMax, iScopeZoomLength)
        iPlayerScopeZoomCurrent = GetKeywordIndex(PlayerRef, kywdArScopeZoomCurrent, iPlayerScopeZoomMax)
        If iPlayerScopeZoomCurrent < 0
            ; If it's not zoomed out, then the 'current zoom' is the maximum
            iPlayerScopeZoomCurrent = iPlayerScopeZoomMax
        EndIf

        Debug.Trace("Loads_v2:ParallelCachePlayerScope: Finished checking scope - zoom "+iPlayerScopeZoomCurrent+"/"+iPlayerScopeZoomMax)
    EndIf
EndFunction


Function ParallelCachePlayerSecondary()
    ; ----------------------------------------
    ;
    ; ----------------------------------------
    omodPlayerSecondary = None
    bPlayerSecondaryActive = False

    FormList flstSecondary = flstGetSecondaryLists(PlayerRef)
    Debug.Trace("Loads_v2:ParallelCachePlayerSecondary: Secondary list is "+flstSecondary)
    If flstSecondary
        Debug.Trace("Loads_v2:ParallelCachePlayerSecondary: Caching secondary mode - "+flstSecondary.GetName()+" "+flstSecondary)
        Int iPlayerSecondaryLength = (flstSecondary.GetAt(0) as FormList).GetSize()
        Keyword[] kywdArPlayerSecondary = FillArrayFromFormList(flstSecondary.GetAt(1) as FormList, new Keyword[32] as Form[]) as Keyword[]
        Int iPlayerSecondary = GetKeywordIndex(PlayerRef, kywdArPlayerSecondary, iPlayerSecondaryLength)

        If (iPlayerSecondary > 0)
            omodPlayerSecondary = (flstSecondary.GetAt(2) as FormList).GetAt(iPlayerSecondary) as ObjectMod
            FormList flstPlayerSecondary = (flstSecondary.GetAt(1) as FormList).GetAt(iPlayerSecondary) as FormList

            bPlayerSecondaryActive = PlayerRef.WornHasKeyword(a0aLOADS_KYWD_Secondary_Active)

            Debug.Trace("Loads_v2:ParallelCachePlayerSecondaryAmmoType: Caching calibre list - "+flstPlayerSecondary)
            iPlayerPrimaryCalibreLength = (flstPlayerSecondary.GetAt(0) as FormList).GetSize()
            ammoArPlayerSecondaryCalibre = FillArrayFromFormList(flstPlayerSecondary.GetAt(0) as FormList, new Ammo[32] as Form[]) as Ammo[]
            kywdArPlayerSecondaryCalibre = FillArrayFromFormList(flstPlayerSecondary.GetAt(1) as FormList, new Keyword[32] as Form[]) as Keyword[]
            omodArPlayerSecondaryCalibre = FillArrayFromFormList(flstPlayerSecondary.GetAt(2) as FormList, new ObjectMod[32] as Form[]) as ObjectMod[]
            Debug.Trace("Loads_v2:ParallelCachePlayerSecondaryAmmoType: Cached calibre - "+iPlayerSecondaryCalibreLength+" types")

            Debug.Trace("Loads_v2:ParallelCachePlayerSecondary: Cached secondary mode - "+omodPlayerSecondary.GetName()+" "+omodPlayerSecondary+", active? "+bPlayerSecondaryActive)
            If bPlayerSecondaryActive
                ; If the player's secondary is active, find the ammo from the lists
                iPlayerSecondaryCalibreAmmoCurrent = GetKeywordIndex(PlayerRef, kywdArPlayerSecondaryCalibre, iPlayerSecondaryCalibreLength, aiDefault=0)
            Else
                ; Otherwise, that last ammo is on the 'last ammo' tags
                iPlayerSecondaryCalibreAmmoCurrent = GetKeywordIndex(PlayerRef, kywdArAmmoLast, kywdArAmmoLast.Length, aiDefault=0)
            EndIf
            Debug.Trace("Loads_v2:ParallelCachePlayerSecondary: Current ammo type - "+iPlayerPrimaryCalibreAmmoCurrent+"/"+iPlayerPrimaryCalibreLength)
        EndIf

    Else
        Debug.Trace("Loads_v2:ParallelCachePlayerSecondary: No supported secondary modes")
    EndIf
EndFunction


Function ParallelCachePlayerPrimaryMode(bool bSkipFind = False)
    ; ----------------------------------------
    ; Checks the player for keywords indicating a list of supported modes,
    ; then caches the formlists for those modes and checks the current one.
    ;
    ; @param bSkipFind: Whether to skip looking for the mode - for if the weapon has the last mode recorded on it
    ; ----------------------------------------
    Debug.Trace("Loads_v2:ParallelCachePlayerPrimaryMode: Caching for "+PlayerRef)
    iPlayerPrimaryModeLength = 0
    iPlayerPrimaryModeCurrent = -1

    ; Lookup if the player has any of kywdArPrimaryModes: This means they have the flstArPrimaryModes at the same index available.
    FormList flstPrimaryModes = flstGetPrimaryModeLists(PlayerRef, weapPlayerCurrentWeapon)

    If flstPrimaryModes
        ; If they do, cache the arrays of keywords of the modes available (flstPrimaryModes[0]) and the corresponding omod for that keyword (flstPrimaryModes[1])
        Debug.Trace("Loads_v2:ParallelCachePlayerPrimaryMode: Caching modes from "+flstPrimaryModes)
        iPlayerPrimaryModeLength = (flstPrimaryModes.GetAt(0) as FormList).GetSize()
        kywdArPlayerPrimaryModeAllowed = FillArrayFromFormList(flstPrimaryModes.GetAt(0) as FormList, new Keyword[32] as Form[]) as Keyword[]
        kywdArPlayerPrimaryModeSelected = FillArrayFromFormList(flstPrimaryModes.GetAt(1) as FormList, new Keyword[32] as Form[]) as Keyword[]
        omodArPlayerPrimaryModeSelected = FillArrayFromFormList(flstPrimaryModes.GetAt(2) as FormList, new ObjectMod[32] as Form[]) as ObjectMod[]
        Debug.Trace("Loads_v2:ParallelCachePlayerPrimaryMode: Cached modes - "+iPlayerPrimaryModeLength+" types")

        ; Iterate over the primary mode keywords available to see if any of them are equipped
        iPlayerPrimaryModeCurrent = GetKeywordIndex(PlayerRef, kywdArPlayerPrimaryModeSelected, kywdArPlayerPrimaryModeSelected.Length, aiDefault=0)

        Debug.Trace("Loads_v2:ParallelCachePlayerPrimaryMode: Current primary mode - "+iPlayerPrimaryModeCurrent+"/"+iPlayerPrimaryModeLength)

    Else
        Debug.Trace("Loads_v2:ParallelCachePlayerPrimaryMode: No primary mode keywords found")
    EndIf
EndFunction


Function ParallelCachePlayerPrimaryAmmoType(Bool bSkipFind = False)
    ; ----------------------------------------
    ; Examines the player's primary weapon to find the ammo calibre,
    ; caches the formlists to arrays, then finds their current equipped ammo
    ;
    ; @param bSkipFind: Whether to skip looking for the ammo - for if the weapon has the last ammo type recorded on it
    ; ----------------------------------------
    Debug.Trace("Loads_v2:ParallelCachePlayerPrimaryAmmoType: Caching for "+PlayerRef)
    iPlayerPrimaryCalibreAmmoCurrent = -1
    iPlayerPrimaryCalibreLength = -1
    ammoArPlayerPrimaryCalibre = None
    kywdArPlayerPrimaryCalibre = None
    omodArPlayerPrimaryCalibre = None

    If weapPlayerCurrentWeapon.GetAmmo()
        Debug.Trace("Loads_v2:ParallelCachePlayerPrimaryAmmoType: Weapon doesn't use ammo")

        FormList flstCalibre = flstGetCalibreLists(PlayerRef, weapPlayerCurrentWeapon)
        If flstCalibre
            Debug.Trace("Loads_v2:ParallelCachePlayerPrimaryAmmoType: Caching calibre list - "+flstCalibre)
            iPlayerPrimaryCalibreLength = (flstCalibre.GetAt(0) as FormList).GetSize()
            ammoArPlayerPrimaryCalibre = FillArrayFromFormList(flstCalibre.GetAt(0) as FormList, new Ammo[32] as Form[]) as Ammo[]
            kywdArPlayerPrimaryCalibre = FillArrayFromFormList(flstCalibre.GetAt(1) as FormList, new Keyword[32] as Form[]) as Keyword[]
            omodArPlayerPrimaryCalibre = FillArrayFromFormList(flstCalibre.GetAt(2) as FormList, new ObjectMod[32] as Form[]) as ObjectMod[]
            Debug.Trace("Loads_v2:ParallelCachePlayerPrimaryAmmoType: Cached calibre - "+iPlayerPrimaryCalibreLength+" types")

            If bPlayerSecondaryActive
                ; If the player's secondary is active, then the 'current' primary ammo is determined by the 'Last Ammo' keyword
                iPlayerPrimaryCalibreAmmoCurrent = GetKeywordIndex(PlayerRef, kywdArAmmoLast, kywdArAmmoLast.Length, aiDefault=0)
            Else
                ; Look up the player's current ammo from the lists
                iPlayerPrimaryCalibreAmmoCurrent = GetKeywordIndex(PlayerRef, kywdArPlayerPrimaryCalibre, iPlayerPrimaryCalibreLength, aiDefault=0)
            EndIf
            Debug.Trace("Loads_v2:ParallelCachePlayerPrimaryAmmoType: Current ammo type - "+iPlayerPrimaryCalibreAmmoCurrent+"/"+iPlayerPrimaryCalibreLength)
        Else
            Debug.Trace("Loads_v2:ParallelCachePlayerPrimaryAmmoType: Not a supported calibre")
        EndIf
    EndIf
EndFunction


Int Function GetPlayerAmmoLastIndex()
    ; ----------------------------------------
    ; What was the last ammo the player had equipped?
    ;
    ; @returns: The index of the last equipped ammo for the <primary if secondary/secondary if primary>,
    ;    or -1 if it's not recorded, or 0 if none found.
    ; ----------------------------------------
    If PlayerRef.WornHasKeyword(a0aLOADS_KYWD_AmmoLast)
        Return GetKeywordIndex(PlayerRef, kywdArAmmoLast, kywdArAmmoLast.Length, aiDefault=0)
    Else
        Return -1
    EndIf
EndFunction


Int Function GetPlayerPrimaryModeLastIndex()
    ; ----------------------------------------
    ; @brief: When switching between primary <-> secondary, what was the last mode for the primary weapon?
    ;
    ; **Frames:** 1 + up to 1 per possible primary mode history.
    ; **Parallelism:** No writes. Could be called in parallel, but needs a blocker
    ;
    ; @returns: The index of the last equipped mode for the primary weapon,
    ;    or -1 if it's not recorded, or 0 if none found.
    ; ----------------------------------------
    If PlayerRef.WornHasKeyword(a0aLOADS_KYWD_PrimaryModeLast)
        Return GetKeywordIndex(PlayerRef, kywdArPrimaryModeLast, kywdArPrimaryModeLast.Length, aiDefault=0)
    Else
        Return -1
    EndIf
EndFunction


FormList Function flstGetPrimaryModeLists(Actor akActor, Weapon weapEquipped)
    ; ----------------------------------------
    ; @brief: Gets the list of possible modes of fire for an actor's weapon
    ;
    ; **Frames:** 1 + up to 1 per possible set of primary RoFs
    ; **Parallelism:** No writes. Could be called in parallel, but needs a blocker
    ;
    ; @param akActor: The actor to check
    ; @param weapEquipped: Their equipped weapon (passed rather than re-found to save reuse)
    ; @returns: A list containing the lists of KYWD[allowed], KYWD[selected] & OMOD[selected], or `None` if it has no options
    ; ----------------------------------------
    If akActor.WornHasKeyword(a0aLOADS_KYWD_PrimaryMode)
        Debug.Trace("Loads_v2:flstGetPrimaryModeLists: Has primary mode options, checking for keyword")
        return GetFormForWornKeyword(PlayerRef, kywdArPrimaryMode, flstArPrimaryMode as Form[], iPrimaryModeLength) as FormList
    Else
        Return None
    EndIf
EndFunction


FormList Function flstGetSecondaryLists(Actor akActor)
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
        Return GetFormForWornKeyword(PlayerRef, kywdArSecondary, flstArSecondary as Form[], iSecondaryLength) as FormList
    Else
        Return None
    EndIf
EndFunction


FormList Function flstGetCalibreLists(Actor akActor, Weapon weapEquipped)
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
        Debug.Trace("Loads_v2:flstGetCalibreLists: Has a rechambered weapon, checking for keyword")
        Return GetFormForWornKeyword(PlayerRef, kywdArCalibreConverted, flstArCalibreConverted as Form[], iCalibreConvertedLength) as FormList

    Else
        Debug.Trace("Loads_v2:flstGetCalibreLists: Has a normal weapon, looking up ammo for "+weapEquipped.GetName()+" "+weapEquipped)
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

Int Function GetKeywordIndex(Actor akActor, Keyword[] akKeywords, Int aiLength, Int aiStart = 0, Int aiDefault = -1)
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


Form Function GetFormForWornKeyword(Actor akActor, Keyword[] akKeywords, Form[] akForms, Int aiLength, Int aiStart = 0, Form akFormDefault = None)
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


Bool Function bEquipOMods(Actor akActor, Weapon akWeap, ObjectMod akOmod1, ObjectMod akOmod2, bool bLoud = False)
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
        bScriptedReequip = True
        akActor.UnequipItem(akWeap, False, False)
        If !akActor.AttachModToInventoryItem(akWeap, akOmod1)
            ; Something went wrong with the first OMod application, show error message if loud
            akActor.EquipItem(akWeap, False, False)
            If bLoud
                a0aLOADS_MESG_Error_Unknown.Show()
            EndIf
            return False

        ElseIf !akActor.AttachModToInventoryItem(akWeap, akOmod2)
            ; Something went wrong with this second OMod application,
            ; so remove the first and show the error message if loud (i.e. called by player)
            akActor.RemoveModFromInventoryItem(akWeap, akOmod1)
            akActor.EquipItem(akWeap, False, False)
            If bLoud
                a0aLOADS_MESG_Error_Unknown.Show()
            EndIf
            return False
        EndIf

        akActor.EquipItem(akWeap, True, True)
        return True
    EndIf
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


Function AmmoCycleNext(Keyword akKywdRequired = None)
    ; ----------------------------------------
    ; @brief: Switches to the next ammunition type in the player's inventory, or warns if there's none.
    ; Entry-point for MCM.
    ;
    ; **Frames:** Up to 1 per possible ammo the player's weapon can have
    ; **Parallelism:** Changes actor state, do not call with NoWait
    ;
    ; @param akKywdRequired: Optional tag to specify the type of ammo, e.g. AP, long-range
    ; ----------------------------------------
    If akKywdRequired
        Debug.Trace("Loads_v2:AmmoCycleNext: Cycling with keyword "+akKywdRequired)
    Else
        Debug.Trace("Loads_v2:AmmoCycleNext: Cycling")
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
            sForceEquipOrigin = "AmmoCycleNext"
            If bEquipOMod(PlayerRef, weapPlayerCurrentWeapon, omodArPlayerPrimaryCalibre[iLoop], True)
                ; The equip was successful, so trigger the equip message and update the current ammo.
                Debug.Notification(ammoNew.GetName()+" equipped")
                iPlayerPrimaryCalibreAmmoCurrent = iLoop
            EndIf
            sForceEquipOrigin = ""
        Else
            ; There are no other types of acceptable ammo here
            a0aLOADS_MESG_AmmoWarning_NoAmmo.Show()
        EndIf
    Else
        ; This weapon isn't in a supported ammo type!
        a0aLOADS_MESG_AmmoError_Calibre.Show()
    EndIf
EndFunction


Function AmmoCyclePrev(Keyword akKywdRequired = None)
    ; ----------------------------------------
    ; Switches to the previous ammunition type in the player's inventory, or warns if there's none.
    ; Entry-point for MCM.
    ; @param akKywdRequired: Optional tag to specify the type of ammo, e.g. AP, long-range.
    ; ----------------------------------------
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
            sForceEquipOrigin = "AmmoCyclePrev"
            If bEquipOMod(PlayerRef, weapPlayerCurrentWeapon, omodArPlayerPrimaryCalibre[iLoop], True)
                ; The equip was successful, so trigger the equip message and update the current ammo.
                Debug.Notification(ammoNew.GetName()+" equipped")
                iPlayerPrimaryCalibreAmmoCurrent = iLoop
            EndIf
            sForceEquipOrigin = ""
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
    Debug.Trace("Loads_v2:HotkeyPrimaryModeDefault: Resetting, secondary - "+bPlayerSecondaryActive)

    If bPlayerSecondaryActive
        a0aLOADS_MESG_PrimaryModeWarning_SecondaryActive.show()

    ElseIf iPlayerPrimaryModeLength > 0
        sForceEquipOrigin = "HotkeyPrimaryModeDefault"
        If bEquipOMod(PlayerRef, weapPlayerCurrentWeapon, a0aLOADS_OMOD_PrimaryModeType_Default)
            Debug.Notification("Default mode")
        EndIf
        sForceEquipOrigin = ""
    Else
        a0aLOADS_MESG_PrimaryModeError_NotSupported.Show()
    EndIf
EndFunction


Function HotkeyPrimaryModeCycleNext()
    ; ----------------------------------------
    ; Switches to the next mode for the player's weapon, or warns if there's none.
    ; Entry-point for MCM.
    ; ----------------------------------------
    Debug.Trace("Loads_v2:HotkeyPrimaryModeCycleNext: Cycling, secondary - "+bPlayerSecondaryActive)

    If bPlayerSecondaryActive
        a0aLOADS_MESG_PrimaryModeWarning_SecondaryActive.show()
        return

    ElseIf iPlayerPrimaryModeLength > 0
        ObjectMod omodNew = None
        Int iLoop = iPlayerPrimaryModeCurrent + 1

        If iLoop == iPlayerPrimaryModeLength
            iLoop = 0
        EndIf

        While (iLoop < iPlayerPrimaryModeLength) && !omodNew
            If PlayerRef.WornHasKeyword(kywdArPlayerPrimaryModeAllowed[iLoop])
                omodNew = omodArPlayerPrimaryModeSelected[iLoop]
            Else
                iLoop += 1
            EndIf
        EndWhile

        If !omodNew
            omodNew = a0aLOADS_OMOD_PrimaryModeType_Default
            iLoop = 0
        EndIf

        ; Equip the found primary mode
        sForceEquipOrigin = "HotkeyPrimaryModeCycleNext"
        If bEquipOMod(PlayerRef, weapPlayerCurrentWeapon, omodNew, True)
            ; The equip was successful, so trigger the equip message and update the current ammo.
            Debug.Notification(omodNew.GetName()+" mode")
            iPlayerPrimaryModeCurrent = iLoop
        EndIf
        sForceEquipOrigin = ""

    Else
        a0aLOADS_MESG_PrimaryModeError_NotSupported.Show()
    EndIf
EndFunction


Function HotkeyPrimaryModeCyclePrev()
    ; ----------------------------------------
    ; Switches to the previous mode for the player's weapon, or warns if there's none.
    ; Entry-point for MCM.
    ; ----------------------------------------
    Debug.Trace("Loads_v2:HotkeyPrimaryModeCyclePrev: Cycling, secondary - "+bPlayerSecondaryActive)

    If bPlayerSecondaryActive
        a0aLOADS_MESG_PrimaryModeWarning_SecondaryActive.show()
        return

    ElseIf iPlayerPrimaryModeLength > 0
        ObjectMod omodNew = None
        Int iLoop = iPlayerPrimaryModeCurrent - 1

        If iLoop == -1
            iLoop = iPlayerPrimaryModeLength - 1
        EndIf

        While (iLoop > -1) && !omodNew
            If PlayerRef.WornHasKeyword(kywdArPlayerPrimaryModeAllowed[iLoop])
                omodNew = omodArPlayerPrimaryModeSelected[iLoop]
            Else
                iLoop -= 1
            EndIf
        EndWhile

        If !omodNew
            omodNew = a0aLOADS_OMOD_PrimaryModeType_Default
            iLoop = 0
        EndIf

        ; Equip the found primary mode
        sForceEquipOrigin = "HotkeyPrimaryModeCyclePrev"
        If bEquipOMod(PlayerRef, weapPlayerCurrentWeapon, omodNew, True)
            ; The equip was successful, so trigger the equip message and update the current ammo.
            Debug.Notification(omodNew.GetName()+" mode")
            iPlayerPrimaryModeCurrent = iLoop
        EndIf
        sForceEquipOrigin = ""

    Else
        a0aLOADS_MESG_PrimaryModeError_NotSupported.Show()
    EndIf
EndFunction


; ========================================
; CONTEXT HOTKEYS: Normal
; ========================================
Function HotkeyContextNext()
    ; ----------------------------------------
    ; Select next available ammo of any type
    ; ----------------------------------------
    AmmoCycleNext(None)
EndFunction

Function HotkeyContextPrev()
    ; ----------------------------------------
    ; Select previous available ammo of any type
    ; ----------------------------------------
    AmmoCyclePrev(None)
EndFunction

Function HotkeyContextDefault()
    ; ----------------------------------------
    ; Switches the current weapon to the default ammo, if it's a supported ammo type.
    ; ----------------------------------------
    If !bPlayerSecondaryActive && iPlayerPrimaryCalibreLength > 0
        If bEquipOMod(PlayerRef, weapPlayerCurrentWeapon, a0aLOADS_OMOD_Ammo_Default, True)
            ; The equip was successful, so trigger the equip message and update the current ammo.
            iPlayerPrimaryCalibreAmmoCurrent = 0
            Debug.Notification(ammoArPlayerPrimaryCalibre[0].getName()+" equipped")
        EndIf

    ElseIf bPlayerSecondaryActive && iPlayerSecondaryCalibreLength > 0
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
        sForceEquipOrigin = "HotkeyContextToggle - Secondary off"
        If PlayerRef.AttachModToInventoryItem(weapPlayerCurrentWeapon, a0aLOADS_OMOD_Secondary_Default)
            bPlayerSecondaryActive = False
            Debug.Notification(weapPlayerCurrentWeapon.GetName()+" active")

            ; If the player's primary had a non-default ammo type equipped (or the secondary currently does)
            If (iPlayerPrimaryCalibreAmmoCurrent != 0 || iPlayerSecondaryCalibreAmmoCurrent > 0)
                ; Clear that by equipping a new mod in the ammo slot
                Debug.Trace("Loads_v2:HotkeyContextToggle: Re-equipping secondary ammo "+iPlayerAmmoLast)
                sForceEquipOrigin = "HotkeyContextToggle - Re-equipping correct primary ammo"
                PlayerRef.AttachModToInventoryItem(weapPlayerCurrentWeapon, omodArPlayerPrimaryCalibre[iPlayerPrimaryCalibreAmmoCurrent])
            EndIf

            If iPlayerPrimaryModeCurrent > 0
                ; If the player's primary had a mode selected, re-apply it (which clears the 'last mode' OMOD too)
                sForceEquipOrigin = "HotkeyContextToggle - Re-equipping correct primary mode "+iPlayerPrimaryModeLast
                PlayerRef.AttachModToInventoryItem(weapPlayerCurrentWeapon, omodArPlayerPrimaryModeSelected[iPlayerPrimaryModeLast])
            EndIf
        Else
            a0aLOADS_MESG_Error_TooManyItems.Show()
        EndIf
        sForceEquipOrigin = ""

    ElseIf omodPlayerSecondary
        sForceEquipOrigin = "HotkeyContextToggle - Secondary on"
        If PlayerRef.AttachModToInventoryItem(weapPlayerCurrentWeapon, omodPlayerSecondary)
            bPlayerSecondaryActive = True
            Debug.Notification(omodPlayerSecondary.GetName()+" active")

            ; If the player's secondary last had a non-default ammo type equipped (or the primary currently does)
            If (iPlayerPrimaryCalibreAmmoCurrent > 0 || iPlayerSecondaryCalibreAmmoCurrent > 0)
                Debug.Trace("Loads_v2:HotkeyContextToggle: Re-equipping secondary ammo "+iPlayerAmmoLast)
                sForceEquipOrigin = "HotkeyContextToggle: Re-equipping secondary ammo"
                PlayerRef.AttachModToInventoryItem(weapPlayerCurrentWeapon, omodArPlayerSecondaryCalibre[iPlayerSecondaryCalibreAmmoCurrent])
            EndIf

            ; If the player's primary weapon has a mode selected, replace it with a "Remember the last primary mode" OMod
            If iPlayerPrimaryModeCurrent > 0
                sForceEquipOrigin = "HotkeyContextToggle: Equipping reminder for primary mode "+iPlayerPrimaryModeCurrent
                PlayerRef.AttachModToInventoryItem(weapPlayerCurrentWeapon, omodArPrimaryModeLast[iPlayerPrimaryModeCurrent])
            EndIf
        Else
            a0aLOADS_MESG_Error_TooManyItems.Show()
        EndIf
        sForceEquipOrigin = ""
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
                    sForceEquipOrigin = "HotkeyContextNext - Zoom alt scope in"
                    If PlayerRef.AttachModToInventoryItem(weapPlayerCurrentWeapon, omodArPlayerScopeTypeAlt[iPlayerScopeZoomCurrent+1])
                        iPlayerScopeZoomCurrent += 1
                    EndIf
                Else
                    Debug.Trace("Loads_v2:HotkeyContextNext: Equipping base scope: "+omodArPlayerScopeTypeAlt[iPlayerScopeZoomCurrent+1].GetName())
                    sForceEquipOrigin = "HotkeyContextNext - Zoom base scope in"
                    If PlayerRef.AttachModToInventoryItem(weapPlayerCurrentWeapon, omodArPlayerScopeTypeBase[iPlayerScopeZoomCurrent+1])
                        iPlayerScopeZoomCurrent += 1
                    EndIf
                EndIf
                sForceEquipOrigin = ""
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
                    Debug.Trace("Loads_v2:HotkeyContextPrev: Equipping alt scope: "+omodArPlayerScopeTypeAlt[iPlayerScopeZoomCurrent+1].GetName())
                    sForceEquipOrigin = "HotkeyContextPrev - Zoom alt scope out"
                    If PlayerRef.AttachModToInventoryItem(weapPlayerCurrentWeapon, omodArPlayerScopeTypeAlt[iPlayerScopeZoomCurrent-1])
                        iPlayerScopeZoomCurrent -= 1
                    EndIf
                Else
                    Debug.Trace("Loads_v2:HotkeyContextPrev: Equipping base scope: "+omodArPlayerScopeTypeBase[iPlayerScopeZoomCurrent+1].GetName())
                    sForceEquipOrigin = "HotkeyContextPrev - Zoom alt scope out"
                    If PlayerRef.AttachModToInventoryItem(weapPlayerCurrentWeapon, omodArPlayerScopeTypeBase[iPlayerScopeZoomCurrent-1])
                        iPlayerScopeZoomCurrent -= 1
                    EndIf
                EndIf
                sForceEquipOrigin = ""
            EndIf
        EndIf
    EndFunction

    Function HotkeyContextDefault()
        ; ----------------------------------------
        ; Zooms the scope out to the default level of zoom
        ; ----------------------------------------
        If omodArPlayerScopeTypeBase
            sForceEquipOrigin = "HotkeyContextDefault - Zoom to default"
            If PlayerRef.AttachModToInventoryItem(weapPlayerCurrentWeapon, a0aLOADS_OMOD_ScopeZoomCurrent_Default)
                iPlayerScopeZoomCurrent == iPlayerScopeZoomMax
            EndIf
            sForceEquipOrigin = ""
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
                sForceEquipOrigin = "HotkeyContextToggle - Alternate scope off"

                If bEquipOMods(PlayerRef, weapPlayerCurrentWeapon, a0aLOADS_OMOD_ScopeTypeAlt_Off, omodArPlayerScopeTypeBase[iPlayerScopeZoomCurrent], bLoud=True)

                ; If PlayerRef.AttachModToInventoryItem(weapPlayerCurrentWeapon, a0aLOADS_OMOD_ScopeTypeAlt_Off)
                    Debug.Trace("Loads_v2:HotkeyContextToggle: Switched off alternate scope")
                    sForceEquipOrigin = "HotkeyContextToggle - Base scope zoom applied"
                    ; PlayerRef.AttachModToInventoryItem(weapPlayerCurrentWeapon, omodArPlayerScopeTypeBase[iPlayerScopeZoomCurrent])
                    bScopeTypeAlt = False
                    a0aLOADS_MESG_ScopeTypeAlt_Off.Show()
                Else
                    a0aLOADS_MESG_Error_TooManyItems.Show()
                EndIf

            Else
                Debug.Trace("Loads_v2:HotkeyContextToggle: Toggling with alternate scope inactive")
                sForceEquipOrigin = "HotkeyContextToggle - Alternate scope on"

                If bEquipOMods(PlayerRef, weapPlayerCurrentWeapon, a0aLOADS_OMOD_ScopeTypeAlt_On, omodArPlayerScopeTypeAlt[iPlayerScopeZoomCurrent], bLoud=True)

                ; If PlayerRef.AttachModToInventoryItem(weapPlayerCurrentWeapon, a0aLOADS_OMOD_ScopeTypeAlt_On)
                    Debug.Trace("Loads_v2:HotkeyContextToggle: Switched on alternate scope")
                    sForceEquipOrigin = "HotkeyContextToggle - Alternate scope zoom applied"
                    ; PlayerRef.AttachModToInventoryItem(weapPlayerCurrentWeapon, omodArPlayerScopeTypeAlt[iPlayerScopeZoomCurrent])
                    bScopeTypeAlt = True
                    a0aLOADS_MESG_ScopeTypeAlt_On.Show()
                Else
                    a0aLOADS_MESG_Error_TooManyItems.Show()
                EndIf
            EndIf
            sForceEquipOrigin = ""
        Else
            a0aLOADS_MESG_ScopeError_NotSupported.Show()
        EndIf
    EndFunction
endState


; ----------------------------------------
; List Patch Properties
; ----------------------------------------
; The list of patches being applied to the mod's formlists
; This structure is set up for a 'queue' format, but we'll just use locks for the moment
; FormList Property a0aLOADS_FLST_PatchNewSubType Auto Const
; FormList Property a0aLOADS_FLST_PatchNewCalibre Auto Const

bool bCalibreBaseLocked = False
bool bCalibreConvertedLocked = False
bool bSubTypeLocked = False

Function PatchInNewSubType(FormList flstPatch)
    FormList flstCalibre = flstPatch.GetAt(0) as FormList
    Ammo ammoSubType = flstPatch.GetAt(1) as Ammo
    Keyword kywdSubType = flstPatch.GetAt(2) as Keyword
    ObjectMod omodSubType = flstPatch.GetAt(3) as ObjectMod

    FormList flstCalibreAmmo = flstCalibre.GetAt(0) as FormList
    FormList flstCalibreKeyword = flstCalibre.GetAt(1) as FormList
    FormList flstCalibreObjectMod = flstCalibre.GetAt(2) as FormList

    while bSubTypeLocked
        Utility.wait(1.0)
    endWhile

    bSubTypeLocked = True
    flstCalibreAmmo.AddForm(ammoSubType)
    flstCalibreKeyword.AddForm(kywdSubType)
    flstCalibreObjectMod.AddForm(omodSubType)
    bSubTypeLocked = False

    CancelTimer(16)
    StartTimer(1.0, 16)
EndFunction


Function PatchInNewCalibreBase(FormList flstPatch)
    Ammo ammoBase = flstPatch.GetAt(0) as Ammo
    FormList flstCalibre = flstPatch.GetAt(1) as FormList

    While bCalibreBaseLocked
        Utility.wait(1.0)
    endWhile

    bCalibreBaseLocked = True
    a0aLOADS_FLST_CalibreBase_AMMO.AddForm(ammoBase)
    a0aLOADS_FLST_CalibreBase_FLST.AddForm(flstCalibre)
    bCalibreBaseLocked = False

    CancelTimer(16)
    StartTimer(1.0, 16)
endFunction


Function PatchInNewCalibreConverted(FormList flstPatch)
    Keyword kywdConverted = flstPatch.GetAt(0) as Keyword
    FormList flstCalibre = flstPatch.GetAt(1) as FormList

    While bCalibreConvertedLocked
        Utility.wait(1.0)
    endWhile

    bCalibreConvertedLocked = True
    a0aLOADS_FLST_CalibreConverted_KYWD.AddForm(kywdConverted)
    a0aLOADS_FLST_CalibreConverted_FLST.AddForm(flstCalibre)
    bCalibreConvertedLocked = False

    CancelTimer(16)
    StartTimer(1.0, 16)
endFunction


Event OnTimer(int aiTimerID)
    ; ----------------------------------------
    ; Runs when *any* timer elapses.
    ; @param aiTimerID: The ID of the timer that just finished. 16 is 'needs recaching'.
    ; ----------------------------------------
    If aiTimerID == 16
        CacheFormLists()
    EndIf
EndEvent
