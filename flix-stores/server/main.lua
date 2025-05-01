local config = require('config.shared')
local locales = require('config.locales')

local function sendDiscordWebhook(message, embedType)
    local discordWebhookUrl = "WEBHOOK"

    local embed = {}
    local content = nil

    if embedType == 1 then
        embed = {
            {
                title = "Store-Logs",
                description = message,
                color = 255,
                footer = {
                    text = "flix-stores"
                }
            }
        }
    elseif embedType == 2 then
        embed = {
            {
                title = "Cheating-Logs",
                description = message,
                color = 16711680,
                footer = {
                    text = "flix-stores"
                }
            }
        }
        content = '@everyone'
    end

    local data = {
        embeds = embed,
        content = content
    }

    PerformHttpRequest(discordWebhookUrl, function(err, text, headers)
    end, 'POST', json.encode(data), { ['Content-Type'] = 'application/json' })
end

local function validItem(itemName)
    for itemKey, _ in pairs(config.items) do
        if itemKey == itemName then
            return true
        end
    end
    return false
end

lib.callback.register('flix-stores:server:sellitem', function(source, item, input)
    local playerName = GetPlayerName(source)
    local dateAndTime = os.date("%d.%m.%Y klo %H:%M")
    local discord = GetPlayerIdentifierByType(source, 'discord')

    if not validItem(item.name) then
        local discordMessage = string.format(locales.unknownitem, playerName, discord, item.name, dateAndTime)
        sendDiscordWebhook(discordMessage, 2)
        return
    end

    local count = exports.ox_inventory:GetItemCount(source, item.name)
    if count < input then
        local discordMessage = string.format(locales.noitems, playerName, dateAndTime)
        sendDiscordWebhook(discordMessage, 2)
        return
    end

    local price = config.items[item.name].price

    exports.ox_inventory:RemoveItem(source, item.name, input)
    exports.ox_inventory:AddItem(source, 'money', price*input)

    lib.notify(source, {description = string.format(locales.solditem, item.label, input, price*input)})

    local discordMessage = string.format(locales.solditems, playerName, discord, item.label, input, price*input, dateAndTime)
    sendDiscordWebhook(discordMessage, 1)
end)

lib.callback.register('flix-stores:server:sellall', function(source, name)
    local playerName = GetPlayerName(source)
    local dateAndTime = os.date("%d.%m.%Y klo %H:%M")
    local discord = GetPlayerIdentifierByType(source, 'discord')
    local amount = 0

    for itemKey, itemData in pairs(config.items) do
        if itemData.store == name then
            if not validItem(itemKey) then
                local discordMessage = string.format(locales.unknownitem, playerName, discord, itemKey, dateAndTime)
                sendDiscordWebhook(discordMessage, 2)
                return
            end

            local count = exports.ox_inventory:GetItemCount(source, itemKey)
            if count >= 1 then
                local price = config.items[itemKey].price

                exports.ox_inventory:RemoveItem(source, itemKey, count)
                exports.ox_inventory:AddItem(source, 'money', price * count)
                amount = amount + (price * count)

                local discordMessage = string.format(locales.solditems, playerName, discord, itemKey, count, price * count, dateAndTime)
                sendDiscordWebhook(discordMessage, 1)
            end
        end
    end

    lib.notify(source, {description = locales.soldall .. amount})
end)