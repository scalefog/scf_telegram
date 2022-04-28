
local prompts = GetRandomIntInRange(0, 0xffffff)

function TogglePost(name)
    InMenu = true
    SetNuiFocus(true, true)
    SendNUIMessage({ type = 'openGeneral', postname = name })
    TriggerServerEvent('scf_telegram:check_inbox', GetPlayers())
end

Citizen.CreateThread(function()
    Citizen.Wait(5000)
    local str = Config.OpenPost
    OpenPost = PromptRegisterBegin()
    PromptSetControlAction(OpenPost, Config.keys.G)
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(OpenPost, str)
    PromptSetEnabled(OpenPost, 1)
    PromptSetVisible(OpenPost, 1)
    PromptSetStandardMode(OpenPost, 1)
    PromptSetHoldMode(OpenPost, 1)
    PromptSetGroup(OpenPost, prompts)
    Citizen.InvokeNative(0xC5F428EE08FA7F2C, OpenPost, true)
    PromptRegisterEnd(OpenPost)
end)


Citizen.CreateThread(function()
    if Config.postoffice then
        for k, v in pairs(Config.postoffice) do
            local blip = Citizen.InvokeNative(0x554d9d53f696d002, 1664425300, v.coords)
            SetBlipSprite(blip, v.blip, 1)
            Citizen.InvokeNative(0x9CB1A1623062F402, blip, "Post Office")
        end
    end
end)




Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local pcoords = GetEntityCoords(PlayerPedId())
        for k, v in ipairs(Config.postoffice) do
            if Vdist(pcoords, v.coords) < 1.5 then

                local label = CreateVarString(10, 'LITERAL_STRING', Config.post)
                PromptSetActiveGroupThisFrame(prompts, label)
                if Citizen.InvokeNative(0xC92AC953F0A982AE, OpenPost) then

                    TogglePost(v.name)
                end
            end
        end
    end
end)

function GetPlayers()
	local players = {}

	for _, player in ipairs(GetActivePlayers()) do
		if NetworkIsPlayerActive(player) then
			table.insert(players, player)
		end
	end

	return players
end


RegisterNUICallback('getview', function(data)
    TriggerServerEvent('scf_telegram:getTelegram', tonumber(data.id))
end)

RegisterNUICallback('sendTelegram', function(data)
    TriggerServerEvent('scf_telegram:SendTelegram', data)
end)

RegisterNUICallback('delete', function(data)
    TriggerServerEvent("scf_telegram:DeleteTelegram", tonumber(data.id))
end)

RegisterNetEvent('messageData')
AddEventHandler('messageData', function(tele)
    SendNUIMessage({ type = 'view', telegram = tele })
end)

RegisterNetEvent('inboxlist')
AddEventHandler('inboxlist', function(data)
    SendNUIMessage({ type = 'inboxlist', response = data })
end)

RegisterNUICallback('NUIFocusOff', function()
    InMenu = false
    SetNuiFocus(false, false)
    SendNUIMessage({ type = 'closeAll' })

end)
