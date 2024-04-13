require("Annotations");
require("TextWriter");




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
    UITextInput.SetText("Word Word1<wbr>Word2<wbr>Word3<wbr>");


    ---@type Button
    local UIButton = UI.CreateButton(UIInput);
    UIButton.SetText("Generate");
    UIButton.SetOnClick(
        function()
            if elements ~= nil then
                for _, element in ipairs(elements) do
                    UI.Destroy(element.HorizontalLayoutGroup);
                end
            end
            elements = AddStringToUI(UIResult, UITextInput.GetText(), UIMaxWidth.GetValue());
            for _, line in ipairs(elements) do
                print(line.HorizontalLayoutGroup);
                for _, value in ipairs(line.Children) do
                    print("XXX", value.GetText());
                end
            end
        end
    );

end
