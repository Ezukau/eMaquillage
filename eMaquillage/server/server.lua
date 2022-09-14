ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem(Config.Item, function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent("eMaquillage:use", source)
end)