# Error handling via a Note Mod
## The Note Mod
We will look into error handling with a simple Note project.<br>
The Mod will support<br>
- Adding colorful Notes<br>
- Preserving notes accross turns and sitting sessions via `Mod.PlayerGameData`<br>

It will not be extensive, therefore it won't support<br>
- Editing Notes<br>
- Deleting Notes<br>
- Reordering notes<br>
- Userdefines new lines<br>
- Linking territories in notes<br>
If you're looking for a full fledged Notes Mod look into [Private Notes](https://github.com/WarzoneJK3/WarzoneMods/tree/main/PrivateNotes) by JK_3<br>

## Error Handling
### How is it usually handled
`AddStringToUI(...)` and `VerifyString(...)` usually manage Warnings and Errors differently:<br>
- `Warning`: Print to UI (to let the user know)<br>
- `Error`: Print to UI and raise exception via error()<br>

It is possible to change how errors are handled via a ProblemHandler table:<br>
```lua
---@type ProblemHandler
local myProblemHandler = {
    Cancel = ...,
    PrintToUI = ...,
    RaiseException ...,
};
```
(all values are booleans)<br>
This should be the value of the `WarningHandler` or `ErrorHandler` key in the `Options` table

It is alternatively also possible to create a ProblemHandler via a Factory Function called `ProblemHandlerFactory(...)`<br>
It currently takes 3 parameters, ordered by effect severity from least to most:<br>
1. Cancel: boolean<br>
2. PrintToUI: boolean<br>
3. RaiseException: boolean<br>
it returns a ProblemHandler table. If an argument to the function is nil, it will default to false.<br>
