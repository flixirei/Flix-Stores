local config = require('config.shared')
local locales = require('config.locales')

local function openStore(name)
    local itemstable = {}

    table.insert(itemstable, {
        title = locales.sellall,
        icon = 'fa-solid fa-sack-dollar',
        onSelect = function()
            lib.callback.await('flix-stores:server:sellall', source, name)
        end
    })

    for itemName, itemData in pairs(config.items) do
        if itemData.store == name then
            local count = exports.ox_inventory:Search('count', itemName)

            if count > 0 then
                local inventoryItem = exports.ox_inventory:Items(itemName)
                table.insert(itemstable, {
                    title = inventoryItem.label,
                    description = string.format(locales.sellingdesc, inventoryItem.label, itemData.price),
                    icon = 'nui://ox_inventory/web/images/' .. inventoryItem.name .. '.png',
                    onSelect = function()
                        if count < 1 then
                            lib.notify({description = locales.noitem})
                            return
                        end

                        local input = lib.inputDialog(locales.sellamount, {
                            {type = 'number', label =locales.amount, description = locales.sellamountdesc .. '\n' .. locales.youhave.. count .. locales.pcs, icon = 'hashtag', required = true, default = count, min = 1, max = count},
                        })

                        if not input or input[1] == 0 then return end
                        lib.callback.await('flix-stores:server:sellitem', source, inventoryItem, input[1])
                    end
                })
            end
        end
    end

    if #itemstable == 1 then
        lib.notify({description = locales.nothingtosell})
        return
    end

    lib.registerContext({
        id = 'storeitems',
        title = config.stores[name].ped.label,
        options = itemstable
    })

    lib.showContext('storeitems')
end

for storeName, store in pairs(config.stores) do
    lib.requestModel(store.ped.model, 5000)

    while not HasModelLoaded(store.ped.model) do
        Wait(100)
    end

    local storeped = CreatePed(1, store.ped.model, store.ped.coords.x, store.ped.coords.y, store.ped.coords.z-1, store.ped.coords.w, false, false)

    SetEntityInvincible(storeped, true)
    SetBlockingOfNonTemporaryEvents(storeped, true)
    FreezeEntityPosition(storeped, true)
    TaskStartScenarioInPlace(storeped, store.ped.scenario, 0, true)

    exports.ox_target:addLocalEntity(storeped, {
        distance = 1.5,
        label = store.ped.label,
        icon = store.ped.icon,
        onSelect = function()
            openStore(storeName)
        end
    })

    if store.blip.enable then
         local storeblip = AddBlipForCoord(store.ped.coords.x, store.ped.coords.y, store.ped.coords.z)

        SetBlipSprite(storeblip, store.blip.sprite)
        SetBlipColour(storeblip, store.blip.color)
        SetBlipScale(storeblip, store.blip.scale)
        SetBlipAsShortRange(storeblip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(store.ped.label)
        EndTextCommandSetBlipName(storeblip)
    else
    end
end