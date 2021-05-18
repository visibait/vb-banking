local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")

RegisterServerEvent('vb-banking:server:depositvb')
AddEventHandler('vb-banking:server:depositvb', function(amount, inMenu)
	local _src = source
	local user_id = vRP.getUserId({_src})
	local walletMoney = vRP.getMoney({user_id})
	local bankMoney = vRP.getBankMoney({user_id})
	amount = tonumber(amount)
	Citizen.Wait(50)
	if amount == nil or amount <= 0 or amount > vRP.getMoney({user_id}) then
		TriggerClientEvent("vb-banking:ShowNotification", _src, "Invalid Quantity")
	else
		vRP.setBankMoney({user_id, bankMoney+tonumber(amount)})
		vRP.setMoney({user_id, walletMoney-amount})
		TriggerClientEvent("vb-banking:ShowNotification", _src, "You've deposited  $"..amount)
	end
end)

RegisterServerEvent('vb-banking:server:withdrawvb')
AddEventHandler('vb-banking:server:withdrawvb', function(amount, inMenu)
	local _src = source
	local user_id = vRP.getUserId({_src})
	local _base = 0
	local walletMoney = vRP.getMoney({user_id})
	local bankMoney = vRP.getBankMoney({user_id})
	amount = tonumber(amount)
	_base = vRP.getBankMoney({user_id})
	Citizen.Wait(100)
	if amount == nil or amount <= 0 or amount > _base then
		TriggerClientEvent("vb-banking:ShowNotification", _src, "Invalid Quantity")
	else
		vRP.setBankMoney({user_id, bankMoney-tonumber(amount)})
		vRP.setMoney({user_id, walletMoney+amount})
		TriggerClientEvent("vb-banking:ShowNotification", _src, "You've withdrawn $"..amount)
	end
end)

RegisterServerEvent('vb-banking:server:balance')
AddEventHandler('vb-banking:server:balance', function(inMenu)
	local _src = source
	local user_id = vRP.getUserId({_src})
	local balance = vRP.getBankMoney({user_id})
	TriggerClientEvent('vb-banking:client:refreshbalance', _src, balance)
end)

RegisterServerEvent('vb-banking:server:transfervb')
AddEventHandler('vb-banking:server:transfervb', function(to, amountt, inMenu)
	local _source = source
	local user_id = vRP.getUserId({_source})
	local zuser_id = vRP.getUserId({tonumber(to)})
	local zSource = vRP.getUserSource({tonumber(to)})
	local balance = 0
	if zuser_id ~= nil then
		balance = vRP.getBankMoney({user_id})
		if tonumber(_source) == tonumber(to) then
			TriggerClientEvent("vb-banking:ShowNotification", _source, "You can't transfer money to yourself")
		else
			if balance <= 0 or balance < tonumber(amountt) or tonumber(amountt) <= 0 then
				TriggerClientEvent("vb-banking:ShowNotification", _source, "You don't have enough money in your bank account.")
			else
				vRP.tryPayment({user_id, tonumber(amountt)})
				vRP.giveBankMoney({zuser_id, tonumber(amountt)}) 
				TriggerClientEvent("vb-banking:ShowNotification", zSource, "You've received a bank transfer of "..amountt.."$ from the ID: "..user_id)
				TriggerClientEvent("vb-banking:ShowNotification", _source, "You've sent a bank transfer of "..amountt.."$ to the ID: "..to)
			end
		end
	else
		TriggerClientEvent("vb-banking:ShowNotification", _source, "That Wallet ID is not valid or doesn't exist")
	end
end)