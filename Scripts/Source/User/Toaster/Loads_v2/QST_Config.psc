Scriptname Toaster:Loads_v2:QST_Config extends Quest

Toaster:Loads_v2:QST_Manager Property a0aLOADS_QST_Manager Auto Const

; More performant than Game.GetPlayer()
Actor PlayerRef

; Used to filter crafting menus to remove unnecessary entries
GlobalVariable Property a0aLOADS_GLOB_HideLoadsWorkbench Auto Const
GlobalVariable Property a0aLOADS_GLOB_HideHotkeyConsumables Auto Const


Event OnQuestInit()
    ; ----------------------------------------
    ; Register for the MCM events
    ; **Frames:** Minimum 1 + called functions.
    ; **Parallelism:** N/A
    ; ----------------------------------------
    PlayerRef = Game.GetPlayer()
    RegisterForMCMEvents()
EndEvent


Event Actor.OnPlayerLoadGame(Actor akSender)
    ; ----------------------------------------
    ; When we load the game, ensure we're registered for events
    ; **Frames:** Minimum 1 + called functions.
    ; **Parallelism:** N/A
    ;
    ; @param akSender: Unused
    ; ----------------------------------------
    PlayerRef = Game.GetPlayer()
    RegisterForMCMEvents()
EndEvent


Function RegisterForMCMEvents(Bool bLoud = False)
    ; ----------------------------------------
    ; When we load the game, ensure we're registered for events
    ; **Frames:** Minimum 1 + called functions.
    ; **Parallelism:** N/A
    ;
    ; @param bLoud: Whether to print messages to screen.
    ; ----------------------------------------
    Debug.Trace("Loads_v2:RegisterForEvents: Registering MCM events")
    RegisterForRemoteEvent(PlayerRef, "OnPlayerLoadGame")
    RegisterForExternalEvent("OnMCMOpen|Loads_v2", "OnMCMOpen")
    RegisterForExternalEvent("OnMCMSettingChange|Loads_v2", "OnMCMSettingChange")
    Debug.Trace("Loads_v2:OnPlayerLoadGame: Finished")
EndFunction


Function OnMCMSettingChange(string modName, string id)
    ; ----------------------------------------
    ; Called when an MCM setting for Loads_v2 is changed.
    ; ----------------------------------------
    Debug.Trace("Loads_v2:OnMCMSettingChange: "+modName+", "+id)
    If (modName == "Loads_v2")
        If (id == "bHideLoadsWorkbench:Display")
            If MCM.GetModSettingBool("Loads_v2", "bHideLoadsWorkbench:Display")
                a0aLOADS_GLOB_HideLoadsWorkbench.SetValue(1)
            Else
                a0aLOADS_GLOB_HideLoadsWorkbench.SetValue(0)
            EndIf
        ElseIf (id == "bHideHotkeyConsumables:Display")
            If MCM.GetModSettingBool("Loads_v2", "bHideHotkeyConsumables:Display")
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
