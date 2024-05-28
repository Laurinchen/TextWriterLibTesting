require("Annotations");

---@cast Mod ModServerHook

---Server_GameCustomMessage
---@param game GameServerHook
---@param playerID PlayerID
---@param payload table
---@param setReturn fun(payload: table) # Sets the table that will be returned to the client when the custom message has been processed
function Server_GameCustomMessage(game, playerID, payload, setReturn)
	---@type table
    local PlayerGameData = Mod.PlayerGameData; -- Fetches PlayerGameData

    --If a note collection for this player doesn't exist yet, creates a new one
    PlayerGameData[playerID] = PlayerGameData[playerID] or {};
    PlayerGameData[playerID].notes = PlayerGameData[playerID].notes or {};


    table.insert(PlayerGameData[playerID].notes, payload.note); -- adds the note
    Mod.PlayerGameData = PlayerGameData; --Updates the saved data


    --Returns the updated note collection, the reason why we don't use Mod.PlayerGameData.notes on the client side is because the callback of game.SendGameCustomMessage
    --is called BEFORE Mod.PlayerGameData gets updated on the client side.
    setReturn(Mod.PlayerGameData[playerID].notes);
end