Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local pcoords = GetEntityCoords(PlayerPedId())
        for k,v in ipairs(Config.postoffice) do
            if Vdist(pcoords, v.coords) < v.radius then
                DrawTxt("Press [~e~G~q~] to view your telegrams", 0.50, 0.95, 0.6, 0.6, true, 255, 255, 255, 255, true, 10000)
                if IsControlJustReleased(0, 0x760A9C6F) then
                    togglePost(v.name) 
                end
            end
        end
    end
end)
Citizen.CreateThread(function()
for i,v in ipairs(Config.postoffice) do 
    local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, x, y, z) -- Blip Creation
    SetBlipSprite(blip, v.blip, true) -- Blip Texture
    Citizen.InvokeNative(0x9CB1A1623062F402, blip, "Post office") -- Name of Blip
end
end)
function DrawTxt(str, x, y, w, h, enableShadow, col1, col2, col3, a, centre)
    local str = CreateVarString(10, "LITERAL_STRING", str, Citizen.ResultAsLong())
   SetTextScale(w, h)
   SetTextColor(math.floor(col1), math.floor(col2), math.floor(col3), math.floor(a))
   SetTextCentre(centre)
   if enableShadow then SetTextDropshadow(1, 0, 0, 0, 255) end
   Citizen.InvokeNative(0xADA9255D, 10);
   DisplayText(str, x, y)
end

function togglePost(name)
    inMenu = true
    SetNuiFocus(true, true)
    SendNUIMessage({type = 'openGeneral',postname = name})
    TriggerServerEvent('scf_telegram:check_inbox')
end
RegisterNUICallback('getview', function(data)
	TriggerServerEvent('scf_telegram:getTelegram', tonumber(data.id))
end)
RegisterNUICallback('sendTelegram', function(data)
	TriggerServerEvent('scf_telegram:SendTelegram', data)
end)

RegisterNetEvent('messageData')
AddEventHandler('messageData', function(tele)
    SendNUIMessage({type = 'view',telegram = tele})
end)
RegisterNetEvent('inboxlist')
AddEventHandler('inboxlist', function(data)
    SendNUIMessage({type = 'inboxlist',response = data})
end)
RegisterNUICallback('NUIFocusOff', function()
	inMenu = false
	SetNuiFocus(false, false)
	SendNUIMessage({type = 'closeAll'})
end)