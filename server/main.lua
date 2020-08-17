ESX = nil 

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

used = false
TriggerEvent('es:addGroupCommand', 'resnotify', "superadmin", function(source, args, user)
	if args[1] then
        if tonumber(args[1]) then
            if not used then
                local counter = tonumber(args[1])
                while counter > 0 do
                    text = " "..counter.." Dakika Sonra Sunucuya Restart Atılacaktır!"
                    dctext =  "Dakika Sonra Sunucuya Restart Atılacaktır!"
                    SendWebhook(counter, dctext)
                    TriggerClientEvent('chat:addMessage', -1, {template = '<div class="chat-message pink"><b>SYSTEM: </b>' .. text .. '</div>'})
                    counter = counter - 1
                    if counter == 0 then
                        used = false
                    end
                    Citizen.Wait(60000)
                end
            else
                TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Bunu zaten kullandın!"}})
            end
		else
			TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Yanlış kullanım!"}})
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Yanlış kullanım"}})
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = {"^1SYSTEM", "Insufficienct permissions!"} })
end, {help = "Crash a user, no idea why this still exists", params = {{name = "userid", help = "The ID of the player"}}})
send = false
Citizen.CreateThread(function()
    while true do 
        local ts = os.time()
        local time = {hour = os.date('%H', ts), minute = os.date('%M', ts)}
        if not send then
            for i = 1, #Config.ResTime.Time do
                if (tostring(Config.ResTime.Time[i].hour) == tostring(time.hour)) and (tostring(Config.ResTime.Time[i].minute) == tostring(time.minute)) then
                    TriggerEvent('fizzfau-resnotify:counter')
                end
            end
        end
        Citizen.Wait(60000)
    end
end)

RegisterServerEvent('fizzfau-resnotify:counter')
AddEventHandler('fizzfau-resnotify:counter', function()
    if not send then
        send = true
        local counter = Config.ResTime.FirstNotify
        while counter > 0 do
            print(counter.. " dakika sonra sunucu yeniden başlatılacak!")
            local text = " dakika sonra sunucu yeniden başlatılacak! @everyone"
            SendWebhook(counter, text)
            TriggerClientEvent('chat:addMessage', -1, {template = '<div class="chat-message pink"><b>SYSTEM: </b>' ..counter .. text .. '</div>'})
            counter = counter - 1
            if counter == 0 then
                send = false
                Citizen.Wait(60000)
                SendWebhook(counter, "Sunucu yeniden başlatılıyor!")
            end
            Citizen.Wait(60000)
        end
    end
end)

function SendWebhook(counter, text)
    if Config.ResTime.DiscordWebhook then
        local webhook_link = Config.ResTime.WebhookLink
        if counter == 0 then
            counter = ''
        end
        local connect = {
            {
                ["color"] = 3092790,
                ["title"] = "Restart Notifier",
                ["description"] = counter.. ' ' .. text,
                ["footer"] = {
                    ["text"] = "by fizzfau                             ",
                    ["icon_url"] = "https://i.ytimg.com/vi/RciuGXnHhR8/hqdefault.jpg",
                },
            }
        }

        PerformHttpRequest(webhook_link, function(err, text, headers) end, 'POST', json.encode({username = "fizzfau-restart", embeds = connect}), { ['Content-Type'] = 'application/json' })
    end
end