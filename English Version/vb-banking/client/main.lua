--================================================================================================
--==                      VB-BANKING BY VISIBAIT (BASED OFF NEW_BANKING)                        ==
--================================================================================================

ESX                         = nil
local inMenu = false
local atbank = false

--
-- MAIN THREAD
--

Citizen.CreateThread(function()

  while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

  while true do
    local _sleep = true
    Citizen.Wait(0)
    if nearBankorATM() then
      _sleep = false
      DisplayHelpText("Press ~INPUT_PICKUP~ to open the bank ~b~")
      if IsControlJustPressed(1, 38) then
        inMenu = true
        SetNuiFocus(true, true)
        SendNUIMessage({type = 'openGeneral', banco = atbank})
        TriggerServerEvent('vb-banking:server:balance', inMenu)
      end
      if IsControlPressed(1, 322) then
        inMenu = false
        SetNuiFocus(false, false)
        SendNUIMessage({type = 'close'})
      end
    end
    if _sleep then Citizen.Wait(1000) end
  end
end)

--
-- BLIPS
--

Citizen.CreateThread(function()
  for k,v in ipairs(Config.Zonas["banks"])do
  local blip = AddBlipForCoord(v.x, v.y, v.z)
  SetBlipSprite(blip, v.id)
  SetBlipDisplay(blip, 4)
  SetBlipScale  (blip, 0.8)
  SetBlipColour (blip, 2)
  SetBlipAsShortRange(blip, true)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString(tostring(v.name))
  EndTextCommandSetBlipName(blip)
  end
end)

--
-- EVENTS
--

RegisterNetEvent('vb-banking:client:refreshbalance')
AddEventHandler('vb-banking:client:refreshbalance', function(balance)
  local _streetcoords = GetStreetNameFromHashKey(GetStreetNameAtCoord(table.unpack(GetEntityCoords(PlayerPedId()))))
  local _pid = GetPlayerServerId(PlayerId())
  ESX.TriggerServerCallback('vb-banking:server:GetPlayerName', function(playerName)
    SendNUIMessage({
      type = "balanceHUD",
      balance = balance,
      player = playerName,
      address = _streetcoords,
      playerid = _pid
    })
  end)
end)

--
-- NUI CALLBACKS
--

RegisterNUICallback('deposit', function(data)
	TriggerServerEvent('vb-banking:server:depositvb', tonumber(data.amount), inMenu)
	TriggerServerEvent('vb-banking:server:balance', inMenu)
end)

RegisterNUICallback('withdraw', function(data)
	TriggerServerEvent('vb-banking:server:withdrawvb', tonumber(data.amountw), inMenu)
	TriggerServerEvent('vb-banking:server:balance', inMenu)
end)

RegisterNUICallback('balance', function()
	TriggerServerEvent('vb-banking:server:balance', inMenu)
end)

RegisterNetEvent('balance:back')
AddEventHandler('balance:back', function(balance)
	SendNUIMessage({type = 'balanceReturn', bal = balance})
end) 

RegisterNUICallback('transfer', function(data)
	TriggerServerEvent('vb-banking:server:transfervb', data.to, data.amountt, inMenu)
	TriggerServerEvent('vb-banking:server:balance', inMenu)
end)

RegisterNetEvent('vb-banking:result')
AddEventHandler('vb-banking:result', function(type, message)
	SendNUIMessage({type = 'result', m = message, t = type})
end)

RegisterNUICallback('NUIFocusOff', function()
	SetNuiFocus(false, false)
	SendNUIMessage({type = 'closeAll'})
  Citizen.Wait(500)
  inMenu = false
end)

--
-- FUNCS
--

nearBankorATM = function()
    local _ped = PlayerPedId()
    local _pcoords = GetEntityCoords(_ped)
    local _toreturn = false
    for _, search in pairs(Config.Zonas["banks"]) do
    local distance = #(vector3(search.x, search.y, search.z) - vector3(_pcoords))
        if distance <= 3 then
          atbank = true
          toreturn = true
          DrawText3D(search.x, search.y, search.z, 'Press ~y~E~w~ to ~r~open~w~ the Bank')
          DrawMarker(2,search.x, search.y, search.z, 0.0, 0.0, 0.0, 300.0, 0.0, 0.0, 0.25, 0.25, 0.05, 0, 100, 255, 255, false, true, 2, false, false, false, false)
        end
    end
    for _, search in pairs(Config.Zonas["atms"]) do
    local distance = #(vector3(search.x, search.y, search.z) - vector3(_pcoords))
    if distance <= 2 then
        atbank = false
        _toreturn = true
        end
    end
    return _toreturn
end

DisplayHelpText = function(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

DrawText3D = function(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end