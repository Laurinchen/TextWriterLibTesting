require("Annotations");
require("TextWriter")

-- To get more help by VSC
---@cast UI UI
---@cast Mod ModClientHook

---This function takes an array of text usable with AddStringToUI and appends the parsed strings to UIGroup
---@param UIGroup UIObject
---@param notes string[]
local function listNotes(UIGroup, notes)
    for index, value in ipairs(notes) do
        UI.CreateLabel(UIGroup).SetText("=====Note " .. tostring(index) .. "====="); --title of note
        AddStringToUI(UIGroup, value, {
            MaxWidth = 900,                                                          --Notes shouldn't be wider than this width in pixels
            WarningHandler = ProblemHandlerFactory(false, false, false),             --Deactivate all warnings, since they have been already checked by VerifyString below
        });
    end
end

---Client_PresentMenuUI hook
---@param rootParent RootParent
---@param setMaxSize fun(width: number, height: number) # Sets the max size of the dialog
---@param setScrollable fun(horizontallyScrollable: boolean, verticallyScrollable: boolean) # Set whether the dialog is scrollable both horizontal and vertically
---@param game GameClientHook
---@param close fun() # Zero parameter function that closes the dialog
function Client_PresentMenuUI(rootParent, setMaxSize, setScrollable, game, close)
    setMaxSize(1000, 700); --Set to a reasonable size

    ---Container for everything
    ---@type VerticalLayoutGroup
    local UIContent = UI.CreateVerticalLayoutGroup(rootParent);

    AddStringToUI(UIContent, "<#d3d3d3>Welcome to\n<red>THE<#FFD700>NOTES<red>MOD<#d3d3d3>!", { MaxWidth = 900 }) -- Title of Mod Menu

    ---Big Input field where users can type a new note
    ---@type TextInputField
    local UIInput = UI.CreateTextInputField(UIContent).SetPlaceholderText("Type your note here...").SetPreferredWidth(700)
        .SetPreferredHeight(300).SetFlexibleHeight(0.1).SetFlexibleWidth(0.1);

    ---Button to add a new note
    ---@type Button
    local UIAddNoteButton = UI.CreateButton(UIContent).SetText("");
    AddStringToUI(UIAddNoteButton, "<smoky black>Add Note"); -- Yes,the mod works for button content too!


    ---Container for the notes
    ---@type VerticalLayoutGroup
    local UINotes = UI.CreateVerticalLayoutGroup(UIContent);

    listNotes(UINotes, Mod.PlayerGameData.notes or {}); --lists preexisting notes, if none exist yet, displays nothing

    UIAddNoteButton.SetOnClick(
        function()
            ---Text (usable by AddStringToUI) the user wants to add to their notes
            ---@type string
            local text = UIInput.GetText();

            --- Parses the string
            ---@type VerifyResult
            local verifyresult = VerifyString(text);

            ---@type string
            local problemstring = ""
            if verifyresult.Type ~= ResultType.Success then -- if there are any problems with the parsed text
                for index, problem in ipairs(verifyresult.Problems) do
                    if problem.VerifyProblemType ~= VerifyProblemType.SymbolWithNoWidthDefined then -- ignore unrecognised symbols so non-english users can use the mod
                        problemstring = problemstring ..
                            "PROBLEM " .. tostring(index) .. ": " .. problem.VerifyProblemType ..               -- Index and name of problem
                            "\nDescription: " .. problem.Description ..                                         -- Short description of the problem
                            '\nAt: "' .. string.sub(text, problem.Position.From, problem.Position.To) .. '"\n'; -- Show which area is affected
                    end
                end
            end
            if #problemstring ~= 0 then
                -- If problemstring is non-empty (aka a problem has been identified) it will alert the user, otherwise it will add the note
                UI.Alert(problemstring);
            else
                -- Clears existing notes
                UI.Destroy(UINotes);
                UINotes = UI.CreateVerticalLayoutGroup(UIContent);

                -- Sends note to Server and relists all notes (check Server_GameCustomMessage.lua for why we use the response instead of Mod.PlayerGameData.notes)
                game.SendGameCustomMessage("Saving Note...", { note = text }, function(notes)
                    listNotes(UINotes, notes);
                end);
            end
        end
    )
end
