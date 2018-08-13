-- There is now a UI for the calculator and some options to change the colors
-- There is an option to set a keybinding for quick pop up and down of the calculator
-- you can also use /calc open and /calc close

-- a simple calculator for use with the chat box,  by zeroIndex
-- and a big thanks to instant, ins@ESOUI for making the addonTests
-- and a huge thanks to Circonian's awesome addon tutorials @esoui/wiki
-- and a HUGE thanks to coolmodi for pointing out how much ive been overthinking this
-- which helped out a lot.


Calc = Calc or {}

local LAM2 = LibStub("LibAddonMenu-2.0")



Calc.name = "Calc"
Calc.version = 3  --edit this and reset all SV  version 3.3.4
Calc.buttons = {}
Calc.default = {
    
    OffsetX = 20,
    OffsetY = 70,
    Show = true,
    CalcBackgroundColor = {0, 0, 1, 1},
    CalcEdgeColor = {0, 0, 0, 0},
    CalcButtonColor = {0, 1, 0, 1},
    CalcButtonEdgeColor = {0, 1, 0, 1},
    CalcChatMessage = true,
    CalcAllChatTabs = true,
}




function Calc.CalcSaveLoc()
    Calc.SV.OffsetX = CalcUI:GetLeft()
    Calc.SV.OffsetY = CalcUI:GetTop()
end


local CalcError = false
local CalcInputString = ""
local CalcInput = ""



local function CalcUpdateUiText(CalcInputString)
   CalcUI_Label:SetText(CalcInputString)
end



local function CalcOnInput(CalcInput)
    if CalcInputString ~= nil then
        CalcInputString = CalcInputString .. CalcInput
        else
        CalcInputString = ""
    end
end



local function CalcGetSolution()
    if CalcInputString ~= nil then 
        CalcInputString = string.gsub(CalcInputString, "%(", "*(")
            --incase the first entry was a (
        CalcInputString = string.gsub(CalcInputString, "^*", "")
        local f = LoadString("return " .. CalcInputString)
        if f == nil then
            CalcError = true
            CalcInput = ""
            CalcUI_Label:SetText("Error")
            return ""
        else
              CalcError = false
            return f()
        end
    end
end



local function CalcAnswerToAllTabs(input)
    if CHAT_SYSTEM then
        if CHAT_SYSTEM.primaryContainer then
            if string.find(input, "%.") then
                CHAT_SYSTEM.primaryContainer:OnChatEvent(nil, "Answer: " .. string.format("%.02f", input), CHAT_CATEGORY_SYSTEM)
            else
                CHAT_SYSTEM.primaryContainer:OnChatEvent(nil, "Answer: " .. input, CHAT_CATEGORY_SYSTEM)
            end
        end
    end
end




function Calc.CalcToggleView()
    Calc.default.Show = not Calc.default.Show
    CalcUI:SetHidden(Calc.default.Show)
end




local function CreateSettingsWindow()
   	local panelData = {
		type = "panel",
		name = "Calculator",
		displayName = "|cAADDBBCalculator|r",
		author = "zeroIndex",
		version = "3.3.4",             ---update verison here due to it wiping Calc.SV with each update
		slashCommand = "/calcsettings",
		registerForRefresh = true,
		registerForDefaults = false,
	}
  LAM2:RegisterAddonPanel("CalculatorPanel", panelData)
 
    local optionsData = {
        [1] = {
            type = "colorpicker",
            name = "Background Color",
            tooltip = "Changes the color of the background.",
            getFunc = function() return unpack( Calc.SV.CalcBackgroundColor ) end,
            setFunc = function(r,g,b,a) 
                local alpha = CalcUI_Backdrop:GetAlpha()
                Calc.SV.CalcBackgroundColor = { r, g, b, a}
                CalcUI_Backdrop:SetCenterColor( r,  g,  b,  a)  
            end,
        },
        [2] = {
            type = "colorpicker",
            name = "Edge Color",
            tooltip = "Changes the edge color.",
            getFunc = function() return unpack( Calc.SV.CalcEdgeColor ) end,
            setFunc = function(r,g,b,a)
                local alpha = CalcUI_Backdrop:GetAlpha()
                Calc.SV.CalcEdgeColor = { r, g, b, a}
                CalcUI_Backdrop:SetEdgeColor( r, g, b, a)
            end,
        },
        [3] = {
            type = "colorpicker",
            name = "Button Color",
            tooltip = "Changes the color of the buttons.",
            getFunc = function() return unpack( Calc.SV.CalcButtonColor ) end,
            setFunc = function(r,g,b,a)
                local alpha = CalcUI_Backdrop_Button1_ButtonBackdrop:GetAlpha()
                Calc.SV.CalcButtonColor = {r, g, b, a}
                Calc.SV.CalcButtonEdgeColor = {r, g, b, a}
                CalcUI_Backdrop_Button1_ButtonBackdrop:SetCenterColor( r, g, b, a)
                CalcUI_Backdrop_Button2_ButtonBackdrop:SetCenterColor( r, g, b, a)
                CalcUI_Backdrop_Button3_ButtonBackdrop:SetCenterColor( r, g, b, a)
                CalcUI_Backdrop_Button4_ButtonBackdrop:SetCenterColor( r, g, b, a)
                CalcUI_Backdrop_Button5_ButtonBackdrop:SetCenterColor( r, g, b, a)
                CalcUI_Backdrop_Button6_ButtonBackdrop:SetCenterColor( r, g, b, a)
                CalcUI_Backdrop_Button7_ButtonBackdrop:SetCenterColor( r, g, b, a)
                CalcUI_Backdrop_Button8_ButtonBackdrop:SetCenterColor( r, g, b, a)
                CalcUI_Backdrop_Button9_ButtonBackdrop:SetCenterColor( r, g, b, a)
                CalcUI_Backdrop_Button0_ButtonBackdrop:SetCenterColor( r, g, b, a)
                CalcUI_Backdrop_ButtonAdd_ButtonBackdrop:SetCenterColor( r, g, b, a)
                CalcUI_Backdrop_ButtonSubtract_ButtonBackdrop:SetCenterColor( r, g, b, a)
                CalcUI_Backdrop_ButtonDivide_ButtonBackdrop:SetCenterColor( r, g, b, a)
                CalcUI_Backdrop_ButtonMultiply_ButtonBackdrop:SetCenterColor( r, g, b, a)
                CalcUI_Backdrop_ButtonDot_ButtonBackdrop:SetCenterColor( r, g, b, a)
                CalcUI_Backdrop_ButtonEquals_ButtonBackdrop:SetCenterColor( r, g, b, a)
                CalcUI_Backdrop_ButtonClear_ButtonBackdrop:SetCenterColor( r, g, b, a)
                CalcUI_Backdrop_ButtonOpenParen_ButtonBackdrop:SetCenterColor( r, g, b, a)
                CalcUI_Backdrop_ButtonCloseParen_ButtonBackdrop:SetCenterColor( r, g, b, a)
                CalcUI_Backdrop_ButtonBackspace_ButtonBackdrop:SetCenterColor( r, g, b, a)
                CalcUI_Backdrop_Button1_ButtonBackdrop:SetEdgeColor( r, g, b, a)
                CalcUI_Backdrop_Button2_ButtonBackdrop:SetEdgeColor( r, g, b, a)
                CalcUI_Backdrop_Button3_ButtonBackdrop:SetEdgeColor( r, g, b, a)
                CalcUI_Backdrop_Button4_ButtonBackdrop:SetEdgeColor( r, g, b, a)
                CalcUI_Backdrop_Button5_ButtonBackdrop:SetEdgeColor( r, g, b, a)
                CalcUI_Backdrop_Button6_ButtonBackdrop:SetEdgeColor( r, g, b, a)
                CalcUI_Backdrop_Button7_ButtonBackdrop:SetEdgeColor( r, g, b, a)
                CalcUI_Backdrop_Button8_ButtonBackdrop:SetEdgeColor( r, g, b, a)
                CalcUI_Backdrop_Button9_ButtonBackdrop:SetEdgeColor( r, g, b, a)
                CalcUI_Backdrop_Button0_ButtonBackdrop:SetEdgeColor( r, g, b, a)
                CalcUI_Backdrop_ButtonAdd_ButtonBackdrop:SetEdgeColor( r, g, b, a)
                CalcUI_Backdrop_ButtonSubtract_ButtonBackdrop:SetEdgeColor( r, g, b, a)
                CalcUI_Backdrop_ButtonDivide_ButtonBackdrop:SetEdgeColor( r, g, b, a)
                CalcUI_Backdrop_ButtonMultiply_ButtonBackdrop:SetEdgeColor( r, g, b, a)
                CalcUI_Backdrop_ButtonDot_ButtonBackdrop:SetEdgeColor( r, g, b, a)
                CalcUI_Backdrop_ButtonEquals_ButtonBackdrop:SetEdgeColor( r, g, b, a)
                CalcUI_Backdrop_ButtonClear_ButtonBackdrop:SetEdgeColor( r, g, b, a)
                CalcUI_Backdrop_ButtonOpenParen_ButtonBackdrop:SetEdgeColor( r, g, b, a)
                CalcUI_Backdrop_ButtonCloseParen_ButtonBackdrop:SetEdgeColor( r, g, b, a)
                CalcUI_Backdrop_ButtonBackspace_ButtonBackdrop:SetEdgeColor( r, g, b, a)
            end,
        },
        [4] = {
            type = "checkbox",
            name = "Send Answers from UI to Chat Tab",
            getFunc = function() return Calc.SV.CalcChatMessage end,
            setFunc = function() 
                Calc.SV.CalcChatMessage = not Calc.SV.CalcChatMessage
            end,
        },
        [5] = {
            type = "checkbox",
            name = "Send Answers to all Chat Tabs",
            getFunc = function() return Calc.SV.CalcAllChatTabs end,
            setFunc = function() 
                Calc.SV.CalcAllChatTabs = not Calc.SV.CalcAllChatTabs
            end,
        },
    }
    
    LAM2:RegisterOptionControls("CalculatorPanel", optionsData)
end


--------------**********START BUTTON STUFFS**********---------------

function Calc.CalcOnBackspaceButtonClick(self, button)
    CalcInputString = string.gsub(CalcInputString, ".$", "")
    CalcUpdateUiText(CalcInputString)

    
end



function Calc.CalcOnOneButtonClick(self, button)
    CalcInput = "1"
    CalcOnInput(CalcInput)
    CalcUpdateUiText(CalcInputString)
    
    
end
     
    
    
function Calc.CalcOnTwoButtonClick(self, button)
    CalcInput = "2"
    CalcOnInput(CalcInput)
    CalcUpdateUiText(CalcInputString)
    
end
    
 

function Calc.CalcOnThreeButtonClick(self, button)
    CalcInput = "3"
    CalcOnInput(CalcInput)
    CalcUpdateUiText(CalcInputString)
    
end
    


function Calc.CalcOnFourButtonClick(self, button)
    CalcInput = "4"
    CalcOnInput(CalcInput)
    CalcUpdateUiText(CalcInputString)
    
end


function Calc.CalcOnFiveButtonClick(self, button)
    CalcInput = "5"
    CalcOnInput(CalcInput)
    CalcUpdateUiText(CalcInputString)
    
end
    


function Calc.CalcOnSixButtonClick(self, button)
    CalcInput = "6"
    CalcOnInput(CalcInput)
    CalcUpdateUiText(CalcInputString)
    
end
    


function Calc.CalcOnSevenButtonClick(self, button)
    CalcInput = "7"
    CalcOnInput(CalcInput)
    CalcUpdateUiText(CalcInputString)
    
end



function Calc.CalcOnEightButtonClick(self, button)
    CalcInput = "8"
    CalcOnInput(CalcInput)
    CalcUpdateUiText(CalcInputString)
    
end



function Calc.CalcOnNineButtonClick(self, button)
    CalcInput = "9"
    CalcOnInput(CalcInput)
    CalcUpdateUiText(CalcInputString)
    
end
    
 

function Calc.CalcOnZeroButtonClick(self, button)
    CalcInput = "0"
    CalcOnInput(CalcInput)
    CalcUpdateUiText(CalcInputString)
    
end
 

function Calc.CalcOnAddButtonClick(self, button)
    CalcInput = "+"
    CalcOnInput(CalcInput)
    CalcUpdateUiText(CalcInputString)
  
end



function Calc.CalcOnSubtractButtonClick(self, button)
    CalcInput = "-"
    CalcOnInput(CalcInput)
    CalcUpdateUiText(CalcInputString)
    
end



function Calc.CalcOnMultiplyButtonClick(self, button)
    CalcInput = "*"
    CalcOnInput(CalcInput)
    CalcUpdateUiText(CalcInputString)
    
end
    
    

function Calc.CalcOnDivideButtonClick(self, button)
    CalcInput = "/"
    CalcOnInput(CalcInput)
    CalcUpdateUiText(CalcInputString)
    
end
    


function Calc.CalcOnDotButtonClick(self, button)
    CalcInput = "."
    CalcOnInput(CalcInput)
    CalcUpdateUiText(CalcInputString)
    
end

    

function Calc.CalcOnOpenParenButtonClick(self, button)
    CalcInput = "("
    CalcOnInput(CalcInput)
    CalcUpdateUiText(CalcInputString)
end



function Calc.CalcOnCloseParenButtonClick(self, button)
    CalcInput = ")"
    CalcOnInput(CalcInput)
    CalcUpdateUiText(CalcInputString)
end



function Calc.CalcOnClearButtonClick(self, button)
    CalcInput = ""
    CalcInputString = ""
    CalcUI_Label:SetText("Calculator")

end



function Calc.CalcOnEqualsButtonClick(self, button)
    CalcInputString = CalcGetSolution()
    if CalcError == false then
        if string.find(CalcInputString, "%.") then
            CalcUpdateUiText(string.format("%.02f", CalcInputString))
        else
            CalcUpdateUiText(CalcInputString)
        end
        if CalcInputString ~= nil then
            if Calc.SV.CalcChatMessage and not Calc.SV.CalcAllChatTabs then
                CHAT_SYSTEM:Maximize()
                if string.find(CalcInputString, "%.") then
                    d("Answer: " .. string.format("%.02f", CalcInputString))
                    CalcUpdateUiText(string.format("%.02f", CalcInputString))
                else
                    d("Answer: " .. CalcInputString)
                    --Is there any difference here?
                    --CHAT_SYSTEM:AddMessage("Answer: " .. CalcInputString)
                end
            elseif Calc.SV.CalcAllChatTabs and Calc.SV.CalcChatMessage then
                CHAT_SYSTEM:Maximize()
                CalcAnswerToAllTabs(CalcInputString)
            end
        end
    end
end



--[[
-------*************************************----------
        "command line" style chat box input
-------*************************************----------
        ]]

local function CalcTextGetSolution(text)
    text = string.gsub(text, "%s", "")
    text = string.gsub(text, "%(", "*(")
    --incase the first entry was a (
    text = string.gsub(text, "^*", "")
    text = string.gsub(text, "a", "+")
    text = string.gsub(text, "d", "/")
    text = string.gsub(text, "m", "*")
    text = string.gsub(text, "x", "*")
    text = string.gsub(text, "s", "-")
    local f = LoadString("return " .. text)
    if f == nil then
        return ""
    else
        return f()
    end
end



--lexer function for the slash command
local CalcCheckText = false
local function lexer(text)

    local text = string.lower(text)

    if text == "open" then
        CalcUI:SetHidden(not Calc.SV.Show)
        CalcCheckText = true
    end
    if text == "close" then
        CalcUI:SetHidden(Calc.SV.Show)
        CalcCheckText = true
    end
    if text ~= nil and CalcCheckText == false then
        answer = CalcTextGetSolution(text)
        if answer == "" then
            d("Error, you entered something wrong")
        else
            if Calc.SV.CalcAllChatTabs then
                CalcAnswerToAllTabs(answer)
            else
                if string.find(answer, "%.") then
                    d("Answer: " .. string.format("%.02f", answer))
                else
                    d("Answer: " .. answer)
                end
            end
        end
    end
    CalcCheckText = false
end




--initialize function
local function Initialize( event, addOnName)

-- the addOnName and the Calc.name have to match otherwise we need to stop
   if(addOnName ~= Calc.name) then return end
    

CalcUI_Label:SetText("Calculator")
    
ZO_CreateStringId("SI_BINDING_NAME_TOGGLE_VIEW", "Toggle Show/Hidden")
    
CalcUI:SetHidden(Calc.default.Show)
    
CreateSettingsWindow()


Calc.SV = ZO_SavedVars:New("Calc_SV", Calc.version, nil, Calc.default)

CalcUI:ClearAnchors()

CalcUI:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, Calc.SV.OffsetX, Calc.SV.OffsetY)
    
    
-----------******* Unpack all the SV colors *********-------------
    CalcUI_Backdrop:SetCenterColor(unpack(Calc.SV.CalcBackgroundColor))
    CalcUI_Backdrop:SetEdgeColor(unpack (Calc.SV.CalcEdgeColor))
    CalcUI_Backdrop_Button1_ButtonBackdrop:SetCenterColor( unpack (Calc.SV.CalcButtonColor))
    CalcUI_Backdrop_Button2_ButtonBackdrop:SetCenterColor( unpack (Calc.SV.CalcButtonColor))
    CalcUI_Backdrop_Button3_ButtonBackdrop:SetCenterColor( unpack (Calc.SV.CalcButtonColor))
    CalcUI_Backdrop_Button4_ButtonBackdrop:SetCenterColor( unpack (Calc.SV.CalcButtonColor))
    CalcUI_Backdrop_Button5_ButtonBackdrop:SetCenterColor( unpack (Calc.SV.CalcButtonColor))
    CalcUI_Backdrop_Button6_ButtonBackdrop:SetCenterColor( unpack (Calc.SV.CalcButtonColor))
    CalcUI_Backdrop_Button7_ButtonBackdrop:SetCenterColor( unpack (Calc.SV.CalcButtonColor))
    CalcUI_Backdrop_Button8_ButtonBackdrop:SetCenterColor( unpack (Calc.SV.CalcButtonColor))
    CalcUI_Backdrop_Button9_ButtonBackdrop:SetCenterColor( unpack (Calc.SV.CalcButtonColor))
    CalcUI_Backdrop_Button0_ButtonBackdrop:SetCenterColor( unpack (Calc.SV.CalcButtonColor))
    CalcUI_Backdrop_ButtonAdd_ButtonBackdrop:SetCenterColor( unpack (Calc.SV.CalcButtonColor))
    CalcUI_Backdrop_ButtonSubtract_ButtonBackdrop:SetCenterColor( unpack (Calc.SV.CalcButtonColor))
    CalcUI_Backdrop_ButtonDivide_ButtonBackdrop:SetCenterColor( unpack (Calc.SV.CalcButtonColor))
    CalcUI_Backdrop_ButtonMultiply_ButtonBackdrop:SetCenterColor( unpack (Calc.SV.CalcButtonColor))
    CalcUI_Backdrop_ButtonDot_ButtonBackdrop:SetCenterColor( unpack (Calc.SV.CalcButtonColor))
    CalcUI_Backdrop_ButtonEquals_ButtonBackdrop:SetCenterColor( unpack (Calc.SV.CalcButtonColor))
    CalcUI_Backdrop_ButtonClear_ButtonBackdrop:SetCenterColor( unpack (Calc.SV.CalcButtonColor))
    CalcUI_Backdrop_ButtonOpenParen_ButtonBackdrop:SetCenterColor( unpack (Calc.SV.CalcButtonColor))
    CalcUI_Backdrop_ButtonCloseParen_ButtonBackdrop:SetCenterColor( unpack (Calc.SV.CalcButtonColor))
    CalcUI_Backdrop_ButtonBackspace_ButtonBackdrop:SetCenterColor( unpack (Calc.SV.CalcButtonColor))
    CalcUI_Backdrop_Button1_ButtonBackdrop:SetEdgeColor( unpack (Calc.SV.CalcButtonEdgeColor))
    CalcUI_Backdrop_Button2_ButtonBackdrop:SetEdgeColor( unpack (Calc.SV.CalcButtonEdgeColor))
    CalcUI_Backdrop_Button3_ButtonBackdrop:SetEdgeColor( unpack (Calc.SV.CalcButtonEdgeColor))
    CalcUI_Backdrop_Button4_ButtonBackdrop:SetEdgeColor( unpack (Calc.SV.CalcButtonEdgeColor))
    CalcUI_Backdrop_Button5_ButtonBackdrop:SetEdgeColor( unpack (Calc.SV.CalcButtonEdgeColor))
    CalcUI_Backdrop_Button6_ButtonBackdrop:SetEdgeColor( unpack (Calc.SV.CalcButtonEdgeColor))
    CalcUI_Backdrop_Button7_ButtonBackdrop:SetEdgeColor( unpack (Calc.SV.CalcButtonEdgeColor))
    CalcUI_Backdrop_Button8_ButtonBackdrop:SetEdgeColor( unpack (Calc.SV.CalcButtonEdgeColor))
    CalcUI_Backdrop_Button9_ButtonBackdrop:SetEdgeColor( unpack (Calc.SV.CalcButtonEdgeColor))
    CalcUI_Backdrop_Button0_ButtonBackdrop:SetEdgeColor( unpack (Calc.SV.CalcButtonEdgeColor))
    CalcUI_Backdrop_ButtonAdd_ButtonBackdrop:SetEdgeColor( unpack (Calc.SV.CalcButtonEdgeColor))
    CalcUI_Backdrop_ButtonSubtract_ButtonBackdrop:SetEdgeColor( unpack (Calc.SV.CalcButtonEdgeColor))
    CalcUI_Backdrop_ButtonDivide_ButtonBackdrop:SetEdgeColor( unpack (Calc.SV.CalcButtonEdgeColor))
    CalcUI_Backdrop_ButtonMultiply_ButtonBackdrop:SetEdgeColor( unpack (Calc.SV.CalcButtonEdgeColor))
    CalcUI_Backdrop_ButtonDot_ButtonBackdrop:SetEdgeColor( unpack (Calc.SV.CalcButtonEdgeColor))
    CalcUI_Backdrop_ButtonEquals_ButtonBackdrop:SetEdgeColor( unpack (Calc.SV.CalcButtonEdgeColor))
    CalcUI_Backdrop_ButtonClear_ButtonBackdrop:SetEdgeColor( unpack (Calc.SV.CalcButtonEdgeColor))
    CalcUI_Backdrop_ButtonOpenParen_ButtonBackdrop:SetEdgeColor( unpack (Calc.SV.CalcButtonEdgeColor))
    CalcUI_Backdrop_ButtonCloseParen_ButtonBackdrop:SetEdgeColor( unpack (Calc.SV.CalcButtonEdgeColor))
    CalcUI_Backdrop_ButtonBackspace_ButtonBackdrop:SetEdgeColor( unpack (Calc.SV.CalcButtonColor))
   
    
--Resister a slash command
   SLASH_COMMANDS["/calc"] = lexer

--after the addon is loaded we dont need this anymore
EVENT_MANAGER:UnregisterForEvent(Calc.name, EVENT_ADD_ON_LOADED)

end

-- Register Event to initialize the addon
EVENT_MANAGER:RegisterForEvent(Calc.name, EVENT_ADD_ON_LOADED, Initialize)

