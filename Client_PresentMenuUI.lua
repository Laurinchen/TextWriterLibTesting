require("Annotations");
require("TextWriter");

---@cast UI UI


---Client_PresentMenuUI hook
---@param rootParent RootParent
---@param setMaxSize fun(width: number, height: number) # Sets the max size of the dialog
---@param setScrollable fun(horizontallyScrollable: boolean, verticallyScrollable: boolean) # Set whether the dialog is scrollable both horizontal and vertically
---@param game GameClientHook
---@param close fun() # Zero parameter function that closes the dialog
function Client_PresentMenuUI(rootParent, setMaxSize, setScrollable, game, close)
    setMaxSize(1000, 500);

    ---@type VerticalLayoutGroup
    local UIInput = UI.CreateVerticalLayoutGroup(rootParent);

    ---@type CreatedUIElements[]
    local elements;

    ---@type VerticalLayoutGroup
    local UIResult = UI.CreateVerticalLayoutGroup(rootParent);

    ---@type NumberInputField
    local UIMaxWidth = UI.CreateNumberInputField(UIInput);
    UIMaxWidth.SetSliderMinValue(150)
    UIMaxWidth.SetSliderMaxValue(1000);

    ---@type TextInputField
    local UITextInput = UI.CreateTextInputField(UIInput)
    UITextInput.SetPreferredHeight(200);
    UITextInput.SetFlexibleWidth(700);
    UITextInput.SetText("Normal\n🕑\n<>\n<lol>\n<abcdef>\n<#oh no>\n<yay");

    ---@type NumberInputField
    local UIButtonWidthInput = UI.CreateNumberInputField(rootParent);
    UIButtonWidthInput.SetWholeNumbers(true);

    ---@type Button
    local UIWidthButton = UI.CreateButton(rootParent);

    ---@type Button
    local setButton = UI.CreateButton(rootParent);
    setButton.SetText("Let's goooo");
    setButton.SetOnClick(
        function()
            UIWidthButton.SetPreferredWidth(UIButtonWidthInput.GetValue());
        end
    )

    ---@type Button
    local UIButton = UI.CreateButton(UIInput);
    UIButton.SetText("Generate");
    UIButton.SetOnClick(
        function()
            if elements ~= nil then
                for _, element in ipairs(elements) do
                    UI.Destroy(element.LayoutGroup);
                end
            end
            elements = AddStringToUI(rootParent, UITextInput.GetText(), {MaxWidth=1000, ErrorHandler=ProblemHandlerFactory(true, true, true), WarningHandler=ProblemHandlerFactory(false, true)}).List;
        end
    );
end
