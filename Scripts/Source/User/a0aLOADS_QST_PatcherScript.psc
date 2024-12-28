Scriptname a0aLOADS_QST_PatcherScript extends Quest
{Handles the hotkey triggers from MCM}

a0aLOADS_QST_ManagerScript Property a0aLOADS_QST_Manager Auto Const

; What base ammo for a weapon corresponds to what set of lists?
FormList Property a0aLOADS_FLST_CalibreBase_AMMO Auto Const
FormList Property a0aLOADS_FLST_CalibreBase_FLST Auto Const

; If this weapon has a converted receiver, what keyword matches corresponds to what set of lists?
FormList Property a0aLOADS_FLST_CalibreConverted_KYWD Auto Const
FormList Property a0aLOADS_FLST_CalibreConverted_FLST Auto Const

; What scope keyword corresponds to what set of lists of current zoom OMods?
FormList Property a0aLOADS_FLST_ScopeTypeBase_KYWD Auto Const
FormList Property a0aLOADS_FLST_ScopeTypeBase_FLST Auto Const
FormList Property a0aLOADS_FLST_ScopeTypeAlt_KYWD Auto Const
FormList Property a0aLOADS_FLST_ScopeTypeAlt_FLST Auto Const

; Primary Fire modes (e.g. burst, full auto)
FormList Property a0aLOADS_FLST_PrimaryMode_KYWD Auto Const
FormList Property a0aLOADS_FLST_PrimaryMode_FLST Auto Const

; Secondary Weapon lists
FormList Property a0aLOADS_FLST_Secondary_KYWD Auto Const
FormList Property a0aLOADS_FLST_Secondary_FLST Auto Const


; ----------------------------------------
; List Patch Properties
; ----------------------------------------
; The list of patches being applied to the mod's formlists

bool bCalibreBaseLocked = False
bool bCalibreConvertedLocked = False
bool bVariantLocked = False
bool bSecondaryLocked = False
bool bWeaponWithSecondariesLocked = False
bool bPrimaryModeLocked = False
bool bWeaponWithPrimaryModesLocked = False


Function PatchInNewVariant(FormList akPatchList, String asCaller)
    Bool bError = False
    FormList flstCalibre = akPatchList.GetAt(0) as FormList
    Ammo ammoVariant = akPatchList.GetAt(1) as Ammo
    Keyword kywdVariant = akPatchList.GetAt(2) as Keyword
    ObjectMod omodVariant = akPatchList.GetAt(3) as ObjectMod

    FormList flstCalibreAmmo = flstCalibre.GetAt(0) as FormList
    FormList flstCalibreKeyword = flstCalibre.GetAt(1) as FormList
    FormList flstCalibreObjectMod = flstCalibre.GetAt(2) as FormList

    If !flstCalibre
        Debug.Trace("Loads_v2:PatchInNewVariant: "+asCaller+" patch form list "+akPatchList+" index 0 is not a form list")
        bError = True
    Else
        If !flstCalibreAmmo
            Debug.Trace("Loads_v2:PatchInNewVariant: "+asCaller+" patch form list "+akPatchList+" index 0 "+akPatchList.GetAt(0)+" is not a calibre master form list. Its index 0 should be a FLST but isn't.")
            bError = True
        ElseIf !(flstCalibreAmmo.GetAt(0) as Ammo)
            Debug.Trace("Loads_v2:PatchInNewVariant: "+asCaller+" patch form list "+akPatchList+" index 0 is not a calibre master form list. Its index 0 "+flstCalibreAmmo+" should contain AMMO but doesn't.")
            bError = True
        EndIf

        If !flstCalibreKeyword
            Debug.Trace("Loads_v2:PatchInNewVariant: "+asCaller+" patch form list "+akPatchList+" index 0 is not a calibre master form list. Its index 1 should be a FLST but isn't.")
            bError = True
        ElseIf !((akPatchList.GetAt(1) as FormList).GetAt(0) as Keyword)
            Debug.Trace("Loads_v2:PatchInNewVariant: "+asCaller+" patch form list "+akPatchList+" index 0 is not a calibre master form list. Its index 1 "+flstCalibreKeyword+" should contain KYWD but doesn't.")
            bError = True
        EndIf

        If !flstCalibreObjectMod
            Debug.Trace("Loads_v2:PatchInNewVariant: "+asCaller+" patch form list "+akPatchList+" index 0 is not a calibre master form list. Its index 2 should be a FLST but isn't.")
            bError = True
        ElseIf !((akPatchList.GetAt(1) as FormList).GetAt(0) as ObjectMod)
            Debug.Trace("Loads_v2:PatchInNewVariant: "+asCaller+" patch form list "+akPatchList+" index 0 is not a calibre master form list. Its index 2 "+flstCalibreObjectMod+" should contain OMOD but doesn't.")
            bError = True
        EndIf
    EndIf
    If !ammoVariant
        Debug.Trace("Loads_v2:PatchInNewVariant: "+asCaller+" patch form list "+akPatchList+" index 1 is not an AMMO")
        bError = True
    EndIf
    If !kywdVariant
        Debug.Trace("Loads_v2:PatchInNewVariant: "+asCaller+" patch form list "+akPatchList+" index 2 is not a KYWD")
        bError = True
    EndIf
    If !omodVariant
        Debug.Trace("Loads_v2:PatchInNewVariant: "+asCaller+" patch form list "+akPatchList+" index 3 is not an OMOD")
        bError = True
    EndIf
    If bError
        Debug.MessageBox("Error registering ammo variants from "+asCaller+". Quit and check Papyrus logs if possible.")
        Return
    EndIf

    while bVariantLocked
        Utility.wait(1.0)
    endWhile

    bVariantLocked = True
    flstCalibreAmmo.AddForm(ammoVariant)
    flstCalibreKeyword.AddForm(kywdVariant)
    flstCalibreObjectMod.AddForm(omodVariant)
    bVariantLocked = False

    CancelTimer(16)
    StartTimer(1.0, 16)
EndFunction


Function PatchInNewPrimaryMode(FormList akPatchList, String asCaller)
    Bool bError = False
    FormList flstWeapon = akPatchList.GetAt(0) as FormList
    Keyword kywdPossible = akPatchList.GetAt(1) as Keyword
    Keyword kywdSelected = akPatchList.GetAt(2) as Keyword
    ObjectMod omodSelected = akPatchList.GetAt(3) as ObjectMod

    FormList flstWeaponPossibleKeyword = flstWeapon.GetAt(0) as FormList
    FormList flstWeaponSelectedKeyword = flstWeapon.GetAt(1) as FormList
    FormList flstWeaponSelectedObjectMod = flstWeapon.GetAt(2) as FormList

    If !flstWeapon
        Debug.Trace("Loads_v2:PatchInNewPrimaryMode: "+asCaller+" patch form list "+akPatchList+" index 0 is not a form list")
        bError = True
    Else
        If !flstWeaponPossibleKeyword
            Debug.Trace("Loads_v2:PatchInNewPrimaryMode: "+asCaller+" patch form list "+akPatchList+" index 0 "+akPatchList.GetAt(0)+" is not a primary mode master form list. Its index 0 should be a FLST but isn't.")
            bError = True
        ElseIf !(flstWeaponPossibleKeyword.GetAt(0) as Keyword)
            Debug.Trace("Loads_v2:PatchInNewPrimaryMode: "+asCaller+" patch form list "+akPatchList+" index 0 is not a primary mode master form list. Its index 0 "+flstWeaponPossibleKeyword+" should contain KYWD but doesn't.")
            bError = True
        EndIf

        If !flstWeaponSelectedKeyword
            Debug.Trace("Loads_v2:PatchInNewPrimaryMode: "+asCaller+" patch form list "+akPatchList+" index 0 is not a primary mode master form list. Its index 1 should be a FLST but isn't.")
            bError = True
        ElseIf !((akPatchList.GetAt(1) as FormList).GetAt(0) as Keyword)
            Debug.Trace("Loads_v2:PatchInNewPrimaryMode: "+asCaller+" patch form list "+akPatchList+" index 0 is not a primary mode master form list. Its index 1 "+flstWeaponSelectedKeyword+" should contain KYWD but doesn't.")
            bError = True
        EndIf

        If !flstWeaponSelectedObjectMod
            Debug.Trace("Loads_v2:PatchInNewPrimaryMode: "+asCaller+" patch form list "+akPatchList+" index 0 is not a primary mode master form list. Its index 2 should be a FLST but isn't.")
            bError = True
        ElseIf !((akPatchList.GetAt(1) as FormList).GetAt(0) as ObjectMod)
            Debug.Trace("Loads_v2:PatchInNewPrimaryMode: "+asCaller+" patch form list "+akPatchList+" index 0 is not a primary mode master form list. Its index 2 "+flstWeaponSelectedObjectMod+" should contain OMOD but doesn't.")
            bError = True
        EndIf
    EndIf
    If !kywdPossible
        Debug.Trace("Loads_v2:PatchInNewPrimaryMode: "+asCaller+" patch form list "+akPatchList+" index 1 is not a KYWD")
        bError = True
    EndIf
    If !kywdSelected
        Debug.Trace("Loads_v2:PatchInNewPrimaryMode: "+asCaller+" patch form list "+akPatchList+" index 2 is not a KYWD")
        bError = True
    EndIf
    If !omodSelected
        Debug.Trace("Loads_v2:PatchInNewPrimaryMode: "+asCaller+" patch form list "+akPatchList+" index 3 is not an OMOD")
        bError = True
    EndIf
    If bError
        Debug.MessageBox("Error registering primary modes from "+asCaller+". Quit and check Papyrus logs if possible.")
        Return
    EndIf

    while bPrimaryModeLocked
        Utility.wait(1.0)
    endWhile

    bPrimaryModeLocked = True
    flstWeaponPossibleKeyword.AddForm(kywdPossible)
    flstWeaponSelectedKeyword.AddForm(kywdSelected)
    flstWeaponSelectedObjectMod.AddForm(omodSelected)
    bPrimaryModeLocked = False

    CancelTimer(16)
    StartTimer(1.0, 16)
EndFunction


Function PatchInNewCalibreBase(FormList akPatchList, String asCaller)
    Ammo ammoBase = akPatchList.GetAt(0) as Ammo
    FormList flstCalibre = akPatchList.GetAt(1) as FormList

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


Function PatchInNewCalibreConverted(FormList akPatchList, String asCaller)
    Keyword kywdConverted = akPatchList.GetAt(0) as Keyword
    FormList flstCalibre = akPatchList.GetAt(1) as FormList

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


Function PatchInNewWeaponWithPrimaryModes(FormList akPatchList, String asCaller)
    Keyword kywdWeapon = akPatchList.GetAt(0) as Keyword
    FormList flstPrimaryModes = akPatchList.GetAt(1) as FormList

    While bWeaponWithPrimaryModesLocked
        Utility.wait(1.0)
    endWhile

    bWeaponWithPrimaryModesLocked = True
    a0aLOADS_FLST_PrimaryMode_KYWD.AddForm(kywdWeapon)
    a0aLOADS_FLST_PrimaryMode_FLST.AddForm(flstPrimaryModes)
    bWeaponWithPrimaryModesLocked = False

    CancelTimer(16)
    StartTimer(1.0, 16)
endFunction


Function PatchInNewWeaponWithSecondaries(FormList akPatchList, String asCaller)
    Keyword kywdWeapon = akPatchList.GetAt(0) as Keyword
    FormList flstSecondaries = akPatchList.GetAt(1) as FormList

    While bWeaponWithPrimaryModesLocked
        Utility.wait(1.0)
    endWhile

    bWeaponWithSecondariesLocked = True
    a0aLOADS_FLST_Secondary_KYWD.AddForm(kywdWeapon)
    a0aLOADS_FLST_Secondary_FLST.AddForm(flstSecondaries)
    bWeaponWithSecondariesLocked = False

    CancelTimer(16)
    StartTimer(1.0, 16)
endFunction


Event OnTimer(int aiTimerID)
    ; ----------------------------------------
    ; Runs when *any* timer elapses.
    ; @param aiTimerID: The ID of the timer that just finished. 16 is 'needs recaching'.
    ; ----------------------------------------
    If aiTimerID == 16
        a0aLOADS_QST_Manager.CacheFormLists()
    EndIf
EndEvent
